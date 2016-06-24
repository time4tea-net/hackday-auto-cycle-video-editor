#!/bin/bash

# $0 recording.mp4 <fit files...>
#
#

export TZ="Europe/London"

mydir=$(dirname $0)

file=$1
base=$(basename $file)
shift

set -x

mkdir -p temp
rm -f temp/ffmpeg.txt
rm -f temp/sections.txt

m4a=temp/$base.m4a
wav=temp/$base.wav

ffmpeg="ffmpeg -nostats -loglevel 0"

file_date=$(date --date "$(exiftool $file | grep '^Create Date' | cut -d: -f2- | sed -e 's/:/\//'|sed -e 's/:/\//')" +%s)

$mydir/fit-to-csv.sh "$@" | $mydir/fit-csv-to-location-csv.pl | sort -n > temp/locations.txt

$ffmpeg -y -i $file -c copy -map 0:a $m4a
$ffmpeg -y -i $m4a $wav
sox $wav -t wav - spectrogram -o $base.spec-before.png sinc 3400-3700 spectrogram -o $base.spec-after.png | aubioonset -i - -s -20 2> /dev/null > temp/$base.dings.txt

if [ -e temp/$base.dings.txt -a -s temp/$base.dings.txt ]
then
    cat temp/$base.dings.txt | perl $mydir/consolidate-dings.pl > temp/incidents.txt
    rm temp/incident_locations.txt
    while read offset length
    do
	incident_date=$(expr $file_date + $offset)
	echo "Incident at $(date --date @$incident_date)"

	incident_location=$(cat temp/locations.txt | $mydir/find-location.pl $incident_date)
	if [ -z "$incident_location" ]
	then
	    incident_location="unknown"
	fi
	
	echo $offset $length $incident_date $incident_location >> temp/incident_locations.txt
    done < temp/incidents.txt

    n=0
    while read offset length timestamp location
    do	
	if [ "$location" == "unknown" ]
	then
	    echo "Unknown" > temp/street.$n.txt
	else
	    lat=$(echo $location | cut -d, -f2)
	    long=$(echo $location | cut -d, -f3)
	    
	    $mydir/mapquest-get-street.sh $lat $long > temp/street.$n.txt
	    $mydir/mapquest-get-map.sh $lat $long > temp/map.$n.png
	fi

	street=$(cat temp/street.$n.txt | sed -e "s/[\"\']//g")

	echo $ffmpeg -y -i $file -ss $offset -t $length -vcodec copy -acodec copy temp/s.$n.mp4 >> temp/ffmpeg.txt
	echo $ffmpeg -y -i temp/s.$n.mp4 -vf \"drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:fontcolor=red@0.8:fontsize=48:text=\'$street\'\" temp/st.$n.mp4 >> temp/ffmpeg.txt
	echo $ffmpeg -y -i  temp/st.$n.mp4 -vf \"movie=temp/map.$n.png [watermark]\; [in][watermark] overlay=main_w-overlay_w-10:main_h-overlay_h-10 [out]\" -acodec copy temp/sm.$n.mp4 >> temp/ffmpeg.txt
	echo $ffmpeg -y -i temp/sm.$n.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp/$base.section.$n.ts >> temp/ffmpeg.txt
	echo file \'$base.section.$n.ts\' >> temp/sections.txt
	n=$(expr $n + 1)
    done < temp/incident_locations.txt

fi

bash -x temp/ffmpeg.txt

ffmpeg -y -f concat -i temp/sections.txt -c copy -bsf:a aac_adtstoasc  $base-incidents.mp4




