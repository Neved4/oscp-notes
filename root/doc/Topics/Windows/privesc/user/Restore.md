# Restore Privilege

This policy defines which users can bypass file, directory, registry, and other object permissions when restoring files and directories from a backup. For more details, refer to the [Microsoft documentation](https://learn.microsoft.com/es-es/windows/security/threat-protection/security-policy-settings/restore-files-and-directories).

This privilege is often associated with the previous one and is also a very dangerous permission, as it allows the creation of a malicious file anywhere on the system. For example, it could be used to modify a service to execute as SYSTEM.

### Attack

To exploit this, the first step is to enable this permission, which can be done using the **EnableSeRestorePrivilege.ps1** script, available [here](https://github.com/gtworek/PSBits/blob/master/Misc/EnableSeRestorePrivilege.ps1). This grants write access to System32, allowing you to replace any service file or perform a DLL Hijacking on a service running with high integrity.

### Tools

[EnableSeRestorePrivilege.ps1](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/EnableSeRestorePrivilege.ps1)

## Example

We first check that we have the **SeRestorePrivilege**, but it is disabled.

![Check SeRestorePrivilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seRestore_1.png)

Next, we use the `EnableSeRestorePrivilege.ps1` script to enable the privilege.

![Enable SeRestorePrivilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seRestore_2.png)

We then search for a service that runs manually as SYSTEM, which we can manipulate using this privilege. In this case, we will use the **vds (Virtual Disk Service)**, which manages a wide range of storage configurations.

![Virtual Disk Service](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seRestore_3.png)

For this attack, we replace the binary with a reverse shell. First, we move the original binary, then place our reverse shell in its place. Finally, to trigger the execution, we restart the service as shown in the following figure.

![Restart Service](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seRestore_4.png)

Upon execution, we obtain a reverse shell as SYSTEM and restore the original service binary.

![Restore Service Binary](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seRestore_5.png)
