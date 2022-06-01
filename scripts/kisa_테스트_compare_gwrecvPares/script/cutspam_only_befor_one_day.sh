#!/bin/bash

#savePath='/home/asfs/Kwon'
#logPath='/home/asfs/Kwon'
savePath='/home/sfslog/logs/admstr'
logPath='/home/sfslog/logs/admstr'

today=`date +%Y%m%d%`
Date=`date +%Y%m%d -d '-1days'`
pad=000000
searchDate=$1

# belos is not necessary at sfslog2 server
#rm -f result_$Date.log

echo "[String (saved before ${searchDate:0:4}/${searchDate:4:2}/${searchDate:6:2})]  [Count (log date :  ${Date:0:4}/${Date:4:2}/${Date:6:2})]" >> $savePath/result_$Date.log
  
query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $savePath/tmp_$Date.log
 select string from sfs_spam_string where save_dt <='$searchDate$pad';
 spool off
 quit
 EOF`
echo `sed -i '$d' $savePath/tmp_$Date.log | sed -i '/SQL>/d' $savePath/tmp_$Date.log | tr -d '\r'`
db_str=`cat $savePath/tmp_$Date.log`
spam_str=`cat $logPath/log_$Date.log | tr -d '\r'`

count=0
for str in ${db_str[@]}
do
	count=0
	for spstr in ${spam_str[@]}
	do
	if [ "$str" = "$spstr" ]
	then
	count=$((count+1));
	fi
	done
	echo "$count   $str" >> $savePath/count_$Date.log
done
temp_arr=`cat $savePath/count_$Date.log | tr -d '\r' | sort | awk '{print $2, $1}'| sed 's/ /\t\t/g'`
echo "$temp_arr" >> $savePath/result_$Date.log

rm -f tmp_$Date.log
rm -f count_$Date.log


