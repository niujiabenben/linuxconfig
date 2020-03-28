#! /bin/zsh

### User specific aliases and functions
TOOLS=${HOME}/Documents/tools

### PATH settings
export PATH=/usr/local/bin:$PATH
export PATH=${TOOLS}/emacs/bin:$PATH
export PATH=${HOME}/.cask/bin:$PATH

### LD_LIBRARY_PATH settings
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

### used in emacs python mode
export PYTHONENV=${TOOLS}/anaconda3/envs/pytorch/bin/python

### command settings
export TERM=xterm-256color
export no_proxy=127.0.0.1
# export ALTERNATE_EDITOR=""
# export EDITOR='emacsclient -t'
# export VISUAL='emacsclient -t'

### alias bought from bashrc
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias diff='diff --color=always'
alias cp='cp -d'
