#! /bin/bash
# Sergi Iserte
# isx39443774
# EDT ASIX M11

# Regles flush
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Polítiques per defecte:
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

# obrir el localhost
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# obrir la nostra ip
iptables -A INPUT -s 192.168.168.39 -j ACCEPT
iptables -A OUTPUT -d 192.168.168.39 -j ACCEPT

# Activar NAT per a les dues xarxes privades locals xarxaA i xarxaB.
# xarxaA 172.19.0.0/24
# xarxaB 172.20.0.0/24
iptables -t nat -A POSTROUTING -s 172.19.0.0/24 -o enp7s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.20.0.0/24 -o enp7s0 -j MASQUERADE
