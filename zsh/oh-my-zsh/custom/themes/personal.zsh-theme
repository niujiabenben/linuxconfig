# Put your custom themes in this folder.
# Example:

IP=`ifconfig | grep broadcast | awk '{print $2}' | awk 'END {print}'`
PROMPT_SIMPLE="%n@${IP}:%~ "
PROMPT_COMPLEX="\
%{$fg[cyan]%}%n\
%{$fg[white]%}@\
%{$fg[green]%}${IP}\
%{$fg[white]%}:\
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"


if [ -z $USE_EMACS ]; then
    PROMPT=$PROMPT_COMPLEX
else
    TERM=dumb
    PROMPT=$PROMPT_SIMPLE
    unset zle_bracketed_paste
fi
