#!/bin/bash

if [ $# -lt 2 ]
then
echo "  Usage : trace_cust_num.sh [MDN] [on or off]"
echo "  ex : trace_cust_num.sh 01088776502 on"
exit 0
fi

var=$1
len=$((${#var}))
if [[ $1 =~ ^[0-9] ]]
then
 if [ \( $len -lt 10 \) -o \( $len -gt 11 \) ]
	then
	 echo " [!] check your 1st parameter ( MDN length is 10 or 11 ) "
	 exit 0
 fi
else
echo " [!] check your 1st parameter ( MDN is only digit) "
exit 0
fi

tab_no=`expr \( $1 \% 4 \) + 1`
tab_name=TM_SFS_CUST_0$tab_no


if [ $2 = "on" ]
then 
order=1
elif [ $2 = "off" ]
then 
order=0
else
echo " [!] Check your 2nd parameter"
echo " [!] Choose between 'on' and 'off'"
exit 0
fi

sqlplus oraasfs/oraasfs2301@asfs << EOF
update $tab_name set TRACE_FLAG='$order' where CUST_NUM='$1';
commit;
quit
EOF
