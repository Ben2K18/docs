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
[ -f $1 ] || usage

src=$(realpath $1)
bgc=${2:-white}
fuzz=${3:-30}
dst=$(realpath $4)
vp=${5:-vp8}
fname=$(basename $src)
fname=${fname%.*}

#install ffmpeg and imagemagick (for convert)
[ -f /usr/bin/ffmpeg ]  || apt install ffmpeg
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

#png to transparent
cd png
for f in $(ls *.png)
do
     convert $f -channel rgba -alpha set -fuzz ${fuzz}% -fill none -opaque "#${bgc}" trans-${f}
     rm -f $f
done
cd ..

#combine png and mp3 to webm
if [ $vp == "vp9" ]
then
      yes|ffmpeg -i mp3/${fname}.mp3 -framerate $rate -f image2 -i png/trans-2\%d.png -c:v libvpx-vp9 -pix_fmt yuva420p $dst
else
      yes|ffmpeg -i mp3/${fname}.mp3 -framerate $rate -f image2 -i png/trans-2\%d.png -c:v libvpx -pix_fmt yuva420p $dst
fi

rm -fr $tmp
#End of Script
