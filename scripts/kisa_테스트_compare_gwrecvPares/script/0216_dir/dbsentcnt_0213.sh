#!/bin/bash
today=`date +%Y%m%d`

resultPath='/home/sfslog/script/cntresult/sec_result'
logPath='/home/sfslog/logs/admsentence'

pad=235959
startTime=$(date +%s%N)


if [ $# -lt 1 ]
  then
    echo " "
	echo " < Usage >"
	echo " [.sh] [Date]"
	echo " ex) ./dbsentcnt.sh 20150120"
    echo " select string from sfs_spam_sentence where save_dt<='20150120235959';"
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

dcnt=16
logDate=`date --date="-$dcnt days" +%Y%m%d`
startlogDate=$(($logDate))

rm -f $resultPath/temp_se_$today.log

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/temp_se_$today.log
 select string from sfs_spam_sentence where save_dt <='$searchDate$pad';
 spool off
 quit
 EOF`

echo `sed -i '$d' $resultPath/temp_se_$today.log | sed -i '/SQL>/d' $resultPath/temp_se_$today.log | tr -d '\r'`
db_str=`cat $resultPath/temp_se_$today.log`


while [ -e $logPath/$logDate.log ]
do
#### check only 31 days
perid_date=$(($start_logDate - $logDate))
if [ $perid_date -ge 30 ]
then
   break;
fi
startTime=$(date +%s%N)

	rm -f $resultPath/result_se_$logDate.log
	rm -f $resultPath/count_se_$logDate.log

	echo "[String (saved before ${searchDate:0:4}/${searchDate:4:2}/${searchDate:6:2})]  [Count (log date :  ${logDate:0:4}/${logDate:4:2}/${logDate:6:2})]" >> $resultPath/result_se_$logDate.log
	echo "`cat $logPath/$logDate.log | tr -d '\r'`" > $resultPath/cutlist_se_$logDate.log
	dbcount=0
	totaldbrow=`cat $resultPath/temp_se_$today.log | wc -l`
	for buff1 in ${db_str[@]}
		do		
		chkcnt=`cat $resultPath/cutlist_se_$logDate.log | fgrep -x -- "$buff1" | wc -l`
		echo "running...[$dbcount/$totaldbrow]"
		echo "$chkcnt $buff1" >> $resultPath/count_se_$logDate.log
	dbcount=$((dbcount+1))
	done
   	temp_arr=`cat $resultPath/count_se_$logDate.log | sort -r -k1 -n | awk '{print $2"	"$1}'`
	echo "$temp_arr" >> $resultPath/result_se_$logDate.log

	rm -f $resultPath/count_se_$logDate.log
    rm -f $resultPath/cutlist_se_$logDate.log


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
      echo "<Sentence>	[ $logDate.log > time(duration) : $Hour(h)  $Min(m)  $Sec.$Msec(s) ]" >> $resultPath/timecheck_se_$today.txt

	dcnt=$((dcnt+1))
	logDate=`date --date="-$dcnt days" +%Y%m%d`




done

#rm -f $resultPath/temp_se_$today.log


