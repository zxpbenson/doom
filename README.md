主机存储在hosts目录下,可以一目录形式组织包含关系,但是最后一级要求是文件

密码可以写在最后一级文件中,如果不写就会在登录的时候提示输入

在/etc/profile中加入如下内容，就可以用mlgn快速进入登录界面

alias mlgn=/Users/sefarious/workspace/doom/login.sh
