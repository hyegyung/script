#!/bin/bash
source /home/vmgw/.bash_profile

scriptName=${0##*/}
Path=${PWD}


if [ "$#" -lt 2 ]; then
	echo -e "\n <Usage> : sh $scriptName [input file name] [RMK] \n"
	echo -e " ex) sh $scriptName input.txt 스팸정책적용_20170403 \n"
	exit 0
fi

#-- delete temp file
rm -rf $Path/insert_list.txt
rm -rf $Path/temp_insert_list.txt
rm -rf $Path/complete_insert_list.txt

today=`date +%Y%m%d%H%M`
curDate=`date +%Y%m%d`
startTime=$(date +%s%N)
$Path/run_insert_mafs $Path/$1 1 $today $2 $Path
endTime=$(date +%s%N)

checkEXE=`cat $Path/insert_list.txt | wc -l`
if [ -f $Path/insert_list.txt ]; then
	if [ $checkEXE -eq 0 ]; then
	exit 0
	fi
	echo ""
	echo " 등록 처리 완료되었습니다."
	echo ""

duration=$((($endTime - $startTime)/1000000))
Hour=$(($duration/3600000 ))
Min=$(($(($duration%3600000))/60000))
Sec=$(($(($duration%60000))/1000))
Msec=$(($duration%1000))
len=$((${#Msec}))
if [ $len -lt 3 ]
  then
 Msec=0$Msec
fi

	SUCNUM=`cat $Path/complete_insert_list.txt | wc -l`
	TOTNUM_orig=`cat $Path/$1 | wc -l`
	TOTNUM=`cat $Path/insert_list.txt | wc -l`
	#TOTNUM=`cat $Path/insert_list.txt | wc -l`
	echo "< 결과 >"
	echo " - 전체 메시지 목록( $TOTNUM_orig X2=$(($TOTNUM_orig*2)) 건) : $1 "
	echo " - 중복 제거한 목록( $TOTNUM 건) : insert_list.txt "
	echo " - 입력 성공한 목록( $SUCNUM 건) : complete_insert_list.log"
	echo -e "\n[Time(소요시간) : $Hour(h)  $Min(m)  $Sec.$Msec(s) ]\n"
else
exit 0
fi
