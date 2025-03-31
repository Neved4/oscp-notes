# Environment Credentials

Occasionally, some applications use environment variables to store credentials for autonomous operation. Therefore, it is important to review the environment for these variables.

## Environment Variables

Commands to search for potential passwords in environment variables:

```powershell
# To search by pattern
Get-ChildItem Env: | findstr /i "passw"

# To list all variables
Get-ChildItem Env:
```

```batch
:: To search by pattern
set | findstr /i "passw"

:: To list all variables
set
```
