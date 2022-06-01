#!/bin/bash

source /home/sfslog/.bash_profile


tempPath='/home/sfslog/script/cut_stat'

#--- each Path
logPath_2='/home/sfslog/logs/admstr'


logDate=`date +%Y%m%d -d '-1days'`
Date=`date +%Y%m%d -d '-1days'`
today=`date +%Y%m%d%H%M%S`

startTime=$(date +%s%N)

rm -f $tempPath/count_st_$logDate.log
rm -f $tempPath/temp_st_$logDate.log
rm -f $tempPath/word_st_$logDate.log

echo "`cat $logPath_2/$logDate.log | tr -d '\r'`" >>  $tempPath/temp_st_$logDate.log

#-- count
str_buff=`cat $tempPath/temp_st_$logDate.log | sort | uniq -c`
echo "$str_buff" > $tempPath/count_st_$logDate.log


#-- top 10
str_word=`cat $tempPath/count_st_$logDate.log | sort -r -k1 -n | awk '{print $2}' | head -10`
echo "$str_word" > $tempPath/word_st_$logDate.log

startdbTime=$(date +%s%N)

#--- Search msg from db & Insert db
# <Usage> : .sh kind recv_date(-1day) save_date(today)
echo "String process ...."
./db_stat 2 $tempPath/word_st_$logDate.log ${Date}000000 $today 

rm -f $tempPath/count_st_$logDate.log
rm -f $tempPath/temp_st_$logDate.log
rm -f $tempPath/word_st_$logDate.log


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
   duration_db=$((($(date +%s%N) - $startdbTime)/1000000))
   Hour_db=$(($duration_db/3600000 ))
   Min_db=$(($(($duration_db%3600000))/60000))
   Sec_db=$(($(($duration_db%60000))/1000))
   Msec_db=$(($duration_db%1000))
   len_db=$((${#Msec_db}))
   if [ $len_db -lt 3 ]
     then
    Msec_db=0$Msec_db
   fi
   echo "[db_time(duration) : $Hour_db(h)  $Min_db(m)  $Sec_db.$Msec_db(s) ]"
   echo "[total_time(duration) : $Hour(h)  $Min(m)  $Sec.$Msec(s) ]"

