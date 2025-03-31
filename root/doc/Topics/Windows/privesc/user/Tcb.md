# Tcb Privilege

This policy determines whether a process can assume the identity of any user and thus gain access to resources it is authorized to access. This permission is typically required only by low-level authentication services. Additionally, the calling process may request that arbitrary additional privileges be added to the current access token. For further details, refer to the [Microsoft documentation](https://learn.microsoft.com/es-es/windows/security/threat-protection/security-policy-settings/act-as-part-of-the-operating-system).

### Attack

An attacker could use **KERB_S4U_LOGON** to obtain an impersonated token for a user without knowing the credentials, add themselves to the administrators group, change the token's integrity level, etc., resulting in a quick privilege escalation. A very useful example is provided by the `TcbElevation.exe` project. For more information, see [this GitHub gist](https://gist.github.com/antonioCoco/19563adef860614b56d010d92e67d178).

### Tools

[TcbElevation.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/TcbElevation.exe)

## Example

We first verify that we have the **SeTcbPrivilege** permission.

![Check SeTcbPrivilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/tcbPriv_1.png)

Next, we create a reverse shell with **msfvenom** and will use the **TcbElevation** project to exploit this vulnerability. Before proceeding, compile the project with the following command:

```bash
g++ -static TcbElevation.cpp -o TcbElevation.exe -municode -lsecur32
```

Now that everything is ready, we are prompted for the service name as the first parameter and the reverse shell command we created as the second parameter.

![TcbElevation Execution](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/tcbPriv_2.png)

After a few seconds, we obtain the reverse shell running as SYSTEM.

![Reverse Shell as SYSTEM](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/tcbPriv_3.png)
