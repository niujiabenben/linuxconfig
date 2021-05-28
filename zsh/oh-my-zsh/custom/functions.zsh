#! /bin/zsh

EMACSEXE=${HOME}/Documents/tools/emacs/bin/emacs
CLIENTEXE=${HOME}/Documents/tools/emacs/bin/emacsclient

# start emacs server if no emacs server is running
startemacs() {
    if [ $(ps xuf | grep emacs | wc -l) -gt 1 ]; then
        echo "emacs server is already started."
    else
        ${EMACSEXE} --daemon
    fi
}

# kill emacs server if emacs server is running
killemacs() {
    if [ $(ps xuf | grep emacs | wc -l) -le 1 ]; then
        echo "emacs server is already killed."
    else
        ps xuf | grep emacs | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
   fi
}

# open file in emacsclient mode
openfile() {
    name=$1
    mode=$2
    if [ ${name} = nil ]; then
        ${CLIENTEXE} -t --eval "(emacs-client-init-find-file nil ${mode})"
    elif [ -f ${name} ]; then
        name=$(realpath ${name})
        ${CLIENTEXE} -t --eval "(emacs-client-init-find-file \"${name}\" ${mode})"
    else
        echo "${name} is not a file."
    fi
}

# open file in emacsclient mode
e() {
    if [ $# -eq 0 ]; then
        openfile nil -1
    elif [ $# -eq 1 ]; then
        openfile $1 -1
    else
        echo "command e requires only one input."
    fi
}

# open file with read only mode
ev() {
    if [ $# -eq 0 ]; then
        openfile nil 1
    elif [ $# -eq 1 ]; then
        openfile $1 1
    else
        echo "command ev requires only one input."
    fi
}

# open file directly by emacs
emacs() {
    if [ $# -eq 0 ]; then
        ${EMACSEXE} --eval "(emacs-client-init-find-file nil -1)"
    elif [ $# -gt 1 ]; then
        echo "command emacs requires only one input."
    elif [ -f $1 ]; then
        ${EMACSEXE} --eval "(emacs-client-init-find-file \"$1\" -1)"
    else
        echo "$1 is not a file."
    fi
}

# avoid unintentional removal
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
