#!/bin/bash

id=vmgw
passwd=julsfS**28

if [ $# -lt 1 ]; then
today=`date +%Y%m%d`
else
today=$1
fi

ftp -n -v 150.31.22.201 << EOF
user $id $passwd
cd /home/vmgw/logs/vmgw
lcd /tmp/
get SVCE_$today.log 
bye
EOF

cat /home/vmgw/logs/vmgw/SVCE_$today.log | awk '{print $13}' | sort | uniq -c | grep -v "-" | awk '{if(length($2)<=12) print $2}' >> /tmp/vmgw_user.log
cat /tmp/SVCE_$today.log | awk '{print $13}' | sort | uniq -c | grep -v "-" | awk '{if(length($2)<=12) print $2}' >> /tmp/vmgw_user.log


#grep REQMOD /home/vmgw/logs/vmgw/UAMP_$today.log | cut -d ',' -f 6 | sort -n | uniq -c | awk '{print $2}' >> /tmp/vmgw_user.log 
#grep REQMOD /tmp/UAMP_$today.log | cut -d ',' -f 6 | sort -n | uniq -c | awk '{print $2}' >> /tmp/vmgw_user.log



user_count=`cat /tmp/vmgw_user.log | sort -n | uniq -c | wc -l`
echo "User Count : $user_count" 


\rm /tmp/SVCE_$today.log
\rm /tmp/vmgw_user.log
