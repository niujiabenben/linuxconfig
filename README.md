## emacsclient.desktop

emacsclient.desktop位于~/.local/share/applications, 在terminal中打开emacsclient, 参考:
[How can I add 'emacs' to one of the 'Show other application' in file explorer](https://askubuntu.com/questions/283285/how-can-i-add-emacs-to-one-of-the-show-other-application-in-file-explorer)

## 联想昭阳E42-80笔记本网络无法链接解决方法

sudo modprobe -r ideapad_laptop

可以将上述命令放在/etc/rc.local中，开机自动启动。

## emacs server自动启动

方法一: 将环境变量ALTERNATE_EDITOR设置为空: export ALTERNATE_EDITOR=""

方法二: 传入alternate-editor为空, 比如: emacsclient -t --alternate-editor=

参考: [How to start emacs server only if it is not started?](https://stackoverflow.com/questions/5570451/how-to-start-emacs-server-only-if-it-is-not-started)
