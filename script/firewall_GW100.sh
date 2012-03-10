#!/bin/bash
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you dont
# want to do the full Sys V style init stuff.

#Variable decalration part
MY_LAN_IP="192.168.57.100"	#Private ip address
MY_WAN_IP="61.12.31.52"		#Public ip address
MY_LAN_NID="192.168.57.0/24"	#Local network id
SQUID_PROXY_IP="192.168.57.200"	#Proxy server ip address
LAN_IF="eth0"			#LAN interface	
WAN_IF="eth1"			#WAN interface


touch /var/lock/subsys/local
iptables --flush			#Flush all chains in filter table
iptables --table nat --flush		#Flush all chains in nat table	


#-----------Enabling masquerading ----------#
iptables --table nat --append POSTROUTING --out-interface eth1 -j MASQUERADE

IPADDRESS="215"
#-----------IP Forwarding ----------#
#added by Nishant to accept port 22 traffic from the outside world.
iptables -t filter -I INPUT -p tcp --dport 22 -j ACCEPT
#this rule is added by Nishant for times Ascent project.. please do not remove it under any condition
iptables -t filter -I FORWARD -p tcp --dport 143 --source 192.168.57.236 -j ACCEPT

for local_ip in $IPADDRESS
do
        iptables -A FORWARD -s 192.168.57.$local_ip  -j ACCEPT
        iptables -A FORWARD -d 192.168.57.$local_ip  -j ACCEPT
        iptables -A FORWARD -d 192.168.57.$local_ip -p tcp --destination-port 11999  -j ACCEPT
done

#this rule is for VPN push from TIL client to Gateway 100.
iptables -t nat -I POSTROUTING -p tcp -d 0.0.0.0/0 -s 10.8.0.0/16 -j SNAT --to 192.168.57.100

#rule ends ::: Nishant
#iptables -t filter -I INPUT -p tcp --destination-port 80 -j ACCEPT

# Forwarding for Bugzilla to port 1112
iptables -t nat -A  PREROUTING -p tcp --dport 1112  -i eth1 -j DNAT --to 192.168.57.10:80
iptables -t nat -A POSTROUTING -d 192.168.57.10 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP

#For CVS
iptables -t nat -A  PREROUTING -p tcp --dport 2401 -i eth1 -j DNAT --to 192.168.57.202:2401
iptables -t nat -A POSTROUTING -d 192.168.57.202 -p tcp --dport 2401 -j SNAT --to $MY_LAN_IP

iptables -t nat -A  PREROUTING -p tcp --dport 8082 -i eth1 -j DNAT --to 192.168.57.201:8080
iptables -t nat -A POSTROUTING -d 192.168.57.201 -p tcp --dport 8080 -j SNAT --to $MY_LAN_IP

#URL exceptioms
#Exclude Payment integration servers to be accessed directly from the local network Access given to 443 https://

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.107 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.107 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.86 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.86 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.13 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.13 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.220 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.220 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.38 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.38 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.218 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.218 -p tcp --dport 443 -j ACCEPT


iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.142 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.142 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.18 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.18 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.222 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.222 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.27 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.27 -p tcp --dport 443 -j ACCEPT
#Arvind
iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.87 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.87 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.48 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.48 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.65 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.65 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.73 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.73 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.212 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.212 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.29 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.29 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.32 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.32 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.182 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.182 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.217 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.217 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.149 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.149 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.130 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.130 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.184 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.184 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.19 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.19 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.34 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.34 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.24 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.24 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.244 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.244 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.195 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.195 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.209 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.209 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.185 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.185 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.216 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.216 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.51 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.51 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.43 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.43 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.49 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.49 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.206 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.250 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.250 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.138 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.138 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.228 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.228 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.229 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.229 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.5 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.5 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.162 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.162 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.174 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.174 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.82 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.82 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.85 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.85 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.232 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.232 -p tcp --dport 443 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.115 -p tcp --dport 500 -j ACCEPT
iptables -I FORWARD -s 192.168.57.115 -p tcp --dport 500 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.115 -p tcp --dport 4500 -j ACCEPT
iptables -I FORWARD -s 192.168.57.115 -p tcp --dport 4500 -j ACCEPT

#Access to 67.63.42.151:28800 

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.65 -p tcp --dport 28800 -j ACCEPT
iptables -I FORWARD -s 192.168.57.65 -p tcp --dport 28800 -j ACCEPT

#Access to 67.63.42.151:23070

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.65 -p tcp --dport 23070 -j ACCEPT
iptables -I FORWARD -s 192.168.57.65 -p tcp --dport 23070 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.174 -p tcp --dport 1521 -j ACCEPT
iptables -I FORWARD -s 192.168.57.174 -p tcp --dport 1521 -j ACCEPT

iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.149 -p tcp --dport 1521 -j ACCEPT
iptables -I FORWARD -s 192.168.57.149 -p tcp --dport 1521 -j ACCEPT

#paypal.com
iptables -t nat -A PREROUTING -i eth0 -d 66.211.168.194 -j ACCEPT
iptables -I FORWARD -s $MY_LAN_NID -d 209.85.171.81 -j ACCEPT

#rang7.com
iptables -t nat -A PREROUTING -i eth0 -d 65.182.162.51 -j ACCEPT
iptables -I FORWARD -s $MY_LAN_NID -d 65.182.162.51 -j ACCEPT

iptables -t nat -A PREROUTING -i eth0 -d 66.211.168.126 -j ACCEPT
iptables -I FORWARD -s $MY_LAN_NID -d 209.85.171.81  -j ACCEPT

#sandbox.google.com
iptables -t nat -A PREROUTING -i eth0 -d 209.85.171.81 -j ACCEPT
iptables -I FORWARD -s $MY_LAN_NID -d  209.85.171.81   -j ACCEPT

#interface.demo.gta-travel.com
iptables -t nat -A PREROUTING -i eth0 -d 213.212.78.49 -j ACCEPT
iptables -I FORWARD -s $MY_LAN_NID -d  213.212.78.49   -j ACCEPT

#mo.vanguardcar.com
iptables -t nat -A PREROUTING -i eth0 -d 12.43.157.110 -j ACCEPT
iptables -I FORWARD -s $MY_LAN_NID -d  12.43.157.110  -j ACCEPT

