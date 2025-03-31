---
title: "SMB Enumeration Cheatsheet"
source: "https://0xdf.gitlab.io/cheatsheets/smb-enum"
author:
  - "[[0xdf hacks stuff]]"
published: 2024-03-21
created: 2025-10-01
description: "SMB enumeration is a key part of a Windows assessment, and it can be tricky and finicky. When I was doing OSCP back in 2018, I wrote myself an SMB enumeration checklist. Five years later, this is the updated version with newer tools and how I approach SMB today. It’s also worth noting that this list is for a Linux attack box."
tags:
  - "clippings"
---
![SMB_Cheat_Sheet](https://0xdf.gitlab.io/img/smb_cheat-cover.webp)

SMB enumeration is a key part of a Windows assessment, and it can be tricky and finicky. When I was doing OSCP back in 2018, I wrote myself an SMB enumeration checklist. Five years later, this is the updated version with newer tools and how I approach SMB today. It’s also worth noting that this list is for a Linux attack box.

## Checklist

On seeing TCP 445 on Windows host:

- Enumerate Host
	- `netexec smb [ip]`
- List Shares
	- `netexec smb [host/ip] -u [user] -p [pass] --shares`
	- `netexec smb [host/ip] -u guest -p '' --shares`
	- `smbclient -N -L //[ip]`
- Enumerate Files
	- `smbclient //[ip]/[share] -N`
	- `smbclient //[ip]/[share] -U [username] [password]`
	- `netexec smb -u [user] -p [pass] -M spider_plus`
	- `smbclient.py '[domain]/[user]:[pass]@[ip/host] -k -no-pass` - Kerberos auth
	- `manspider.py --threads 256 [IP/CIDR] -u [username] -p [pass] [options]`
- User enumeration
	- RID Cycling
		- `lookupsid.py guest@[ip] -no-pass`
		- `netexec smb [ip] -u guest -p '' --rid-brute`
	- SAM Remote Protocol - `samrdump.py [domain]/[user]:[pass]@[ip]`
- Check for Vulnerabilities - `nmap --script smb-vuln* -p 139,445 [ip]`

## Tools

- `netexec`
	- General network service enumeration / exploitation tool, great SMB support. [Docs](https://www.netexec.wiki/)
	- Install with `pipx` - `pipx install git+https://github.com/Pennyw0rth/NetExec`
	- Formerly `crackmapexec`.
- `smbclient`
	- Linux SMB client [Man page](https://www.samba.org/samba/docs/current/man-html/smbclient.1.html)
	- Install with `apt install smbclient`.
- `manspider`
	- Python script for finding valuable data in large shares [GitHub](https://github.com/blacklanternsecurity/MANSPIDER)
	- Recommended to run via Docker: `docker run blacklanternsecurity/manspider`.
- Impacket Example Scripts
	- Impacket is a collection of Python classes for working with network protocols. The Example Scripts contain some really great tools for pentesters / hackers, including for SMB scripts like `smbclient.py`, `lookupsids.py`, and `samrdump.py`. [GitHub](https://github.com/fortra/impacket)
	- Install with `pipx` - `pipx install impacket`.
- `nmap`
	- General port scanner.
	- Useful to identify open TCP 445, as well as scripts to identify vulnerabilities.
	- Install with `apt install nmap`.

### Other Tools

There are a bunch of other tools out there that can be useful in different scenarios, some of which showed up in older versions of this post. For example, `smbmap` and `enum4linux`. There’s also an [updated](https://github.com/cddmp/enum4linux-ng) `enum4linux-ng` (re-written in Python). There’s nothing wrong with these tools. I just find myself not using them much anymore.

There’s also a bunch of Windows tools that are useful here that aren’t covered in this sheet, as this list is very Linux-centric. Enumerating from a Windows host is a completely different exercise, and something that has it’s own tools. While it is very common for a pentest to start with a Windows box joined to the network with creds, for my uses I’ve typically been working from a Linux attack system, so that’s the focus here. If you are working from a Windows attack station (especially if it is already joined to the domain), some tools that are recommended by people I respect include:

- [Snaffler](https://github.com/SnaffCon/Snaffler)
- [PowerHuntShares](https://github.com/NetSPI/PowerHuntShares)

## Background

SMB, or Server Message Block, is a very complicated protocol designed to handle file sharing, printer sharing, serial ports, and other communications between nodes in a network. It is primarily a Windows protocol, but Linux implementations like Samba do exist.

Today, the SMB server listens on TCP port 445. It would be very strange to see it on another port. Before Windows 2000, SMB happened over NETBIOS, and thus used TCP/UDP 137,138, and 139. But this is rare today.

In general, when enumerating SMB, the primary goal is the file system - finding interesting files to read, or writable locations. It’s also worth trying to enumeration users (see RID Cycling) and keep in mind to look for serious vulnerabilities in older / unpatched networks.

## Enumerate Host

The most basic run of `netexec` will give a wealth of information about the host, including the hostname, the domain, the OS version, and details about SMB version and if signing is enabled.

```
oxdf@hacky$ netexec smb 10.10.11.236 
SMB         10.10.11.236    445    DC01             [*] Windows 10 / Server 2019 Build 17763 x64 (name:DC01) (domain:manager.htb) (signing:True) (SMBv1:False)
```

## List Shares

### netexec

`netexec` with the `--shares` flag provides a nice list of the shares on the host. With valid creds, I’ll use the `-u [username]` and `-p [password]` flags:

```
oxdf@hacky$ netexec smb flight.htb -u svc_apache -p 'S@Ss!K@*t13' --shares
SMB         flight.htb      445    G0               [*] Windows 10.0 Build 17763 (name:G0) (domain:flight.htb) (signing:True) (SMBv1:False)
SMB         flight.htb      445    G0               [+] flight.htb\svc_apache:S@Ss!K@*t13 
SMB         flight.htb      445    G0               [+] Enumerated shares
SMB         flight.htb      445    G0               Share           Permissions     Remark
SMB         flight.htb      445    G0               -----           -----------     ------
SMB         flight.htb      445    G0               ADMIN$                          Remote Admin
SMB         flight.htb      445    G0               C$                              Default share
SMB         flight.htb      445    G0               IPC$            READ            Remote IPC
SMB         flight.htb      445    G0               NETLOGON        READ            Logon server share 
SMB         flight.htb      445    G0               Shared          READ            
SMB         flight.htb      445    G0               SYSVOL          READ            Logon server share 
SMB         flight.htb      445    G0               Users           READ            
SMB         flight.htb      445    G0               Web             READ
```

Without creds, it’s worth trying a couple different ways:

- Without providing creds.
- Bad username and/or guest account with blank password.
- Bad username and/or guest account and bad password.

For example, on [Manager](https://0xdf.gitlab.io/2024/03/16/htb-manager.html), the guest account (or bad account name like 0xdf) with blank password works where others don’t:

```
oxdf@hacky$ netexec smb 10.10.11.236 --shares
SMB         10.10.11.236    445    DC01             [*] Windows 10 / Server 2019 Build 17763 x64 (name:DC01) (domain:manager.htb) (signing:True) (SMBv1:False)
SMB         10.10.11.236    445    DC01             [-] Error getting user: list index out of range
SMB         10.10.11.236    445    DC01             [-] Error enumerating shares: STATUS_USER_SESSION_DELETED
oxdf@hacky$ netexec smb 10.10.11.236 --shares -u '0xdf' -p '0xdf'
SMB         10.10.11.236    445    DC01             [*] Windows 10 / Server 2019 Build 17763 x64 (name:DC01) (domain:manager.htb) (signing:True) (SMBv1:False)
SMB         10.10.11.236    445    DC01             [+] manager.htb\0xdf:0xdf 
SMB         10.10.11.236    445    DC01             [-] Error enumerating shares: STATUS_ACCESS_DENIED
oxdf@hacky$ netexec smb 10.10.11.236 --shares -u 'guest' -p ''
SMB         10.10.11.236    445    DC01             [*] Windows 10 / Server 2019 Build 17763 x64 (name:DC01) (domain:manager.htb) (signing:True) (SMBv1:False)
SMB         10.10.11.236    445    DC01             [+] manager.htb\guest: 
SMB         10.10.11.236    445    DC01             [*] Enumerated shares
SMB         10.10.11.236    445    DC01             Share           Permissions     Remark
SMB         10.10.11.236    445    DC01             -----           -----------     ------
SMB         10.10.11.236    445    DC01             ADMIN$                          Remote Admin
SMB         10.10.11.236    445    DC01             C$                              Default share
SMB         10.10.11.236    445    DC01             IPC$            READ            Remote IPC
SMB         10.10.11.236    445    DC01             NETLOGON                        Logon server share 
SMB         10.10.11.236    445    DC01             SYSVOL                          Logon server share
```

### smbclient

Different Windows configurations can be a bit finicky when enumerating shares, so I like to always try a couple different tools if the first fails. `smbclient` has a nice way to specify null auth, with the `-N` flag. To list shares:

The downside to this output is that it doesn’t show permissions. An alternative way to run this is to pipe “exit” into the connection like `echo exit | smbclient -L //[ip]`.

### Other Tools

`smbmap` will also provide similar output, and there are `nmap` enumeration scripts that will try to list shares as well. I’ve found myself not using these lately in favor of `netexec` and `smbclient`.

## Enumerate Files

### smbclient

To connect to an SMB share, `smbclient` takes the following format:

- `smbclient //[ip]/[share name] -U [username] [password]` - With creds
- `smbclient //[ip]/[share name] -N` - Null authentication

Examples:

```
oxdf@hacky$ smbclient //10.10.11.202/Public -N
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sat Nov 19 06:51:25 2022
  ..                                  D        0  Sat Nov 19 06:51:25 2022
  SQL Server Procedures.pdf           A    49551  Fri Nov 18 08:39:43 2022

                5184255 blocks of size 4096. 1450035 blocks available
```
```
oxdf@hacky$ smbclient //flight.htb/users -U svc_apache 'S@Ss!K@*t13'
Try "help" to get a list of possible commands.
smb: \> ls
  .                                  DR        0  Thu Sep 22 20:16:56 2022
  ..                                 DR        0  Thu Sep 22 20:16:56 2022
  .NET v4.5                           D        0  Thu Sep 22 19:28:03 2022
  .NET v4.5 Classic                   D        0  Thu Sep 22 19:28:02 2022
  Administrator                       D        0  Fri Oct 21 18:49:50 2022
  All Users                       DHSrn        0  Sat Sep 15 07:28:48 2018
  C.Bum                               D        0  Thu Sep 22 20:08:23 2022
  Default                           DHR        0  Tue Jul 20 19:20:24 2021
  Default User                    DHSrn        0  Sat Sep 15 07:28:48 2018
  desktop.ini                       AHS      174  Sat Sep 15 07:16:48 2018
  Public                             DR        0  Tue Jul 20 19:23:25 2021
  svc_apache                          D        0  Fri Sep 23 07:10:00 2022

                7706623 blocks of size 4096. 3749019 blocks available
```

### netexec

`netexec` has a module `spider_plus` that will run through all the shares and collect data about all the files:

```
oxdf@hacky$ netexec smb 10.10.11.222 -u oxdf -p '' -M spider_plus
SMB         10.10.11.222    445    AUTHORITY        [*] Windows 10 / Server 2019 Build 17763 x64 (name:AUTHORITY) (domain:authority.htb) (signing:True) (SMBv1:False)
SMB         10.10.11.222    445    AUTHORITY        [+] authority.htb\oxdf: 
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] Started module spidering_plus with the following options:
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*]  DOWNLOAD_FLAG: False
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*]     STATS_FLAG: True
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] EXCLUDE_FILTER: ['print$', 'ipc$']
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*]   EXCLUDE_EXTS: ['ico', 'lnk']
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*]  MAX_FILE_SIZE: 50 KB
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*]  OUTPUT_FOLDER: /tmp/nxc_spider_plus
SMB         10.10.11.222    445    AUTHORITY        [*] Enumerated shares
SMB         10.10.11.222    445    AUTHORITY        Share           Permissions     Remark
SMB         10.10.11.222    445    AUTHORITY        -----           -----------     ------
SMB         10.10.11.222    445    AUTHORITY        ADMIN$                          Remote Admin
SMB         10.10.11.222    445    AUTHORITY        C$                              Default share
SMB         10.10.11.222    445    AUTHORITY        Department Shares
SMB         10.10.11.222    445    AUTHORITY        Development     READ            
SMB         10.10.11.222    445    AUTHORITY        IPC$            READ            Remote IPC
SMB         10.10.11.222    445    AUTHORITY        NETLOGON                        Logon server share 
SMB         10.10.11.222    445    AUTHORITY        SYSVOL                          Logon server share 
SPIDER_P... 10.10.11.222    445    AUTHORITY        [+] Saved share-file metadata to "/tmp/nxc_spider_plus/10.10.11.222.json".
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] SMB Shares:           7 (ADMIN$, C$, Department Shares, Development, IPC$, NETLOGON, SYSVOL)
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] SMB Readable Shares:  2 (Development, IPC$)
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] SMB Filtered Shares:  1
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] Total folders found:  27
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] Total files found:    52
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] File size average:    1.5 KB
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] File size min:        4 B
SPIDER_P... 10.10.11.222    445    AUTHORITY        [*] File size max:        11.1 KB
```

From that output, it shows that these creds can read two of seven shares. It finds 27 folders and 52 files, and stored data about all of them in `/tmp/nxc_spider_plus/10.10.11.222.json`. That data looks like:

```
oxdf@hacky$ cat /tmp/nxc_spider_plus/10.10.11.222.json
{
    "Development": {
        "Automation/Ansible/ADCS/.ansible-lint": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "259 B"
        },
        "Automation/Ansible/ADCS/.yamllint": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "205 B"
        },
        "Automation/Ansible/ADCS/LICENSE": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "11.1 KB"
        },
        "Automation/Ansible/ADCS/README.md": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "7.11 KB"
        },
        "Automation/Ansible/ADCS/SECURITY.md": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "924 B"
        },
        "Automation/Ansible/ADCS/defaults/main.yml": {
            "atime_epoch": "2023-04-23 18:50:28",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-04-23 18:50:28",
            "size": "1.54 KB"
        },
        "Automation/Ansible/ADCS/meta/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-04-23 18:50:36",
            "size": "549 B"
        },
        "Automation/Ansible/ADCS/meta/preferences.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-04-23 18:50:33",
            "size": "22 B"
        },
        "Automation/Ansible/ADCS/molecule/default/converge.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "106 B"
        },
        "Automation/Ansible/ADCS/molecule/default/molecule.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "526 B"
        },
        "Automation/Ansible/ADCS/molecule/default/prepare.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "371 B"
        },
        "Automation/Ansible/ADCS/requirements.txt": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "466 B"
        },
        "Automation/Ansible/ADCS/requirements.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "264 B"
        },
        "Automation/Ansible/ADCS/tasks/assert.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "2.87 KB"
        },
        "Automation/Ansible/ADCS/tasks/generate_ca_certs.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-04-23 18:50:56",
            "size": "2.21 KB"
        },
        "Automation/Ansible/ADCS/tasks/init_ca.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "1.21 KB"
        },
        "Automation/Ansible/ADCS/tasks/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-04-23 18:50:44",
            "size": "1.33 KB"
        },
        "Automation/Ansible/ADCS/tasks/requests.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "4.12 KB"
        },
        "Automation/Ansible/ADCS/templates/extensions.cnf.j2": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "1.62 KB"
        },
        "Automation/Ansible/ADCS/templates/openssl.cnf.j2": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "11.03 KB"
        },
        "Automation/Ansible/ADCS/tox.ini": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "419 B"
        },
        "Automation/Ansible/ADCS/vars/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "2.1 KB"
        },
        "Automation/Ansible/LDAP/.bin/clean_vault": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "677 B"
        },
        "Automation/Ansible/LDAP/.bin/diff_vault": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "357 B"
        },
        "Automation/Ansible/LDAP/.bin/smudge_vault": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "768 B"
        },
        "Automation/Ansible/LDAP/.travis.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "1.38 KB"
        },
        "Automation/Ansible/LDAP/README.md": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "5.63 KB"
        },
        "Automation/Ansible/LDAP/TODO.md": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "119 B"
        },
        "Automation/Ansible/LDAP/Vagrantfile": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "640 B"
        },
        "Automation/Ansible/LDAP/defaults/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-04-23 18:51:08",
            "size": "1.02 KB"
        },
        "Automation/Ansible/LDAP/files/pam_mkhomedir": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "170 B"
        },
        "Automation/Ansible/LDAP/handlers/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "277 B"
        },
        "Automation/Ansible/LDAP/meta/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "416 B"
        },
        "Automation/Ansible/LDAP/tasks/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "5.11 KB"
        },
        "Automation/Ansible/LDAP/templates/ldap_sudo_groups.j2": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "131 B"
        },
        "Automation/Ansible/LDAP/templates/ldap_sudo_users.j2": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "106 B"
        },
        "Automation/Ansible/LDAP/templates/sssd.conf.j2": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "2.5 KB"
        },
        "Automation/Ansible/LDAP/templates/sudo_group.j2": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "30 B"
        },
        "Automation/Ansible/LDAP/vars/debian.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "174 B"
        },
        "Automation/Ansible/LDAP/vars/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "75 B"
        },
        "Automation/Ansible/LDAP/vars/redhat.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "222 B"
        },
        "Automation/Ansible/LDAP/vars/ubuntu-14.04.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "203 B"
        },
        "Automation/Ansible/PWM/README.md": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "1.26 KB"
        },
        "Automation/Ansible/PWM/ansible.cfg": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "491 B"
        },
        "Automation/Ansible/PWM/ansible_inventory": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "174 B"
        },
        "Automation/Ansible/PWM/defaults/main.yml": {
            "atime_epoch": "2023-04-23 18:51:38",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-04-23 18:51:38",
            "size": "1.55 KB"
        },
        "Automation/Ansible/PWM/handlers/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "4 B"
        },
        "Automation/Ansible/PWM/meta/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "199 B"
        },
        "Automation/Ansible/PWM/tasks/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "1.79 KB"
        },
        "Automation/Ansible/PWM/templates/context.xml.j2": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "422 B"
        },
        "Automation/Ansible/PWM/templates/tomcat-users.xml.j2": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "388 B"
        },
        "Automation/Ansible/SHARE/tasks/main.yml": {
            "atime_epoch": "2023-03-17 09:20:48",
            "ctime_epoch": "2023-03-17 09:20:48",
            "mtime_epoch": "2023-03-17 09:37:52",
            "size": "1.83 KB"
        }
    }
```

### MANSPIDER

[MANSPIDER](https://github.com/blacklanternsecurity/MANSPIDER) is a tool for crawling through a share or many shares looking for certain file types and/or content. Matching content will be copied to a local folder.

Without username / password (or on failed auth), it will try the guest account and a null session.

Filenames can be filtered by extension or by a regex. A regex can also be provided for content of files to look for. Can look inside PDFs, Office documents (`.docx`, `.xlsx`, `.pptx`, etc), text-based formats, as well as images using an optional OCR install.

This tool will be less relevant for individual targets / CTFs, but for a large network, can save a ton of time.

## Kerberos Auth

Some environments will have NTLM authentication disabled, forcing all auth to occur over Kerberos. `netexec` typically works really well with the `-k` flag.

My success with `smbclient` has been limited in this case, but the Impacket `smbclient.py` example has worked great.

Connecting takes the typical Impacket “target” in the format of `[domain]/[user]:[password]@[target host/ip]`, as well as the `-k` to use Kerberos and `-no-pass` to use tickets:

`shares` will list the shares, `use [share]` will select a share, and then `ls`, `cd`, etc work within the share:

## User / Object Enumeration

### RID Cycling

#### Background

Every Windows object (including users and groups) has a [security identifier](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers) or SID. The SID is a unique ID that contains a bunch of information about the domain configuration, and might look something like `S-1-5-21-1004336348-1177238915-682003330-512`.

Within a domain or stand-alone host, the entire SID except the last number will be the same, and the last number is the relative identifier, or RID. These values fall in a predictable range, and thus, we can brute force the numbers across that range and get a list of users and groups.

#### Manually

To see how this works manually, `rpcclient` can be used. It takes an IP and a `-U '[username]%[password]'`. Must like with other SMB tools, it’s worth trying `-U 'guest%'` for an empty password:

```
oxdf@hacky$ rpcclient 10.10.11.222 -U 'guest%'
rpcclient $>
```

`lookupnames [username]` will get the SID for a user:

```
rpcclient $> lookupnames administrator
administrator S-1-5-21-622327497-3269355298-2248959698-500 (User: 1)
```

`lookupsids [sid]` will do the reverse, get the username for a SID:

```
rpcclient $> lookupsids S-1-5-21-622327497-3269355298-2248959698-500
S-1-5-21-622327497-3269355298-2248959698-500 HTB\Administrator (1)
```

If I check RID 1601 on this host, it returns another user:

```
rpcclient $> lookupsids S-1-5-21-622327497-3269355298-2248959698-1601
S-1-5-21-622327497-3269355298-2248959698-1601 HTB\svc_ldap (1)
```

#### lookupsids.py

The Impacket script `lookupsids.py` will brute force this range for me:

```
oxdf@hacky$ lookupsid.py guest@10.10.11.222 -no-pass
Impacket v0.10.1.dev1+20230608.100331.efc6a1c3 - Copyright 2022 Fortra

[*] Brute forcing SIDs at 10.10.11.222
[*] StringBinding ncacn_np:10.10.11.222[\pipe\lsarpc]
[*] Domain SID is: S-1-5-21-622327497-3269355298-2248959698
498: HTB\Enterprise Read-only Domain Controllers (SidTypeGroup)
500: HTB\Administrator (SidTypeUser)
501: HTB\Guest (SidTypeUser)                        
502: HTB\krbtgt (SidTypeUser)                       
512: HTB\Domain Admins (SidTypeGroup)
513: HTB\Domain Users (SidTypeGroup)
514: HTB\Domain Guests (SidTypeGroup)
515: HTB\Domain Computers (SidTypeGroup)
516: HTB\Domain Controllers (SidTypeGroup)
517: HTB\Cert Publishers (SidTypeAlias)
518: HTB\Schema Admins (SidTypeGroup)
519: HTB\Enterprise Admins (SidTypeGroup)
520: HTB\Group Policy Creator Owners (SidTypeGroup)
521: HTB\Read-only Domain Controllers (SidTypeGroup)
522: HTB\Cloneable Domain Controllers (SidTypeGroup)
525: HTB\Protected Users (SidTypeGroup)
526: HTB\Key Admins (SidTypeGroup)
527: HTB\Enterprise Key Admins (SidTypeGroup)
553: HTB\RAS and IAS Servers (SidTypeAlias)
571: HTB\Allowed RODC Password Replication Group (SidTypeAlias)
572: HTB\Denied RODC Password Replication Group (SidTypeAlias)
1000: HTB\AUTHORITY$ (SidTypeUser)
1101: HTB\DnsAdmins (SidTypeAlias)
1102: HTB\DnsUpdateProxy (SidTypeGroup)
1601: HTB\svc_ldap (SidTypeUser)
```

The number at the start of the line is the RID.

#### netexec

`netexec` can also do this with the `--rid-brute` flag:

```
oxdf@hacky$ netexec smb 10.10.11.222 -u guest -p '' --rid-brute
SMB         10.10.11.222    445    AUTHORITY        [*] Windows 10 / Server 2019 Build 17763 x64 (name:AUTHORITY) (domain:authority.htb) (signing:True) (SMBv1:False)
SMB         10.10.11.222    445    AUTHORITY        [+] authority.htb\guest:
SMB         10.10.11.222    445    AUTHORITY        498: HTB\Enterprise Read-only Domain Controllers (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        500: HTB\Administrator (SidTypeUser)
SMB         10.10.11.222    445    AUTHORITY        501: HTB\Guest (SidTypeUser)
SMB         10.10.11.222    445    AUTHORITY        502: HTB\krbtgt (SidTypeUser)
SMB         10.10.11.222    445    AUTHORITY        512: HTB\Domain Admins (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        513: HTB\Domain Users (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        514: HTB\Domain Guests (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        515: HTB\Domain Computers (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        516: HTB\Domain Controllers (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        517: HTB\Cert Publishers (SidTypeAlias)
SMB         10.10.11.222    445    AUTHORITY        518: HTB\Schema Admins (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        519: HTB\Enterprise Admins (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        520: HTB\Group Policy Creator Owners (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        521: HTB\Read-only Domain Controllers (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        522: HTB\Cloneable Domain Controllers (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        525: HTB\Protected Users (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        526: HTB\Key Admins (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        527: HTB\Enterprise Key Admins (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        553: HTB\RAS and IAS Servers (SidTypeAlias)
SMB         10.10.11.222    445    AUTHORITY        571: HTB\Allowed RODC Password Replication Group (SidTypeAlias)
SMB         10.10.11.222    445    AUTHORITY        572: HTB\Denied RODC Password Replication Group (SidTypeAlias)
SMB         10.10.11.222    445    AUTHORITY        1000: HTB\AUTHORITY$ (SidTypeUser)
SMB         10.10.11.222    445    AUTHORITY        1101: HTB\DnsAdmins (SidTypeAlias)
SMB         10.10.11.222    445    AUTHORITY        1102: HTB\DnsUpdateProxy (SidTypeGroup)
SMB         10.10.11.222    445    AUTHORITY        1601: HTB\svc_ldap (SidTypeUser)
```

### SAM Remote Interface

#### Background

The Security Account Manager (SAM) is best known for it’s registry hive where password hashes are stored. However, it also has a [remote protocol](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-samr/4df07fab-1bbc-452f-8e92-7853a3c7e380) that works over SMB / RPC. From the docs:

> Specifies the Security Account Manager (SAM) Remote Protocol, which supports management functionality for an account store or directory containing users and groups. The goal of the protocol is to enable IT administrators and users to manage users, groups, and computers.

#### samrdump.py

Another Impacket example script, `samrdump.py` will use the SAM remote interface to enumerate users as well as basic information about each user:

```
oxdf@hacky$ samrdump.py htb.local/amanda:Ashare1972@10.10.10.103
Impacket v0.12.0.dev1+20240308.164415.4a62f39 - Copyright 2023 Fortra

[*] Retrieving endpoint list from 10.10.10.103
Found domain(s):
 . HTB
 . Builtin
[*] Looking up users in domain HTB
Found user: Administrator, uid = 500
Found user: Guest, uid = 501
Found user: krbtgt, uid = 502
Found user: DefaultAccount, uid = 503
Found user: amanda, uid = 1104
Found user: mrlky, uid = 1603
Found user: sizzler, uid = 1604
Administrator (500)/FullName:
Administrator (500)/UserComment:
Administrator (500)/PrimaryGroupId: 513
Administrator (500)/BadPasswordCount: 0
Administrator (500)/LogonCount: 158
Administrator (500)/PasswordLastSet: 2018-07-12 13:32:41.200387
Administrator (500)/PasswordDoesNotExpire: False
Administrator (500)/AccountIsDisabled: False
Administrator (500)/ScriptPath:
Guest (501)/FullName:
Guest (501)/UserComment:
Guest (501)/PrimaryGroupId: 514
Guest (501)/BadPasswordCount: 0
Guest (501)/LogonCount: 0
Guest (501)/PasswordLastSet: 2018-07-02 16:07:00.585860
Guest (501)/PasswordDoesNotExpire: True
Guest (501)/AccountIsDisabled: False
Guest (501)/ScriptPath:
krbtgt (502)/FullName:
krbtgt (502)/UserComment:
krbtgt (502)/PrimaryGroupId: 513
krbtgt (502)/BadPasswordCount: 0
krbtgt (502)/LogonCount: 0
krbtgt (502)/PasswordLastSet: 2018-07-02 14:58:36.836745
krbtgt (502)/PasswordDoesNotExpire: False
krbtgt (502)/AccountIsDisabled: True
krbtgt (502)/ScriptPath:
DefaultAccount (503)/FullName:
DefaultAccount (503)/UserComment:
DefaultAccount (503)/PrimaryGroupId: 513
DefaultAccount (503)/BadPasswordCount: 0
DefaultAccount (503)/LogonCount: 0
DefaultAccount (503)/PasswordLastSet: <never>
DefaultAccount (503)/PasswordDoesNotExpire: True
DefaultAccount (503)/AccountIsDisabled: True
DefaultAccount (503)/ScriptPath:
amanda (1104)/FullName:
amanda (1104)/UserComment:
amanda (1104)/PrimaryGroupId: 513
amanda (1104)/BadPasswordCount: 0
amanda (1104)/LogonCount: 106
amanda (1104)/PasswordLastSet: 2018-07-10 16:42:11.374214
amanda (1104)/PasswordDoesNotExpire: False
amanda (1104)/AccountIsDisabled: False
amanda (1104)/ScriptPath:
mrlky (1603)/FullName:
mrlky (1603)/UserComment:
mrlky (1603)/PrimaryGroupId: 513
mrlky (1603)/BadPasswordCount: 0
mrlky (1603)/LogonCount: 68
mrlky (1603)/PasswordLastSet: 2018-07-10 14:08:09.536421
mrlky (1603)/PasswordDoesNotExpire: False
mrlky (1603)/AccountIsDisabled: False
mrlky (1603)/ScriptPath:
sizzler (1604)/FullName:
sizzler (1604)/UserComment:
sizzler (1604)/PrimaryGroupId: 513
sizzler (1604)/BadPasswordCount: 0
sizzler (1604)/LogonCount: 0
sizzler (1604)/PasswordLastSet: 2018-07-12 10:29:49.234640
sizzler (1604)/PasswordDoesNotExpire: False
sizzler (1604)/AccountIsDisabled: False
sizzler (1604)/ScriptPath:
[*] Received 7 entries.
```

## Check for Vulnerabilities

While SMB vulnerabilities are pretty rare, when they do hit, they often hit big. A couple examples:

- MS06-025 - RCE vulnerability.
- MS08-067 / CVE-2008-4250 - RCE vulnerability exploited by the Conficker worm.
- MS17-010 / CVE-2017-0144 - RCE vulnerability allegedly leaked from the NSA.

While these are getting a bit old, they are still worth looking for, especially on older or unpatched systems.

`nmap` has a nice scanner that will alert for these: `nmap --script smb-vuln* -p 139,445 [ip]`

- `--script smb-vuln*` - will run all smb vulnerability scan scripts
- `-p 139,445` - smb ports

For example:

```
oxdf@hacky$ nmap --script smb-vuln* -p 139,445 [ip]
Starting Nmap 7.70 ( https://nmap.org ) at 2018-09-27 16:37 EDT
Nmap scan report for [ip]
Host is up (0.030s latency).

PORT    STATE SERVICE
139/tcp open  netbios-ssn
445/tcp open  microsoft-ds
MAC Address: 00:50:56:XX:XX:XX (VMware)

Host script results:
| smb-vuln-ms06-025:
|   VULNERABLE:
|   RRAS Memory Corruption vulnerability (MS06-025)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2006-2370
|           A buffer overflow vulnerability in the Routing and Remote Access service (RRAS) in Microsoft Windows 2000 SP4, XP SP1
|           and SP2, and Server 2003 SP1 and earlier allows remote unauthenticated or authenticated attackers to
|           execute arbitrary code via certain crafted "RPC related requests" aka the "RRAS Memory Corruption Vulnerability."
|
|     Disclosure date: 2006-6-27
|     References:
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-2370
|_      https://technet.microsoft.com/en-us/library/security/ms06-025.aspx
|_smb-vuln-ms10-054: false
|_smb-vuln-ms10-061: false
| smb-vuln-ms17-010:
|   VULNERABLE:
|   Remote Code Execution vulnerability in Microsoft SMBv1 servers (ms17-010)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2017-0143
|     Risk factor: HIGH
|       A critical remote code execution vulnerability exists in Microsoft SMBv1
|        servers (ms17-010).
|
|     Disclosure date: 2017-03-14
|     References:
|       https://technet.microsoft.com/en-us/library/security/ms17-010.aspx
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0143
|_      https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/
|_smb-vuln-regsvc-dos: ERROR: Script execution failed (use -d to debug)

Nmap done: 1 IP address (1 host up) scanned in 5.58 seconds
```

## Samba

`smbclient` works just fine to connect to Samba SMB shares on Linux hosts.

It is useful to look for vulnerabilities in the version of Samba. `nmap` is mostly good at doing this now when the `-sCV` option is given.

Years ago this script from rewardone in the PWK forums was handy for grabbing Samba versions:

```bash
#!/bin/sh
#Author: rewardone
#Description:
# Requires root or enough permissions to use tcpdump
# Will listen for the first 7 packets of a null login
# and grab the SMB Version
#Notes:
# Will sometimes not capture or will print multiple
# lines. May need to run a second time for success.
if [ -z $1 ]; then echo "Usage: ./smbver.sh RHOST {RPORT}" && exit; else rhost=$1; fi
if [ ! -z $2 ]; then rport=$2; else rport=139; fi
tcpdump -s0 -n -i tap0 src $rhost and port $rport -A -c 7 2>/dev/null | grep -i "samba\|s.a.m" | tr -d '.' | grep -oP 'UnixSamba.*[0-9a-z]' | tr -d '\n' & echo -n "$rhost: " &
echo "exit" | smbclient -L $rhost 1>/dev/null 2>/dev/null
sleep 0.5 && echo ""
```

You may need to update the adapter that `tcpdump` listens on (it’s `tap0` in the script above).

When you run this on a box running Samba, you get results:

```
root@# ./smbver.sh [IP]
[IP]: UnixSamba 227a
```

When in doubt, we can check the smb version in PCAP. Here’s an example Unix Samba 2.2.3a:

 [![image](https://0xdfimages.gitlab.io/img/1535861610117.png) *Click for full size image*](https://0xdfimages.gitlab.io/img/1535861610117.png)