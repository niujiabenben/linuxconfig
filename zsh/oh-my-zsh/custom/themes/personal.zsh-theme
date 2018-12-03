# Put your custom themes in this folder.
# Example:

IP=`ifconfig | grep broadcast | awk '{print $2}' | awk 'END {print}'`
PROMPT="\
%{$fg[cyan]%}%n\
%{$fg[white]%}@\
%{$fg[green]%}${IP}\
%{$fg[white]%}:\
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
