# Pentesting SSH

### Enumeration

Connect to the server

```bash
ssh -p 22 <user>@$ip
```

Scan the service

```bash
nmap -sCV -p22 $ip
```

Try brute-force

```bash
hydra -l <user> -P $rockyou ssh://$ip -s 22 -t 64
```

Google search `<openssh version> launchpad` for codename.
