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
150.203.41.48
150.203.41.49
150.203.41.51
150.203.41.52
150.203.41.53
150.203.41.54
150.203.41.55
"

for m in $SERVERS; do
scp sfs@$m:/home/sfs/image_file/$2/$1/decode* ./
done

