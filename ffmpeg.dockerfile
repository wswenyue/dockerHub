FROM ubuntu:16.04 
MAINTAINER wswenyue wswenyue@163.com

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get -y update


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
    apt-get install -y  ${buildDeps}

RUN mkdir -p /ffmpegsrc /ffmpegsrc/out && \
    cd /ffmpegsrc && \
    curl -#LO https://ffmpeg.org/releases/ffmpeg-4.2.1.tar.bz2 && \
    tar -jvx --strip-components=1 -f ffmpeg-4.2.1.tar.bz2 && \
    rm ffmpeg-4.2.1.tar.bz2



WORKDIR /ffmpegsrc

RUN ["/bin/bash", "-c", "./configure --prefix=\"/src/bin\" --disable-x86asm  && make -j 8 && make install && make distclean"]


