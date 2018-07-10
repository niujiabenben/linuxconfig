################################################################################
################################################################################
################################################################################

# User specific aliases and functions
TOOLS=/home/chenli/Documents/tools

### PATH settings
export PATH=/usr/local/bin:$PATH

### LD_LIBRARY_PATH settings
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

### command settings
export TERM=xterm-256color
export no_proxy=127.0.0.1
export ALTERNATE_EDITOR=""
export EDITOR='emacsclient -t'
export VISUAL='emacsclient -t'

### command prompt format
ip=`ifconfig | grep 'inet ' | awk '{print $2}' | grep -v '127.0.0.1' | head -n1`
PS1="\u@${ip}:\w$ "

### start emacs server if no emacs server is running
startemacs() {
    NUM=`ps xuf | grep emacs | grep daemon | wc -l`
    if [ $NUM -eq 0 ]; then
        emacs --daemon
    else
        echo "emacs server is already started."
    fi
}

### kill emacs server if emacs server is running
killemacs() {
    NUM=`ps xuf | grep emacs | grep daemon | wc -l`
    if [ $NUM -eq 0 ]; then
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
    recycle="/home/chenli/.recycle"
    for i in $*; do
        if [[ $i != -* ]]; then
            stamp=`date +%Y-%m-%d`
            mkdir -p ${recycle}/${stamp}
            ### avoid name conflict
            name=`basename $i`
            path=${recycle}/${stamp}/${name}
            count=2
            while [ -e ${path} ]; do
                path=${recycle}/${stamp}/${name}.${count}
                count=$((count + 1))
            done
            mv $i ${path}
            ### unlink if necessary
            if [ -d ${path} ]; then
                if [ `find ${path} -type l | wc -l` -gt 0 ]; then
                    find ${path} -type l | xargs -n1 unlink
                fi
            fi
        fi
    done
}

### start autokey
start_autokey() {
    NUM=`ps xuf | grep python | grep autokey | wc -l`
    if [ $NUM -eq 0 ]; then
        autokey >/dev/null 2>&1 &
    fi
}
start_autokey
