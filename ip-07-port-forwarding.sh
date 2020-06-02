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

# Fer NAT per les xarxes internes:
# - 172.19.0.0/24
# - 172.20.0.0/24
iptables -t nat -A POSTROUTING -s 172.19.0.0/24 -o enp7s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.20.0.0/24 -o enp7s0 -j MASQUERADE


# exemple de fer port forwarding dels ports 5001, 5002 i 5003 al port 13 de hostA1, hostA2 i el pròpi router. Observar que externament accedim al port 13 de cada host.
iptables -t nat -A PREROUTING -i enp4s0 -p tcp --dport 5001 -j DNAT --to 172.19.0.2:13
iptables -t nat -A PREROUTING -i enp4s0 -p tcp --dport 5002 -j DNAT --to 172.19.0.2:13
iptables -t nat -A PREROUTING -i enp4s0 -p tcp --dport 5003 -j DNAT --to 172.19.0.2:13

iptables -t nat -A PREROUTING -i enp4s0 -p tcp --dport 5001 -j DNAT --to 172.19.0.3:13
iptables -t nat -A PREROUTING -i enp4s0 -p tcp --dport 5002 -j DNAT --to 172.19.0.3:13
iptables -t nat -A PREROUTING -i enp4s0 -p tcp --dport 5003 -j DNAT --to 172.19.0.3:13

# posar ara una regla forwarding reject del port 13 i veiem que l’accés dels ports 5001 i 5002 es rebutja, perquè després del port forwarding hi ha el routing que aplica forward.
iptables -A FORWARD -p tcp --dport 13 -j REJECT

# treiem la regla forward i posem una regla input reject del port 13. ara és el port 5003 el que no funciona, perquè s’aplica input en ser el destí localhost.
iptables -nL --line-numbers
iptables -D FORWARD 1
iptables -A INPUT -p tcp --dport 13 -j REJECT
