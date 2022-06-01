#!/bin/bash

savePath='/home/asfs/Kwon'
logPath='/home/asfs/Kwon'

today=`date +%Y%m%d%`
Date=`date +%Y%m%d -d '-1days'`
pad=000000
searchDate=$1


result=`cat $logPath/20150125.log | sort | uniq -c`
while read -a line; 
do echo "${line[1]}" >>$savePath/count_$Date.log
done <<< "$result"


exit 0

rm -f tmp_$Date.log
rm -f count_$Date.log
echo "Sentence	|	Date" >> $savePath/count_$Date.log

rm -f testSQL.sql
echo "set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on" >> testSQL.sql
echo "spool $savePath/tmp_$Date.log" >> testSQL.sql


#for spamString in `cat $logPath/$Date.log`
for spamString in `cat $logPath/20150125.log`
do

query="select string, count(*) from sfs_spam_string where string='$spamString' and save_dt <= '$searchDate$pad' group by string;"
echo "$query">> testSQL.sql

done



echo "spool off" >> testSQL.sql
echo "quit" >> testSQL.sql

sqlplus oraasfs/oraasfs2301@asfs < testSQL.sql >> $savePath/tmp_$Date.log


echo `sed -i '$d' $savePath/tmp_$Date.log`
result=`cat $savePath/tmp_$Date.log | sed '/SQL>/d' | awk '{print $1}' | sort | uniq -c`

while read -a line; do echo "${line[1]}		${line[0]}"; done <<< "$result" >>$savePath/count_$Date.log