#production.webservices.amadeus.com
iptables -t nat -A PREROUTING -i eth0 -d 82.150.229.130 -j ACCEPT
iptables -I FORWARD -s $MY_LAN_NID -d  82.150.229.130   -j ACCEPT

#americas.copy-webservices.travelport.com
iptables -t nat -A PREROUTING -i eth0 -d 12.17.227.153 -j ACCEPT
iptables -I FORWARD -s $MY_LAN_NID -d  12.17.227.153  -j ACCEPT

#Galileo
iptables -t nat -A PREROUTING -i eth0 -d 12.17.227.71  -j ACCEPT
iptables -A FORWARD -s $MY_LAN_NID -d 12.17.227.71 -j ACCEPT

#ITZCASH
iptables -t nat -A PREROUTING -i eth0 -d 202.46.194.40  -j ACCEPT
iptables -A FORWARD -s $MY_LAN_NID -d 202.46.194.40 -j ACCEPT

#Amedeus
iptables -t nat -A PREROUTING -i eth0 -d 82.150.226.67  -j ACCEPT
iptables -A FORWARD -s $MY_LAN_NID -d 82.150.226.67 -j ACCEPT

#TSI
iptables -t nat -A PREROUTING -i eth0 -d 210.211.171.74  -j ACCEPT
iptables -A FORWARD -s $MY_LAN_NID -d 210.211.171.74 -j ACCEPT

#entrada
iptables -t nat -A PREROUTING -i eth0 -d 62.1.56.3  -j ACCEPT
iptables -A FORWARD -s $MY_LAN_NID -d 62.1.56.3 -j ACCEPT

#radixx.com
#iptables -t nat -A PREROUTING -i eth0 -d 209.40.202.21  -j ACCEPT
#iptables -A FORWARD -s $MY_LAN_NID -d 209.40.202.21 -j ACCEPT

#religaresecurities.com
iptables -t nat -A PREROUTING -i eth0 -d 203.200.85.91  -j ACCEPT
iptables -A FORWARD -s $MY_LAN_NID -d 203.200.85.91 -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -d 59.165.200.225  -j ACCEPT
iptables -A FORWARD -s $MY_LAN_NID -d 59.165.200.225 -j ACCEPT

#Redirecting all requests to squid on ports 80
iptables -t nat -A PREROUTING -i eth0 -s ! $SQUID_PROXY_IP -p tcp --dport 80 -j DNAT --to $SQUID_PROXY_IP:3128
iptables -t nat -A POSTROUTING -o eth0 -d $SQUID_PROXY_IP -p tcp --dport 3128 -j SNAT --to $MY_LAN_IP

iptables -t nat -A PREROUTING -i eth0 -d 203.27.235.32 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -d  203.27.235.32 -p tcp --dport 443 -j ACCEPT

iptables -t nat -A PREROUTING -i eth0 -d 12.17.227.155 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -d  12.17.227.155 -p tcp --dport 443 -j ACCEPT

#Redirecting all requests to squid on ports 443
#iptables -t nat -A PREROUTING -i eth0 -s ! $SQUID_PROXY_IP -d 209.85.199.107 -p tcp --dport 443 -j ACCEPT

iptables -t nat -A PREROUTING -i eth0 -s ! $SQUID_PROXY_IP -p tcp --dport 443 -j DNAT --to $SQUID_PROXY_IP:3128
iptables -t nat -A POSTROUTING -o eth0 -d $SQUID_PROXY_IP -p tcp --dport 3128 -j SNAT --to $MY_LAN_IP


#-----------FORWARD chain rules----------#
#Allow ping
iptables -A FORWARD  -p icmp -j ACCEPT
iptables -A FORWARD -i eth1 -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT

#Block llist for share
iptables -A FORWARD -d 195.122.131.250 -j DROP
iptables -A FORWARD -d 195.122.131.2/28 -j DROP

#iptables -A FORWARD -d 72.51.45.153 -j DROP
iptables -A INPUT -s 72.51.45.153 -j DROP

#Block all access to the server list
BLOCK_LIST="120"
for block_ip in $BLOCK_LIST
do
        iptables -A FORWARD -s 192.168.57.$block_ip -j DROP
        iptables -A FORWARD -d 192.168.57.$block_ip -j DROP
done

#Allow servers full access
IP_LIST="2 10 149 150 190 200 206 225"
for local_ip in $IP_LIST
do
        iptables -A FORWARD -s 192.168.57.$local_ip -j ACCEPT
        iptables -A FORWARD -d 192.168.57.$local_ip -j ACCEPT
done

FTPUSERS="56"
for ftp_ip in $FTPUSERS
do
	iptables -A FORWARD -s 192.168.57.$ftp_ip -p tcp --dport 1000:65534 -j ACCEPT
	iptables -A FORWARD -d 192.168.57.$ftp_ip -p tcp --sport 1000:65534 -j ACCEPT
done

# Allow DNS queries from whole network
iptables -A FORWARD -p udp --dport 53   -j ACCEPT
iptables -A FORWARD -p udp --sport 53   -j ACCEPT

iptables -A FORWARD -i eth0 -o eth0 -p tcp --dport 3128 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth0 -p tcp --sport 3128 -j ACCEPT

#Allow lotus notes for clients with public ip address
#iptables -A FORWARD -s 192.168.57.0/24 -d 203.120.54.72 -p tcp --dport 1352 -j ACCEPT
#iptables -A FORWARD -d 192.168.57.0/24 -s 203.120.54.72 -p tcp --sport 1352 -j ACCEPT

#Allow access to go to meeting
iptables -A FORWARD -s 192.168.57.0/24  -p tcp --dport 8200 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24  -p tcp --sport 8200 -j ACCEPT

#Allow 8080 port to public
iptables -A FORWARD -s 192.168.57.0/24  -p tcp --dport 8080 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24  -p tcp --sport 8080 -j ACCEPT

#Allow fnp database from localnet
iptables -A FORWARD -s 192.168.57.0/24 -d 65.182.191.3 -p tcp --dport 3306 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 65.182.191.3 -p tcp --sport 3306 -j ACCEPT

#Allow client to use pop service
iptables -A FORWARD -s 192.168.57.0/24 -d 220.226.203.245 -p tcp --dport 110 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 220.226.203.245 -p tcp --sport 110 -j ACCEPT
iptables -A FORWARD -s 192.168.57.0/24 -d 220.226.203.245 -p tcp --dport 25 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 220.226.203.245 -p tcp --sport 25 -j ACCEPT

