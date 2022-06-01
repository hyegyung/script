
today=`date +%Y%m%d`
recDate=`date +%Y%m%d -d '-1days'`

for kisaNum in 01093174965 01071474451
do
hamCnt=`grep -r $kisaNum ./$today/* | grep $recDate | cut -d '|' -f 10 | sort | uniq -c | awk '{print $1}' | head -1`
spamCnt=`grep -r $kisaNum ./$today/* | grep $recDate | cut -d '|' -f 10 | sort | uniq -c | awk '{print $1}'| tail -1`

if [ $hamCnt ]
then
	echo "$kisaNum $hamCnt $spamCnt" >> msg_count_$recDate.log
fi
done







