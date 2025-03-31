## Kernel Exploits

One of the final techniques in this methodology involves searching for potential vulnerabilities in the Linux kernel and attempting to exploit them for possible privilege escalation.

It’s important to note that these types of attacks should be used as a last resort, as they can cause instability in the operating system and potentially cause the machine to crash.

## Verification

The most common method attackers use for this task is the **Linux Exploit Suggester** tool. This tool contains a database of vulnerabilities focused on privilege escalation and attempts to suggest which ones can be exploited based on probability.

It’s also possible to manually verify this. First, we collect the kernel version on the server and then search for that version in [[exploit-db]] or **`searchsploit`** to check if it is vulnerable.

```bash
#(Server) Kernel version
uname -a
#(Kali) Search for the kernel version we found
searchsploit "Linux Kernel"
```

## Attack

The attack will depend on the type of exploit needed, such as DirtyCow, PwnKit, etc. The most common method is to use exploits published in [[exploit-db]] or search for them directly in **GitHub** repositories.

A very useful resource that should be kept handy is the [**kernel-exploits repository by lucyoa**](https://github.com/lucyoa/kernel-exploits), which contains a large collection of precompiled Linux exploits, organized and categorized.