iptables -A FORWARD -s 192.168.57.0/24 -d 205.178.146.50 -p tcp --dport 110 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 205.178.146.50 -p tcp --sport 110 -j ACCEPT
iptables -A FORWARD -s 192.168.57.0/24 -d 205.178.146.50 -p tcp --dport 25 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 205.178.146.50 -p tcp --sport 25 -j ACCEPT

iptables -A FORWARD -s 192.168.57.0/24 -d 210.19.14.4 -p tcp --dport 110 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 210.19.14.4 -p tcp --sport 110 -j ACCEPT
iptables -A FORWARD -s 192.168.57.0/24 -d 210.19.14.4 -p tcp --dport 25 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 210.19.14.4 -p tcp --sport 25 -j ACCEPT

#Allow localnet to fetchmail with public ip address
iptables -A FORWARD -s 192.168.57.0/24 -d 61.12.31.50 -p tcp --dport 25 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 61.12.31.50 -p tcp --sport 25 -j ACCEPT

#Allow localnet to fetchmail with public ip address
iptables -A FORWARD -s 192.168.57.0/24 -d 61.12.31.50 -p tcp --dport 110 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 61.12.31.50 -p tcp --sport 110 -j ACCEPT

#Allow direct msn access
#iptables -A FORWARD -s 192.168.57.0/24 -p tcp --dport 1863 -j ACCEPt
#iptables -A FORWARD -d 192.168.57.0/24 -p tcp --sport 1863 -j ACCEPT
iptables -A FORWARD -p tcp --dport 1863 -j DROP


#Allow any mysql database access from localnet
iptables -A FORWARD -s 192.168.57.0/24 -p tcp --dport 3306 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -p tcp --sport 3306 -j ACCEPT

#Allow access of RDP 
iptables -A FORWARD -s 192.168.57.0/24 -p tcp --dport 3389 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -p tcp --sport 3389 -j ACCEPT

iptables -A FORWARD -s 192.168.57.0/24 -p tcp --dport 3390 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -p tcp --sport 3390 -j ACCEPT
iptables -A FORWARD -s 192.168.57.0/24 -p tcp --dport 9821 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -p tcp --sport 9821 -j ACCEPT

#Allow cisco vpn client
iptables -A FORWARD -s 192.168.57.0/24 -d 63.208.143.3 -p udp --dport 10000 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -s 63.208.143.3 -p udp --sport 10000 -j ACCEPT

#Allow localnet to use windows vpn client
iptables -A FORWARD -s 192.168.57.0/24 -p tcp --dport 1723 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -p tcp --sport 1723 -j ACCEPT
iptables -A FORWARD -s 192.168.57.0/24 -p gre -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -p gre -j ACCEPT

#Allow ssh access from local network to internet
iptables -A FORWARD -s 192.168.57.0/24 -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -p tcp --sport 22 -j ACCEPT

#Allow access to use telnet port
iptables -A FORWARD -i eth0 -s 192.168.57.0/24 -p tcp --dport 23 -j ACCEPT
iptables -A FORWARD -i eth1 -d 192.168.57.0/24 -p tcp --sport 23 -j ACCEPT

#Allow ftp access
iptables -A FORWARD -i eth0 -s 192.168.57.0/24 -p tcp --dport 20:21  -j ACCEPT
iptables -A FORWARD -o eth1 -d 192.168.57.0/24 -p tcp --sport 20:21  -j ACCEPT

#Allow bugzilla access
iptables -A FORWARD -d 192.168.57.10 -p tcp --dport 1112 -j ACCEPT
iptables -A FORWARD -s 192.168.57.10 -p tcp --sport 1112 -j ACCEPT

#---------CVS access section---------------#
#Allow cvs access
iptables -A FORWARD -p tcp --dport 2401 -j ACCEPT

iptables -A FORWARD -s 122.163.106.174 -d 192.168.57.202 -p tcp --dport 2401 -j ACCEPT
iptables -A FORWARD -d 122.163.106.174 -s 192.168.57.202 -p tcp --sport 2401 -j ACCEPT

iptables -A FORWARD -s 61.12.31.51 -d 192.168.57.202 -p tcp --dport 2401 -j ACCEPT
iptables -A FORWARD -d 61.12.31.51 -s 192.168.57.202 -p tcp --sport 2401 -j ACCEPT


#Allow amadeus web application
iptables -A FORWARD -p tcp --sport 20002 -j ACCEPT
iptables -A FORWARD -p tcp --dport 20002 -j ACCEPT

#Allow cisco vpn access
iptables -A FORWARD -p udp --dport 500 -j ACCEPT
iptables -A FORWARD -p udp --sport 500 -j ACCEPT

#Allow pugmarks on 8443 port
iptables -A FORWARD -d 65.182.191.189 -p tcp --dport 8443 -j ACCEPT
iptables -A FORWARD -s 65.182.191.189 -p tcp --sport 8443 -j ACCEPT

#Allow dropit.3dsecure.net on 9443 port
iptables -A FORWARD -d 198.241.171.150 -p tcp --dport 9443 -j ACCEPT
iptables -A FORWARD -s 198.241.171.150 -p tcp --sport 9443 -j ACCEPT

#Allow nisar on 1443
iptables -A FORWARD -d 207.106.22.54 -p tcp --dport 1434 -j ACCEPT
iptables -A FORWARD -s 207.106.22.54 -p tcp --sport 1434 -j ACCEPT
iptables -A FORWARD -s 207.106.22.54 -p tcp --sport 1433 -j ACCEPT
iptables -A FORWARD -s 207.106.22.54 -p tcp --sport 1433 -j ACCEPT

#----------------SKYPE section-------------------##---------------------SKYPE section--------------# 

iptables -A FORWARD -s 192.168.57.0/24 -p tcp --sport 62507 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -p tcp --dport 62507 -j ACCEPT

#To block all the ips other than proxy  
iptables -A FORWARD -i eth0 -o eth1 -s ! $SQUID_PROXY_IP -p tcp --syn -j DROP 
#iptables -A FORWARD -i eth0 -o eth1 -s 192.168.57.0/24  -p tcp --syn -j ACCEPT

