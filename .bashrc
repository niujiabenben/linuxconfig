# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
TOOLS=/home/wangsongOCR/Documents/tools


### PATH settings
export PATH=/usr/local/bin:$PATH
export PATH=$TOOLS/anaconda/bin:$PATH
export PATH=$TOOLS/emacs/bin:$PATH


### LD_LIBRARY_PATH settings
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$TOOLS/anaconda/lib:$LD_LIBRARY_PATH


### emacs settings
export TERM=xterm-256color
export no_proxy=127.0.0.1
alias startemacs="emacs --daemon"
alias killemacs="emacsclient -e '(kill-emacs)'"
alias ls='ls --color=auto'

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

export PYTHONPATH=/home/wangsongOCR/Desktop/caffe/python:$PYTHONPATH
