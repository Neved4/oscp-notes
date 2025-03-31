---
desc: Network logon cracker which supports many services
url: https://github.com/vanhauser-thc/thc-hydra
tags:
  - pkg/apt
  - tools/pentest
---

# Hydra - Network logon cracker


### Create dictionary for password spray

Since `hydra -C` takes a list in `user:pass` format, we can create it easily with:

```bash
sed 's/.*/&:&/' input.txt > output.txt
```
