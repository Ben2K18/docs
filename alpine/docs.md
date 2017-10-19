<pre>
<b>.Setting System Hostname</b>
# echo "shortname" > /etc/hostname
# hostname -F /etc/hostname
# echo '192.168.1.150   shortname.domain.com' >> /etc/hosts
# echo '2001:470:ffff:ff::2   shortname.domain.com' >> /etc/hosts

./etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4

.enable ipv6
modprobe ipv6
echo "ipv6" >> /etc/modules

.dhcp /etc/network/interfaces
auto eth0
iface eth0 inet dhcp

./etc/network/interfaces
auto eth0
iface eth0 inet static
        address 192.168.1.150
        netmask 255.255.255.0
        gateway 192.168.1.1
        
.check config
ifconfig

.manage services
 apk add openrc-run
 rc-update add ssh
 rc-update del ssh

.iptables
apk add iptables
apk add ip6tables
apk add iptables-doc

rc-update add iptables 
/etc/init.d/iptables save
If you use Alpine Local Backup:
Save the configuration
 lbu ci 
For ip6tables
Set ip6tables to start on reboot
 rc-update add ip6tables 
Write the firewall rules to disk
 /etc/init.d/ip6tables save
If you use Alpine Local Backup:
Save the configuration
 lbu ci 
