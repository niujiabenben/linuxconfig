### {C, M} - {left, right}
bindkey "\e[1;5D" backward-word    ### C-left
bindkey "\e[1;3D" backward-word    ### M-left
bindkey "\e[1;5C" forward-word     ### C-right
bindkey "\e[1;3C" forward-word     ### M-right

### {C, M} - {home, end}
bindkey "\e[1;5H" beginning-of-line   ### C-home
bindkey "\e[1;3H" beginning-of-line   ### M-home
bindkey "\e[1;5F" end-of-line         ### C-end
bindkey "\e[1;3F" end-of-line         ### M-end

### {C, M} - {backspace, delete}
bindkey "\e[z5c" backward-kill-word    ### C-backspace
bindkey "\e[z3c" backward-kill-word    ### M-backspace
bindkey "\e[3;5~" kill-word            ### C-delete
bindkey "\e[3;3~" kill-word            ### M-delete