iptables -A FORWARD -p tcp --dport 80   -j ACCEPT
iptables -A FORWARD -p tcp --sport 80   -j ACCEPT
iptables -A FORWARD -p tcp --dport 443  -j ACCEPT
iptables -A FORWARD -p tcp --sport 443  -j ACCEPT
iptables -A FORWARD -j DROP

#-----------------------**  INPUT chain rules **-------------------------------------------------------------#

#Accept all traffice for loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp  -j ACCEPT

#Allow webmin access
iptables -A INPUT -i eth0 -p tcp --dport 10080 -j ACCEPT

#Allow snmp port from eth0 
iptables -A INPUT -i eth0 -p udp --dport 161 -j ACCEPT
iptables -A INPUT -i eth1 -s 61.12.31.51 -p udp --dport 161 -j ACCEPT

#Accept all the responses from intranet and internet
iptables -A INPUT -i eth0 -p tcp -m tcp ! --syn -j ACCEPT
iptables -A INPUT -i eth1 -p tcp -m tcp ! --syn -j ACCEPT

#Accept ping from our network
iptables -A INPUT -i eth0  -p icmp -j ACCEPT
iptables -A INPUT -i eth1  -p icmp -j ACCEPT

#Accept snmp to check port 25
iptables -A INPUT -i eth0 -p tcp --dport 25 -j ACCEPT

#--------------------------- **  FTP SECTION **----------------------------------------------------------------#

#Allow ports from 5000 to 5010 for ftp data mode
iptables -A INPUT -i eth1  -p tcp -m tcp --dport 5000:5010 -j ACCEPT


#Times --cotact - pradeep.sharma
iptables -A INPUT -i eth1 -s 122.162.104.130  -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 202.54.243.53  -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 61.12.31.51   -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 122.160.153.10  -p tcp -m tcp --dport 20:21 -j ACCEPT


#Allow TIL BLOGS clients to access ftp #Contact Mr. Pranjal
iptables -A INPUT -i eth1 -s 220.226.197.219 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 220.226.197.162 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 123.237.7.133 -p tcp -m tcp --dport 20:21 -j ACCEPT

#Allow Innovative  clients to access ftp #Contact Mr. Manish Tak
iptables -A INPUT -i eth1 -s 62.103.152.247 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 62.103.152.247 -p tcp -m tcp --dport 20:21 -j ACCEPT

#Allow MGHFTP to Access --- Shantonu Rae
iptables -A INPUT -i eth1 -s 202.65.11.55 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 202.65.11.50 -p tcp -m tcp --dport 20:21 -j ACCEPT

#Allow MERCURY FTP to Access ---Nisar Siddique / Manish Tak
iptables -A INPUT -i eth1 -s 125.18.117.202 -p tcp -m tcp --dport 20:21 -j ACCEPT

#Allow Milestone 
iptables -A INPUT -i eth1 -s 202.63.168.2 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 125.99.63.133 -p tcp -m tcp --dport 20:21 -j ACCEPT

iptables -A INPUT -i eth1 -s 123.237.7.133 -p tcp -m tcp --dport 20:21 -j ACCEPT

#Allow ftp access to local network
iptables -A INPUT -i eth0 -s 192.168.57.0/24 -p tcp -m tcp --dport 20:21 -j ACCEPT 


#Jaipur Office
iptables -A INPUT -i eth1 -s 122.161.160.9 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 122.163.83.79 -p tcp -m tcp --dport 20:21 -j ACCEPT


#----------------------------**  SSH SECTION  ** ------------------------------------------------------------------#
#Allow sagar from home
# for bglens access
iptables -A INPUT -i eth1 -s 220.226.197.162 -p tcp -m tcp --dport 22 -j ACCEPT


#Accept ssh access to local network
iptables -A INPUT -i eth0 -s 192.168.57.0/24  -p tcp -m tcp --dport 22 -j ACCEPT 

#-------------------------** TELNET SECTION  ** --------------------------------------------------------------------#
#Allow telnet to local network
iptables -A INPUT -i eth0 -s 192.168.57.0/24  -p tcp -m tcp --dport 23 -j ACCEPT 

#Allow DNS responses to local machine
#iptables -A INPUT -p tcp -m tcp --dport 22 -j LOG
iptables -A INPUT -p udp -m udp --sport 53 -j ACCEPT
iptables -A INPUT -j DROP

#----------------------------------- OUTPUT chain rules -------------------------------------------------------------#
#Adding by Nagendra for gaurav garg 
iptables -t nat -I  PREROUTING -p tcp --dport 8084 -i eth1 -j DNAT --to 192.168.57.154:80
iptables -t nat -I POSTROUTING -d 192.168.57.154 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -i eth1 -d 192.168.57.154 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -i eth0 -s 192.168.57.154 -p tcp --sport 80 -j ACCEPT

#241 server 
iptables -t nat -I  PREROUTING -p tcp --dport 8087 -i eth1 -j DNAT --to 192.168.57.241:80
iptables -t nat -I POSTROUTING -d 192.168.57.241 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -i eth1 -d 192.168.57.241 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -i eth0 -s 192.168.57.241 -p tcp --sport 80 -j ACCEPT

#253 server 
iptables -t nat -I  PREROUTING -p tcp --dport 8083 -i eth1 -j DNAT --to 192.168.57.253:9080
iptables -t nat -I POSTROUTING -d 192.168.57.253 -p tcp --dport 9080 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -i eth1 -d 192.168.57.253 -p tcp --dport 9080 -j ACCEPT
iptables -I FORWARD -i eth0 -s 192.168.57.253 -p tcp --sport 9080 -j ACCEPT

#Adding by Nagendra fo sugarcrm and mediawikis
iptables -t nat -I  PREROUTING -p tcp --dport 82  -i eth1 -j DNAT --to 192.168.57.90:80
iptables -t nat -I POSTROUTING -d 192.168.57.90 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -i eth1 -d 192.168.57.90 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -i eth0 -s 192.168.57.90 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra Pal >> Wirelss Router
iptables -t nat -I  PREROUTING -p tcp --dport 443 -i eth1 -j DNAT --to 192.168.57.225:443
iptables -t nat -I POSTROUTING -d 192.168.57.225 -p tcp --dport 443 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.225 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.225 -p tcp --sport 443 -j ACCEPT


