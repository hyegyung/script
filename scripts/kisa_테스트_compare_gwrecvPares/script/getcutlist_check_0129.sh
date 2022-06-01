#!/bin/bash

saveStrPath='/home/sfslog/logs/admstr'
saveSecPath='/home/sfslog/logs/admsentence'

logPath='/home/sfslog/logs/transaction/sfs'

Date=`date +%Y%m%d -d '-1days'`
filename=${Date:0:8}


for hour in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
do
	for Min in 00 05 10 15 20 25 30 35 40 45 50 55
	do
	if [ -e $logPath/$Date/*/$filename$hour$Min.log ]
	then
getString=`grep -r "운영자 차단 문자열" $logPath/$Date/*/$filename$hour$Min.log | cut -d '|' -f 16 | awk '{print substr($3,5,length($3)-6)}'`
getSentence=`grep -r "운영자 차단 문장" $logPath/$Date/*/$filename$hour$Min.log | cut -d '|' -f 16 | awk '{print substr($3,4,length($3)-5)}'`
echo "$getString" >> $saveStrPath/$filename.log
echo "$getSentence" >> $saveSecPath/$filename.log
sleep 10
	fi
	done
sleep 2
done
