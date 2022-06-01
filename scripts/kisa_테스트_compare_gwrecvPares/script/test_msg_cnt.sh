
today=`date +%Y%m%d`
yesterday=`date +%Y%m%d -d '-1days'`

msgResult=`grep -r 01093174965 $yesterday*.log | cut -d '|' -f 10`

#if [ -n $msgResult ]
#then
msgResult=`| sort | uniq -c | awk'{print $1}' | head -1`
echo $msgResult
#else
#	echo "There is no result (empty)"
#fi

#hamCnt=`grep -r 01093174965 $yesterday*.log | cut -d '|' -f 10 | sort | uniq -c | awk'{print $0}'| head -1`
#spamCnt=`grep -r 01093174965 $yesterday*.log | cut -d '|' -f 10 | sort | uniq -c | awk'{print $1}'| tail -1`
#echo $msgResult
### 1. read ham/spam count
### 2. if 0x01의 카운트가 30개넘으면 ham/spam 카운트 모두  log파일에 기록 ( cust_num hamCnt spamCnt )
###    ex) 01093174965 30 200


#echo "hamCnt = $hamCnt, spamCnt = $spamCnt"
#if [ $msgType = ""]
#then




