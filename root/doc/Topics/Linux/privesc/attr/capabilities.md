## Capabilities

In Linux, capabilities are special attributes that can be assigned to processes, binaries, services, and users, granting specific privileges typically reserved for the root user. These privileges may include the ability to intercept network traffic or mount/unmount filesystems.

### Attack

Some default files use these special configurations, but if a user misconfigures them, it can allow an attacker to escalate privileges. The following capabilities are particularly dangerous and should be closely monitored:

- **`CAP_SETUID`** - _Allows setting the effective user ID to the real user ID. This is one of the most critical capabilities, and techniques similar to those covered in the SUID & GUID section should be applied._
- **`CAP_SETGID`** - _Allows setting the effective group ID to the real group ID. Similar to **`CAP_SETUID`** - this is another critical capability requiring attention._
- **`CAP_CHOWN`** - _Allows changing the owner and group of any file in the system._
- **`CAP_DAC_OVERRIDE`** - _Grants the ability to bypass file access permissions, enabling reading, writing, and executing any file._
- **`CAP_DAC_READ_SEARCH`** - _Enables reading and searching any file on the system, even if read or search permissions are not granted to the user._
- **`CAP_NET_RAW`** - _Allows direct use of network sockets, which could enable malicious or unauthorized network actions._
- **`CAP_SYS_ADMIN`** - _Grants a wide range of system administration capabilities, including mounting filesystems, loading/unloading kernel modules, and performing network administration tasks._
- **`CAP_SYS_PTRACE`** - _Allows tracing and manipulating processes of other users, which can be used for obtaining sensitive information or launching attacks._
- **`CAP_SYS_MODULE`** - _Permits loading and unloading kernel modules, which could be exploited to load malicious modules or alter kernel behavior._
- **`CAP_FOWNER`** - _Allows overriding file ownership permissions and performing ownership changes on any file._
- **`CAP_SETFCAP`** - _Enables setting extended file attributes, which could be used to modify critical security attributes of files._

### Check

To identify all binaries with capabilities, use the following command:

```bash
getcap -r / 2>/dev/null
```