#Added by Nagendra >>  Nagios
iptables -t nat -I  PREROUTING -p tcp --dport 8094 -i eth1 -j DNAT --to 192.168.57.2:80
iptables -t nat -I POSTROUTING -d 192.168.57.2 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.2 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.2 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra 
iptables -t nat -I  PREROUTING -p tcp --dport 8089 -i eth1 -j DNAT --to 192.168.57.206:80
iptables -t nat -I POSTROUTING -d 192.168.57.206 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.206 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra 
iptables -t nat -I  PREROUTING -p tcp --dport 22022 -i eth1 -j DNAT --to 192.168.57.206:22
iptables -t nat -I POSTROUTING -d 192.168.57.206 -p tcp --dport 22 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.206 -p tcp --dport 22 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --sport 22 -j ACCEPT

#Adding by Nagendra  >> US SugarCRM
iptables -t nat -I  PREROUTING -p tcp --dport 83 -i eth1 -j DNAT --to 192.168.57.199:80
iptables -t nat -I POSTROUTING -d 192.168.57.199 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.199 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.199 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra Pal   # Test Was Ontra Server
iptables -t nat -I  PREROUTING -p tcp --dport 9003 -i eth1 -j DNAT --to 192.168.57.49:8085
iptables -t nat -I POSTROUTING -d 192.168.57.49 -p tcp --dport 8085 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.49 -p tcp --dport 8085 -j ACCEPT
iptables -I FORWARD -s 192.168.57.49 -p tcp --sport 8085 -j ACCEPT

#Adding by Nagendra >> TEST WAS SERVER
iptables -t nat -I  PREROUTING -p tcp --dport 3307 -i eth1 -j DNAT --to 192.168.57.206:3306
iptables -t nat -I POSTROUTING -d 192.168.57.206 -p tcp --dport 3306 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.206 -p tcp --dport 3306 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --sport 3306 -j ACCEPT

#Adding by Nagendra 
iptables -t nat -I  PREROUTING -p tcp --dport 8085 -i eth1 -j DNAT --to 192.168.57.206:8085
iptables -t nat -I POSTROUTING -d 192.168.57.206 -p tcp --dport 8085 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.206 -p tcp --dport 8085 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --sport 8085 -j ACCEPT

#Adding by Nagendra >> SUSE SERVER
iptables -t nat -I  PREROUTING -p tcp --dport 8098 -i eth1 -j DNAT --to 192.168.57.157:8080
iptables -t nat -I POSTROUTING -d 192.168.57.157 -p tcp --dport 8080 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.157 -p tcp --dport 8080 -j ACCEPT
iptables -I FORWARD -s 192.168.57.157 -p tcp --sport 8080 -j ACCEPT


#Adding by Nagendra Pal --DEMO SERVER 
#iptables -t nat -I  PREROUTING -p tcp --dport 9081 -i eth1 -j DNAT --to 192.168.57.5:80
#iptables -t nat -I POSTROUTING -d 192.168.57.5 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
#iptables -I FORWARD -d 192.168.57.5 -p tcp --dport 80 -j ACCEPT
#iptables -I FORWARD -s 192.168.57.5 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra Pal --DEMO SERVER 
iptables -t nat -I  PREROUTING -p tcp --dport 9080 -i eth1 -j DNAT --to 192.168.57.5:9080
iptables -t nat -I POSTROUTING -d 192.168.57.5 -p tcp --dport 9080 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.5 -p tcp --dport 9080 -j ACCEPT
iptables -I FORWARD -s 192.168.57.5 -p tcp --sport 9080 -j ACCEPT

iptables -t nat -I  PREROUTING -p tcp --dport 10090 -i eth1 -j DNAT --to 192.168.57.5:80
iptables -t nat -I POSTROUTING -d 192.168.57.5 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.5 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.5 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra  >> SOLARIS SERVER 
iptables -t nat -I  PREROUTING -p tcp --dport 443 -i eth1 -j DNAT --to 192.168.57.51:80
iptables -t nat -I POSTROUTING -d 192.168.57.51 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.51 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.51 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra  >> SOLARIS SERVER 
iptables -t nat -I  PREROUTING -p tcp --dport 8086 -i eth1 -j DNAT --to 192.168.57.51:443
iptables -t nat -I POSTROUTING -d 192.168.57.51 -p tcp --dport 443 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.51 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.51 -p tcp --sport 443 -j ACCEPT

iptables -t nat -I  PREROUTING -p tcp --dport 9099 -i eth1 -j DNAT --to 192.168.57.241:3306
iptables -t nat -I POSTROUTING -d 192.168.57.241 -p tcp --dport 3306 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.241 -p tcp --dport 3306 -j ACCEPT
iptables -I FORWARD -s 192.168.57.241 -p tcp --sport 3306 -j ACCEPT

#Adding by Mubeen  >> ASCENT 
iptables -t nat -I  PREROUTING -p tcp --dport 9001 -i eth1 -j DNAT --to 192.168.57.236:80
iptables -t nat -I POSTROUTING -d 192.168.57.236 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.236 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.236 -p tcp --sport 80 -j ACCEPT

iptables -A FORWARD -o eth0 -p tcp --dport 25 -j REJECT


iptables --table nat --append POSTROUTING --out-interface ppp0 -j MASQUERADE
iptables -I INPUT -s 10.0.0.0/8 -i ppp0 -j ACCEPT
iptables --append FORWARD --in-interface eth0 -j ACCEPT


#Added by Mubeen for TSI (Shantonu)
iptables -t nat -I  PREROUTING -p tcp --dport 86 -i eth1 -j DNAT --to 192.168.57.149:80
iptables -t nat -I POSTROUTING -d 192.168.57.149 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.149 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.149 -p tcp --sport 80 -j ACCEPT

#Added by Mubeen for Wespro 
iptables -t nat -I  PREROUTING -p tcp --dport 9095 -i eth1 -j DNAT --to 192.168.57.241:80
iptables -t nat -I POSTROUTING -d 192.168.57.241 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.241 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.241 -p tcp --sport 80 -j ACCEPT

#Added by Mubeen for Support Ticket System
iptables -t nat -I  PREROUTING -p tcp --dport 9595 -i eth1 -j DNAT --to 192.168.57.141:80
iptables -t nat -I POSTROUTING -d 192.168.57.141 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.141 -p tcp --dport 80 -j ACCEPT
#Allow amadeus web application
iptables -A FORWARD -p tcp --sport 20002 -j ACCEPT
iptables -A FORWARD -p tcp --dport 20002 -j ACCEPT

