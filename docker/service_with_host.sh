.HOST
1)/data/docker/init.sh
#!/bin/bash
times=0
while true
do
  docker ps | grep mydockername
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

ip=$(docker inspect mydockername | grep '\<IPAddress\>' | tail -1 | sed 's/"\|,\| //g' | awk -F: '{print $2}') 
 
/usr/bin/expect <<EOF
spawn /usr/bin/docker exec -it mydockername bash

expect "#"
send "/data/scripts/services.sh; echo $ip >> /tmp/a.txt; \r"

expect "#"
exit

expect eof
exit
EOF

2)/etc/rc.local
/data/docker/init.sh

////////////////////////////////

3)container /data/scripts/services.sh
   /etc/init.d/cron status || /etc/init.d/cron start
   /etc/init.d/nginx status || /etc/init.d/nginx start
   /etc/init.d/ssh status || /etc/init.d/ssh start
