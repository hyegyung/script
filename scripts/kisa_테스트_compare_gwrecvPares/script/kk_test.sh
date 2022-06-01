savePath='/home/asfs/Kwon'
logPath='/home/asfs/Kwon'

today=`date +%Y%m%d%H%M%S`
Date=`date +%Y%m%d -d '-1days'`

kisa_num_list=(01093174965 01046321221 01049033759)

echo "MDN			HAM		SPAM" >> $savePath/msg_count_$Date.log

for kisaNum in "${kisa_num_list[@]}"
do

hamCnt=`grep -r $kisaNum $logPath/$Date/* | cut -d '|' -f 10 | sort | uniq -c | head -1 | awk '$2 ~ /0x01/{print $1}'`
spamCnt=`grep -r $kisaNum $logPath/$Date/* | cut -d '|' -f 10 | sort | uniq -c | tail -1 | awk '$2 ~ /0x03/{print $1}'`

echo "$kisaNum  $hamCnt		$spamCnt" >> $savePath/msg_count_$Date.log

done
