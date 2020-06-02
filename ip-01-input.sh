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

# port 80 obert a tothom
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# port 2080 tancat a tothom (reject)
iptables -A INPUT -p tcp --dport 2080 -j REJECT

# port 2080 tancat a tothom (drop)
iptables -A INPUT -p tcp --dport 2080 -j DROP

# port 3080 tancat a tothom però obert al i26
iptables -A INPUT -p tcp --dport 3080 -s i26 -j ACCEPT
iptables -A INPUT -p tcp --dport 3080 -j DROP

# port 4080 obert a tohom però tancat a i26
iptables -A INPUT -p tcp --dport 4080 -s i26 -j DROP
iptables -A INPUT -p tcp --dport 4080 -j ACCEP

# port 5080 tancat a tothom, obert a hisx2 (192.168.2.0/24) i tancat a i26.

iptables -A INPUT -p tcp --dport 5080 -s i26 -j DROP
iptables -A INPUT -p tcp --dport 5080 -s 192.168.2.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 5080 -j DROP
