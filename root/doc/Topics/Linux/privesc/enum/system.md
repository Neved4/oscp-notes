# System Information

## Operating System Information

Retrieve details about the operating system and kernel version.

```bash
uname -a
```

## Storage Devices

List partitions and usage percentage.

```bash
df -h || lsblk
```

Display partitions mounted at boot.

```bash
cat /etc/fstab
```

## Environment Variables

Enumerate environment variables. These can sometimes reveal useful system information or even credentials.

```bash
env
```

## Miscellaneous

Retrieve information about connected PCI devices.

```bash
lspci
```

Retrieve information about connected USB devices.

```bash
lsusb
```
