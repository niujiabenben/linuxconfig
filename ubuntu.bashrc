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
export EDITOR='emacs'
export TERM=xterm-256color
export no_proxy=127.0.0.1
alias startemacs="emacs --daemon"
alias killemacs="emacsclient -e '(kill-emacs)'"

### command prompt format
ip=`ifconfig | grep 'inet ' | awk '{print $2}' | grep -v '127.0.0.1' | head -n1`
PS1="\u@${ip}:\w$ "


### open file while checking if it exists
e() {
    if [ $# -eq 0 ]; then
        emacsclient -c -a emacs --eval "(toggle-frame-fullscreen)"
    elif [ $# -eq 1 ]; then
        if [ -f $1 ]; then
            emacsclient -c -a emacs --eval "(emacs-client-init-find-file \"$1\" -1)"
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
        emacsclient -c -a emacs --eval "(toggle-frame-fullscreen)"
    elif [ $# -eq 1 ]; then
        if [ -f $1 ]; then
            emacsclient -c -a emacs --eval "(emacs-client-init-find-file \"$1\" t)"
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
