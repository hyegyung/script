#!/bin/bash

file1=`cat merge_string_0126.txt | tr -d '\r'`
row=`cat merge_string_0126.txt | wc -l`
count=0;

file2=`cat merge_string_0126.txt | awk '{print $2"	"$1}' | tr -d '\r'`
echo "$file2" > test_0123.log

while read -a line; do buff1="${line[@]}";
echo "running...[$count/$row]"
buff2=${line[0]}
buff3=${line[1]}
sleep 1
count=$((count+1))
#result1=`cat merge_string_0126.txt | fgrep -- "$buff3\t" | awk 'BEGIN{sum=0;}{sum+=$1;}END{print $2"	"sum}'`
#result1=`cat merge_string_0126.txt | fgrep -x -- "$buff3" | awk 'BEGIN{sum=0;}{sum+=$2}END{print $1,sum}'`
#result1=`cat merge_string_0126.txt | awk '$buff3~/^$1$/{print $0}' | awk 'BEGIN{sum=0;}{sum+=$2}END{print $1,sum}'`
#result1=`cat merge_string_0126.txt | awk '$1~/$buff3/{print $2}' | awk 'BEGIN{sum=0;}{sum+=$1;}END{print sum}'`
result1=`cat merge_string_0126.txt | awk '{if($1=="'${buff3}'")print $2}' | awk 'BEGIN{sum=0;}{sum+=$1;}END{print "'${buff3}'""	"sum}'`

if [ $count -eq 10 ]
then
break
fi
echo ">>> $result1"
done <<< "$file2"

echo "$result1" >> total_0123.txt
