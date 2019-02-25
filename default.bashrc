################################################################################
################################################################################
################################################################################

### User specific aliases and functions
TOOLS=${HOME}/Documents/tools

### PATH settings
export PATH=/usr/local/bin:$PATH
export PATH=$TOOLS/anaconda/bin:$PATH
export PATH=$TOOLS/clang/bin:$PATH
export PATH=$TOOLS/emacs/bin:$PATH
export PATH=$TOOLS/paralell/bin:$PATH
export PATH=$TOOLS/protobuf/bin:$PATH

### LD_LIBRARY_PATH settings
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$TOOLS/anaconda/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$TOOLS/clang/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$TOOLS/protobuf/lib:$LD_LIBRARY_PATH

### command settings
export TERM=xterm-256color
export no_proxy=127.0.0.1
export ALTERNATE_EDITOR=""
# export EDITOR='emacsclient -t'
# export VISUAL='emacsclient -t'

### command prompt format
IP=`ifconfig | grep broadcast | awk '{print $2}' | awk 'END {print}'`
PS1="\[\e[36;1m\]\u\[\e[37;1m\]@\[\e[32;1m\]${IP}\[\e[37;1m\]:\[\e[33;1m\]\w\[\e[37;0m\]$ "

### start emacs server if no emacs server is running
startemacs() {
    NUM=`ps xuf | grep 'emacs --daemon' | wc -l`
    if [ $NUM -le 1 ]; then
        emacs --daemon
    else
        echo "emacs server is already started."
    fi
}

### kill emacs server if emacs server is running
killemacs() {
    NUM=`ps xuf | grep 'emacs --daemon' | wc -l`
    if [ $NUM -le 1 ]; then
        echo "emacs server is already killed."
    else
        emacsclient -e '(kill-emacs)'
    fi
}

### open file while checking if it exists
e() {
    if [ $# -eq 0 ]; then
        emacsclient -t
    elif [ $# -eq 1 ]; then
        if [ -f $1 ]; then
            emacsclient -t --eval "(emacs-client-init-find-file \"$1\" -1)"
        else
            echo "$1 is not a file."
        fi
    else
        echo "command e requires only one input."
    fi
}

### open file with read only mode
ev() {
    if [ $# -eq 0 ]; then
        emacsclient -t
    elif [ $# -eq 1 ]; then
        if [ -f $1 ]; then
            emacsclient -t --eval "(emacs-client-init-find-file \"$1\" t)"
        else
            echo "$1 is not a file."
        fi
    else
        echo "command ev requires only one input."
    fi
}

### avoid unintentional removal
rm() {
    recycle="${HOME}/.recycle"
    for i in $*; do
        if [[ $i != -* ]]; then
            stamp=`date +%Y-%m-%d`
            mkdir -p ${recycle}/${stamp}
            ### avoid name conflict
            name=`basename $i`
            dstpath=${recycle}/${stamp}/${name}
            count=2
            while [ -e ${dstpath} ]; do
                dstpath=${recycle}/${stamp}/${name}.${count}
                count=$((count + 1))
            done
            mv $i ${dstpath}
            ### unlink if necessary
            if [ -d ${dstpath} ]; then
                if [ `find ${dstpath} -type l | wc -l` -gt 0 ]; then
                    find ${dstpath} -type l | xargs -n1 unlink
                fi
            fi
        fi
    done
}

### autojump setting
if [[ -s ${HOME}/.autojump/etc/profile.d/autojump.sh ]]; then
    source ${HOME}/.autojump/etc/profile.d/autojump.sh
fi

### start autokey (直接使用Ubuntu系统, 并非通过SSH连接Ubuntu服务器)
start_autokey() {
    NUM=`ps xuf | grep python | grep autokey | wc -l`
    if [ $NUM -eq 0 ]; then
        autokey >/dev/null 2>&1 &
    fi
}
# start_autokey
