1)crontab -e
* * * * * /data/scripts/ssh.login.attack.sh

2)/data/scripts/ssh.login.attack.sh
#!/bin/bash
while read line
do
   read num ip _ <<< "$line"
   if [ $num -gt  10 ]
   then
     ufw status |grep $ip >/dev/null
     if [ $? -ne 0 ]
     then
        echo -n "deny from $ip "
        ufw insert 1 deny from $ip
     fi
   fi
done <<< "$(lastb |awk '/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]/ {print $3,$4,$5,$6,$7}'|grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' |awk -F: '{print $1}'|sort|uniq -c|sort -nr)"
