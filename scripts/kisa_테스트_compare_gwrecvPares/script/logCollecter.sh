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

SERVERS="
150.31.22.143
150.31.22.144
150.31.22.145
150.31.22.146
150.31.22.147
150.31.22.148
150.31.22.149
150.31.22.150
150.31.22.151
150.31.22.152
150.31.22.153
150.31.22.155
150.31.22.156
"

for m in $SERVERS; do
ssh $m grep $1 /home/sfs/log/stat/sfs/$today/*.log > $today_$1_$m.log &
done

count=99
while [ $count -gt 0 ]; do
count=`ps -ef | grep ssh | grep $1 | wc -l`
echo "running..["$count"]"
sleep 1
done

echo "파일 처리 중......"

cat $today_$1_*.log > temp_$1.txt
sleep 1

sed 's/.*.log://g' temp_$1.txt > sed_$1.txt

echo -e "요청시간\t처리시간\t메시지타입\t발신번호\t착신번호\t회신번호\t처리결과\t결과코드\t차단사유" > log_$1_$today.txt
awk -F '|' '{ if ($7 == "'${1}'") print $1 "\t" $2 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $10 "\t" $11 "\t" $16 }' sed_$1.txt | sort -k 6 >> log_$1_$today.txt

rm -f $today_$1_*.log
rm -f temp_$1.txt
rm -f sed_$1.txt

echo "수집 완료"

