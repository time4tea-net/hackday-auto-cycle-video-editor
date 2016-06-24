#!/bin/bash

if [ -z "$MAPQUEST_KEY" ]
then
    echo "define MAPQUEST_KEY"
    exit 1
fi

lat=$1
long=$2

curl http://www.mapquestapi.com/staticmap/v4/getmap?key=$MAPQUEST_KEY'&'size=400,400'&'zoom=15'&'mcenter=$lat,$long'&'type=hyb'&'imagetype=png

