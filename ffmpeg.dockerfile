FROM ubuntu:16.04 
MAINTAINER wswenyue wswenyue@163.com

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get -y install --no-install-recommends unzip aria2


# dependence
RUN buildDeps="autoconf \
                automake \
                cmake \
                curl \
                bzip2 \
                libexpat1-dev \
                g++ \
                gcc \
                git \
                gperf \
                libtool \
                make \
                nasm \
                perl \
                pkg-config \
                python \
                libssl-dev \
                yasm \
                zlib1g-dev" && \
    apt-get install -y --no-install-recommends ${buildDeps}

RUN mkdir -p /src /src/bin && \
    aria2c -x16  https://github.com/FFmpeg/FFmpeg/archive/n4.2.1.zip -o ffmpeg_source.zip && \
    unzip ffmpeg_source.zip -d /src && \
    rm /src/ffmpeg_source.zip



WORKDIR /src

RUN ["/bin/bash", "-c", "./configure --prefix=\"/src/bin\" --disable-x86asm  && make -j 8 && make install && make distclean"]


