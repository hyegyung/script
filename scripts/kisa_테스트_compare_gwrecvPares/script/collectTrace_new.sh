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

if [ $# -lt 3 ]; then
time=300
else
time=$3
fi

if [ ${#today} -ne 8 ]; then
echo "�˻� ��¥ �Է� ���� (YYYYMMDD)"
exit
fi

echo "�α� ����...."
./src/logCollecter.sh $1 $today $time
echo "�޽��� ����...."
./src/msgCollecter.sh $1 $today $time
echo "�̹��� ����...."
./src/imgCollecter.sh $1 $today


echo "���� ����..."

echo -e "��û�ð�\tó���ð�\t�޽���Ÿ��\tMsgID\tSeqID\t�߽Ź�ȣ\t���Ź�ȣ\tȸ�Ź�ȣ\tó�����\t����ڵ�\t���ܻ���\t�޽���" > result_$1_$today.txt
cut -f 5 msg_$1_$today.txt > temp.txt
paste log_$1_$today.txt temp.txt | sort -k 8 >> result_$1_$today.txt

echo "���� �Ϸ�"

echo "��� ����..."
echo ""
./src/reasonCode.sh result_$1_$today.txt

echo "����"


#rm log_$1_$today.txt
#rm msg_$1_$today.txt
rm temp.txt
