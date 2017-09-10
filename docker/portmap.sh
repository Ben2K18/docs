添加端口映射, 如映射host:8080 ==>  myubuntu:80
./data/scripts/docker/portmap.sh

#!/bin/bash
if [ $# -ne 3 ]
then
    echo Usage: $0 host_port comtainer_port
    echo        $0 myubuntu 8080 80
    exit
fi

container=$1
sport=$2
dport=$3

times=0
while true
do
  docker ps | grep $container
  if [ $? -eq 0 ]
  then
     break
 fi

  if [ $times -gt 100 ]
  then
      echo $container not  running >> /var/log/syslog
    exit
  fi
  sleep 3
  ((times=times+1))
done

dip=$(docker inspect $container | grep '\<IPAddress\>' | tail -1 | sed 's/"\|,\| //g' | awk -F: '{print $2}')

/sbin/iptables -t nat -A DOCKER -p tcp --dport $sport -j DNAT --to-destination $dip:$dport
/sbin/iptables -t nat -A POSTROUTING -j MASQUERADE -p tcp --source $dip --destination $dip --dport $dport
/sbin/iptables -A DOCKER -j ACCEPT -p tcp --destination $dip --dport $dport

ufw allow $sport
#End of Script

.
$ sudo /data/scripts/docker/portmap.sh myubuntu  8080  80
