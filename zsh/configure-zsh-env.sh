#! /bin/bash

THREADS=4
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

    URL="https://mirrors.ustc.edu.cn/gnu/emacs/emacs-27.2.tar.gz"
    NAME="emacs-27.2.tar.gz"
    MD5="6c7f1583d043fffff8dc892a1f8f7b83"
    download_file ${URL} ${NAME} ${MD5}

    TEMP=${NAME%.tar.gz}
    cd ${CACHE} && tar zxvf ${NAME} && cd ${TEMP}
    sudo apt install -y texinfo libx11-dev libxpm-dev libjpeg-dev
    sudo apt install -y libgif-dev libtiff-dev libgtk2.0-dev
    sudo apt install -y libxpm-dev libpng-dev libncurses-dev
    ./configure --prefix=${TOOLS}/emacs
    make -j${THREADS} && make install
}

install_autojump_from_source() {
    if [ -e ${HOME}/.autojump ]; then
        echo "autojump has already been installed." && return 0
    fi

    cd ${CACHE} && git clone git://github.com/wting/autojump.git
    cd autojump && ./install.py
}

install_from_source() {
    if [ "$1" == "emacs" ]; then
        install_emacs_from_source
    elif [ "$1" == "autojump" ]; then
        install_autojump_from_source
    fi
}

configure_zsh_env() {
    if [ -e ${HOME}/.emacs.d ]; then
        echo ".emacs.d has already been installed."
    else
        git clone https://github.com/niujiabenben/prelude.git ${HOME}/.emacs.d
    fi

    if [ -e ${HOME}/.oh-my-zsh ]; then
        echo ".oh-my-zsh has already been installed."
    else
        git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
    fi

    cp ${ROOT}/default.zshrc        ~/.zshrc
    cp ${ROOT}/oh-my-zsh/custom     ~/.oh-my-zsh -rf
    cp ${ROOT}/../default.gitconfig ~/.gitconfig
    echo -e "\n" >> ~/.bashrc && cat ${ROOT}/default.bash_profile >> ~/.bashrc
}

################################################################################
################################################################################
################################################################################

### step 1: install all dependencies
sudo apt update
sudo apt install -y build-essential
sudo apt install -y automake autoconf
sudo apt install -y git wget curl cmake zsh cmake-curses-gui
# sudo apt install emacs

### step 2: install packages
# install_from_source emacs
# install_from_source autojump

### step 3: configure zsh environment
configure_zsh_env
