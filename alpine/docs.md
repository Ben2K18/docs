<pre>
<b>.docker run alpine</b>
   docker run -it -d -p 8889:80 -p 2225:22 -p 3356:3306 -v /home/docker/webs/alpine:/data -h alpine --name alpine --cap-add=NET_ADMIN --restart=always alpine /bin/sh

   docker exec -it alpine /bin/sh
   
   vi /etc/network/interfaces
    auto eth0
    iface eth0 inet dhcp
    
  apk update
  apk upgrade 

  apk add openrc
  openrc
  touch /run/openrc/softlevel

  apk add openssh 
  rc-update add sshd
  /etc/init.d/sshd start

  netstat -tnlp

<b>.apk</b>
  apk add|del|search vim
  apk info -a zlib
  apk info --who-owns /bin/ls
     /bin/ls symlink target is owned by busybox-1.26.2-r7
  apk cache clean 
  apk -v cache clean
  
  required check
  apk info -R package1 package2
  apk info -r package1 package2

<b>.rc-update</b>
   apk add openssh
   rc-update add sshd
   rc-status
   /etc/init.d/sshd start

<b>.mount</b>  
  mount -o remount,rw /media/sda1

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

rc-update add|del iptables 
rc-status
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
  
<b>.vlan</b>
  apk add vlan

<b>.bond</b>
  apk add bonding

/etc/network/interfaces:
auto bond0
iface bond0 inet static
	address 192.168.0.2
	netmask 255.255.255.0
	gateway 192.168.0.1
	# specify the ethernet interfaces that should be bonded
	bond-slaves eth0 eth1 eth2 eth3

<b>.vim</b>
  apk add vim
  
<b>.openssh</b>
  apk add openssh

<b>.desktop</b>
  apk add xfce4

<b>.nginx</b> 
   apk add nginx 
   adduser -D -u 1000 -g 'www' www
   mkdir /www
   chown -R www:www /var/lib/nginx
   chown -R www:www /www 

vi /etc/nginx/nginx.conf
user                            www;
worker_processes                1;

error_log                       /var/log/nginx/error.log warn;
pid                             /var/run/nginx.pid;

events {
    worker_connections          1024;
}

http {
    include                     /etc/nginx/mime.types;
    default_type                application/octet-stream;
    sendfile                    on;
    access_log                  /var/log/nginx/access.log;
    keepalive_timeout           3000;
    server {
        listen                  80;
        root                    /www;
        index                   index.html index.htm;
        server_name             localhost;
        client_max_body_size    32m;
        error_page              500 502 503 504  /50x.html;
        location = /50x.html {
              root              /var/lib/nginx/html;
        }
    }
}

rc-service nginx start
rc-service nginx restart
rc-service nginx stop
rc-update add nginx default
