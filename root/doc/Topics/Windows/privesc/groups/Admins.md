# Administrators, Domain Admins, Enterprise Admins

Members of the **Administrators** group have full control over the system. This group can perform actions such as accessing any system object, modifying group memberships, managing users, and even managing membership in the Administrators group itself.

This section distinguishes between three different levels of administrators: the first group has local machine privileges, the **Domain Admins** group can manage an entire domain, and **Enterprise Admins** exist only in the root domain of an Active Directory forest. [Learn More](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups#administrators)

### Attack

Even though a user belongs to the **Administrators** group, all actions by the user, unless otherwise specified, will be executed with standard user permissions at a medium integrity level. When attempting to create a process with higher integrity and privileges, it is necessary to bypass User Account Control (UAC) protection. Therefore, we must first check the privileges we can access through the **Privilege Enumeration** section. If we do not have sufficient privileges, we proceed with a UAC Bypass.

If access to a graphical interface is available, such as through RDP, accepting execution is all that is needed. Otherwise, refer to the following link for techniques.

[↪ UAC Bypass Techniques](https://daniel10barredo.github.io/PrivEscAssist_Windows/#info/UAC)

## EXAMPLE

First, verify that you belong to the **Administrators** group.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/Admin_1.png)

However, upon listing privileges, only basic permissions are available, so the current process runs at a medium integrity level.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/Admin_2.png)

To elevate to a high integrity level, we need to perform a **UAC Bypass**. To determine which technique to use, we start by identifying the target operating system.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/Admin_3.png)

In this case, it is Windows 7 SP1, so we use the technique involving a vulnerability in **EventViewer**. To exploit it, we will use the **Invoke-EventVwrBypass.ps1** script suggested in the **Bypass UAC** section of the tool.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/Admin_4.png)

After executing the reverse shell, we obtain another process for the same user, but this time with a high integrity level, granting us all the permissions of the **Administrators** group and its accesses.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/Admin_5.png)

Finally, if we wish to execute as **SYSTEM**, we can use the `Get-System.ps1` script as shown below.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/Admin_6.png)
