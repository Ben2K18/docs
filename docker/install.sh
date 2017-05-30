1) 安装docker
sudo -s

apt-get -y install apt-transport-https ca-certificates curl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update 

apt-get -y install docker-ce

2) 修改docker container的存储路径为/data/docker
   sed -i 's/^DOCKER_OPTS=""$/DOCKER_OPTS=" --graph \/data\/docker "/' /etc/init.d/docker
   
   /etc/init.d/docker restart

3) 创建一个ubuntu:16.04的名为myubuntu的docker, 挂载主机目录/data/docker/data/node.qcourse.cc为docker内/data
   docker run -it -d -p 8080:80 -p 2222:22 -v /data/docker/data/node.qcourse.cc:/data --name <b>myubuntu</b> --restart=always ubuntu:16.04 /bin/bash
   
   docker update --restart=no|unless-stopped|always myubuntu
   
4) 列出所有的docker
   docker ps -a 
   
   只列出docker id
   docker ps -a -q
   
   删除所有非运行中的docker
   docker rm $(docker ps -a -q)
   
5) 进入docker
   docker exec -it <b>myubuntu</b> bash
   
   更新docker内的软件
   # apt update
   # apt upgrade
   
   安装软件
   # apt install vim curl wget cron
   
   运行cron进程
   # update-rc.d cron enable
   # /etc/init.d/cron start
   
   安装 
   apt-get install vim curl wget elinks 
   
   #ssh
   1) install
   apt-get install openssh-server
   
   2) permit root
   vim /etc/ssh/sshd_config.conf
     PasswordAuthentication yes
     PermitRootLogin yes
     
   3) restart
   /etc/init.d/ssh restart
   
6) 添加端口映射
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

ufw allow $1
#End of Script
