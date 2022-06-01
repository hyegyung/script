#!/bin/bash

if [ $# -lt 1 ]; then
echo "검색 번호 입력"
exit 
fi

rm -r before_result.txt
today=20150429

cut -f 5 msg_$1_$today.txt > temp.txt

#paste log_$1_$today.txt temp.txt | sort -k 8 >> result_$1_$today.txt

log_buff=`cat log_$1_$today.txt`
msg_buff=`cat msg_$1_$today.txt`
buff=`cat temp.txt`
#chk=`cat temp.txt | grep "${line[1]}" | head -4`
#echo "${chk}"
count=0;
echo "!!! before while"
	while read -a line;
	do
	count=$((count+1))
	logline="${line[@]}"
	msgId="${line[4]}"

chk=`cat msg_$1_$today.txt | grep "${msgId}" | awk '{print $5}' `
if [ -n "${chk}" ]
then echo "${logline}	${chk}" >> before_result.txt
else echo "${logline}" >> before_result.txt
fi
done <<< "$log_buff"


echo "`cat before_result.txt | awk -F '[ ]' '{ print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10,$11 }' | head -10`"
