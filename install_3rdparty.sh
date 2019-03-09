#! /bin/bash

THREADS=8
ROOT=${PWD}
CACHE=${ROOT}/.cache
TOOLS=${HOME}/Documents/tools
mkdir -p ${ROOT} ${CACHE} ${TOOLS}

download_file() {
    URL=$1
    MD5=$3
    FILE=${CACHE}/$2
    if [ ! -e $FILE ]; then
        wget -O ${FILE} ${URL}
    fi
    echo "$MD5 ${FILE}" | md5sum -c --status
    if [ $? -ne 0 ]; then
        echo "Failed to check md5sum: ${FILE}" && exit
    fi
}

install_emacs_from_source() {
    if [ -e ${TOOLS}/emacs ]; then
        echo "emacs has already been installed." && return 0
    fi

    URL="https://mirrors.ustc.edu.cn/gnu/emacs/emacs-26.1.tar.gz"
    NAME="emacs-26.1.tar.gz"
    MD5="544d2ab5eb142e9ca69adb023d17bf4b"
    download_file ${URL} ${NAME} ${MD5}

    TEMP=${NAME%.tar.gz}
    cd ${CACHE} && tar zxvf ${NAME} && cd ${TEMP}
    sudo apt-get install libncurses-dev
    ./configure --without-x --with-gnutls=no --prefix=${TOOLS}/emacs
    make -j${THREADS} && make install
}

install_opencv_from_source() {
    if [ -e ${TOOLS}/opencv ]; then
        echo "opencv has already been installed." && return 0
    fi

    URL="https://github.com/opencv/opencv/archive/3.4.2.zip"
    NAME="opencv-3.4.2.zip"
    MD5="9e9ebe9c1fe98c468f6e53f5c3c49716"
    download_file ${URL} ${NAME} ${MD5}

    ### if you want to build with your own ffmpeg version
    # TOOLS=/home/chenli/Documents/tools
    # export LD_LIBRARY_PATH=${TOOLS}/ffmpeg/lib/
    # export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:${TOOLS}/ffmpeg/lib/pkgconfig
    # export PKG_CONFIG_LIBDIR=${PKG_CONFIG_LIBDIR}:${TOOLS}/ffmpeg/lib

    TEMP=${NAME%.zip}
    cd ${CACHE} && unzip ${NAME} && cd ${TEMP}
    sudo apt install build-essential cmake git pkg-config
    sudo apt install libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev
    mkdir -p build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=${TOOLS}/opencv \
          -DBUILD_JAVA=OFF \
          -DBUILD_PACKAGE=OFF \
          -DBUILD_PERF_TESTS=OFF \
          -DBUILD_TESTS=OFF \
          -DBUILD_opencv_apps=OFF \
          -DBUILD_opencv_dnn=OFF \
          -DBUILD_opencv_java_bindings_gen=OFF \
          -DBUILD_opencv_ml=OFF \
          -DBUILD_opencv_objdetect=OFF \
          -DBUILD_opencv_python2=OFF \
          -DBUILD_opencv_python_bindings_generator=OFF \
          -DOPENCV_DNN_OPENCL=OFF \
          -DWITH_CUFFT=OFF \
          ..
    make -j${THREADS} && make install
}

install_jpeg_turbo_from_source() {
    if [ -e ${TOOLS}/jpeg-turbo ]; then
        echo "jpeg-turbo has already been installed." && return 0
    fi

    URL="https://github.com/libjpeg-turbo/libjpeg-turbo/archive/2.0.0.tar.gz"
    NAME="libjpeg-turbo-2.0.0.tar.gz"
    MD5="e643c8cafdf5c40567fa11b2c0f4c20c"
    download_file ${URL} ${NAME} ${MD5}

    TEMP=${NAME%.tar.gz}
    cd ${CACHE} && tar zxvf ${NAME} && cd ${TEMP}
    sudo apt install cmake nasm
    mkdir -p build && cd build
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_PREFIX=${TOOLS}/jpeg-turbo \
          ..
    make -j${THREADS} && make install
}

install_protobuf_from_source() {
    if [ -e ${TOOLS}/protobuf ]; then
        echo "protobuf has already been installed." && return 0
    fi

    URL="https://github.com/protocolbuffers/protobuf/releases/download/v3.5.1/protobuf-cpp-3.5.1.tar.gz"
    NAME="protobuf-3.5.1.tar.gz"
    MD5="ca0d9b243e649d398a6b419acd35103a"
    download_file ${URL} ${NAME} ${MD5}

    TEMP=${NAME%.tar.gz}
    cd ${CACHE} && tar zxvf ${NAME} && cd ${TEMP}
    sudo apt install autoconf automake libtool curl make g++ unzip
    ./configure --prefix=${TOOLS}/protobuf
    make -j${THREADS} && make install
}

install_boost_from_source() {
    if [ -e ${TOOLS}/boost ]; then
        echo "boost has already been installed." && return 0
    fi

    URL="https://ayera.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz"
    NAME="boost_1_59_0.tar.gz"
    MD5="51528a0e3b33d9e10aaa311d9eb451e3"
    download_file ${URL} ${NAME} ${MD5}

    TEMP=${NAME%.tar.gz}
    cd ${CACHE} && tar zxvf ${NAME} && cd ${TEMP}
    ./bootstrap.sh --prefix=${TOOLS}/boost
    ./b2 cxxflags=-fPIC cflags=-fPIC --build-dir=build -j${THREADS} variant=release install
}

install_ffmpeg_from_source() {
    if [ -e ${TOOLS}/ffmpeg ]; then
        echo "ffmpeg has already been installed." && return 0
    fi

    URL="https://ffmpeg.org/releases/ffmpeg-3.4.5.tar.bz2"
    NAME="ffmpeg-3.4.5.tar.bz2"
    MD5="1c608d4b8cf7f1f5e0dbe7a795ae7f5b"
    download_file ${URL} ${NAME} ${MD5}

    TEMP=${NAME%.tar.bz2}
    cd ${CACHE} && tar jxvf ${NAME} && cd ${TEMP}
    sudo apt install autoconf automake build-essential libtool libass-dev
    sudo apt install libfreetype6-dev libvorbis-dev texinfo zlib1g-dev
    sudo apt install nasm yasm libx264-dev libx265-dev libnuma-dev libvpx-dev
    sudo apt install libfdk-aac-dev libmp3lame-dev libopus-dev
    ### compile with shared & -fpic
    ./configure \
        --enable-shared \
        --extra-cflags="-fPIC" \
        --prefix=${TOOLS}/ffmpeg \
        --enable-gpl \
        --enable-libfdk-aac \
        --enable-libfreetype \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libx265 \
        --enable-nonfree
    make -j${THREADS} && make install
}

################################################################################
################################################################################
################################################################################

# install_emacs_from_source
# install_opencv_from_source
# install_jpeg_turbo_from_source
# install_protobuf_from_source
# install_boost_from_source
# install_ffmpeg_from_source