#Allow cisco vpn access
iptables -A FORWARD -p udp --dport 500 -j ACCEPT
iptables -A FORWARD -p udp --sport 500 -j ACCEPT

#Allow pugmarks on 8443 port
iptables -A FORWARD -d 65.182.191.189 -p tcp --dport 8443 -j ACCEPT
iptables -A FORWARD -s 65.182.191.189 -p tcp --sport 8443 -j ACCEPT

#Allow dropit.3dsecure.net on 9443 port
iptables -A FORWARD -d 198.241.171.150 -p tcp --dport 9443 -j ACCEPT
iptables -A FORWARD -s 198.241.171.150 -p tcp --sport 9443 -j ACCEPT

#Allow nisar on 1443
iptables -A FORWARD -d 207.106.22.54 -p tcp --dport 1434 -j ACCEPT
iptables -A FORWARD -s 207.106.22.54 -p tcp --sport 1434 -j ACCEPT
iptables -A FORWARD -s 207.106.22.54 -p tcp --sport 1433 -j ACCEPT
iptables -A FORWARD -s 207.106.22.54 -p tcp --sport 1433 -j ACCEPT

#----------------SKYPE section-------------------##---------------------SKYPE section--------------# 

iptables -A FORWARD -s 192.168.57.0/24 -p tcp --sport 62507 -j ACCEPT
iptables -A FORWARD -d 192.168.57.0/24 -p tcp --dport 62507 -j ACCEPT

#To block all the ips other than proxy  
iptables -A FORWARD -i eth0 -o eth1 -s ! $SQUID_PROXY_IP -p tcp --syn -j DROP 
#iptables -A FORWARD -i eth0 -o eth1 -s 192.168.57.0/24  -p tcp --syn -j ACCEPT

iptables -A FORWARD -p tcp --dport 80   -j ACCEPT
iptables -A FORWARD -p tcp --sport 80   -j ACCEPT
iptables -A FORWARD -p tcp --dport 443  -j ACCEPT
iptables -A FORWARD -p tcp --sport 443  -j ACCEPT
iptables -A FORWARD -j DROP

#-----------------------**  INPUT chain rules **-------------------------------------------------------------#

#Accept all traffice for loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp  -j ACCEPT

#Allow webmin access
iptables -A INPUT -i eth0 -p tcp --dport 10080 -j ACCEPT

#Allow snmp port from eth0 
iptables -A INPUT -i eth0 -p udp --dport 161 -j ACCEPT
iptables -A INPUT -i eth1 -s 61.12.31.51 -p udp --dport 161 -j ACCEPT

#Accept all the responses from intranet and internet
iptables -A INPUT -i eth0 -p tcp -m tcp ! --syn -j ACCEPT
iptables -A INPUT -i eth1 -p tcp -m tcp ! --syn -j ACCEPT

#Accept ping from our network
iptables -A INPUT -i eth0  -p icmp -j ACCEPT
iptables -A INPUT -i eth1  -p icmp -j ACCEPT

#Accept snmp to check port 25
iptables -A INPUT -i eth0 -p tcp --dport 25 -j ACCEPT

#--------------------------- **  FTP SECTION **----------------------------------------------------------------#

#Allow ports from 5000 to 5010 for ftp data mode
iptables -A INPUT -i eth1  -p tcp -m tcp --dport 5000:5010 -j ACCEPT


#Times --cotact - pradeep.sharma
iptables -A INPUT -i eth1 -s 122.162.104.130  -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 202.54.243.53  -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 61.12.31.51   -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 122.160.153.10  -p tcp -m tcp --dport 20:21 -j ACCEPT


#Allow TIL BLOGS clients to access ftp #Contact Mr. Pranjal
iptables -A INPUT -i eth1 -s 220.226.197.219 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 220.226.197.162 -p tcp -m tcp --dport 20:21 -j ACCEPT

#Allow MGHFTP to Access --- Shantonu Rae
iptables -A INPUT -i eth1 -s 202.65.11.55 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 202.65.11.50 -p tcp -m tcp --dport 20:21 -j ACCEPT

#Allow MERCURY FTP to Access ---Nisar Siddique / Manish Tak
iptables -A INPUT -i eth1 -s 125.18.117.202 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 125.21.42.42 -p tcp -m tcp --dport 20:21 -j ACCEPT

#Allow Milestone 
iptables -A INPUT -i eth1 -s 202.63.168.2 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 125.99.63.133 -p tcp -m tcp --dport 20:21 -j ACCEPT

iptables -A INPUT -i eth1 -s 123.237.7.133 -p tcp -m tcp --dport 20:21 -j ACCEPT

#Allow ftp access to local network
iptables -A INPUT -i eth0 -s 192.168.57.0/24 -p tcp -m tcp --dport 20:21 -j ACCEPT 


#Jaipur Office
iptables -A INPUT -i eth1 -s 122.161.160.9 -p tcp -m tcp --dport 20:21 -j ACCEPT
iptables -A INPUT -i eth1 -s 122.163.83.79 -p tcp -m tcp --dport 20:21 -j ACCEPT


#----------------------------**  SSH SECTION  ** ------------------------------------------------------------------#
#Allow sagar from home
# for bglens access
iptables -A INPUT -i eth1 -s 220.226.197.162 -p tcp -m tcp --dport 22 -j ACCEPT


#Accept ssh access to local network
iptables -A INPUT -i eth0 -s 192.168.57.0/24  -p tcp -m tcp --dport 22 -j ACCEPT 

##Block outgoing SSH to vsnl ip's
iptables -A OUTPUT  -d 82.197.80.125 -p tcp --dport 22 -j DROP
iptables -A OUTPUT  -d 82.197.80.100 -p tcp --dport 22 -j DROP

#-------------------------** TELNET SECTION  ** --------------------------------------------------------------------#
#Allow telnet to local network
iptables -A INPUT -i eth0 -s 192.168.57.0/24  -p tcp -m tcp --dport 23 -j ACCEPT 

#Allow DNS responses to local machine
#iptables -A INPUT -p tcp -m tcp --dport 22 -j LOG
iptables -A INPUT -p udp -m udp --sport 53 -j ACCEPT
iptables -A INPUT -j DROP

