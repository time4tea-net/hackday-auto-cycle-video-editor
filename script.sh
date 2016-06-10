#!/bin/bash

mydir=$(dirname $0)

file=$1
base=$(basename $1)
m4a=$base.m4a
wav=$base.wav

ffmpeg="ffmpeg -nostats -loglevel 0"

set -x

$ffmpeg -y -i $file -c copy -map 0:a $m4a
$ffmpeg -y -i $m4a $wav
sox $wav -t wav - spectrogram -o $base.spec-before.png sinc 3400-3700 spectrogram -o $base.spec-after.png | aubioonset -i - -s -20 2> /dev/null > $base.dings.txt

mkdir -p temp
n=0
rm -f temp/ffmpeg.txt
rm -f temp/sections.txt

if [ -e $base.dings.txt -a -s $base.dings.txt ]
then
    cat $base.dings.txt | perl $mydir/consolidate-dings.pl > temp/incidents.txt
    while read a b
    do
	echo $ffmpeg -y -i $file -ss $a -t $b -vcodec copy -acodec copy temp/$base.section.$n.mp4 >> temp/ffmpeg.txt
	echo $ffmpeg -y -i temp/$base.section.$n.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp/$base.section.$n.ts >> temp/ffmpeg.txt
	echo file \'$base.section.$n.ts\' >> temp/sections.txt
	n=$(expr $n + 1)
    done < temp/incidents.txt
fi

bash -x temp/ffmpeg.txt

ffmpeg -y -f concat -i temp/sections.txt -c copy -bsf:a aac_adtstoasc  $base-incidents.mp4




