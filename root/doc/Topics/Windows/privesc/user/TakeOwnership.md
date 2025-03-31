# Take Ownership Privilege

This policy defines which users can take ownership of any object on the device, including folders, processes, registry keys, etc. Each object has an owner, and the owner controls how permissions are set on the object and to whom those permissions are granted. For further details, refer to the [Microsoft documentation](https://learn.microsoft.com/es-es/windows/security/threat-protection/security-policy-settings/take-ownership-of-files-or-other-objects).

### Attack

An attacker with this privilege can exploit the `WRITE_OWNER` permission, which allows modifying an object by its owner. To escalate privileges, the attacker can change the ownership of a service executable or directory to the current user and then replace it with a malicious file that triggers privilege escalation to SYSTEM. To take ownership of the file:

```batch
takeown /f 'C:\Windows\System32\[binary]'
icacls 'C:\Windows\System32\[binary]' /grant user:F
```

## Example

We first verify that the **seTakeOwnershipPrivilege** is available.

![Check SeTakeOwnershipPrivilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seOwnership_1.png)

The goal of this attack is to replace the binary of a service running as SYSTEM and that can be manually started. In this case, we use the **Fax** service in Windows.

![Fax Service](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seOwnership_2.png)

Since the service is located in **System32**, we use `takeown` to set our user as the owner and then grant full permissions (**F**) on this directory.

![Take Ownership](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seOwnership_3.png)

We can confirm that we now have full permissions on the directory using **cacls**.

![Full Permissions Check](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seOwnership_4.png)

With everything in place, we replace the original binary, place a reverse shell in its place, and then restart the service.

![Replace Binary](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seOwnership_5.png)

After a few seconds, we obtain the reverse shell as **SYSTEM** and restore the service binary to its original location.

![Restore Service Binary](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seOwnership_6.png)
