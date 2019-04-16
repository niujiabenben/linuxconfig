### start zsh
startzsh() {
    if [ -x /bin/zsh ]; then
        export SHELL=/bin/zsh
        exec /bin/zsh -l
    fi
}
