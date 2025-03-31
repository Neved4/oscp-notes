---
desc: Directory/file & DNS busting tool written in Go
url: https://github.com/OJ/gobuster
tags:
- pkg/apt
- tools/pentest
---

# Gobuster - Directory/file & DNS busting tool

Enumerate directories:

```bash
gobuster dir -q -u "http://$ip/$dir" -w $directoryListMedium -x php,html,zip,txt,conf,bak,tar,sh -b 403,404
```
