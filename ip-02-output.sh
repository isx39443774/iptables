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

# accedir a qualsevol host/port extern
iptables -A OUTPUT -j ACCEPT

# accedir a qualsevol port extern 13.
iptables -A OUTPUT -p tcp --dport 13 -j ACCEPT

# accedir a qualsevol port 2013 excepte el del i26.
iptables -A OUTPUT -p tcp --dport 2013 -d i26 -j DROP
iptables -A OUTPUT -p tcp --dport 2013 -j ACCEPT

# denegar l’accés a qualsevol port 3013, però permetent accedir al 3013 de i26.
iptables -A OUTPUT -p tcp --dport 3013 -d i26 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3013 -j DROP

# permetre accedir al port 4013 de tot arreu, excepte dels hosts de la xarxa hisx2, però si permetent accedir al port 4013 del host i26.
iptables -A OUTPUT -p tcp --dport 4013 -d i26 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 4013 -d 192.168.2.0/24 -j DROP
iptables -A OUTPUT -p tcp --dport 4013 -j ACCEPT

# xapar l’accés a qualsevol port 80, 13, 7.
iptables -A OUTPUT -p tcp --dport 80 -j DROP
iptables -A OUTPUT -p tcp --dport 13 -j DROP
iptables -A OUTPUT -p tcp --dport 7 -j DROP

# no permetre accedir als hosts i26 i i27.
iptables -A OUTPUT -d i26 -j DROP
iptables -A OUTPUT -d i27 -j DROP

# no permetre accedir a les xarxes hisx1 i hisx2.
iptables -A OUTPUT -d 192.168.3.0/24 -j DROP
iptables -A OUTPUT -d 192.168.2.0/24 -j DROP

# no permetre accedir a la xarxa hisx2 excepte per ssh.
iptables -A OUTPUT -d 192.168.2.0/24 -j DROP
iptables -A OUTPUT -p tcp --dport 22 -d 192.168.2.0/24 -j ACCEPT
