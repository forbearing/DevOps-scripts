#!/bin/bash

#########################################
# Funcation:				Configure Ubuntu after install
# Usage					bash ubuntu_conf.sh
# Author					hybfkuf
# Date					2018-06-20
#########################################

ERROR=1
RHOME="/root/"
UHOME="/home/hyb"

# Funcation:			判断用户是 "root" 还是 "hyb"
# Usage:				is_user "root"  或者  is_user "hyb"
# Author				hybfkuf
is_user() {
	if [ "$1" == "root" ]; then
		if [ "$(id -u)" -ne 0 ]; then
			echo "Error: You must be root"
			exit $ERROR
		fi
	elif [ "$1" == "hyb" ]; then
		if [ "$(whoami)" != "hyb" ]; then
			echo "Error: You must be user hyb"
			echo $ERROR
		fi
	elif [ -z "$1" ]; then
		echo "Error: You must pass a parameter"
		exit $ERROR
	else
		echo "Error: parameter error"
		exit $ERROR
	fi
}

# Funcation:				自动判断当前用户并切换到对应的家目录中
# Usage:					cd_home
# Author:					hybfkuf
cd_home() {
	[ "$(id -u)" -eq 0 ] && cd $RHOME || exit $ERROR
	[ "$(whoami)" == "hyb" ] && cd $UHOME || exit $ERROR
}

mkdir Documents || exit $ERROR
ln -s /home/hyb/Downloads || exit $ERROR


#=====  ROOT ====

# 1:Install essential packages
apt-get update > /dev/null && apt-get -y upgrade \
	&& echo "Upgrade Successfull !!!"  || exit $ERROR
apt-get install -y \
	zsh git vim tmux curl net-tools \
	aptitude gdebi guake htop apt-file pydf \
	chromium-browser virtualbox smplayer \
	fcitx-libpinyin fcitx-pinyin \
	shellcheck libappindicator3-1 > /dev/null \
	&& echo "Install Packages Successful !!!" || exit $ERROR

apt-file update > /dev/null \
	&& echo "apt-file update Successfule !!!"

wget -bc https://raw.githubusercontent.com/getlantern/lantern-binaries/master/lantern-installer-64-bit.deb > /dev/null && gdebi lantern-installer-64-bit.deb  \
	&& echo "Lantern Install Successful !!!"

# mount /mnt/sda2
echo "/dev/sda2  /mnt/sda2  ntfs  defaults  0  0" >> /etc/fstab || exit $ERROR
mount -a

# zsh
is_user "root"
cd_home
git clone https://robbyrussell/oh-my-zsh
cp oh-my-zsh/tempplate/zshrc.template .zshrc
mv oh-my-zsh .oh-my-zsh
chsh -s /usr/bin/zsh
echo "zsh compelete !!!"

# vim
is_user "root"
cd_home
read -r -p "please input your note path" note
#cp /mnt/sda2/linux_backup/bak/vim.tar.xz . || exit
cp "$note" .
tar xvf vim.tar.xz 
cp vim/vimrc .vimrc
mv vim .vimrc
echo "vim compelete !!!"

# UbuntuCMD
is_user "root"
cd_home
read -r -p "please input your note path: " note
name=$(basename "$note")
cp "$note" .
tar xvf "$name" > /dev/null
rm "$name"
echo "$name compelete !!!"

# tmux
is_user "root"
cd_home
cat > .tmux.conf << EOF
unbind C-b
set -g prefix C-s
set -g mouse on
set -g default-shell /usr/bin/zsh
bind r source-file ~/.tmux.conf \; display-message "configure reloaded"

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind H resize-pane -L 10
bind J resize-pane -D 5
bind K resize-pane -U 5
bind L resize-pane -R 10
EOF

# fonts
read -r -p "please input your fonts path: " font
name=$(basename "$font")
cp "$font" .
tar xvf "$name" -C /usr/share/fonts > /dev/null
rm "$name"
cd /usr/share/fonts/hyb || exit $ERROR
mkfontscale
mkfontdir
fc-cache -fv > /dev/null
echo "fonts compelete !!!"

# 5 configre .zshrc
is_user "root"
cd_home
cat >> ~/.zshrc << EOF
alias s='. /etc/profile && .~/.zshrc'
alias sck='shellcheck'
alias proxy='export | grep -i proxy'
alias lproxy='export http_proxy="http://127.0.0.1:45203" \
	&& export https_proxy=$http_proxy'
alias sproxy='export socks_proxy="http://127.0.0.1:1080"'
alias uproxy='unset http_proxy https_proxy socks_proxy'
EOF
echo "zshrc compelete !!!"

# 5: Shutdown unnecessary services

# 6:shadowsocks
is_user "root"
cd_home
cat > /etc/shadowsocks.json << EOF
{
	"server":"45.77.135.91",
	"server_port":8388,
	"local_address":"127.0.0.1",
	"local_port":1080,
	"password":"hybxswlyf"
	"timeout":300,
	"method":"aes-256-cfb"
}
EOF
echo "shadowsocks compelete !!!"

# 7:create_ap
is_user "root"
cd_home
apt install hostapd > /dev/null
git clone https://github.com/oblique/create_ap && cd create_ap || exit $ERROR
make install


#===== for hyb ====
for var in ~/.vim ~/.vimrc ~/.oh-my-zsh ~/.zshrc ~/.tmux.conf
do
	cp -rL $var /home/hyb
done
[ $? -eq 0 ] && echo "copy essential file to hyb successful !!!"
chown -R hyb:hyb /home/hyb 
