#!/bin/bash

if [ -z "$MAPQUEST_KEY" ]
then
    echo "define MAPQUEST_KEY"
    exit 1
fi

#curl http://www.mapquestapi.com/staticmap/v4/getmap?key=$MAPQUEST_KEY'&'size=400,400'&'zoom=15'&'mcenter=40.039401,-76.307078'&'type=hyb'&'imagetype=png -o map.png

curl http://www.mapquestapi.com/geocoding/v1/reverse?key=$MAPQUEST_KEY'&'location=40.053116,-76.313603
