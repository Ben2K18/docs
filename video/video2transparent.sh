#!/bin/bash
# Convert video to transparent webm
# Author: cnscn <http://www.redlinux.org>
# Date: 20170615
#

#usage
function usage() {
   cat <<_EOF_ 
Usage: 
      $ $0 a.mp4 bgcolor color-relate-range
      $ $0 a.mp4 4fff87 10
    
      $ ls /tmp/videotrans/*
        result.webm mp3 png
_EOF_

   exit
}

#args
[ $# -eq 3 ] || usage
[ -f $1 ] || usage

src=$1
bgc=${2:-white}
fuzz=${3:-30}
fname=${$(basename $src)%.*}

#install ffmpeg and imagemagick (for convert)
[ -f /usr/bin/ffmpeg ]  || apt install ffmpeg
[ -f /usr/bin/convert ] || apt install imagemagick 

#convert directory
[ -f /tmp/videotrans ] || mkdir /tmp/videotrans

cd /tmp/videotrans

[ -d png ] || mkdir png ; [ -d mp3 ] || mkdir mp3 ; rm -f png/* ; rm -f mp3/*

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
rm -f output.webm
yes|ffmpeg -i mp3/${fname}.mp3 -framerate $rate -f image2 -i png/trans-2\%d.png -c:v libvpx -pix_fmt yuva420p ${fname}.webm

rm -f png/*
rm -f mp3/*

#End of Script