#----------------------------------- OUTPUT chain rules -------------------------------------------------------------#
#Adding by Nagendra for gaurav garg 
iptables -t nat -I  PREROUTING -p tcp --dport 8084 -i eth1 -j DNAT --to 192.168.57.154:80
iptables -t nat -I POSTROUTING -d 192.168.57.154 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -i eth1 -d 192.168.57.154 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -i eth0 -s 192.168.57.154 -p tcp --sport 80 -j ACCEPT

#241 server 
iptables -t nat -I  PREROUTING -p tcp --dport 8087 -i eth1 -j DNAT --to 192.168.57.241:80
iptables -t nat -I POSTROUTING -d 192.168.57.241 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -i eth1 -d 192.168.57.241 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -i eth0 -s 192.168.57.241 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra fo sugarcrm and mediawikis
#iptables -t nat -I  PREROUTING -p tcp --dport 82  -i eth1 -j DNAT --to 192.168.57.90:80
#iptables -t nat -I POSTROUTING -d 192.168.57.90 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
#iptables -I FORWARD -i eth1 -d 192.168.57.90 -p tcp --dport 80 -j ACCEPT
#iptables -I FORWARD -i eth0 -s 192.168.57.90 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra Pal >> Wirelss Router
iptables -t nat -I  PREROUTING -p tcp --dport 443 -i eth1 -j DNAT --to 192.168.57.225:443
iptables -t nat -I POSTROUTING -d 192.168.57.225 -p tcp --dport 443 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.225 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.225 -p tcp --sport 443 -j ACCEPT


#Added by Nagendra >>  Nagios
iptables -t nat -I  PREROUTING -p tcp --dport 8094 -i eth1 -j DNAT --to 192.168.57.2:80
iptables -t nat -I POSTROUTING -d 192.168.57.2 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.2 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.2 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra 
iptables -t nat -I  PREROUTING -p tcp --dport 8089 -i eth1 -j DNAT --to 192.168.57.206:80
iptables -t nat -I POSTROUTING -d 192.168.57.206 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.206 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra 
iptables -t nat -I  PREROUTING -p tcp --dport 22022 -i eth1 -j DNAT --to 192.168.57.206:22
iptables -t nat -I POSTROUTING -d 192.168.57.206 -p tcp --dport 22 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.206 -p tcp --dport 22 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --sport 22 -j ACCEPT

#Adding by Nagendra  >> US SugarCRM
iptables -t nat -I  PREROUTING -p tcp --dport 83 -i eth1 -j DNAT --to 192.168.57.199:80
iptables -t nat -I POSTROUTING -d 192.168.57.199 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.199 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.199 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra Pal   # Test Was Ontra Server
iptables -t nat -I  PREROUTING -p tcp --dport 9003 -i eth1 -j DNAT --to 192.168.57.49:8085
iptables -t nat -I POSTROUTING -d 192.168.57.49 -p tcp --dport 8085 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.49 -p tcp --dport 8085 -j ACCEPT
iptables -I FORWARD -s 192.168.57.49 -p tcp --sport 8085 -j ACCEPT

#Adding by Nagendra >> TEST WAS SERVER
iptables -t nat -I  PREROUTING -p tcp --dport 3307 -i eth1 -j DNAT --to 192.168.57.206:3306
iptables -t nat -I POSTROUTING -d 192.168.57.206 -p tcp --dport 3306 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.206 -p tcp --dport 3306 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --sport 3306 -j ACCEPT

#Adding by Nagendra 
iptables -t nat -I  PREROUTING -p tcp --dport 8085 -i eth1 -j DNAT --to 192.168.57.206:8085
iptables -t nat -I POSTROUTING -d 192.168.57.206 -p tcp --dport 8085 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.206 -p tcp --dport 8085 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --sport 8085 -j ACCEPT

#Adding by Sagar >> SUSE SERVER
iptables -t nat -I  PREROUTING -p tcp --dport 8098 -i eth1 -j DNAT --to 192.168.57.157:8080
iptables -t nat -I POSTROUTING -d 192.168.57.157 -p tcp --dport 8080 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.157 -p tcp --dport 8080 -j ACCEPT
iptables -I FORWARD -s 192.168.57.157 -p tcp --sport 8080 -j ACCEPT


#Adding by Nagendra Pal --DEMO SERVER 
#iptables -t nat -I  PREROUTING -p tcp --dport 9081 -i eth1 -j DNAT --to 192.168.57.5:80
#iptables -t nat -I POSTROUTING -d 192.168.57.5 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
#iptables -I FORWARD -d 192.168.57.5 -p tcp --dport 80 -j ACCEPT
#iptables -I FORWARD -s 192.168.57.5 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra Pal --DEMO SERVER 
iptables -t nat -I  PREROUTING -p tcp --dport 9080 -i eth1 -j DNAT --to 192.168.57.5:9080
iptables -t nat -I POSTROUTING -d 192.168.57.5 -p tcp --dport 9080 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.5 -p tcp --dport 9080 -j ACCEPT
iptables -I FORWARD -s 192.168.57.5 -p tcp --sport 9080 -j ACCEPT

iptables -t nat -I  PREROUTING -p tcp --dport 10090 -i eth1 -j DNAT --to 192.168.57.5:80
iptables -t nat -I POSTROUTING -d 192.168.57.5 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.5 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.5 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra  >> SOLARIS SERVER 
iptables -t nat -I  PREROUTING -p tcp --dport 443 -i eth1 -j DNAT --to 192.168.57.51:80
iptables -t nat -I POSTROUTING -d 192.168.57.51 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.51 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.51 -p tcp --sport 80 -j ACCEPT

#Adding by Nagendra  >> SOLARIS SERVER 
iptables -t nat -I  PREROUTING -p tcp --dport 8086 -i eth1 -j DNAT --to 192.168.57.51:443
iptables -t nat -I POSTROUTING -d 192.168.57.51 -p tcp --dport 443 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.51 -p tcp --dport 443 -j ACCEPT
iptables -I FORWARD -s 192.168.57.51 -p tcp --sport 443 -j ACCEPT

