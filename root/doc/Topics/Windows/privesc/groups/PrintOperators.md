# Print Operators

Members of this group can manage, create, share, and delete printers that are connected, as well as manage printer objects. Members of this group may also log in locally to domain controllers and even shut them down. [Learn More](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups#print-operators)

### Attack

Initially, we should check if we have the default privilege **SeLoadDriverPrivilege**, as indicated in the **privilege enumeration** phase. If it does not appear, it is necessary to elevate to a high integrity level, for which one of the techniques suggested in the **UAC bypass techniques** section must be used.

[↪ UAC Bypass Techniques](https://daniel10barredo.github.io/PrivEscAssist_Windows/#info/UAC)

Once the permission appears, we can proceed to exploit the **SeLoadDriverPrivilege** permission, which, as we saw in the previous section, allows us to install drivers as long as they are signed by Microsoft. If an attacker installs a driver with a known vulnerability, they could exploit it to gain execution as SYSTEM and elevate privileges.

[↪ SeLoadDriverPrivilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/#users/SeLoadDriverPrivilege)
