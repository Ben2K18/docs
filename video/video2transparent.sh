#!/bin/bash
#
# Convert video to transparent webm
# Script: video2trans.sh
# Author: cnscn <http://www.redlinux.org>
# Date: 20170615
#
# apt install gcc shc
#
# convert sh to executable file
# shc -f video2trans.sh
# ls -l  video2trans.sh.x
# mv video2trans.sh.x video2trans
#

#usage
function usage() {
   cat <<_EOF_
Usage:
      $ $0 a.mp4 bgcolor color-relate-range dst [vp8|vp9]
      $ $0 a.mp4 4fff87 10 /tmp/a.webm
      $ $0 a.mp4 4fff87 10 /tmp/a-vp9.webm vp9
_EOF_

   exit
}

#args
[[ $# -eq 4 || $# -eq 5 ]] || usage
echo $#
[ -f $1 ] || usage

function realpath() {
   file=$(basename $1)
   dir=$(dirname $1)
   cd $dir
   dir=$(pwd)
   echo "$dir/$file"
}
echo $#
src=$(realpath $1)
bgc=${2:-white}
fuzz=${3:-30}
dst=$(realpath $4)
vp=${5:-vp8}
fname=$(basename $src)
fname=${fname%.*}

#install ffmpeg and imagemagick (for convert)
[ -f /usr/bin/ffmpeg ]  || apt install ffmpeg libav-tools
[ -f /usr/bin/convert ] || apt install imagemagick

tmp=/tmp/videotrans$$
#create convert directory
if [ -d $tmp ]
then
     rm -fr $tmp/*
fi

mkdir -p $tmp/{mp3,png}

#convert
cd $tmp

#extract audio from video
ffmpeg -i $src -q:a 0 -map a mp3/${fname}.mp3

#extract png from video
ffmpeg -i $src -f image2 png/2\%d.png

#get rate from video
rate=$(ffmpeg -i $src 2>&1 | sed -n "s/.*, \(.*\) fp.*/\1/p")
yuva=$(ffmpeg -i $src 2>&1 | grep yuv | awk -F, '{print $2}'|sed 's/(.*//'|sed 's/\s\+//')

#png to transparent
cd png
echo begin...

k=0
pidlist=""
cp /data/webs/ppt.yiyaozg.com/ppt.yiyaozg.com/mp4totrans/bj.jpg bj.jpg
for f in $(find . -type f -name "*.png")
do
    f=${f/\.\//}
    convert $f -channel rgba -alpha set -fuzz ${fuzz}% -fill none -opaque "#${bgc}" trans-${f} && \
    mogrify -gravity center -background transparent  -alpha Set -draw 'image Dst_Over 0,0 0,0 "bj.jpg"' trans-${f} && \
    rm -f $f &

    if [ ${#pidlist} -eq 0 ]
    then
       pidlist="$!"
    else
       pidlist="$pidlist,$!"
    fi

    if [ $(( ++k % 20 ))  -eq 0 ] 
    then
        while true 
        do
           [ ${#pidlist} -eq 0 ] && break 
           ps -p $pidlist > /dev/null
           if [ $? -eq 0 ]
           then
               echo coverting $(( k-20 )) - $k ...
               sleep 5
           else
               pidlist=""
               break
           fi
        done
     fi
done 

while true 
do
    [ ${#pidlist} -eq 0 ] && break 
    ps -p $pidlist > /dev/null
    if [ $? -eq 0 ]
    then
        echo coverting $(( k-20 )) - $k ...
        sleep 5
    else
        pidlist=""
        break
    fi
done

echo finished ...
cd ..

#combine png and mp3 to webm
if [ $vp == "vp9" ]
then
    ffmpeg -i mp3/${fname}.mp3 -framerate $rate -f image2 -i png/trans-2\%d.png -c:v libvpx-vp9 -pix_fmt $yuva $dst
    #ffmpeg -framerate $rate -f image2 -i png/trans-2\%d.png -c:v libvpx-vp9  $dst
else
    ffmpeg -i mp3/${fname}.mp3 -framerate $rate -f image2 -i png/trans-2\%d.png -c:v libvpx -pix_fmt $yuva $dst
fi

txt="Qcourse videos..."
ffmpeg -i $dst -vf  "format=$yuva, drawbox=y=ih/PHI:color=black@0.4:width=iw:height=48:t=max, drawtext=fontfile=OpenSans-Regular.ttf:text='Qcourse videos...':fontcolor=white:fontsize=24:x=(w-tw)/2:y=(h/PHI)+th, format=yuv420p" -c:v libvpx -c:a copy -movflags +faststart /tmp/dst.webm

avconv -i /tmp/dst.webm -c:v libx264  -strict experimental /tmp/out.mp4
rm -fr $tmp
#End of Script
