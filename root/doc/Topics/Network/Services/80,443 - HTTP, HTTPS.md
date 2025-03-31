# Pentesting HTTP, HTTPS (80, 443)

## Enumeration

- [ ] Identify the service: `whatweb`, `wpscan`, `nuclei`
  ```bash
  whatweb
  ```

- [ ] Look into the dir tree: `wfuzz`, `fuff`, `gobuster`, `dir`, `dirsearch`, `feroxbuster`
  ```bash
  gobuster dir -u $ip -w $dirListMedium -x php,html,zip,txt,conf,bak,tar,sh -b 403,404
  ```

- [ ] Scan the service
  ```bash
  nmap -sCV -p80,443 $ip
  ```

#### SSL/TLS

- [ ] SSL/TLS subdomains and mails
  ```bash
  openssl s_client -connect <domain>:443
  ```

- [ ] Analyze SSL certificate vulnerabilities:
  ```bash
  sslscan <domain>
  ```

#### Heart-bleed

- [ ] Attempt heart-bleed
  ```bash
  nmap --script ssl-heartbleed -p443 $ip
  ```

- [ ] Memory steal
  ```bash
  python3 ssltest.py $ip -p 443 |
  	grep -v "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
  ```
