#!/bin/bash

set -e

if [ -z "$MAPQUEST_KEY" ]
then
    echo "define MAPQUEST_KEY"
    exit 1
fi

lat=$1
long=$2

curl -s http://www.mapquestapi.com/geocoding/v1/reverse?key=$MAPQUEST_KEY'&'location=$lat,$long | jq -r '.results[0].locations[0] | [ .street, .adminArea5 ] | @csv' 
