FROM ubuntu:16.04 
MAINTAINER wswenyue wswenyue@163.com

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get -y update


# base dependence
RUN buildDeps="autoconf \
                automake \
                g++ \
                gcc \
                make \
                cmake \
                build-essential \
                curl \
                wget \
                aria2 \
                tar \
                unzip \
                bzip2 \
                p7zip-full \
                libtool \
                nasm" && \
    apt-get install -y  ${buildDeps} && \
    # Language、Tools
    buildTools="git \
                python \
                perl" && \
    apt-get install -y  ${buildTools}


