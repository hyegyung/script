#!/bin/bash
source /home/vmgw/.bash_profile

scriptName=${0##*/}
Path=${PWD}


if [ "$#" -lt 2 ]; then
	echo -e "\n <Usage> : sh $scriptName [input file name] [RMK] \n"
	echo -e " ex) sh $scriptName input.txt ������å����_20170403 \n"
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
	echo " ��� ó�� �Ϸ�Ǿ����ϴ�."
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
	echo "< ��� >"
	echo " - ��ü �޽��� ���( $TOTNUM_orig X2=$(($TOTNUM_orig*2)) ��) : $1 "
	echo " - �ߺ� ������ ���( $TOTNUM ��) : insert_list.txt "
	echo " - �Է� ������ ���( $SUCNUM ��) : complete_insert_list.log"
	echo -e "\n[Time(�ҿ�ð�) : $Hour(h)  $Min(m)  $Sec.$Msec(s) ]\n"
else
exit 0
fi
