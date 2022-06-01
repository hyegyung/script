#!/bin/bash

savePath='/home/asfs/Kwon'
logPath='/home/asfs/Kwon'
#save는 아마 script경로에 ?
#savePath='/home/sfslog/logs/admstr'
#logPath='/home/sfslog/logs/admstr'

today=`date +%Y%m%d`
pad=000000
searchDate=$1

rm -f result_$logDate.log

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $savePath/temp_$today.log
 select string from sfs_spam_string where save_dt <='$searchDate$pad';
 spool off
 quit
 EOF`

echo `sed -i '$d' $savePath/temp_$today.log | sed -i '/SQL>/d' $savePath/temp_$today.log | tr -d '\r'`
db_str=`cat $savePath/temp_$today.log`


dcnt=1
dDay=`date --date="-$dcnt days" +%Y%m%d`

while [ -e $logPath/log_$logDate.log ]
	do
	echo "[String (saved before ${searchDate:0:4}/${searchDate:4:2}/${searchDate:6:2})]  [Count (log date :  ${dDay:0:4}/${dDay:4:2}/${dDay:6:2})]" >> $savePath/result_$logDate.log
	spam_str=`cat $logPath/log_$logDate.log | tr -d '\r'`

	coun=0
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
		echo "$count   $str" >> $savePath/count_$logDate.log
	done
	
	temp_arr=`cat $savePath/count_$logDate.log | tr -d '\r' | sort | awk '{print $2, $1}'| sed 's/ /\t\t/g'`
	echo "$temp_arr" >> $savePath/result_$logDate.log

	rm -f $savePath/count_$logDate.log

	dcnt=$((dcnt+1))
	dDay=`date --date="-$dcnt days" +%Y%m%d`

# while done
done
rm -f $savePath/temp_$today.log

