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
    apt-get install -y --no-install-recommends ${buildDeps}

RUN mkdir -p /src /src/bin && \
    curl -sL https://github.com/FFmpeg/FFmpeg/archive/n4.2.1.tar.gz -o ffmpeg_source.zip | \
    tar -zx --strip-components=1 && \
    rm -f /src/n4.2.1.tar.gz



WORKDIR /src

RUN ["/bin/bash", "-c", "./configure --prefix=\"/src/bin\" --disable-x86asm  && make -j 8 && make install && make distclean"]


