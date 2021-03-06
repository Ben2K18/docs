.kernel优化

#!/bin/bash
#
ulimit -SHn 500000

grep 'LimitNOFILE=500000' /lib/systemd/system/nginx.service || { sed -i '/\[Service\]/aLimitNOFILE=500000' /lib/systemd/system/nginx.service ; systemctl daemon-reload ; /etc/init.d/nginx restart; }

grep 'nofile 500000' /etc/security/limits.conf || sed -i  '/End/ i  *  -   nofile 500000' /etc/security/limits.conf

grep 'session required pam_limits.so' /etc/pam.d/common-session ||  sed -i '/end of pam-auth-update/ i session required pam_limits.so' /etc/pam.d/common-session

grep 'session    required   pam_limits.so' /etc/pam.d/su ||  echo  'session    required   pam_limits.so' >> /etc/pam.d/su

grep 'ulimit -SHn 500000' /etc/profile || sed -i '$ a ulimit -SHn 500000' /etc/profile

grep 'net.ipv4.tcp_tw_recycle = 1' /etc/sysctl.conf || cat >> /etc/sysctl.conf  <<_EOF_
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1 
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_fin_timeout = 30

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.ip_local_port_range = 1024 65000
net.core.somaxconn = 262144
net.core.netdev_max_backlog = 262144
_EOF_
