#!/bin/bash
today=`date +%Y%m%d`
recDate=`date +%Y%m%d -d '-1days'`

kisa_num=(01093174965 01071474451)

for kisaNum in "${kisa_num[@]}"
do
hamCnt=`grep -r $kisaNum ./$today/* | grep $recDate | cut -d '|' -f 10 | sort | uniq -c | head -1 | awk '$2 ~ /0x01/{print $1}'`
spamCnt=`grep -r $kisaNum ./$today/* | grep $recDate | cut -d '|' -f 10 | sort | uniq -c | tail -1 | awk '$2 ~ /0x03/{print $1}'`

if [ $hamCnt ]
then
	echo "$kisaNum $hamCnt $spamCnt" >> msg_count_$recDate.log
fi
done







