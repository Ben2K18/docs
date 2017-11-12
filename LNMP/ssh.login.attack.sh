1)crontab -e
* * * * * /data/scripts/ssh.login.attack.sh

2)/data/scripts/ssh.login.attack.sh
#!/bin/bash

whitelist=(
   172.17.0
)

# iswhite $ip
function iswhite() {
     ip=$1
     for wip in ${whitelist[@]}
     do
        if [[ "$ip" =~ ^"$wip" ]]
        then
           echo 1
           return
        fi
     done
     echo 0
}

#banip $ip
function banip() {
     ip=$1
     /usr/sbin/ufw status |grep $ip >/dev/null
     if [ $? -ne 0 ]
     then
        echo -n "deny from $ip "
        /usr/sbin/ufw insert 1 deny from $ip
     fi
}

while read line
do
   read num ip _ <<< "$line"
   
   white=$(iswhite $ip)
   if [ $white -eq 1 ]
   then
      echo $ip is white
      continue
   fi
    
   if [ $num -gt  5 ]
   then
      banip $ip
   fi
done <<< "$(lastb |awk '/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]/ {print $3,$4,$5,$6,$7}'|grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' |awk -F: '{print $1}'|sort|uniq -c|sort -nr)"

while read ip
do
  banip $ip
done < /data/docker/mydocker1/data/scripts/banip.txt

#############################################################################

3)docker container (/data/docker/
a) crontab -e
  * * * * * /data/scripts/ssh.login.attack.sh

b)/data/scripts/ssh.login.attack.sh
#!/bin/bash
#ban the ip , which failed nums great than 5 every hour
#

whitelist=(
   172.17.0
)

# iswhite $ip
function iswhite() {
     ip=$1
     for wip in ${whitelist[@]}
     do
        if [[ "$ip" =~ ^"$wip" ]]
        then
           echo 1
           return
        fi
     done
     echo 0
}

while read line
do
   read num ip _ <<< "$line"
   if [ $num -gt  5 ]
   then
    white=$(iswhite $ip)
    if [ $white -eq 1 ]
    then
       echo $ip is white
       continue
    fi

    grep $ip /data/scripts/banip.txt >/dev/null || echo $ip >> /data/scripts/banip.txt
   fi
done <<< "$(lastb |awk '/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]/ {print $3,$4,$5,$6,$7}'|grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' |awk -F: '{print $1}'|sort|uniq -c|sort -nr)"

