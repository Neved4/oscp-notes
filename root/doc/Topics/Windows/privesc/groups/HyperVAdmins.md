# Hyper-V Administrators

Members of the **Hyper-V Administrators** group have unrestricted access to all Microsoft virtualization features. This group is used to reduce the number of users in the full Administrators group. [Learn More](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups#hyper-v-administrators)

### Attack

A vulnerability exists when deleting a virtual machine: the `vmms.exe` process attempts to restore permissions on the original `.vhdx` file as SYSTEM, without impersonating the user. This behavior can be exploited by creating a hard link to a SYSTEM-protected file, allowing an attacker to modify its permissions and achieve privilege escalation. [More Details](https://decoder.cloud/2020/01/20/from-hyper-v-admin-to-system/)
