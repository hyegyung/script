#!/bin/bash
LANG=ko_KR.eucKR
saveStrPath='/home/asfs/Kwon'
#saveStrPath='/home/sfslog/logs/admstr'
saveSecPath='/home/asfs/Kwon'
logPath='/home/asfs/Kwon'
#logPath='/home/asfs/Kwon/env_test'
#logPath='/home/sfslog/logs/transaction/sfs'

Date=`date +%Y%m%d -d '-1days'`
Date=20150130
startTime=$(date +%s%N)

filename=${Date:0:8}
for hour in 00 01 02 03
#04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
do
	for Min in 00 05 10 15 20 25 30 35 40 45 50 55
	do
#echo ">>hour/Min = $hour/$Min"

#getString=`grep -r "운영자 차단 문자열" $logPath/20150202/*/201501300000.log | cut -d '|' -f 16 | awk '{print substr($3,5,length($3)-6)}'`
# if(length(val)>0){print substr($3,3,length($3)-4)}}'`
getString=`grep -r "운영자 차단 문자열" $logPath/20150202/*/201501300000.log | cut -d '|' -f 16 | awk '{val=substr($3,3,length($3)-4); if(length(val)>1)print val}'`
								
# if(length(val)>0){print substr($3,3,length($3)-4)}}'`
	
getSentence=`grep -r "운영자 차단 문장" $logPath/20150202/*/201501300000.log | cut -d '|' -f 16 | awk '{print substr($3,4,length($3)-5)}'`

# (2) 속도빠름, sfslog서버에서 문자열 파싱안됨 ㅠ 원인파악X															   
#	getString=`grep -r "운영자 차단 문자열" $logPath/20150202/*/201501300000.log | cut -d '|' -f 16 | awk '{print substr($3,5,length($3)-6)}'`
#	getSentence=`grep -r "운영자 차단 문장" $logPath/20150202/*/201501300000.log | cut -d '|' -f 16 | awk '{print substr($3,4,length($3)-5)}'`

# (3) 속도느림, 문장은 파싱안됨
#	getString=`awk -F '|' '{ if (substr($16, 0, 10) == "운영자 차단 문자열") { sub("^운영자 차단 문자열-", "", $16); sub("--$", "" , $16); print $16 } }' $logPath/20150202/*/201501300000.log`
#	getSentence=`awk -F '|' '{ if (substr($16, 0, 10) == "운영자 차단 문장") { sub("^운영자 차단 문장-", "", $16); sub("--$", "" , $16); print $16 } }' $logPath/20150202/*/201501300000.log `
#len=$((${#getString}))
#if [ $len -ne 0 ]
if [ -n "$getString" ]
then
echo "$getString" >> $saveStrPath/20150130.log
fi

if [ -n "$getSentence" ]
then
echo "$getSentence" >> $saveSecPath/20150130_2.log
fi
#	sleep 5
	done
#sleep 10
done
#문자열 혹시몰라서 아래 추가 

echo `cat $saveStrPath/20150130.log`
echo `sed -i 's/^열-//g' ./20150130.log`

echo ">>> for loop end"
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
