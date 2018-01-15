.host server

#!/bin/bash
#ssh.attack.sh
#

whitelist=(
   172.17.0
   x.x.x.x
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
     white=$(iswhite $ip)
     if [ $white -eq 1 ]
     then
        echo $ip is white
        return
     fi

     /usr/sbin/ufw status |grep $ip >/dev/null
     if [ $? -ne 0 ]
     then
        echo -n "deny from $ip "
        /usr/sbin/ufw insert 1 deny from $ip
     fi
}
lastb -f /var/log/btmp |awk '/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]/ {print $3,$4,$5,$6,$7}'|grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' |awk -F: '{print $1}'|sort|uniq -c|sort -nr > /tmp/login.txt


while read line
do
   read num ip _ <<< "$line"
   if [ $num -gt  8 ]
   then
      banip $ip
   fi
done < "/tmp/login.txt"

while read ip
do
  banip $ip
done < /data/docker/html.a.com/data/scripts/banip.txt
echo > /data/docker/html.a.com/data/scripts/banip.txt

while read ip
do
  banip $ip
done < /docker/datas/node.a.cc/scripts/banip.txt
echo > /docker/datas/node.a.cc/scripts/banip.txt

//////////////////////////////////////////////////////////////
.container
#!/bin/bash
# ssh.attack.sh
#
# ban the ip , which failed nums great than 5 every hour
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
echo > /var/log/btmp
