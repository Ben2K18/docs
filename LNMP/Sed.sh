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


.
