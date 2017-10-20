
```nginx
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
