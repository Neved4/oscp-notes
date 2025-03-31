# DLL Hijacking

System services typically run with high integrity (SYSTEM) and are often installed by third-party applications that may not implement proper security measures. This oversight can expose vulnerabilities that attackers might exploit. This attack takes advantage of the directory search order for DLL libraries in the system when they are referenced relatively in the service.

## `PATH` Variable

This section involves checking whether the user has write permissions to any of the predefined directories or those referenced in the `PATH` environment variable.

This function checks all the directories listed in the `PATH` and verifies if the user can modify any of them.

> [!NOTE]
> Requires auxiliary function [[ModPathCheck]].

```powershell
Get-Item Env:Path | Select-Object -ExpandProperty Value | ForEach-Object { $_.split(';') } |
    Where-Object {$_ -and ($_ -ne '')} | ForEach-Object { if(ModifiablePath $_){ $_ } }
```

You can also manually check with CMD and `icacls` as follows:

```batch
for %I in ("%PATH:;=" "%") do (icacls %I)
```

### Attack

If any of these directories are modifiable, it is worth investigating whether privilege escalation can be achieved via DLL Hijacking attacks.

## Special Directories

It is important to check for irregular permission configurations in potentially dangerous locations.

Automatic function to check for irregular permissions within Program Files and the Windows directory.

> [!NOTE]
> Requires auxiliary function.

```powershell
Get-ChildItem 'C:\Program Files\*','C:\Program Files (x86)\*','C:\Windows\*' |
    ForEach-Object { try { if (ModifiablePath $_) { $_ } } catch {} }
```

You can also manually check with CMD using `icacls` to check permissions:

```batch
:: Program Files and Windows
icacls "C:\Program Files\*" 2>nul | findstr "(M)" | findstr "Everyone"
icacls "C:\Program Files\*" 2>nul | findstr "(M)" | findstr "BUILTIN\Users" 
icacls "C:\Program Files (x86)\*" 2>nul | findstr "(M)" | findstr "Everyone"
icacls "C:\Program Files (x86)\*" 2>nul | findstr "(M)" | findstr "BUILTIN\Users" 
icacls "C:\Windows\*" 2>nul | findstr "(M)" | findstr "BUILTIN\Users" 
icacls "C:\Windows\*" 2>nul | findstr "(M)" | findstr "BUILTIN\Users"
```

### Attack

If any of these directories are modifiable, it is worth investigating whether privilege escalation can be achieved via DLL Hijacking attacks.
