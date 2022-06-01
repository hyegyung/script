#!/bin/sh

if [ $# -lt 1 ]; then
echo "input value error"
exit;
fi

nowtime=`date +%H%M`
startIgnoreTime=0005 
endIgnoreTime=0830  

serverIp="150.31.22.160"
userid="asfs"
passwd="novsfS**44"
path="/home/asfs/SendSMS/notice/"
lpath="/home/vmgw/script/monitor/"

ftp -n -v << EOF
open $serverIp
user $userid $passwd
cd $path
lcd $lpath
put $1
bye
EOF


rm -f $1 
