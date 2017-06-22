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
      $ $0 a.mp4 bgcolor color-relate-range dst [vp8|vp9] bg.jpg text
      $ $0 a.mp4 4fff87 10 /tmp/a.webm  
      $ $0 a.mp4 4fff87 10 /tmp/a-vp9.webm vp9
      $ $0 a.mp4 4fff87 10 /tmp/a-vp9.webm vp9 bg.jpg
      $ $0 a.mp4 4fff87 10 /tmp/a-vp9.webm vp9 bg.jpg text
_EOF_

   exit
}

function realpath() {
   cur=$(pwd)
   file=$(basename "$1")
   dir=$(dirname "$1")
   cd $dir
   dir=$(pwd)
   cd $cur
   echo "$dir/$file"
}

#args
[[ $# -ge 4 && $# -le 7 ]] || usage

[ -f "$1" ] || usage

procs=25

src=$(realpath $1)
bgc=${2:-white}
fuzz=${3:-30}
dst=$(realpath $4)
vp=${5:-vp8}
vbg=${6:-}
txt=${7:-}

[ -f "$vbg" ] && echo $vbg && vbg=$(realpath $vbg)

fname=$(basename $src)
fname=${fname%.*}

#install ffmpeg and imagemagick (for convert)
[ -f /usr/bin/ffmpeg ]  || apt install ffmpeg libav-tools
[ -f /usr/bin/convert ] || apt install imagemagick

#create convert directory
tmp=/tmp/videotrans$$
if [ -d "$tmp" ]
then
   rm -fr "$tmp/*"
fi

mkdir -p $tmp/{mp3,png}

#convert
cd $tmp

#get rate from video
rate=$(ffmpeg -i $src 2>&1 | sed -n "s/.*, \(.*\) fp.*/\1/p")
yuva=$(ffmpeg -i $src 2>&1 | grep yuv | awk -F, '{print $2}'|sed 's/(.*//'|sed 's/\s\+//')

vsize=$(ffmpeg -i $src 2>&1 |grep -i Stream |grep Video | sed -E 's/^.+ ([0-9]+x[0-9]+),.+/\1/g')

#extract audio from video
ffmpeg -i $src -q:a 0 -map a mp3/${fname}.mp3

#extract png from video
ffmpeg -i $src -f image2 png/2\%d.png

#png to transparent
echo png to trans and add bg begin...
cd png

k=0
pidlist=""
cp $vbg bgbgbg.jpg
mogrify -resize "$vsize!" -quality 100  bgbgbg.jpg
for f in $(find . -type f -name "*.png")
do
    f=${f/\.\//}
    if [ -f "$vbg" ]
    then
       #mogrify -quality 100 -gravity center -background transparent  -alpha Set -draw 'image Dst_Over 0,0 0,0 "bgbgbg.jpg"' trans-${f} && \
       mogrify -resize "$vsize!" -quality 100 $f
       convert $f -channel rgba -alpha set -fuzz ${fuzz}% -fill none -opaque "#${bgc}" trans-${f} && \
       mogrify -quality 100 -gravity center -draw 'image Dst_Over 0,0 0,0 "bgbgbg.jpg"' trans-${f} && \
       rm -f $f &
    else
       mogrify -resize "$vsize!" -quality 100 $f
       convert $f -channel rgba -alpha set -fuzz ${fuzz}% -fill none -opaque "#${bgc}" trans-${f} && rm -f $f &
    fi

    if [ ${#pidlist} -eq 0 ]
    then
       pidlist="$!"
    else
       pidlist="$pidlist,$!"
    fi

    if [ $(( ++k % $procs ))  -eq 0 ] 
    then
        while true 
        do
           [ ${#pidlist} -eq 0 ] && break 
           ps -p $pidlist > /dev/null
           if [ $? -eq 0 ]
           then
               echo coverting $(( k-$procs )) - $k ...
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
        echo coverting $(( k-$procs )) - $k ...
        sleep 5
    else
        pidlist=""
        break
    fi
done

echo png to trans and add bg finished...

#combine png and mp3 to webm
cd ..
if [ $vp == "vp9" ]
then
    #ffmpeg -i mp3/${fname}.mp3 -framerate $rate -f image2 -i png/trans-2\%d.png -c:v libvpx-vp9 -pix_fmt $yuva $tmp/dst-src.webm
    ffmpeg -i mp3/${fname}.mp3 -framerate $rate -f image2 -i png/trans-2\%d.png -c:v libx264 -profile:v high -strict -2 -b:v 1000k -threads 10 -pix_fmt $yuva $tmp/dst-src.mp4
else
    ffmpeg -i mp3/${fname}.mp3 -framerate $rate -f image2 -i png/trans-2\%d.png -c:v libx264 -profile:v high -strict -2 -b:v 1000k -threads 10 -pix_fmt $yuva $tmp/dst-src.mp4
fi

#add text
echo add text ...
[ ${#txt} -gt 0 ] &&
ffmpeg -i $tmp/dst-src.mp4 -vf "drawbox=y=ih/PHI:color=black@0.4:width=iw:height=36:t=max, drawtext=text='$txt':fontcolor=white:fontsize=18:x=(w-tw)/2:y=(h/PHI)+th, format=$yuva" -c:v libx264 -strict -2 -c:a copy -movflags +faststart $dst

#avconv -i $tmp/dst.webm -c:v libx264  -strict experimental $dst

#rm $tmp
#rm -fr $tmp
#End of Script
