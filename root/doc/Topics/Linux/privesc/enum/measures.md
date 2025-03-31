## System Protections

### SELinux

Check for the presence of SELinux.

```bash
(sestatus 2>/dev/null | echo "Not found SELinux")
```

### AppArmor

Check for the presence of AppArmor.

```bash
if [ command -v aa-status 2>/dev/null ]
then
    aa-status
elif [ command -v apparmor_status 2>/dev/null ]
then
    apparmor_status
elif [ ls -d /etc/apparmor* 2>/dev/null ]
then
    ls -d /etc/apparmor*
else
    echo "Not found AppArmor"
fi
```

### Address space layout randomization (ASLR)

Check the memory randomization protection level.

```bash
cat /proc/sys/kernel/randomize_va_space 2>/dev/null
```

### PaX

Check for buffer overflow protection via PaX.

```bash
(which paxctl-ng paxctl >/dev/null 2>&1 && echo "Yes" || echo "Not found PaX")
```

### Execshield

Check for Execshield stack protection.

```bash
(grep "exec-shield" /etc/sysctl.conf || echo "Not found Execshield")
```
