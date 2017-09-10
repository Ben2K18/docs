1) /data/scripts/docker/dockerin.sh
#!/bin/bash
select c  in $( docker ps |awk 'NR>1 {print $NF}' ):
do
   docker exec -it $c bash
done

2) 
ln -s /data/scripts/docker/dockerin.sh /usr/local/bin/dockerin

3)
$ dockerin
1) mysql.a.com  3) html.a.com   5) node.a.cc:
2) php.a.com    4) php.a.cc

#? 3
root@php:/#
