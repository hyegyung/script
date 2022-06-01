#!/bin/bash

if [ $# -lt 1 ]; then
echo "검색 번호 입력"
exit 
fi

rm -rf khg_result.txt
rm -rf tmp_file1.txt
rm -rf tmp_file2.txt

today=`date +%Y%m%d`

cut -f 5 msg_$1_$today.txt > temp.txt

#paste log_$1_$today.txt temp.txt | sort -k 8 >> result_$1_$today.txt

log_buff=`cat log_$1_$today.txt`
#log_buff=`cat log_$1_$today.txt | awk -F '\t' '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"|"$11}'`
msg_buff=`cat msg_$1_$today.txt`
#echo "$log_buff"
#exit 0
echo "!!! before while"
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
#sed -i 's/ /\t/g' tmp_file1.txt
#exit 0
sed -i 's/ /\t/g' tmp_file1_1.txt

paste -d'\t' tmp_file1_1.txt tmp_file1_2.txt tmp_file2.txt > khg_result.txt

#paste -d'\t' tmp_file1.txt tmp_file2.txt > khg_result.txt

