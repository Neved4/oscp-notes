# Pentesting FTP

### Enumeration

- [ ] Connect to the server
  ```bash
  ftp $ip
  ```

- [ ] Scan the FTP
  ```bash
  nmap -sCV -p21 $ip
  ```

- [ ] Attempt to brute-force it
  ```bash
  hydra -l <user> -P "$rockyou" ftp://$ip -t 64
  ```

- [ ] Try log in as `anonymous` user
