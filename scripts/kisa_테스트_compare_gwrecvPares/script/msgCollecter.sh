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
if [ $m == "150.31.22.150" ]; then
ssh $m grep $1 /home/sfs/log/sfs/gwrecv2/*$today* | grep TRACE > $today_$1_$m.log &
else
ssh $m grep $1 /home/sfs/log/sfs/gwrecv/*$today* | grep TRACE > $today_$1_$m.log &
fi
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

sed 's/.*.log.\{0,3\}://g' temp_$1.txt | sed 's/\[URL_HOLD\]\{0,1\}//g' | sed 's/^\[[0-9]\{8\}-[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}.[0-9]\{3\}\]\[[0-9]\{1,2\}:[0-9]\{1,2\}\]\[main.c.*gwrecv[0-9]\{0,1\}\]:\[TRACE_LOG\]\[[0-9]\{1,2\}:[0-9]\{16\}:.\{8,11\}:[0-9]\{1,2\}\]\[\([a-zA-Z0-9]\{0,11\}\):\([a-zA-Z0-9]\{0,11\}\):\([a-zA-Z0-9]\{0,11\}\):.*:.*\]\[[0-9]\{1,2\}\]\[[A-Z]\{3,4\}:[0-9]\{1,2\}:[0-9]\{1,2\}:[0-9]\{1,2\}:.*\]\[[a-zA-Z0-9]\{0,256\}:[a-zA-Z0-9]\{0,16\}\]\[/\1\t\2\t\3\t/g' | sed 's/\]$//g'  >  sed_$1.txt

echo -e "발신번호\t착신번호\t회신번호\t메시지 " > msg_$1_$today.txt
cat sed_$1.txt | sort -k 3 >> msg_$1_$today.txt

rm -f $today_$1_*.log
rm -f temp_$1.txt
rm -f sed_$1.txt

echo "수집 완료"