iptables -t nat -I  PREROUTING -p tcp --dport 9099 -i eth1 -j DNAT --to 192.168.57.241:3306
iptables -t nat -I POSTROUTING -d 192.168.57.241 -p tcp --dport 3306 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.241 -p tcp --dport 3306 -j ACCEPT
iptables -I FORWARD -s 192.168.57.241 -p tcp --sport 3306 -j ACCEPT

iptables -A FORWARD -o eth0 -p tcp --dport 25 -j REJECT


iptables --table nat --append POSTROUTING --out-interface ppp0 -j MASQUERADE
iptables -I INPUT -s 10.0.0.0/8 -i ppp0 -j ACCEPT
iptables --append FORWARD --in-interface eth0 -j ACCEPT


#Added by Mubeen for TSI (Shantonu)
iptables -t nat -I  PREROUTING -p tcp --dport 86 -i eth1 -j DNAT --to 192.168.57.149:80
iptables -t nat -I POSTROUTING -d 192.168.57.149 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.149 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.149 -p tcp --sport 80 -j ACCEPT

#Added by Mubeen for Wespro 
iptables -t nat -I  PREROUTING -p tcp --dport 9095 -i eth1 -j DNAT --to 192.168.57.241:80
iptables -t nat -I POSTROUTING -d 192.168.57.241 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.241 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.241 -p tcp --sport 80 -j ACCEPT

#Added by Mubeen for Support Ticket System
iptables -t nat -I  PREROUTING -p tcp --dport 9595 -i eth1 -j DNAT --to 192.168.57.141:80
iptables -t nat -I POSTROUTING -d 192.168.57.141 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.141 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.141 -p tcp --sport 80 -j ACCEPT

#Added by Sagar for QNA
iptables -t nat -I  PREROUTING -p tcp --dport 9596 -i eth1 -j DNAT --to 192.168.57.175:80
iptables -t nat -I POSTROUTING -d 192.168.57.175 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.175 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.175 -p tcp --sport 80 -j ACCEPT

#Added by Sagar for Kotak
iptables -t nat -I  PREROUTING -p tcp --dport 7110 -i eth1 -j DNAT --to 192.168.57.245:7110
iptables -t nat -I POSTROUTING -d 192.168.57.245 -p tcp --dport 7110 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.245 -p tcp --dport 7110 -j ACCEPT
iptables -I FORWARD -s 192.168.57.245 -p tcp --sport 7110 -j ACCEPT

#Added by Sagar for Ascent
iptables -t nat -I  PREROUTING -p tcp --dport 9597 -i eth1 -j DNAT --to 192.168.57.236:90
iptables -t nat -I POSTROUTING -d 192.168.57.236 -p tcp --dport 90 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.236 -p tcp --dport 90 -j ACCEPT
iptables -I FORWARD -s 192.168.57.236 -p tcp --sport 90 -j ACCEPT

#Added by Sagar for 206 CVS
iptables -t nat -I  PREROUTING -p tcp --dport 2403 -i eth1 -j DNAT --to 192.168.57.206:2401
iptables -t nat -I POSTROUTING -d 192.168.57.206 -p tcp --dport 2401 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.206 -p tcp --dport 2401 -j ACCEPT
iptables -I FORWARD -s 192.168.57.206 -p tcp --sport 2401 -j ACCEPT

#Added by Sagar for 230 CVS
iptables -t nat -I  PREROUTING -p tcp --dport 9598 -i eth1 -j DNAT --to 192.168.57.230:80
iptables -t nat -I POSTROUTING -d 192.168.57.230 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.230 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.230 -p tcp --sport 80 -j ACCEPT

#Added by Sagar for 111 Vishal 
iptables -t nat -I  PREROUTING -p tcp --dport 9011 -i eth1 -j DNAT --to 192.168.57.111:8080
iptables -t nat -I POSTROUTING -d 192.168.57.111 -p tcp --dport 8080 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.111 -p tcp --dport 8080 -j ACCEPT
iptables -I FORWARD -s 192.168.57.111 -p tcp --sport 8080 -j ACCEPT

#Gmail Access
#Gmail to Sujan Singh
iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.159 -p tcp --dport 995 -j ACCEPT
iptables -I FORWARD -s 192.168.57.159 -p tcp --dport 995 -j ACCEPT
iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.159 -p tcp --dport 587 -j ACCEPT
iptables -I FORWARD -s 192.168.57.159 -p tcp --dport 587 -j ACCEPT

#Gmail to Sandeep Gupta
iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.95 -p tcp --dport 995 -j ACCEPT
iptables -I FORWARD -s 192.168.57.95 -p tcp --dport 995 -j ACCEPT
iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.95 -p tcp --dport 587 -j ACCEPT
iptables -I FORWARD -s 192.168.57.95 -p tcp --dport 587 -j ACCEPT

#Gmail to Naaptol
iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.248 -p tcp --dport 995 -j ACCEPT
iptables -I FORWARD -s 192.168.57.248 -p tcp --dport 995 -j ACCEPT
iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.248 -p tcp --dport 465 -j ACCEPT
iptables -I FORWARD -s 192.168.57.248 -p tcp --dport 465 -j ACCEPT

#Gmail to Sudipta
iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.229 -p tcp --dport 995 -j ACCEPT
iptables -I FORWARD -s 192.168.57.229 -p tcp --dport 995 -j ACCEPT
iptables -t nat -I PREROUTING -i eth0 -s 192.168.57.229 -p tcp --dport 587 -j ACCEPT
iptables -I FORWARD -s 192.168.57.229 -p tcp --dport 587 -j ACCEPT


#Added by Sandip for fnpuat 
iptables -t nat -I  PREROUTING -p tcp --dport 9012 -i eth1 -j DNAT --to 192.168.57.253:80
iptables -t nat -I POSTROUTING -d 192.168.57.253 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.253 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.253 -p tcp --sport 80 -j ACCEPT

#Added by Sandip for ump.anmsoft.com
iptables -t nat -I  PREROUTING -p tcp --dport 9013 -i eth1 -j DNAT --to 192.168.57.241:80
iptables -t nat -I POSTROUTING -d 192.168.57.241 -p tcp --dport 80 -j SNAT --to $MY_LAN_IP
iptables -I FORWARD -d 192.168.57.241 -p tcp --dport 80 -j ACCEPT
iptables -I FORWARD -s 192.168.57.241 -p tcp --sport 80 -j ACCEPT

