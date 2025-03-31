---
tags:
- cme
- web
desc: Web content management system
---

# Drupal

## Prerequisites

- [ ] Install `droopescan`

  ```bash
  git clone github.com/SamJoan/droopescan
  cd droopescan
  pip3 install -r requirements.txt
  ```

# Enumeration

- [ ] Run `whatweb` or Wappalyzer

  ```bash
  whatweb http://127.0.0.1:8080
  ```

- [ ] Run `droopescan`
  ```bash
  droopescan scan drupal --url http://127.0.0.1:8080
  ```

- [ ] Burp Suite for [CVE-2018-7600](https://github.com/a2u/CVE-2018-7600/blob/master/exploit.py)
- [ ] `whoami` -> `www-data`

# Exploitation
