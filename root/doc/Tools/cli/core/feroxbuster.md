---
desc: Fast, simple, recursive content discovery tool written in Rust
url: https://github.com/epi052/feroxbuster
tags:
- pkg/apt
- tools/pentest
---

# Feroxbuster - Content discovery tool in Rust

Enumerate directories:

```bash
feroxbuster -u "http://bashed.htb/" -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -d 0 -t 10 -o fuzzing_dev.txt -x php,txt,html,config -C 404 -k
# -h # for cookie
```
