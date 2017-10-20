
```nginx
.连接优化
worker_processes 8;

worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000 10000000;

worker_rlimit_nofile 102400;

events {
    use epoll;
    worker_connections 102400;
}

http {
    upstream redisbackend {
        server 127.0.0.1:6379;
        keepalive 1000;
    }

    server {
        listen 8080 reuseport;
    }
}

. 限速
1. 限制访问请求数
语法: limit_req_zone $variable zone=name:size rate=rate;
默认值: none
配置段: http

设置一块共享内存size MB限制域用来保存键值的状态参数。 
特别是保存了当前超出请求的数量。 键的值就是指定的变量（空值不会被计算）。如
limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;

说明：区域名称为one，大小为10m，平均处理的请求频率不能超过每秒一次。

键是:IP,使用$binary_remote_addr变量， 可以将每条状态记录的大小减少到64个字节，这样1M的内存可以保存大约1万6千个64字节的记录。
如果限制域的存储空间耗尽了，对于后续所有请求，服务器都会返回 503 (Service Temporarily Unavailable)错误。
速度可以设置为每秒处理请求数和每分钟处理请求数，其值必须是整数，所以如果你需要指定每秒处理少于1个的请求，2秒处理一个请求，可以使用 “30r/m”。

limit_req_log_level
语法: limit_req_log_level info | notice | warn | error;
默认值: limit_req_log_level error;
配置段: http, server, location
设置你所希望的日志级别，当服务器因为频率过高拒绝或者延迟处理请求时可以记下相应级别的日志。 延迟记录的日志级别比拒绝的低一个级别；比如， 如果设置“limit_req_log_level notice”， 延迟的日志就是info级别。

limit_req_status
语法: limit_req_status code;
默认值: limit_req_status 503;
配置段: http, server, location
该指令在1.3.15版本引入。设置拒绝请求的响应状态码。

limit_req
语法: limit_req zone=name [burst=number] [nodelay];
默认值: —
配置段: http, server, location
设置对应的共享内存限制域和允许被处理的最大请求数阈值。 如果请求的频率超过了限制域配置的值，请求处理会被延迟，所以所有的请求都是以定义的频率被处理的。 超过频率限制的请求会被延迟，直到被延迟的请求数超过了定义的阈值，这时，这个请求会被终止，并返回503 (Service Temporarily Unavailable) 错误。

示例
http {
    limit_req_zone $binary_remote_addr zone=eop:10m rate=20r/s;

    server {
        location  ^~ /download/ {
            #限制每ip每秒不超过20个请求，漏桶数burst为5
                    #brust的意思就是，如果第1秒、2,3,4秒请求为19个，
                    #第5秒的请求为25个是被允许的。
                    #但是如果你第1秒就25个请求，第2秒超过20的请求返回503错误。
                    #nodelay，如果不设置该选项，严格使用平均速率限制请求数，
                    #第1秒25个请求时，5个请求放到第2秒执行，
                    #设置nodelay，25个请求将在第1秒执行。  
            limit_req zone=eop burst=5;
            alias /data/www.eop.com/download/;
        }
    }
}

2. 限制并发连接数
语法: limit_conn_zone $variable zone=name:size;
默认值: none
配置段: http
键的状态中保存了当前连接数，键的值可以是特定变量的任何非空值（空值将不会被考虑）。
$variable定义键，zone=name定义区域名称，后面的limit_conn指令会用到的。size定义各个键共享内存空间大小。如：
limit_conn_zone $binary_remote_addr zone=addr:10m;

注释：客户端的IP地址作为键。注意，这里使用的是$binary_remote_addr变量，而不是$remote_addr变量。
$remote_addr变量的长度为7字节到15字节，而存储状态在32位平台中占用32字节或64字节，在64位平台中占用64字节。
$binary_remote_addr变量的长度是固定的4字节，存储状态在32位平台中占用32字节或64字节，在64位平台中占用64字节。
1M共享空间可以保存3.2万个32位的状态，1.6万个64位的状态。
如果共享内存空间被耗尽，服务器将会对后续所有的请求返回 503 (Service Temporarily Unavailable) 错误。
limit_zone 指令和limit_conn_zone指令同等意思，已经被弃用，就不再做说明了。

limit_conn_log_level
语法：limit_conn_log_level info | notice | warn | error
默认值：error
配置段：http, server, location
当达到最大限制连接数后，记录日志的等级。

limit_conn
语法：limit_conn zone_name number
默认值：none
配置段：http, server, location
指定每个给定键值的最大同时连接数，当超过这个数字时被返回503 (Service Temporarily Unavailable)错误。如：

limit_conn_zone $binary_remote_addr zone=addr:10m;
server {
    location /www.ttlsa.com/ {
        limit_conn addr 1;
    }
}

同一IP同一时间只允许有一个连接。
当多个 limit_conn 指令被配置时，所有的连接数限制都会生效。比如，下面配置不仅会限制单一IP来源的连接数，同时也会限制单一虚拟服务器的总连接数：

limit_conn_zone $binary_remote_addr zone=perip:10m;
limit_conn_zone $server_name zone=perserver:10m;
server {
    limit_conn perip 10;
    limit_conn perserver 100;
}
[warning]limit_conn指令可以从上级继承下来。[/warning]

limit_conn_status
语法: limit_conn_status code;
默认值: limit_conn_status 503;
配置段: http, server, location
该指定在1.3.15版本引入的。指定当超过限制时，返回的状态码。默认是503。

limit_rate
语法：limit_rate rate
默认值：0
配置段：http, server, location, if in location
对每个连接的速率限制。参数rate的单位是字节/秒，设置为0将关闭限速。 按连接限速而不是按IP限制，因此如果某个客户端同时开启了两个连接，那么客户端的整体速率是这条指令设置值的2倍。

配置示例
http {
    geo $whiteiplist  {
        default 1;
        218.249.60.68 0;
    }
    map $whiteiplist $limit {
        1 $binary_remote_addr;
        0 "";
    }
    #limit_conn_zone $limit zone=limit:10m;
    #limit_req_zone $binary_remote_addr zone=limit_req:10m rate=3r/m;
    limit_req_zone $limit zone=limit_req:10m rate=3r/m;
    limit_req zone=limit_req burst=1 nodelay;
    limit_req_status 503;
    limit_req_log_level error;

    server {
    }
}

.limit_conn_zone
#10m will store 160k requests history
limit_conn_zone $binary_remote_addr zone=conzone:10m;

#max 1000 connections per IP at any time
limit_conn conzone 1000;

.limit_req_zone
#5 requests/second from 1 IP address are allowed.
#Between 5 and 10 requests/sec all new incoming requests are delayed.
#Over 10 requests/sec all new incoming requests are rejected with the status code set in limit_req_status

limit_req_zone $binary_remote_addr zone=reqzone:10m rate=5r/s;
limit_req zone=reqzone burst=10;
limit_req_status 503;

.limit_rate
limit_rate 50k;
limit_rate_after 500k;

///////////////////// Example //////////////////////////
#除以下白名单外的IP进行连接和请求限制

geo $whiteiplist  {
   default 1;   
   127.0.0.1 0;   
   10.0.0.0/8 0;   
   121.207.242.0/24 0;   
}

#映射白名单以外的IP为灰色IP，需要限制
map $whiteiplist  $graylist {
   1 $binary_remote_addr;
   0 "";
}

limit_conn_zone $graylist zone=conzone:10m;
limit_req_zone $graylist zone=reqzone:10m rate=10r/s;

server {
    location / {    
        limit_conn conzone 8;
        
        limit_req zone=reqzone burst=20;        
        limit_req_status 503;        

        limit_rate 50k;        
        limit_rate_after 500k;        
   }
}

.access_log
配置段: http
log_format  myformat  '$server_name $remote_addr - $remote_user [$time_local] "$request" '
                        '$status $uptream_status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$http_x_forwarded_for" '
                        '$ssl_protocol $ssl_cipher $upstream_addr $request_time $upstream_response_time';
access_log /var/log/nginx/access.log myformat;

$server_name：虚拟主机名称。

$remote_addr
远程客户端的IP地址。

-
空白，用一个“-”占位符替代，历史原因导致还存在。

$remote_user
远程客户端用户名称，用于记录浏览者进行身份验证时提供的名字，如登录百度的用户名scq2099yt，如果没有登录就是空白。

[$time_local]
访问的时间与时区，比如18/Jul/2012:17:00:01 +0800，时间信息最后的"+0800"表示服务器所处时区位于UTC之后的8小时。

$request
请求的URI和HTTP协议，这是整个PV日志记录中最有用的信息，记录服务器收到一个什么样的请求

$status
记录请求返回的http状态码，比如成功是200。

$uptream_status
upstream状态，比如成功是200.

$body_bytes_sent
发送给客户端的文件主体内容的大小，比如899，可以将日志每条记录中的这个值累加起来以粗略估计服务器吞吐量。

$http_referer
记录从哪个页面链接访问过来的。 

$http_user_agent
客户端浏览器信息

$http_x_forwarded_for
客户端的真实ip，通常web服务器放在反向代理的后面，这样就不能获取到客户的IP地址了，通过$remote_add拿到的IP地址是反向代理服务器的iP地址。反向代理服务器在转发请求的http头信息中，可以增加x_forwarded_for信息，用以记录原有客户端的IP地址和原来客户端的请求的服务器地址。

$ssl_protocol
SSL协议版本，比如TLSv1

$ssl_cipher
交换数据中的算法，比如RC4-SHA。 

$upstream_addr
upstream的地址，即真正提供服务的主机地址。 

$request_time
整个请求的总时间。

$upstream_response_time
请求过程中，upstream的响应时间。


.logrotate
/home/eop/openresty/nginx/logs/*.log {
        daily
        missingok
        rotate 52
        compress
        delaycompress
        notifempty
        create 640 nginx adm
        sharedscripts
        postrotate
                [ -f /home/eop/openresty/nginx/logs/nginx.pid ] && kill -USR1 `cat /home/eop/openresty/nginx/logs/nginx.pid`
        endscript
}

配置说明: 
daily: 日志文件每天进行滚动 
missingok: 如果找不到这个log档案,就忽略过去 
rotate: 保留最进52次滚动的日志 
compress: 通过gzip压缩转储以后的日志 
delaycompress: 和compress一起使用时,转储的日志文件到下一次转储时才压缩
notifempty: 如果是空文件的话,不转储 
create mode owner group:转储文件,使用指定的文件模式创建新的日志文件 
sharedscripts: 运行postrotate脚本(该脚本作用为让nginx重新生成日志文件) 
postrotate/endscript: 在转储以后需要执行的命令可以放入这个对,这两个关键字必须单独成行

.https
1. 生成证书
cd /home/eop/openresty/nginx/conf
openssl genrsa -des3 -out server.key 1024
openssl req -new -key server.key -out server.csr
openssl rsa -in server.key -out server_nopwd.key
openssl x509 -req -days 365 -in server.csr -signkey server_nopwd.key -out server.crt

2. 配置
server {
    listen 443;
    ssl on;
    ssl_certificate  /home/eop/openresty/nginx/conf/server.crt;
    ssl_certificate_key  /home/eop/openresty/nginx/conf/server_nopwd.key;
}

