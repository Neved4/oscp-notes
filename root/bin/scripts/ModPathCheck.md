This function, based on [[PowerSploit]], checks whether the user has sufficient permissions to modify a directory or registry key. Some scripts in [[Windows Privilege Escalation]] will require this function—simply copy and paste its contents.

#### `ModPathCheck.ps1`

```powershell
function Get-CurrentSids {
	$Sids = [System.Security.Principal.WindowsIdentity]::GetCurrent().Groups |
		Select-Object -ExpandProperty Value
	$Sids += $UserIdentity.User.Value
	return $Sids
}

function Get-FilePathIfValid {
	param (
		[String]$Path
	)
	
	$Path = $Path.Replace('"', "")
	
	if (-Not (Test-Path -Path $Path -ErrorAction Stop)) {
		$Path = Split-Path -Path $Path -Parent
	}
	
	if (Test-Path -Path $Path -ErrorAction Stop) {
		return (Resolve-Path -Path $Path |
			Select-Object -ExpandProperty Path)
	}
	
	return $null
}

function Get-AccessibleRights {
	param (
		[String]$Path,
		[String[]]$Sids
	)
	
	Get-Acl -Path $Path |
		Select-Object -ExpandProperty Access |
		Where-Object { $_.AccessControlType -match 'Allow' } |
		ForEach-Object {
			$Rights = if ($_.FileSystemRights) {
				$_.FileSystemRights.value__
			} else {
				$_.RegistryRights.value__
			}

			$modRights = @(
				[uint32]'0x40000000', [uint32]'0x10000000',
				[uint32]'0x02000000', [uint32]'0x00080000',
				[uint32]'0x00040000', [uint32]'0x00000004',
				[uint32]'0x00000002'
			)
			
			if ($modRights | Where-Object { $Rights -band $_ }) {
				$Identity = $_.IdentityReference.Translate(
					[System.Security.Principal.SecurityIdentifier]
				)
				
				if ($Sids -contains $Identity |
					Select-Object -ExcludeProperty Value) {
					return $Path
				}
			}
		}
	
	return $null
}

function ModifiablePath {
    param (
        [Parameter(Mandatory = $true)]
        [String[]]$Paths
    )
    
    $Sids = Get-CurrentSids
    
    foreach ($Path in $Paths) {
        try {
            $ValidPath = Get-FilePathIfValid -Path $Path
            if ($ValidPath) {
                $AccessiblePath = Get-AccessibleRights `
                    -Path $ValidPath `
                    -Sids $Sids
                if ($AccessiblePath) {
                    $AccessiblePath
                }
            }
        } catch {
            $false
        }
    }
}
```