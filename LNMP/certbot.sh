 add-apt-repository ppa:certbot/certbot 
 apt-get update 
 apt-get install python-certbot-nginx

 安装证书
 certbot --nginx
 
 更新证书
 certbot renew
