#!/bin/bash

docker build -t hackday-video . 
docker run -e "MAPQUEST_KEY=$MAPQUEST_KEY" -v $(pwd):/hackday/scripts -v /home/$USER/Videos:/hackday/data -it hackday-video
