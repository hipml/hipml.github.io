---
layout: post
category: projects
---

Welcome to the first installment of my three-part series exploring recent research findings. This series will guide you through layerwise analysis, pruning and task evaluation, and conclude with environmental and computational impact assessments. I've crafted these articles to make complex concepts accessible—if you have a basic understanding of large language models, you'll be able to follow along comfortably as we explore these insights in an informal manner.


![Qwen Heatmaps](images/thesis_qwen_combined_heatmaps.png)

Pardon our dust! This article will be live soon. [^1]

$$ x^{(\ell+1)} = x^{(\ell)} + f(x^{(\ell)}, \theta^{(\ell)}) $$ 

$$ x^{(L)} = x^{(0)} + \sum_{\ell=0}^{L-1} f(x^{(\ell)}, \theta^{(\ell)}) $$

$$ \mathbf{u} \cdot \mathbf{v} = \|\mathbf{u}\| \|\mathbf{v}\| \cos(\theta) $$

$$ \cos(\theta) = \frac{\mathbf{u} \cdot \mathbf{v}}{\|\mathbf{u}\| \|\mathbf{v}\|} $$

![Comparison equations](images/thesis_criteria_plot_direct.png)

$$ f_{\text{cos}}(x) = \frac{1}{2}(x+1) $$

$$ f_{\text{ang}}(x) = 1 - \frac{1}{\pi}\arccos(x) $$

$$ f_{\text{cubic}}(x) = \frac{1}{4} (x^3 + x + 2) $$

$$ f_{\text{sqrt}}(x) = 1 - \sqrt{\frac{1}{2}(1-x)} $$

$$ f_{\text{exp}}(x) = \frac{e^{x} - e^{-1}}{e^1 - e^{-1}} $$

$$ O(n) $$ 

---
{: data-content="footnotes"}
[^1]: Lorem Ipsum!
