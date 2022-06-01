#!/bin/bash

source /home/sfslog/.bash_profile
saveStrPath='/home/sfslog/logs/admstr'
saveSecPath='/home/sfslog/logs/admsentence'

logPath='/home/sfslog/logs/transaction/sfs'
Date=20150101
daycnt=19
Date=`expr $Date + $daycnt`
while [ $daycnt -lt 31 ]
do
CurTime=`date +%k%M`
echo ">���� ������� ��¥ : ${Date:0:8} / ����ð� ${CurTime:0:2}�� ${CurTime:2:2}��"

filename=${Date:0:8}
for hour in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
do
echo "...������� �ð� : $hour "
	for Min in 00 05 10 15 20 25 30 35 40 45 50 55
	do
	getString=`grep -r "��� ���� ���ڿ�" $logPath/$Date/*/$filename$hour$Min.log | cut -d '|' -f 16 | awk '{print substr($3,5,length($3)-6)}'`
	getSentence=`grep -r "��� ���� ����" $logPath/$Date/*/$filename$hour$Min.log | cut -d '|' -f 16 | awk '{print substr($3,4,length($3)-5)}'`

if [ -n "$getString" ]
	then	
	echo "$getString" >> $saveStrPath/$filename.log
fi

if [ -n "$getSentence" ]
	then	
	echo "$getSentence" >> $saveSecPath/$filename.log
fi	

	sleep 1
	done
sleep 1

done

sleep 1

daycnt=$((daycnt+1))
Date=`expr $Date + 1`

done
