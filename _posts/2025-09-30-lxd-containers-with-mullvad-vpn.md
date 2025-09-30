---
layout: post
category: projects
---

If you use LXD and have Mullvad VPN installed, you probably ran into an issue with LXD containers not properly launching or starting. 

The core of the issue is that LXD requires cgroup2, and Mullvad mounts "net_cls" on cgroups1 (errr....)

```bash
mount | grep net_cls

litterbox2 ➜  ~ mount | grep net_cls
net_cls on /sys/fs/cgroup/net_cls type cgroup (rw,relatime,net_cls)
net_cls on /opt/net-cls-v1 type cgroup (rw,relatime,net_cls)

litterbox2 ➜  ~ grep cgroup /proc/mounts
cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime 0 0
net_cls /sys/fs/cgroup/net_cls cgroup rw,relatime,net_cls 0 0
```
