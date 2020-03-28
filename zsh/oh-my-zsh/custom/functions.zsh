#! /bin/zsh

### start emacs server if no emacs server is running
startemacs() {
    local NUM=`ps xuf | grep 'emacs --daemon' | wc -l`
    if [ $NUM -le 1 ]; then
        emacs --daemon
    else
        echo "emacs server is already started."
    fi
}

### kill emacs server if emacs server is running
killemacs() {
    local NUM=`ps xuf | grep 'emacs --daemon' | wc -l`
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
    realpwd=$(realpath "${PWD}")
    recycle=$(realpath "${HOME}/.recycle")
    ### if we are already in ${recycle}, we execute the original command
    if [[ "${realpwd}" == "${recycle}" ]] || [[ "${realpwd}" == "${recycle}"/* ]]; then
        /bin/rm $*
        return 0
    fi

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

conn() {
    ssh ainfinit@tunnel.ainfinit.com -p $1
}
