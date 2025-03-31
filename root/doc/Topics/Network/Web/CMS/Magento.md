# Prerequisites

- https://github.com/vulhub/vulhub/tree/master/magento/2.2-sqli
- https://github.com/ambionics/magento-exploits/blob/master/magento-sqli.py
- https://chromewebstore.google.com/detail/cookie-editor/hlkenndednhfkekhgcdicdfddnkalmdm
- https://github.com/steverobbins/magescan

## Enumeration

```bash
php magescan.phar scan:all http/://localhost:8080/
```

## Exploitation

- [ ] Run `magento-sqli.py`
  ```bash
  python3 magento-sqli.py http/://localhost:8080/
  ```
