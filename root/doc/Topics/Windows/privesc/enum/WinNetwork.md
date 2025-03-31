# Networks and Connections

## Interfaces

List network interfaces and configurations.

```batch
ipconfig /all
```

```powershell
Get-NetIPConfiguration | ft InterfaceAlias,InterfaceDescription,IPv4Address
```

## Ports

Enumerate open ports.

```batch
netstat -ano
```

Script to scan internal network ports.

```powershell
1..1024 | % {echo ((New-Object Net.Sockets.TcpClient).Connect("10.10.10.1", $_)) "TCP port $_ is open"} 2>$null
```

## Routing

Display the routing table.

```batch
route print
```

```powershell
Get-NetRoute -AddressFamily IPv4 | ft DestinationPrefix,NextHop,RouteMetric,ifIndex
```

## ARP

Display the ARP table.

```batch
arp -A
```

```powershell
Get-NetNeighbor -AddressFamily IPv4 | ft ifIndex,IPAddress,L
```

## Shared Files

Enumerate shared files on the system.

```batch
:: List network machines
net view

:: List shared files on a machine
net view \\computer /ALL

:: Shared files on the machine
net share
```
