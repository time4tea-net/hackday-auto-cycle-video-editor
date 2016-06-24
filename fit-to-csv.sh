#!/bin/bash

set -e

dir=$(dirname $0)

file=$1

output_dir=$(dirname $file)
output_file=$(basename $file | sed -e 's/.fit$/.csv/')

output=$output_dir/$output_file

jarfile=$dir/FitCSVTool.jar

if [ ! -e $jarfile ]
then
    echo "You need the fit sdk from  https://www.thisisant.com/resources/fit" >&2
    exit 1
fi

java -jar $jarfile $file

cat $output | tail -n+2

rm $output

