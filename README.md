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


## 远程连接jupyter notebook

将jupyter_notebook_config.py拷贝到~/.jupyter中:

``` shell
mkdir -p ~/.jupyter && cp ./jupyter_notebook_config.py ~/.jupyter
```

设置登录密码: `jupyter notebook password`, 并将值放入c.NotebookApp.password字段

默认端口为8889, 也可以修改, 字段为: c.NotebookApp.port


## emacs编译问题

报错: `configure: error: pkg-config found alsa, but it does not compile.`<br>
解决: `sudo apt-get install libsdl2-dev`

报错: `xml.c:23:10: fatal error: libxml/tree.h: No such file or directory`<br>
解决: `sudo apt install libxml2-dev`

报错: `lcms.c:23:10: fatal error: lcms2.h: No such file or directory`<br>
解决: `sudo apt install liblcms2-dev`


## build clang from source

```shell
mkdir build && cd build
cmake -G "Unix Makefiles" \
      -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly" \
      -DCMAKE_INSTALL_PREFIX=${HOME}/Documents/tools/clang \
      -DCMAKE_BUILD_TYPE=Release \
      ../llvm
make -j32 && make install
```
