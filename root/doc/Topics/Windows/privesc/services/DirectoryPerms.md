# Directory Permissions Vulnerabilities

System services typically run with high integrity (`SYSTEM`) and are often installed by third-party applications that may not implement proper security measures. This oversight can expose vulnerabilities that attackers might exploit. In some cases, services do not enforce adequate permission restrictions on binaries and directories created during installation. If an attacker can modify a service binary, they can inject malicious code and escalate privileges.

> [!NOTE]
> Requires the following function [[ModPathCheck]].

## Service Directories

This procedure enumerates all service binary locations and checks whether the current user can modify any of the binaries or their directories. The following PowerShell command iterates through each service path and verifies modifiability using the auxiliary function.

```powershell
Get-WMIObject -Class win32_service | Where-Object { $_ -and $_.pathname } | ForEach-Object { 
    if (ModifiablePath (($_.pathname -split ".exe")[0] + ".exe")) { $_ } 
}
```

Alternatively, you can manually verify permissions using CMD. The goal is to determine whether the user or their groups have modify (M) or full (F) access:

```batch
:: List all services
wmic service list brief

:: Retrieve service details (to locate the binary path)
sc qc [service]

:: Check permissions on the specified path
icacls "C:\service path"
```

For a more intuitive permissions review, Microsoft [Sysinternals](https://learn.microsoft.com/en-us/sysinternals/) tools can be employed:

```batch
accesschk.exe /accepteula -dqv "C:\service path"
```

### Attack

If the service binary is modifiable, an attacker can replace it with a malicious payload and then restart the service to escalate privileges.

## Example

1. **Load the Auxiliary Function:** Copy and paste the auxiliary function into your PowerShell session.

2. **Enumerate and Assess Service Binaries:** Run the provided script to list all service binaries and determine if the current user can modify them.
   ![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/dirPerm_1.png)

   The script reveals that the `filepermsvc` service is misconfigured and its binary is modifiable. Verify the service details to identify the executable path.
   ![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/dirPerm_2.png)

3. **Confirm Vulnerability:** Use `cacls` or `icacls` to confirm that the binary is vulnerable, showing that all users have full permissions.

   ![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/dirPerm_3.png)

4. **Exploit:** Create a reverse shell payload and replace the service binary with your malicious version.
   ![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/dirPerm_4.png)

5. **Restart the Service:** Manually start the service to trigger the execution of the malicious binary.

   ![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/dirPerm_5.png)

6. **Obtain a SYSTEM Shell:** Within seconds, you should receive a reverse shell running with SYSTEM privileges.

   ![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/dirPerm_6.png)
