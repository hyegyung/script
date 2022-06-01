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
waiting=120
else
waiting=$3
fi

if [ ${#today} -ne 8 ]; then
echo "검색 날짜 입력 오류 (YYYYMMDD)"
exit
fi

#SERVERS="
#150.31.22.143
#150.31.22.144
#150.31.22.145
#150.31.22.146
#150.31.22.147
#150.31.22.148
#150.31.22.149
#150.31.22.150
#150.31.22.151
#150.31.22.152
#150.31.22.153
#150.31.22.155
#150.31.22.156
#"

SERVERS="
150.203.41.43
150.203.41.44
150.203.41.45
150.203.41.46
150.203.41.47
150.203.41.48
150.203.41.49
150.203.41.50
150.203.41.51
150.203.41.52
150.203.41.53
150.203.41.54
150.203.41.55
"

for m in $SERVERS; do
ssh $m grep -s $1 /home/sfs/log/stat/sfs/$today/*.log > "$today"_$1_$m.log &
done

count=99
while [ $count -gt 0 -a $waiting -gt 0 ]; do
count=`ps -ef | grep ssh | grep $1 | wc -l`
echo -n -e  "\rrunning..[$waiting][$count]     "
let waiting=$waiting-1
sleep 1
done
echo ""
if [ $count -gt 0 ]; then
echo "시간 초과로 강제 수집 종료..."
kill -9 `ps -ef | grep ssh | grep $1 | awk '{print $2}'`
sleep 2
fi


echo "파일 처리 중......"

cat "$today"_$1_*.log > temp_$1.txt
sleep 1

sed 's/.*.log://g' temp_$1.txt > sed_$1.txt

awk -F '|' '{ if ($7 == "'${1}'") print $1 "\t" $2 "\t" $5 "\t" $9 "\t" $17 "\t" $6 "\t" $7 "\t" $8 "\t" $10 "\t" $11 "\t" $16 }' sed_$1.txt | sort -k 5 > log_$1_$today.txt

rm -f "$today"_$1_*.log
rm -f temp_$1.txt
rm -f sed_$1.txt

echo "수집 완료"

