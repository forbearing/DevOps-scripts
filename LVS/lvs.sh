#!/bin/bash

#==========================================
#Name:		lvs.sh
#Function:	LVS 添加两个real server
#Date:		2018-7-9 17:00
#Author:	hybfkuf
#==========================================


. /etc/init.d/functions

ifconfig eth0:0 192.168.12.105/24 up

VIP=192.168.12.105
PORT=80
RIP=(
	192.168.12.100
	192.168.12.101
)

start(){
	echo "starting ..."
	ipvsadm -C
	ipvsadm --set 30 5 60
	ipvsadm -A -t $VIP:$PORT -s rr -p 20
	for ((i=0; i<${#RIP[*]}; i++))
	do
		ipvsadm -a -t $VIP:$PORT -r ${RIP[$i]} -g -w 1
	done
	echo "start ok !!!"
}

stop(){
	echo "stoping ..."
	ipvsadm -C
	echo "stop ok !!!"
}

restart(){
	start
	stop
	echo "restart ok !!!"
}

status(){
	ipvsadm -L -n
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	status)
		status
		;;
	*)
		echo "Usage: $0 [start|stop|restart|status]"
esac
