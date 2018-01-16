 add-apt-repository ppa:certbot/certbot 
 apt-get update 
 apt-get install python-certbot-nginx
 
.安装证书 
#!/bin/bash
# certbot --nginx
certbot --authenticator standalone --installer nginx --pre-hook "service nginx stop" --post-hook "service nginx start"


.更新证书
#!/bin/bash
# certbot renew
certbot --authenticator standalone --installer nginx --pre-hook "service nginx stop" --post-hook "service nginx start" renew
