#!/bin/bash

today=`date +%Y%m%d`

log_buff=`cat log_$1_$today.txt`
msg_buff=`cat msg_$1_$today.txt`

while read -a line;
do
	logline="${line[@]}"
	msgId="${line[4]}"

	chk=`cat msg_$1_$today.txt | grep "${msgId}" | awk -F '\t' '{print $5}' `
if [ -n "${chk}" ]
then 
 echo "${logline}" >> tmp_file1.txt
 echo "${chk}" >> tmp_file2.txt
else 
 echo "${logline}" >> tmp_file1.txt
 echo "" >> tmp_file2.txt
fi
done <<< "$log_buff"

cat tmp_file1.txt | cut -d ' ' -f 1-10 > tmp_file1_1.txt
cat tmp_file1.txt | cut -d ' ' -f 11-200 > tmp_file1_2.txt
sed -i 's/ /\t/g' tmp_file1_1.txt

echo -e "요청시간\t처리시간\t메시지타입\tMsgID\tSeqID\t발신번호\t착신번호\t회신번호\t처리결과\t결과코드\t차단사유\t메시지" > mapping_result_$1_$today.txt

paste -d'\t' tmp_file1_1.txt tmp_file1_2.txt tmp_file2.txt >> mapping_result_$1_$today.txt

rm tmp_file1.txt
rm tmp_file1_1.txt
rm tmp_file1_2.txt
rm tmp_file2.txt
