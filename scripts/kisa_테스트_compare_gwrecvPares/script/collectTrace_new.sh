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

if [ $# -lt 3 ]; then
time=300
else
time=$3
fi

if [ ${#today} -ne 8 ]; then
echo "검색 날짜 입력 오류 (YYYYMMDD)"
exit
fi

echo "로그 추출...."
./src/logCollecter.sh $1 $today $time
echo "메시지 추출...."
./src/msgCollecter.sh $1 $today $time
echo "이미지 복사...."
./src/imgCollecter.sh $1 $today


echo "파일 병합..."

echo -e "요청시간\t처리시간\t메시지타입\tMsgID\tSeqID\t발신번호\t착신번호\t회신번호\t처리결과\t결과코드\t차단사유\t메시지" > result_$1_$today.txt
cut -f 5 msg_$1_$today.txt > temp.txt
paste log_$1_$today.txt temp.txt | sort -k 8 >> result_$1_$today.txt

echo "병합 완료"

echo "통계 추출..."
echo ""
./src/reasonCode.sh result_$1_$today.txt

echo "종료"


#rm log_$1_$today.txt
#rm msg_$1_$today.txt
rm temp.txt
