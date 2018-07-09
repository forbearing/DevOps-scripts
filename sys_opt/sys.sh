#!/bin/bash

#============================================
#Name:		sys.sh
#Function:	系统优化
#Date:		2018-7-9 20:30
#Author:	hybfkuf
#============================================


DISK=sda

# 1:内核参数优化
cat >> /etc/sysctl.conf << EOF
net.ipv4.ip_forward = 1
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.core.wmem_default = 87380
net.core.wmem_max = 16777216
net.core.rmem_default = 87380
net.core.rmem_max = 16777216
net.ipv4.tcp_keepalive_time = 120
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3
kernel.shmmax = 4294967295
vm.swappiness = 0
EOF
sysctl -p

# 2:资源限制优化
cat >> /etc/security/limit.conf << EOF
* sofe nofile 65535
* hard nofile 65535
EOF

# 3:磁盘调度策略优化
echo  deadline > /sys/block/$DISK/queue/scheduler

# 4:文件系统优化
#/dev/sda1//ext4  noatime,nodiratime,data=writeback  1  1
