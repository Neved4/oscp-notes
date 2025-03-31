Ferr

```bash
nmap -sS -sC -sV -n -Pn -p- -T5 --min-rate 5000 -vvv $ip
```

Usual

```bash
nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn $ip -oG allPorts
```

```bash
getPorts allPorts
```

```bash
nmap -sCV -p $ports -oN targeted
```

Faster

```bash
nmap -A -p- --open -sS --min-rate 5000 -v -n -Pn -T4 $ip
```

###### Scan all ports

```bash
nmap -v -Pn -p- --open -sT -T5 $ip
```

Top ports

```bash
nmap -v -Pn --top-ports 500 --open -sT -T5 $ip
```

UDP

```bash
nmap -v -Pn --open -sU -T5 $ip
```

Ping sweep:

```bash
nmap -sn $ip | grep -oP '\d{1,3}'
```

Local

```bash
nmap -O $ip
```

Versions

```bash
nmap -p22,80 -sV $ip
```

## Evasion

Fragment packets

```bash
nmap -p22 -f $ip
```

## Find

```bash
find / -name passwd 2>/dev/null
find / -name passwd 2>/dev/null | xargs ls -l
```

Find SUID:

```bash
find / -perm -4000 2>/dev/null
```

Find wheel / user / root:

```bash
find / -group wheel 2>/dev/null
find / -type d -group user 2>/dev/null
find / -user root -writable 2>/dev/null
find / -type f -user root -executable 2>/dev/null
```

Find a word / pass

```bash
grep -r "\w" 2>/dev/null
grep -r "\w" 2>/dev/null | tail -n 1 | awk '{print $2}' FS=":"
grep -r "\w" 2>/dev/null | tail -n 1 | cut -d ':' -f 2
grep -r "\w" 2>/dev/null | tail -n 1 | tr ':' ' ' | awk '{print $2}'
grep -r "\w" 2>/dev/null | tail -n 1 | tr ':' ' ' | awk 'NF {print $NF}'
grep -r "\w" 2>/dev/null | tail -n 1 | tr ':' ' ' | rev | awk '{print $1}' | rev
```

Find refined queries:

```bash
find . -type f -perm -u+r
find . -type f -perm -444
find . -type f -size 1033c ! -executable
find . -type f -size 1033c ! -executable | xargs cat | grep '\w'
find / -type f -user bandit7 -group bandit6 -size 33c 2>/dev/null
```

SSH

```bash
ssh -i sshkey.private bandit14@localhost
```

List ports

```bash
nestat -nat
ss -nltp
State        Recv-Q       Send-Q             Local Address:Port              Peer Address:Port      Process
LISTEN       0            5                      127.0.0.1:1840                   0.0.0.0:*
LISTEN       0            4096               127.0.0.53%lo:53                     0.0.0.0:*
cat /proc/net/tcp
sort -u | while read line; do echo "[+] Puerto $line -> $(echo "obase=10; ibase=16; $line" | bc) - OPEN" ; done

ps -faux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
bandit15 3700786  0.0  0.1   9196  5760 pts/101  Ss   17:04   0:00 -bash
bandit15 3845619  0.0  0.2  10820  8704 pts/101  S+   17:07   0:00  \_ openssl s_client -connect
bandit15   32475  0.0  0.1   8652  5632 pts/71   Ss   17:43   0:00 -bash
bandit15  211193  0.0  0.1  12184  5376 pts/71   R+   17:48   0:00  \_ ps -faux
bandit15    1014  0.0  0.0   2692  1536 ?        S    Jan17   0:00 /usr/bin/sendonpass 30000 /home/bandit1

ps -eo command

lsof -i:<port>
```

Netcat with ssl:

```bash
ncat --ssl 127.0.0.1 30001
```

Use temp to save stuff if I don't have other perms:

```bash
mkdir /tmp/myuser123$
nano id_rsa
chmod 400 id_rsa # or chmod 600 id_rsa for CTF
ssh -i id_rsa bandit17@localhost
```

Pass commands, like `/bin/sh`:

```bash
sshpass -p <pass> ssh -p 2220 bandit18@bandit.labs.overthewire.org <cmd>
```

Watch current dir for files:

```bash
watch -n1 ls -l
```

Call the current process:

```bash
echo $0
```
