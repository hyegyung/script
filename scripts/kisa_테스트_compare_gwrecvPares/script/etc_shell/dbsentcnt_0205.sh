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


rm -f $savePath/temp_$today.log
rm -f `ls | grep count_2015\[0-9\]`
rm -f `ls | grep result_se_2015\[0-9\]`
rm -f $savePath/cutlist_$logDate.log

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $savePath/temp_$today.log
 select string from sfs_spam_sentence where save_dt <='$searchDate$pad';
 spool off
 quit
 EOF`
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


echo `sed -i '$d' $savePath/temp_$today.log | sed -i '/SQL>/d' $savePath/temp_$today.log | tr -d '\r'`
db_str=`cat $savePath/temp_$today.log | sort`


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



dcnt=1
#logDate=`date --date="-$dcnt days" +%Y%m%d`
logDate=20150203
#while [ -e $logPath/$logDate.log ]
#	do

echo "[String (saved before ${searchDate:0:4}/${searchDate:4:2}/${searchDate:6:2})]  [Count (log date :  ${logDate:0:4}/${logDate:4:2}/${logDate:6:2})]" >> $savePath/result_se_$logDate.log
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


#spam_str=`cat $logPath/$logDate.log | tr -d '\r' | sort | uniq -c`
spam_str=`cat $logPath/$logDate.log | tr -d '\r' | sed '/^$/d' | sort | uniq -c`

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



echo "$spam_str" >> $logPath/cutlist_$logDate.log
echo "비교중..."
for str in ${db_str[@]}
do
#while read -r line; do str="${line[@]}";
      while read -a spam_line;  
	  	do 
		tmp1=${spam_line[1]}
		tmp2=${spam_line[0]}
		if [ "$str" = "$tmp1" ]
       	then
       	echo "$tmp2 $tmp1" >> $savePath/count_$logDate.log
       	fi
       done <<< "$spam_str"
done
	temp_arr=`cat $savePath/count_$logDate.log | tr -d '\r' | sort -r -k1 -n | awk '{print $2, $1}'| sed 's/ /\t\t/g'`
	echo "$temp_arr" >> $savePath/result_se_$logDate.log

#	dcnt=$((dcnt+1))
#	logDate=`date --date="-$dcnt days" +%Y%m%d`

#done
rm -f $savePath/temp_$today.log
rm -f `ls | grep count_2015\[0-9\]`
rm -f $savePath/cutlist_$logDate.log



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

