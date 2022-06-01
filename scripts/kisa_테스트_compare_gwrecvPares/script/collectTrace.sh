#!/bin/sh

if [ $# -lt 1 ]; then
echo "검색 번호 입력"
exit 
fi

if [ $# -lt 2 ]; then
today=`date +%Y%m%d`
else
today=$2
fi

if [ ${#today} -ne 8 ]; then
echo "검색 날짜 입력 오류 (YYYYMMDD)"
exit
fi

./logCollecter.sh $1 $today
./msgCollecter.sh $1 $today

cut -f 4 msg_$1_$today.txt > temp.txt
paste log_$1_$today.txt temp.txt > result_$1_$today.txt

#rm log_$1_$today.txt
#rm msg_$1_$today.txt
rm temp.txt

echo "병합 완료"
