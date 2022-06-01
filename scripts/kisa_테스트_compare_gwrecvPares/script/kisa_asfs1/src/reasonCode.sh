#!/bin/sh

if [ $# -lt 1 ]; then
echo "Input File name"
exit
fi

cut -f 10 $1 | sort | uniq -c | sort -r > .reason.txt

sed 's/0x12/�Ǽ��� URL/g' .reason.txt | 
sed 's/0x13/������ ��� ��ȣ/g' | 
sed 's/0x14/������ ��� ����/g' | 
sed 's/0x15/����� ��� ��ȣ/g' | 
sed 's/0x16/����� ��� �ּҷ�/g' | 
sed 's/0x17/����� ���� ��ȣ/g' | 
sed 's/0x18/����� ���� ����/g' | 
sed 's/0x31/�� ��� ����/g' | 
sed 's/0x32/�� ���� ����/g' | 
sed 's/0x33/��� ��� ��ȣ/g' | 
sed 's/0x34/��� ��� ����/g' | 
sed 's/0x35/��� ���� ��ȣ/g' | 
sed 's/0x36/��� ���� ����/g' | 
sed 's/0x37/��� ���� Callback URL/g' | 
sed 's/0x38/��� ���� URL/g' | 
sed 's/0x39/��� ���� URL + ��ȣ/g' | 
sed 's/0x3a/��� ���� URL + ����/g' | 
sed 's/0x3b/���� ���͸� �̼���/g' | 
sed 's/0x3c/��� ���� ���ڿ�/g' | 
sed 's/0x3d/��� ���� ����/g' | 
sed 's/0x45/�������͸� HAM/g' | 
sed 's/0x46/���� ���͸� SPAM/g' | 
sed 's/0x48/�̹��� ���͸� SPAM(FS)/g' | 
sed 's/0x52/�̹��� ���͸� SPAM(IS)/g' | 
sed '/����ڵ�/d'

rm .reason.txt
