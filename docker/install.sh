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
   
