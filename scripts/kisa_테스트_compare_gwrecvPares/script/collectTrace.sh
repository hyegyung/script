#!/bin/sh

if [ $# -lt 1 ]; then
echo "�˻� ��ȣ �Է�"
exit 
fi

if [ $# -lt 2 ]; then
today=`date +%Y%m%d`
else
today=$2
fi

if [ ${#today} -ne 8 ]; then
echo "�˻� ��¥ �Է� ���� (YYYYMMDD)"
exit
fi

./logCollecter.sh $1 $today
./msgCollecter.sh $1 $today

cut -f 4 msg_$1_$today.txt > temp.txt
paste log_$1_$today.txt temp.txt > result_$1_$today.txt

#rm log_$1_$today.txt
#rm msg_$1_$today.txt
rm temp.txt

echo "���� �Ϸ�"
