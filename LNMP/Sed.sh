.删除 a.txt中的
zone a.com
{
   ...
}

zone b.com
{
   ...
}

[sed]
sed  -n '/^zone "'a.com'"$/,/^};$/d;p' a.txt


.replace
 sed 's/old/new/g' a.txt
 
.replace and save
 sed -i 's/old/new/g' a.txt

.整个词
sed 's/\<word\>/xxxx/g' a.txt

.
 [abc]
 [a-z]
 [0-9]
 
.
sed 's/<[^>]*>//g' a.html

.3到6行
sed "3,6s/old/new/g" a.txt

.替换每行第一个s
 sed "s/s/S/1" a.txt
 
.替换每行第二个s
 sed "s/s/S/2" a.txt
 
.替换第一行的第3个以后的s
 sed 's/s/S/3g' a.txt
 
.&来当做被匹配的变量，然后可以在基本左右加点东西 
 This is my cat, my cat's name is betty

 sed 's/my/[&]/g' my.txt
 This is [my] cat, [my] cat's name is betty

.圆括号匹配的示例
sed 's/This is my \([^,&]*\),.*is \(.*\)/\1:\2/g' my.txt
  cat:betty
  dog:frank
  
正则为：This is my ([^,]*),.*is (.*)
匹配为：This is my (cat),……….is (betty)

然后：\1就是cat，\2就是betty

.N命令
 把下一行的内容纳入到当前行进行操作
 [root@XB-DNS-1 ~]# cat a.txt
 1
 1
 1
 1

 .替换当前行的第一个1 (偶数行会 合并到奇数行的缓冲区进行操作)
 1
 1
 1
 1
 
 即变成
 11
 11
 
 [root@XB-DNS-1 ~]# sed 'N;s/1/..s../' a.txt
 ..s..
 1
 ..s..
 1

 .替换当前行所有的1 (偶数行会 合并到奇数行的缓冲区进行操作)
 [root@XB-DNS-1 ~]# sed 'N;s/1/..s../g' a.txt
 ..s..
 ..s..
 ..s..
 ..s..

 
 N;N;...
 1
 1
 1
 1
 变成
 111
 1(因为不符合后面有两行，所以不进行替换...)
 
 [root@XB-DNS-1 ~]# sed 'N;N;s/1/..s../' a.txt
 ..s..11
 1不进行替换

结果为
..s..
1
1
1


[root@XB-DNS-1 ~]# cat a.txt
1
1
1
1
1
1
1
1

变成
111
111
11  (因为不符合后面有两行，所以不进行替换...)
[root@XB-DNS-1 ~]# sed  'N;N;s/1/..s../' a.txt
..s..
1
1
..s..
1
1
1不进行替换
1不进行替换


.
sed -n 'm,np' a.txt
sed -n '1,/fish/p' a.txt
sed -n '/dog/,/fish/p' a.txt

.其中的+3表示/dog/后面连续3行
$ sed '/dog/,+3s/^/# /g' pets.txt

.对3行到第6行，执行命令/This/d
$ sed '3,6 {/This/d}' pets.txt

.对3行到第6行，匹配/This/成功后，再匹配/fish/，成功后执行d命令
$ sed '3,6 {/This/{/fish/d}}' pets.txt

.从第一行到最后一行，如果匹配到This，则删除之；如果前面有空格，则去除空格
$ sed '1,${/This/d;s/^ *//g}' pets.txt

.使用分号作为定界符
sed ‘s;/home/tolstor;/home/lt/;’

.把第一行替换成#!/bin/more
sed -e '1c/#!/bin/more' file

.把 1 到 10 行替换成一行
 I can do itsed -e '1,10c/I can do it' file
 
.
