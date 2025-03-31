# System Users

## User Enumeration

Enumerates users on the system.

```batch
net users
```

```powershell
Get-LocalUser | ft Name,Enabled,LastLogon
Get-WmiObject -Class Win32_UserAccount
```

## User Information

Displays detailed information about a specific user.

```batch
net users [user]
```

```powershell
Get-WmiObject Win32_UserAccount | Where-Object { $_.Name -eq "[user]" }
```

## Group Enumeration

Enumerates local groups on the system.

```batch
net localgroup
```

```powershell
Get-LocalGroup
```

## Group Members

Enumerates the users that belong to a specific group.

```batch
net localgroup [group]
```

```powershell
Get-LocalGroupMember [group]
```

## Active Sessions

Enumerates active user sessions on the machine.

```batch
:: Logged-in users
quser

:: Remote sessions
qwinsta

:: Kerberos tickets
klist sessions
```

## Password Policy

Displays password policies configured on the system.

```batch
net accounts
```
