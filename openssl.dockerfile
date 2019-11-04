FROM ubuntu:16.04 
MAINTAINER wswenyue wswenyue@163.com

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get -y update


# base dependence
RUN buildDeps="autoconf \
                automake \
                cmake \
                build-essential \
                curl \
                wget \
                aria2 \
                tar \
                unzip \
                bzip2 \
                p7zip-full \
                g++ \
                gcc \
                libtool \
                make \
                nasm \
                perl" && \
    apt-get install -y  ${buildDeps}


# Download SDK / NDK

RUN mkdir /Android && cd Android && mkdir output
WORKDIR /Android

# RUN aria2c -x16 http://dl.google.com/android/android-sdk_r24.3.3-linux.tgz
COPY ./android-sdk_r24.3.3-linux.tgz /Android/

# RUN aria2c -x16 https://dl.google.com/android/repository/android-ndk-r10e-linux-x86_64.zip
COPY ./android-ndk-r10e-linux-x86_64.zip /Android/

# Extracting ndk/sdk
RUN ls -alh && tar zxvf ./android-sdk_r24.3.3-linux.tgz && \
    ls -alh && unzip -o ./android-ndk-r10e-linux-x86_64.zip

# RUN tar -xvzf android-sdk_r24.3.3-linux.tgz && \
# 	chmod a+x android-ndk-r10e-linux-x86_64.bin && \
# 	7z x android-ndk-r10e-linux-x86_64.bin


# Set ENV variables

ENV ANDROID_HOME /Android/android-sdk-linux
ENV NDK_ROOT /Android/android-ndk-r10e
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

# Make stand alone toolchain (Modify platform / arch here)

RUN mkdir toolchain-arm && bash $NDK_ROOT/build/tools/make-standalone-toolchain.sh --verbose --platform=android-19 --install-dir=toolchain-arm --arch=arm --toolchain=arm-linux-androideabi-clang3.6 --llvm-version=3.6 --system=linux-x86_64 --stl=libc++

ENV TOOLCHAIN /Android/toolchain-arm
ENV SYSROOT $TOOLCHAIN/sysroot
ENV PATH $PATH:$TOOLCHAIN/bin:$SYSROOT/usr/local/bin

# Configure toolchain path

ENV ARCH armv7

#ENV CROSS_COMPILE arm-linux-androideabi
ENV CC arm-linux-androideabi-clang
ENV CXX arm-linux-androideabi-clang++
ENV AR arm-linux-androideabi-ar
ENV AS arm-linux-androideabi-as
ENV LD arm-linux-androideabi-ld
ENV RANLIB arm-linux-androideabi-ranlib
ENV NM arm-linux-androideabi-nm
ENV STRIP arm-linux-androideabi-strip
ENV CHOST arm-linux-androideabi

ENV CXXFLAGS -std=c++14 -Wno-error=unused-command-line-argument

# download, configure and make Zlib

# RUN aria2c https://www.zlib.net/fossils/zlib-1.2.8.tar.gz
COPY ./zlib-1.2.8.tar.gz /Android/

RUN tar -xzf ./zlib-1.2.8.tar.gz && \
    mv zlib-1.2.8 zlib && \
    cd zlib && ./configure --static && \
	make && \
	ls -hs . && \
	cp libz.a /Android/output

# open ssl


ENV CPPFLAGS -mthumb -mfloat-abi=softfp -mfpu=vfp -march=$ARCH  -DANDROID

# RUN aria2c -x16 https://www.openssl.org/source/openssl-1.0.2d.tar.gz
COPY ./openssl-1.0.2d.tar.gz /Android/
RUN ls -alh && tar -xzf openssl-1.0.2d.tar.gz


# Build armv7
RUN ls && cd openssl-1.0.2d && ./Configure android-armv7 no-asm no-shared --static --with-zlib-include=/Android/zlib/include --with-zlib-lib=/Android/zlib/lib && \
	make build_crypto build_ssl -j 4 && ls && cp libcrypto.a /Android/output/libcrypto_armv7.a && cp libssl.a /Android/output/libssl_armv7.a && make clean
RUN cp -r openssl-1.0.2d /Android/output/openssl-armv7

# Build android-x86
# RUN ls && cd openssl-1.0.2d && ./Configure android-x86 no-asm no-shared --static --with-zlib-include=/Android/zlib/include --with-zlib-lib=/Android/zlib/lib && \
# 	make build_crypto build_ssl -j 4 && ls && cp libcrypto.a /Android/output/libcrypto_x86.a && cp libssl.a /Android/output/libssl_x86.a && make clean
# RUN cp -r openssl-1.0.2d /Android/output/openssl-x86

# Build android-mips
# RUN ls && cd openssl-1.0.2d && ./Configure android-mips no-asm no-shared --static --with-zlib-include=/Android/zlib/include --with-zlib-lib=/Android/zlib/lib && \
# 	make build_crypto build_ssl -j 4 && ls && cp libcrypto.a /Android/output/libcrypto_mips.a && cp libssl.a /Android/output/libssl_mips.a && make clean
# RUN cp -r openssl-1.0.2d /Android/output/openssl-mips

# To get the results run container with output folder
# Example: docker run -v HOSTFOLDER:/output --rm=true IMAGENAME 
# ENTRYPOINT cp -r /Android/output/* /output