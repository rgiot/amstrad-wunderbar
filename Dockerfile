FROM cpcsdk/crossdev:latest
MAINTAINER Krusty/Benediction

user root

# Put here specific commands to create the container for this project

RUN apt-get update
RUN apt-get install -y mesa-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy xserver-xorg-video-all

user arnold

