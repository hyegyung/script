#!/bin/sh

if [ $# -lt 1 ]; then
echo "Input File name"
exit
fi

cut -f 10 $1 | sort | uniq -c | sort -r > .reason.txt

sed 's/0x12/악성앱 URL/g' .reason.txt | 
sed 's/0x13/금융권 허용 번호/g' | 
sed 's/0x14/금융권 허용 문구/g' | 
sed 's/0x15/사용자 허용 번호/g' | 
sed 's/0x16/사용자 허용 주소록/g' | 
sed 's/0x17/사용자 차단 번호/g' | 
sed 's/0x18/사용자 차단 국번/g' | 
sed 's/0x31/고객 허용 문구/g' | 
sed 's/0x32/고객 차단 문구/g' | 
sed 's/0x33/운영자 허용 번호/g' | 
sed 's/0x34/운영자 허용 문구/g' | 
sed 's/0x35/운영자 차단 번호/g' | 
sed 's/0x36/운영자 차단 문구/g' | 
sed 's/0x37/운영자 차단 Callback URL/g' | 
sed 's/0x38/운영자 차단 URL/g' | 
sed 's/0x39/운영자 차단 URL + 번호/g' | 
sed 's/0x3a/운영자 차단 URL + 문구/g' | 
sed 's/0x3b/동적 필터링 미설정/g' | 
sed 's/0x3c/운영자 차단 문자열/g' | 
sed 's/0x3d/운영자 차단 문장/g' | 
sed 's/0x45/동적필터링 HAM/g' | 
sed 's/0x46/동적 필터링 SPAM/g' | 
sed 's/0x48/이미지 필터링 SPAM(FS)/g' | 
sed 's/0x52/이미지 필터링 SPAM(IS)/g' | 
sed '/결과코드/d'

rm .reason.txt
