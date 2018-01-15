#!/bin/bash
# ./getip.sh containername
#    172.17.0.10
#
name=$1
/usr/bin/docker inspect $name|grep '"IPAddress"'|head -n1|sed -e 's/"//g' -e 's/,//g'|awk -F : '{print $2}'|sed 's/\s\+//g'
