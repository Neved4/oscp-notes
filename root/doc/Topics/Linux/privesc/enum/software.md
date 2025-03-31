# Software

## Installed Programs

List the installed software on the system along with descriptions.

```bash
dpkg -l || rpm -qa
```

List the last 100 installed packages.

```bash
grep " install " /var/log/dpkg.log* | sed 's/^[^:]*://g' | sort | tail -n100
```

## Processes

Enumerate system processes in a tree format.

```bash
ps -auxfwww
```

Enhanced interactive process visualization.

```bash
top

echo 2
```
