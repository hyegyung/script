#!/bin/bash

savePath='/home/asfs/Kwon'
logPath='/home/asfs/Kwon'
#savePath='/home/sfslog/script'
#logPath='/home/sfslog/logs/admsentence'

today=`date +%Y%m%d`
pad=235959
startTime=$(date +%s%N)


if [ $# -lt 1 ]
  then
    echo " "
	echo " < Usage >"
	echo " [.sh] [Date]"
	echo " ex) ./dbsentcnt.sh 20150120"
	echo " "
	exit 0
fi

searchDate=$1
len=$((${#searchDate}))
if [[ $searchDate =~ ^[0-9] ]]
then
	if [ $len -ne 8 ]
	then
		echo " [!] Check 1st parameter ( Date length is 8 )"
		exit 0
	fi
else
	echo " [!] Check parameter ( only number )"
	exit 0
fi

dcnt=1
#logDate=`date --date="-$dcnt days" +%Y%m%d`
start_logDate=`date --date="-$dcnt days" +%Y%m%d`
logDate=20150203
echo ``

rm -f $savePath/temp_$today.log
rm -f `ls | grep count_\[0-9\]`
rm -f `ls | grep result_se_\[0-9\]`
rm -f `ls | grep cutlist_\[0-9\]`

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $savePath/temp_$today.log
 select string from sfs_spam_sentence where save_dt <='$searchDate$pad';
 spool off
 quit
 EOF`

echo `sed -i '$d' $savePath/temp_$today.log | sed -i '/SQL>/d' $savePath/temp_$today.log | tr -d '\r'`
db_str=`cat $savePath/temp_$today.log`


#while [ -e $logPath/$logDate.log ]
#do
#### check only 31 days
#perid_date=$(($start_logDate - $logDate))
#if [ $perid_date -ge 30 ]
#then
#	break;
#fi

echo "[String (saved before ${searchDate:0:4}/${searchDate:4:2}/${searchDate:6:2})]  [Count (log date :  ${logDate:0:4}/${logDate:4:2}/${logDate:6:2})]" >> $savePath/result_se_$logDate.log
#echo "`cat $logPath/$logDate.log | tr -d '\r'`" >> $logPath/cutlist_$logDate.log
#echo "`cat $logPath/$logDate.log |sort | uniq -c |  tr -d '\r'`" >> $logPath/cutlist_$logDate.log
echo "`cat $logPath/$logDate.log |  tr -d '\r'`" > $logPath/cutlist_$logDate.log

 	duration=$((($(date +%s%N) - $startTime)/1000000))
	   Hour=$(($duration/3600000 ))
	   Min=$(($(($duration%3600000))/60000))
	   Sec=$(($(($duration%60000))/1000))
	   Msec=$(($duration%1000))
	   len=$((${#Msec}))
	   if [ $len -lt 3 ]
	        then
			    Msec=0$Msec
				   fi
				      echo "[ time(duration) : $Hour(h)  $Min(m)  $Sec.$Msec(s) ]"

		for buff1 in ${db_str[@]}
		do		
#chkcnt=`cat $logPath/cutlist_$logDate.log | fgrep -x -- "$buff1" | sort | uniq -c | awk '{print $0}'`
chkcnt=`cat $logPath/cutlist_$logDate.log | fgrep -x -- "$buff1" | wc -l`
echo "$chkcnt $buff1" >> count_$logDate.log
	done
   duration=$((($(date +%s%N) - $startTime)/1000000))
	   Hour=$(($duration/3600000 ))
	   Min=$(($(($duration%3600000))/60000))
	   Sec=$(($(($duration%60000))/1000))
	   Msec=$(($duration%1000))
	   len=$((${#Msec}))
	   if [ $len -lt 3 ]
	        then
			    Msec=0$Msec
				   fi
				      echo "[ time(duration) : $Hour(h)  $Min(m)  $Sec.$Msec(s) ]"

	temp_arr=`cat $savePath/count_$logDate.log | sort -r -k1 -n | awk '{print $2"	"$1}'`
	#temp_arr=`cat $savePath/count_$logDate.log | tr -d '\r' | sort -r -k1 -n | awk '{print $2, $1}'| sed 's/ /\t\t/g'`
	echo "$temp_arr" >> $savePath/result_se_$logDate.log

	dcnt=$((dcnt+1))
	logDate=`date --date="-$dcnt days" +%Y%m%d`


rm -f `ls | grep count_\[0-9\]`

#done
rm -f `ls | grep cutlist_\[0-9\]`
rm -f $savePath/temp_$today.log

   duration=$((($(date +%s%N) - $startTime)/1000000))
	   Hour=$(($duration/3600000 ))
	   Min=$(($(($duration%3600000))/60000))
	   Sec=$(($(($duration%60000))/1000))
	   Msec=$(($duration%1000))
	   len=$((${#Msec}))
	   if [ $len -lt 3 ]
	        then
			    Msec=0$Msec
				   fi
				      echo "[$logDate> time(duration) : $Hour(h)  $Min(m)  $Sec.$Msec(s) ]"
