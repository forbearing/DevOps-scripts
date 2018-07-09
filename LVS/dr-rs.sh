#!/bin/bash

#=========================================
#Name:		dr-rs.sh
#Function:	dr 工作模式下, real server 的配置
#Date:		2018-7-9 17:30
#Author:	hybfkuf
#=========================================

INTER=eth2

echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
echo 1 > /proc/sys/net/ipv4/conf/default/arp_ignore
echo 1 > /proc/sys/net/ipv4/conf/$INTER/arp_ignore

echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
echo 2 > /proc/sys/net/ipv4/conf/default/arp_announce
echo 2 > /proc/sys/net/ipv4/conf/$INTER/arp_announce

sysctl -w net/ipv4/conf/default/rp_filter=0
sysctl -w net/ipv4/conf/lo/rp_filter=0
sysctl -w net/ipv4/conf/$INTER/rp_filter=0

ifconfig lo:0 192.168.12.105/32 up
