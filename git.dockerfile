FROM ubuntu:16.04 
MAINTAINER wswenyue@163.com
TAG git:v1

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install git