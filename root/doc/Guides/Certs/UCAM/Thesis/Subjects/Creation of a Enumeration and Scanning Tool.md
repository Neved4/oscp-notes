#### Description

This Master's Thesis involves the development of a tool that integrates enumeration and scanning techniques to conduct the initial reconnaissance phase of a pentesting process.

The scope of the project will focus on a local area network (LAN) for internal system pentesting. The tool can be written in scripting languages such as Python (e.g., Scapy), PowerShell, or any other language with which the student is familiar.

The tool must perform at least the following operations:

- **Discover devices** on a local area network using various techniques such as ARP Ping, TCP Ping, UDP Ping, and ICMP Ping.
- **Enumerate open ports** through scans such as SYN Scan or TCP Connect.
- **Detect firewalls** that may be filtering ports, using techniques like ACK Scan.
- **Perform banner grabbing** to retrieve software version information.
- **Evaluate HTTP headers** to determine software versions.
- **Differentiate between operating systems**, specifically Windows and Linux (OS detection).
- **Additional contributions:** Any extra fingerprinting or enumeration techniques proposed by the student will be highly valued.

#### Milestones and Objectives

1. **Explain the state of the art** of fingerprinting and enumeration techniques.
2. **Study enumeration and fingerprinting techniques** as well as scanning methods.
3. **Develop a tool** to assist pentesters in gathering initial information about the environment (focusing on local area networks for internal pentesting).
4. **Can use different programming languages**, with Scapy, Python, and PowerShell recommended for study.
5. **Demonstrate the effectiveness** of the implemented techniques through testing within controlled environments.
