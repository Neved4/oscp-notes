# Credentials in Files

Credentials for various applications may sometimes be stored in files, ranging from configuration files to unattended installation scripts.

## Unattended Installations

Unattended installations may leave files containing default credentials to be used during installation. To locate these files, use the following commands.

```powershell
Get-Childitem "C:\" -Include ("*unattend*","*sysprep*") -Recurse -ErrorAction SilentlyContinue | where {($_.Name -like "*.xml" -or $_.Name -like "*.txt" -or $_.Name -like "*.ini")}
```

```batch
dir /s *sysprep.inf *sysprep.xml *unattended.xml *unattend.xml *unattend.txt 2>nul
```

## Web Servers

Credentials may sometimes be found in the configuration files of web servers. To search for these files, use the following commands.

```powershell
# For IIS Server
Get-Childitem –Path C:\inetpub\ -Include web.config -File -Recurse -ErrorAction SilentlyContinue

# For XAMPP Server
Get-Childitem –Path C:\xampp\ -Include web.config -File -Recurse -ErrorAction SilentlyContinue
```

Also, it is worth checking the log files.

```powershell
# For IIS Server
Get-Childitem C:\inetpub\logs\LogFiles\*

# For Apache Server
Get-Childitem –Path C:\ -Include access.log,error.log -File -Recurse -ErrorAction SilentlyContinue
```

## Other Recognized Files

The following list contains known files that may also store credentials if present on the system.

```powershell
@("env:localappdata\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState\plum.sqlite", "env:SYSTEMDRIVE\pagefile.sys","env:WINDIR\debug\NetSetup.log","env:WINDIR\repair\software","env:WINDIR\repair\security","env:WINDIR\system32\config\AppEvent.Evt","env:WINDIR\system32\config\SecEvent.Evt","env:WINDIR\system32\config\default.sav","env:WINDIR\system32\config\security.sav","env:WINDIR\system32\config\software.sav","env:WINDIR\system32\config\system.sav","env:USERPROFILE\ntuser.dat","env:USERPROFILE\LocalS~1\Tempor~1\Content.IE5\index.dat","env:USERPROFILE\appdata\Local\Microsoft\Remote Desktop Connection Manager\RDCMan.settings","env:USERPROFILE\.aws\credentials","env:USERPROFILE\AppData\Roaming\gcloud\credentials.db","env:USERPROFILE\AppData\Roaming\gcloud\legacy_credentials","env:USERPROFILE\AppData\Roaming\gcloud\access_tokens.db","env:USERPROFILE\.azure\accessTokens.json","env:USERPROFILE\.azure\azureProfile.json") | ForEach-Object {if(Test-Path $_){$_}}
```

```batch
:: Sticky Notes
dir "%localappdata%\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState\plum.sqlite"

:: Other Files
dir %SYSTEMDRIVE%\pagefile.sys
dir %WINDIR%\debug\NetSetup.log
dir %WINDIR%\repair\software, %WINDIR%\repair\security
dir %WINDIR%\system32\config\AppEvent.Evt
dir %WINDIR%\system32\config\SecEvent.Evt
dir %WINDIR%\system32\config\default.sav
dir %WINDIR%\system32\config\security.sav
dir %WINDIR%\system32\config\software.sav
dir %WINDIR%\system32\config\system.sav
dir %WINDIR%\system32\CCM\logs\*.log
dir %USERPROFILE%\ntuser.dat
dir %USERPROFILE%\LocalS~1\Tempor~1\Content.IE5\index.dat

:: Remote Desktop Connection Manager Settings
dir %USERPROFILE\appdata\Local\Microsoft\Remote Desktop Connection Manager\RDCMan.settings

:: Cloud Credentials
dir %USERPROFILE%\.aws\credentials
dir %USERPROFILE%\AppData\Roaming\gcloud\credentials.db
dir %USERPROFILE%\AppData\Roaming\gcloud\legacy_credentials
dir %USERPROFILE%\AppData\Roaming\gcloud\access_tokens.db
dir %USERPROFILE%\.azure\accessTokens.json
dir %USERPROFILE%\.azure\azureProfile.json
```

## General Search

The following commands search recursively for files that may contain credentials by **File Name**.

```powershell
Get-Childitem –Path C:\Users\ -Include *passw*,*vnc*,*.config -File -Recurse -ErrorAction SilentlyContinue
```

```batch
dir /s *passw* == *cred* == *vnc* == *.config* == *.kdbx* 2>nul
```

The following commands search recursively for files that may contain credentials by **File Content**.

```powershell
Get-ChildItem C:\* -include *.xml,*.ini,*.txt,*.config,*.kdbx -Recurse -ErrorAction SilentlyContinue | Select-String -Pattern "passw"
```

```batch
findstr /si passw *.xml *.ini *.txt *.config 2>nul
```
