1) 安装docker
sudo -s

apt-get -y install apt-transport-https ca-certificates curl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update 

apt-get -y install docker-ce


2) 创建一个ubuntu:16.04的名为myubuntu的docker
   docker run -d -it -name myubuntu  ubuntu:16.04
   
3) 列出所有的docker
   docker ps -a
   
4) 进入docker
   docker exec -it myubuntu bash
   
   更新docker内的软件
   # apt update
   # apt upgrade
   
   安装软件
   # apt install vim curl wget cron
   
   运行cron进程
   # update-rc.d cron enable
   # /etc/init.d/cron start
   
   安装mysql / nginx 
   apt-get install nginx-extras mysql-server-5.7 mysql-client-5.7
   
5) 添加端口映射
#!/bin/bash
# Script: portmap.sh
# Usage: <b>./portmap.sh</b>  8080  <b>myubuntu</b> 80

[ $# -eq 3 ] || { 
   echo "Usage: $0 host_port containerid container_port";
   echo "       $0 85 myserver 80"; 
   exit 1; 
}
  
function portmap() {
   host_port=$1
   containerid=$2
   container_port=$3

   ip=$(docker inspect webserver2 | grep '\<IPAddress\>' | tail -1 | sed 's/"\|,\| //g' | awk -F: '{print $2}')
   iptables -t nat -A  DOCKER -p tcp --dport 85 -j DNAT --to-destination $ip:80
}

portmap $1 $2 $3 
#End of Script
