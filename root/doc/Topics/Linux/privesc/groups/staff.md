## Staff Group

The **staff** group allows users to make modifications in the `/usr/local` directory without needing root privileges. It's important to note that `/usr/local/bin` is typically included in the `PATH` variable, which can be very dangerous.

## Attack

An attacker could carry out a hijacking attack by creating a malicious binary in the `/usr/local/bin` directory with an appropriate name, so that when a user with elevated privileges attempts to execute a binary relatively, the malicious one is loaded first. It should be noted that executables in `/bin` and `/usr/bin` can be _"overwritten"_.
