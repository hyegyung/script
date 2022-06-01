#!/bin/bash

source /home/sfslog/.bash_profile

tempPath='/home/sfslog/script/cut_stat'

#--- each Path
logPath_1='/home/sfslog/logs/admsentence'
logPath_2='/home/sfslog/logs/admstr'
logPath_3='/home/sfslog/logs/smishurl'
logPath_4='/home/sfslog/logs/cuturl'


logDate=`date +%Y%m%d -d '-1days'`
Date=`date +%Y%m%d -d '-1days'`
today=`date +%Y%m%d%H%M%S`

startTime=$(date +%s%N)

rm -f $tempPath/count_se_$logDate.log
rm -f $tempPath/temp_se_$logDate.log
rm -f $tempPath/word_se_$logDate.log

rm -f $tempPath/count_st_$logDate.log
rm -f $tempPath/temp_st_$logDate.log
rm -f $tempPath/word_st_$logDate.log


rm -f $tempPath/count_surl_$logDate.log
rm -f $tempPath/temp_surl_$logDate.log
rm -f $tempPath/word_surl_$logDate.log

rm -f $tempPath/count_curl_$logDate.log
rm -f $tempPath/temp_curl_$logDate.log
rm -f $tempPath/word_curl_$logDate.log


echo "`cat $logPath_1/$logDate.log | tr -d '\r'`" >>  $tempPath/temp_se_$logDate.log
echo "`cat $logPath_2/$logDate.log | tr -d '\r'`" >>  $tempPath/temp_st_$logDate.log
echo "`cat $logPath_3/$logDate.log | tr -d '\r'`" >>  $tempPath/temp_surl_$logDate.log
echo "`cat $logPath_4/$logDate.log | tr -d '\r'`" >>  $tempPath/temp_curl_$logDate.log

#-- count
sec_buff=`cat $tempPath/temp_se_$logDate.log | sort | uniq -c`
str_buff=`cat $tempPath/temp_st_$logDate.log | sort | uniq -c`
smishURL_buff=`cat $tempPath/temp_surl_$logDate.log | sort | uniq -c`
cutURL_buff=`cat $tempPath/temp_curl_$logDate.log | sort | uniq -c`

echo "$sec_buff" > $tempPath/count_se_$logDate.log
echo "$str_buff" > $tempPath/count_st_$logDate.log
echo "$smishURL_buff" > $tempPath/count_surl_$logDate.log
echo "$cutURL_buff" > $tempPath/count_curl_$logDate.log


#-- top 10
sec_word=`cat $tempPath/count_se_$logDate.log | sort -r -k1 -n | awk '{print $2}' | head -10`
str_word=`cat $tempPath/count_st_$logDate.log | sort -r -k1 -n | awk '{print $2}' | head -10`
smishURL_word=`cat $tempPath/count_surl_$logDate.log | sort -r -k1 -n | awk '{print $2}' | head -10`
cutURL_word=`cat $tempPath/count_curl_$logDate.log | sort -r -k1 -n | awk '{print $2}' | head -10`

echo "$sec_word" > $tempPath/word_se_$logDate.log
echo "$str_word" > $tempPath/word_st_$logDate.log
echo "$smishURL_word" > $tempPath/word_surl_$logDate.log
echo "$cutURL_word" > word_curl_$logDate.log

startdbTime=$(date +%s%N)

#--- Search msg from db & Insert db
# <Usage> : .sh kind recv_date(-1day) save_date(today)
echo "Sentence process ...."
./db_stat 1 $tempPath/word_se_$logDate.log ${Date}000000 $today

echo "String process ...."
./db_stat 2 $tempPath/word_st_$logDate.log ${Date}000000 $today 

echo "Smishing URL process ...."
./db_stat 3 $tempPath/word_surl_$logDate.log ${Date}000000 $today 

echo "Cut URL process ...."
./db_stat 4 $tempPath/word_curl_$logDate.log $Date $today


rm -f $tempPath/count_se_$logDate.log
rm -f $tempPath/temp_se_$logDate.log
rm -f $tempPath/word_se_$logDate.log

rm -f $tempPath/count_st_$logDate.log
rm -f $tempPath/temp_st_$logDate.log
rm -f $tempPath/word_st_$logDate.log


rm -f $tempPath/count_surl_$logDate.log
rm -f $tempPath/temp_surl_$logDate.log
rm -f $tempPath/word_surl_$logDate.log

rm -f $tempPath/count_curl_$logDate.log
rm -f $tempPath/temp_curl_$logDate.log
rm -f $tempPath/word_curl_$logDate.log



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

