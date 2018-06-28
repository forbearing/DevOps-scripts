#!/bin/bash

########################################################
#Function:		"An enhanced and more portable `ls -l`"
#Date:			2018/6/28
#Author			hyb
#Usage			./l.sh
########################################################

(
 [ "$LS_COLORS" ] || eval $(dircolors)
 [ "$LS_COLORS" ] || eval $(TERM=xterm dircolors)
 printf "$LS_COLORS"
) | tr : '\n' |
sed 's/\([^=]*\)=\(.*\)/\x1b[\2m\1\x1b[0m\t\2/'
