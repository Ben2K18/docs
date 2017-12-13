1) 安装docker
$ apt-get update
$ apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual 
$ apt-get install apt-transport-https ca-certificates curl software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ apt-key fingerprint 0EBFCD88
$ add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
$ apt-get update
$ apt-get install docker-ce

2) 修改docker container的存储路径为/data/docker
   mv /var/lib/docker /data/docker
   ln -s /data/docker /var/lib/
   /etc/init.d/docker restart

.)指定ip
   
   

3) 创建一个ubuntu:16.04的名为myubuntu的docker, 挂载主机目录/data/docker/data/node.qcourse.cc为docker内/data
   docker network create --subnet 172.18.0.0/24 dockernet
   docker run -it -d --ip=172.17.0.8 --net=dockernet -p 8080:80 -p 2222:22 -v /data/docker/data/node.qcourse.cc:/data -h myubuntu --name myubuntu --restart=always ubuntu:16.04 /bin/bash
   
   docker update --restart=no|unless-stopped|always myubuntu
   
4) 列出所有的docker
   docker ps -a 
   
   只列出docker id
   docker ps -a -q
   
   删除所有非运行中的docker
   docker rm $(docker ps -a -q)
   
5) 进入docker
   docker exec -it myubuntu bash
   
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
   
6) 添加端口映射, 如映射host:8080 ==>  myubuntu:80
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

7) 修改hostname
   a) 停止myubuntu和docker服务
   docker stop myubuntu
   /etc/init.d/docker stop
   
   b)修改配置文件 
   sed 's/"Hostname":"[^"]*"/"Hostname":"www-a-com"/g' /var/lib/docker/containers/d34..c2460/config.v2.json
   
   c) 启动myubuntu和docker服务
   /etc/init.d/docker start
   docker start myubuntu
   
