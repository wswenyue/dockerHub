FROM ubuntu:16.04 
MAINTAINER wswenyue wswenyue@163.com

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install curl git tar xz-utils unzip gnupg flex bison gperf build-essential ccache openjdk-8-jdk && \
    apt-get -y install zlib1g-dev libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc lib32z1-dev qemu g++-multilib gcc-multilib libglib2.0-dev libpixman-1-dev linux-libc-dev:i386 && \
    apt-get -y install python3-paramiko python-paramiko python-jenkins python-requests python-xlwt && \
    apt-get -y install gcc-5-aarch64-linux-gnu g++-5-aarch64-linux-gnu aria2 && \
    mkdir -p /tools/ninja /tools/gn && \
    cd /tools && \
    aria2c -x16  http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz && \
    aria2c -x16  https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-linux.zip && \
    curl -L -o /tools/gn/gn https://archive.softwareheritage.org/browse/content/sha1_git:2dc0d5b26caef44f467de8120b26f8aad8b878be/raw/?filename=gn && \
    tar Jvxf /tools/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz -C /tools/ && \
    unzip /tools/ninja-linux.zip -d /tools/ninja/ && \
    chmod a+x /tools/gn/gn && \
    cd / && \
    rm /tools/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz /tools/ninja-linux.zip && \
    rm -rf /var/cache/apt/archives && \
    git clone https://code.opensource.huaweicloud.com/HarmonyOS/OpenArkCompiler.git ark && \
    mkdir -p /ark/tools /ark/tools/gn && \
    ln -s /tools/ninja /ark/tools/ninja_1.9.0 && \
    ln -s /tools/gn/gn /ark/tools/gn/gn && \
    ln -s /tools/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04 /ark/tools/clang_llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04

WORKDIR /ark

RUN ["/bin/bash", "-c", "source build/envsetup.sh && make"]