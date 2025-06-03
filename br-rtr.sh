ena
conf t
hostname br-rtr
ip domain-name au-team.irpo

interface int0
description "to isp"
ip address 172.16.50.14/28
port te0
service-instance te0/int0
encapsulation untagged
interface int0
connect port te0 service-instance te0/int0

interface int1
description "to br-srv"
ip address 192.168.23.1/28
port te1
service-instance te1/int1
encapsulation untagged
interface int1
connect port te1 service-instance te1/int1

exit
ip route 0.0.0.0/0 172.16.50.1
username net_admin
password P@$$word
role admin
exit
int tunnel.0
ip add 172.16.0.2/30
ip mtu 1400
ip tunnel 172.16.50.14 172.16.40.14 mode gre
exit
router ospf 1
router-id 2.2.2.2
network 172.16.0.0/30 area 0
network 192.168.23.0/28 area 0 
passive-interface default
no passive-interface tunnel.0
exit
int tunnel.0
ip ospf authentication message-digest
ip ospf message-digest-key 1 md5 P@ssw0rd
exit
int int1
ip nat inside
int int0
ip nat outside
exit
ip nat pool NAT_POOL 192.168.23.1-192.168.23.14
ip nat source dynamic inside-to-outside pool NAT_POOL overload interface int0
ntp timezone utc+4
ip nat source static tcp 192.168.23.14 8086 172.16.50.14 80
ip nat source static tcp 192.168.23.14 3015 172.16.50.14 3015
security none
exit
wr mem
