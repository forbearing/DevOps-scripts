#!/bin/bash

#Function:				自动化源代码编译安装 LNMP 环境,并安装 hdwiki
#Name:					lnmp_hdwiki
#Author:				Hyb
#Date:					2018/06/22
#Description:			mysql: 5.6

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH
ERROR=1

# Check if user is root
if [ "$(id -u)" != 0 ]; then
	echo "Error, You must be root to run this script"
	exit $ERROR
fi

# Check if system architecture is x86_64
if [ "$(uname -m)" != "x86_64" ]; then
	echo "You arch must be x86_64";
	exit $ERROR
fi

# Download packages
wget -b -o wget_nginx.log -O /usr/src/nginx.tar.gz  https://nginx.org/download/nginx-1.6.3.tar.gz > /dev/null && echo "Nginx-1.6.3 is downloading !!!"
wget -b -o wget_mysql.log -O /usr/src/mysql.tar.gz https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz > /dev/null && echo "MySQL-5.6.40 finished downloading"
wget -b -o wget_php.log -O /usr/src/php.tar.gz http://jp2.php.net/distributions/php-5.6.36.tar.bz2 > /dev/null && echo "php-5.6.36 is downloading !!!"
wget -b -o wget_hdwiki.log -O /usr/src/hdwiki.zip http://kaiyuan.hudong.com/download.php\?n\=HDWiki-v6.0UTF8-20170209.zip > /dev/null && echo "HDWiki-v6 is downloading !!!"
[ $(ps ax | grep wget | grep -iE 'nginx|mysql|hdwiki' > /dev/null) ] || echo "download finished !!!"
for log in wget_nginx.log wget_mysql.log wget_php.log wget_hdwiki.log
do
	rm -f $log
done


# Configure The Nginx Source Code

echo "Start Install Configure Install Nginx !!!"
yum install -y pcre pcre-devel openssl openssl-devel
[ $(id nginx 2> /dev/null) ] || useradd -M -s /sbin/nologin -g nginx nginx
[ -d /usr/src ] && cd /usr/src || exit $ERROR

tar xf nginx.tar.gz && cd nginx-1.6.3
./configure \
	--prefix=/usr/local/nginx \
	--user=nginx --group=nginx \
	--with-http_stub_status_module \
	--with-http_ssl_moudle
make && make install
echo "Configure Install Nginx finished !!!"


