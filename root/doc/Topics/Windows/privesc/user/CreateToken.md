# Create Token Privilege

This policy determines which users have permission to create a token and which accounts can be used to gain access to local resources using the `NtCreateToken()` function in the Windows API. [Link](https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/create-a-token-object)
## Attack

An attacker can exploit this policy to escalate privileges by impersonating a token, provided it belongs to the same user and the integrity level is equal to or lower than the current execution context. In this scenario, the user can create and impersonate a token, adding themselves to a privileged group to escalate through other means.
