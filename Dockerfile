
FROM ubuntu:14.04

RUN apt-get update
RUN apt-get -y install cmake cmake-curses-gui libargtable2-0 libargtable2-dev libsndfile1 libsndfile1-dev libmpg123-0 libmpg123-dev libfftw3-3 libfftw3-dev liblapack-dev libhdf5-serial-dev libhdf5-serial-dev  curl python2.7 python-pip software-properties-common sox man python-matplotlib fonts-freefont-ttf
RUN  gpg --keyserver pgpkeys.mit.edu --recv-key E3298399DF14BB7C
RUN  gpg -a --export E3298399DF14BB7C | apt-key add - 
RUN add-apt-repository "deb http://debian.parisson.com/debian/ trusty main"
RUN add-apt-repository -s "deb http://debian.parisson.com/debian/ trusty main"
RUN apt-get update
RUN apt-get -y install python-yaafe
RUN add-apt-repository ppa:mc3man/trusty-media
RUN add-apt-repository ppa:openjdk-r/ppa
RUN sudo apt-get update
RUN apt-get -y install ffmpeg
RUN apt-get -y install openjdk-8-jdk
RUN apt-get -y install libtext-csv-perl liblist-moreutils-perl
RUN apt-get -y install jq
RUN apt-get -y install exiftool
RUN apt-get -y install aubio-tools
