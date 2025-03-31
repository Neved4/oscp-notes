# System Protections

## Firewall

Check the status and configuration of the firewall.

```batch
netsh firewall show state
netsh firewall show config
```

## Antivirus

Retrieve the name of the antivirus software in use.

```batch
WMIC /Node:localhost /Namespace:\\root\SecurityCenter2 Path AntiVirusProduct Get displayName
```

Check Windows Defender exclusions.

```powershell
Get-ChildItem 'registry::HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions' -ErrorAction SilentlyContinue
```

## AppLocker

Check for any AppLocker restrictions.

```powershell
Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections
```
