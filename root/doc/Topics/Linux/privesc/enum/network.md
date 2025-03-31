## Networks and Connections

### Interfaces

List interfaces and network configuration.

```bash
ifconfig || ip a
```

### Ports

Enumerating open ports.

```bash
netstat -punta || ss --ntpu
```

Scan ports on the internal network.

```bash
for ((port=1; port<=1024; port++))
do
	(echo >/dev/tcp/10.10.10.1/$port) >/dev/null 2>&1 && echo "TCP port $port is open"
done
```

### Routing

Listing routing table.

```bash
route || ip n
```

### ARP

Listing ARP table.

```bash
arp -e || arp -a
```
