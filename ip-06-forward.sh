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


# xarxaA no pot accedir xarxab
iptables -A FORWARD -s 172.19.0.0/16 -d 172.20.0.0/16 -j REJECT

# xarxaA no pot accedir a B2.
iptables -A FORWARD -s 172.19.0.0/16 -d 172.20.0.3 -j REJECT

# host A1 no pot connectar host B1
iptables -A FORWARD -s 172.19.0.2 -d 172.20.0.2 -j REJECT

# xarxaA no pot accedir a port 13.
iptables -A FORWARD -p tcp -s 172.19.0.0/24 --dport 13 -j REJECT

# xarxaA no pot accedir a ports 2013 de la xarxaB
iptables -A FORWARD -p tcp -s 172.19.0.0/16 -d 172.20.0.0/16 --dport 2013 -j REJECT

# xarxaA permetre navegar per internet però res més a l'exterior
iptables -A FORWARD -d 172.19.0.0/16 -p tcp --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -d 172.19.0.0/16 -p tcp --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16 -p tcp -j REJECT

# xarxaA accedir port 2013 de totes les xarxes d'internet excepte de la xarxa hisx2
iptables -A FORWARD -s 172.19.0.0/24 -d 192.168.2.0/24 -p tcp --dport 2013 -o enp7s0 -j REJECT
iptables -A FORWARD -s 172.19.0.0/24 -p tcp --dport 2013 -o enp7s0  -j ACCEPT

# evitar que es falsifiqui la ip de origen: SPOOFING
iptable -A FORWARD ! -s 172.19.0.0/16 -i enp7s0 -j DROP
