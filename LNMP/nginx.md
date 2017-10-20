```nginx
*.limit_conn_zone*

#10m will store 160k requests history
limit_conn_zone $binary_remote_addr zone=conzone:10m;

#max 1000 connections per IP at any time
limit_conn conzone 1000;

.limit_req_zone
#5 requests/second from 1 IP address are allowed.
#Between 5 and 10 requests/sec all new incoming requests are delayed.
#Over 10 requests/sec all new incoming requests are rejected with the status code set in limit_req_status

limit_req_zone $binary_remote_addr zone=one:10m rate=5r/s;
limit_req zone=one burst=10;
limit_req_status 503;

.limit_rate
limit_rate 50k;
limit_rate_after 500k;

geo $whiteiplist  {
   default 1;
   127.0.0.1 0;
   10.0.0.0/8 0;
   121.207.242.0/24 0;
}

map $whiteiplist  $limit {
   1 $binary_remote_addr;
   0 "";
}

limit_conn_zone $limit zone=conzone:10m;

limit_req_zone $binary_remote_addr zone=reqzone:10m rate=5r/s;
server {
    location / {
        limit_conn conzone 4;

        limit_req zone=reqzone burst=10;
        limit_req_status 503;

        limit_rate 50k;
        limit_rate_after 500k;
   }
}   
```
