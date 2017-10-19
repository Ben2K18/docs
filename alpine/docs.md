<pre>
<b>.Setting System Hostname</b>
# echo "shortname" > /etc/hostname
# hostname -F /etc/hostname
# echo '192.168.1.150   shortname.domain.com' >> /etc/hosts
# echo '2001:470:ffff:ff::2   shortname.domain.com' >> /etc/hosts

<b>./etc/resolv.conf</b>
nameserver 8.8.8.8
nameserver 8.8.4.4

<b>.enable ipv6</b>
modprobe ipv6
echo "ipv6" >> /etc/modules

<b>.dhcp /etc/network/interfaces</b>
auto eth0
iface eth0 inet dhcp

<b>./etc/network/interfaces</b>
auto eth0
iface eth0 inet static
        address 192.168.1.150
        netmask 255.255.255.0
        gateway 192.168.1.1
        
<b>.check config</b>
ifconfig

<b>.manage services</b>
 apk add openrc-run
 rc-update add ssh
 rc-update del ssh

<b>.iptables</b>
apk add iptables
apk add ip6tables
apk add iptables-doc

rc-update add iptables 
/etc/init.d/iptables save
lbu ci 

rc-update add ip6tables 
/etc/init.d/ip6tables save
lbu ci 

<b>.restart network</b>
/etc/init.d/networking restart

<b>.install iputils</b>
 apk add iputils
 
<b>.iproute2</b>
  apk add iproute2
   
  ss -tl
  ss -ptl
  ss -tnl
  ss -ta
  ss -s

<b>.dig drill</b>
  apk add drill
  
  drill baidu.com @8.8.8.8
  
