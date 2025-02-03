---
layout: post
category: coding
---

Arrays are one of Slurm's most powerful features for parallel job submission. 

{% highlight bash %}
#!/bin/bash
#SBATCH --array=1-100

input_file="data_${SLURM_ARRAY_TASK_ID}.txt"
output_file="results_${SLURM_ARRAY_TASK_ID}.txt"

./my_program $input_file $output_file
{% endhighlight %}

In general, Slurm is quite flexible, and that extends to arrays. There are a number of built in features:

* Sequential range: `--array=1-100`,
* With step size: `--array=1-100:2` (odd numbers only),
* Specific values: `--array=1,3,5,7`

However, one feature that Slurm doesn't have is _variable sized_ arrays. What if we want a reusable HPC launch script to run over some number of simulations, but that number varies based on other inputs?

I found an elegant solution when working on my undergraduate thesis: using Slurm to launch another Slurm script. 

This is a functional proof-of-concept Slurm script for initializing a variable array batch job:

{% highlight bash %}
#!/bin/bash
#SBATCH --account=myaccount
#SBATCH --partition=secondary
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=rng_poc
#SBATCH --output=logs/%x_%j_%a.out
#SBATCH --error=logs/%x_%j_%a.err

# Generate random size between 1-5
RANDOM_SIZE=$((RANDOM % 5 + 1))

# If this is the initial submission, create and submit new array job
if [ -z "$SLURM_ARRAY_TASK_ID" ]; then
    # Create temporary script with same frontmatter
    cat << 'EOF' > tmp_array_job.sh
#!/bin/bash
#SBATCH --account=myaccount
#SBATCH --partition=secondary
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=child_rng_poc
#SBATCH --output=logs/%x_%j_%a.out
#SBATCH --error=logs/%x_%j_%a.err

echo "This is array task ${SLURM_ARRAY_TASK_ID}"
EOF

    # Submit array job with random size
    sbatch --array=0-$((RANDOM_SIZE-1)) tmp_array_job.sh
    rm tmp_array_job.sh
    exit 0
fi

# Rest of your script for array tasks...

{% endhighlight %}

To wit: I wanted to prune a variable number of layers out of a given LLM, from 0 layers pruned to (n-1). Below is a sample script using this technique with an associative array to store the number of decoder layers per autoregressive model in our testing suite. 

```bash
#!/bin/bash
#SBATCH --account=its-a-me
#SBATCH --partition=low-requirement-box
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=multiqlora
#SBATCH --output=logs/%x/%j.out
#SBATCH --error=logs/%x/%j.err

# define model layers lookup
declare -A MODEL_LAYERS=(
    ["llama321b"]=16
    ["llama323b"]=28
    ["llama3170b"]=80
    ["llama38b"]=32
    ["qwen257b"]=28
    ["qwen2505b"]=24
    ["qwen2514b"]=48
    ["qwen2532b"]=64
    ["nemotron"]=80
)

# check if all arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <model> <task>"
    exit 1
fi

MODEL_NAME="$1"
TASK="$2"

# get the number of layers for the model
NUM_LAYERS=${MODEL_LAYERS[$MODEL_NAME]}
if [ -z "$NUM_LAYERS" ]; then
    echo "Error: Unknown model '$MODEL_NAME'"
    echo "Available models: ${!MODEL_LAYERS[@]}"
    exit 1
fi

echo "Model: $MODEL_NAME, layers $NUM_LAYERS"

if [ -z "$SLURM_ARRAY_TASK_ID" ]; then
    cat << 'EOF' > tmp_array_job.sh
#!/bin/bash
#SBATCH --account=its-a-me
#SBATCH --partition=massive-gpu-cluster
#SBATCH --gres=gpu:4
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=20
#SBATCH --mem=256G
#SBATCH --job-name=gmultitrain
#SBATCH --output=logs/%x/%a.out
#SBATCH --error=logs/%x/%a.err

# debug mode
# set -e
# set -x

# Load necessary modules and activate Conda environment
module load anaconda3/2024.06-Jun
module load cuda/12.4
module load texlive/2019
source /home/lamber10/.bashrc
export BNB_CUDA_VERSION=124
conda activate res_env
cd /projects/research/thesis/

mkdir -p logs

# Get command line arguments
MODEL_NAME="$1"
TASK="$2"

# run the evaluation script
torchrun --nproc_per_node=4 src/multitrain.py --model "$MODEL_NAME" --task "$TASK" --nltp "$SLURM_ARRAY_TASK_ID"
EOF

    # Submit array job
    sbatch --array=0-$((NUM_LAYERS-1)) tmp_array_job.sh "$MODEL_NAME" "$TASK"
    rm tmp_array_job.sh
    exit 0
fi
```

While it might seem a bit like Inception-style job scheduling, it cleanly solves the problem of variable-sized arrays without requiring external dependencies or complex bash wizardry. The parent job stays lightweight - it just needs to determine the array size and hand off the actual computation to its children.

In my case, this let me write reusable training scripts that could handle any model architecture without modifications. But the pattern works just as well for other variable-sized workloads, from dataset preprocessing to hyperparameter sweeps. Next time you find yourself hard-coding array sizes or maintaining multiple versions of the same script, consider letting Slurm launch Slurm instead.
