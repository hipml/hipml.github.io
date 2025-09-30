---
layout: post
category: projects
---

If you use LXD and have Mullvad VPN installed, you probably ran into an issue with LXD containers not properly launching or starting. 

## The Problem

The core issue is that LXD requires cgroup2, but Mullvad mounts net_cls as a cgroup1 controller, which conflicts with the unified cgroup2 hierarchy. You can verify this is happening by checking your current mounts:

```bash
mount | grep net_cls
```

If you see something like this, you've got the problem: 

```bash
litterbox2 ➜  ~ mount | grep net_cls
net_cls on /sys/fs/cgroup/net_cls type cgroup (rw,relatime,net_cls)

litterbox2 ➜  ~ grep cgroup /proc/mounts
cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime 0 0
net_cls /sys/fs/cgroup/net_cls cgroup rw,relatime,net_cls 0 0
```

## The Solution

The fix is straightforward: mount net_cls somewhere else that doesn't interfere with cgroup2. Following the Filesystem Hierarchy Standard (FHS), we'll use /var/lib/mullvad/net_cls since this is application state data.

```bash
sudo mkdir -p /var/lib/mullvad/net_cls
sudo mount -t cgroup -o net_cls net_cls /var/lib/mullvad/net_cls
sudo chown -R root:root /var/lib/mullvad/net_cls
```

To have this change persist across restarts, we need to edit the systemd file:

```bash
sudo vim /lib/systemd/system/mullvad-daemon.service
```

Add the following line to the `[Service]` section:

```
Environment="TALPID_NET_CLS_MOUNT_DIR=/var/lib/mullvad/net_cls/"
```

```
sudo systemctl stop mullvad-daemon
sudo umount /sys/fs/cgroup/net_cls
```

Verify only the new mount remains, and you should now see:

```bash
litterbox2 ➜  ~ mount | grep net_cls
net_cls on /var/lib/mullvad/net_cls type cgroup (rw,relatime,net_cls)
```

Finally, restart the Mullvad daemon and do final verification:

```bash
sudo systemctl restart mullvad-daemon
mount | grep net_cls
```

You should now be able to start up your LXD containers! 
