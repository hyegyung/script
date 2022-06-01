#!/bin/bash
source ~/.bash_profile

if [ $# -lt 1 ]
then
echo "<Usage> : [sh] [cust_num] "
echo ""
exit 0
fi


rm -rf ./dbResult_$today.log
rm -rf ./dbResult2_$today.log


MDN=$1
#== msg_table_name
temp_msgTab=`expr \( $1 \% 256 \) + 1`

len=$((${#temp_msgTab}))

if [ $len -lt 2 ]
then 
msgTab=00${temp_msgTab}
elif [ $len -lt 3 ]
then
msgTab=0${temp_msgTab}
else msgTab=${temp_msgTab}
fi
MSGTABLE=TM_SFS_SMS_${msgTab}

#== cust_table_name
custTab=`expr \( $1 \% 4 \) + 1`
USRTABLE=tm_sfs_cust_0${custTab}

#== blacklist/spamPattern_table_name
etcTab=`expr \( $1 \% 8 \) + 1`
SNUMTABLE=TM_SFS_USR_BLACK_LST_0${etcTab}
SPATABLE=TM_SFS_USR_SPAM_PATTERN_0${etcTab}

echo " $MSGTABLE / $USRTABLE / $SNUMTABLE / $SPATABLE"
#====
resultPath='/home/vmgw/script'
today=`date +%Y%m%d`
#==== DB 조회

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select cust_num, wifi_id from $USRTABLE where cust_num='$MDN'; 
spool off
 quit
EOF`
#==== DB 조회(2)

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off linesize 200 pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult2_$today.log
select push_key from $USRTABLE where cust_num='$MDN'; 
spool off
 quit
EOF`

#==== db확인
echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
cat dbResult_$today.log | awk '{print $2}'

wifi_id=`cat dbResult_$today.log | awk '{print $2}'`
#rm -rf ./dbResult_$today.log
#==== db확인2
echo `sed -i '$d' $resultPath/dbResult2_$today.log | sed -i '/SQL>/d' $resultPath/dbResult2_$today.log | tr -d '\r'`
push_key=`cat dbResult2_$today.log | awk '{print $1}'`
#rm -rf ./dbResult2_$today.log
#
echo ">>> $wifi_id"
echo ">>> $push_key"
echo "" > ./result_$1.log
echo "" >> ./result_$1.log
echo "########################################" > ./result_title_$1.log
echo "#      서버 요청 후 응답 확인          #" >> ./result_title_$1.log
echo "########################################" >> ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

#==== 가입자정보요청

addHeader="carrier-name:SKTelecom"

echo "" >> ./result_$1.log
echo ">>>>>>>>> (1) 가입자정보요청" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v3/getUserInfo >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
#==== 가입자정보변경 요구

echo ""
echo "" >> ./result_$1.log
echo ">>>>>>>>> (2) 가입자정보 변경요청(push 설정 ON)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
if [ -z $push_key ]; then
	push_key="test123"
fi
curl -H $addHeader -d "userID=${wifi_id}&userState=[1,1,1,1,1,1]&emailAddress=spam@hunter.com&notifySMSTime=1000&notifySMSCycle=256&referenceFilterValue=4&pushKey=${push_key}" http://127.0.0.1:9003/api/v3/setUserInfo >> ./result_$1.log
###curl -H $addHeader -d "userID=${wifi_id}&userState=[1,1,1,1,1]&emailAddress=spam@hunter.com&notifySMSTime=1000&notifySMSCycle=256&referenceFilterValue=4" http://127.0.0.1:9003/api/v3/setUserInfo >> ./result_$1.log
echo "" >> ./result_$1.log
echo ""

echo ""
echo "" >> ./result_$1.log
echo ">>>>>>>>> (2_2) 가입자정보 변경요청(push 설정 OFF)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&userState=[1,1,1,1,1,0]&emailAddress=spam@hunter.com&notifySMSTime=1000&notifySMSCycle=256&referenceFilterValue=4&pushKey=" http://127.0.0.1:9003/api/v3/setUserInfo >> ./result_$1.log
echo "" >> ./result_$1.log
echo ""

echo ""
echo "" >> ./result_$1.log
echo ">>>>>>>>> (2_3) 가입자정보 변경요청(kisa동의 OFF)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&userState=[1,1,0,1,1,1]&emailAddress=spam@hunter.com&notifySMSTime=1000&notifySMSCycle=256&referenceFilterValue=4&pushKey=" http://127.0.0.1:9003/api/v3/setUserInfo >> ./result_$1.log
echo "" >> ./result_$1.log
echo ""



#==== 가입자필터설정 정보요청

echo ""
echo "" >> ./result_$1.log
echo ">>>>>>>>> (3) 가입자필터설정 정보요청" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]" http://127.0.0.1:9003/api/v3/getUserfilter >> ./result_$1.log
echo "" >> ./result_$1.log

#==== 가입자필터링 정보 변경요청(추가)
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (4) 가입자필터 정보변경 요청(허용번호 추가)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[1, \"\", \"0101234\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (5) 가입자필터 정보변경 요청(허용패턴 추가)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[1, \"\", \"test1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (6) 가입자필터 정보변경 요청(차단번호 추가)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[1, \"\", \"15779999\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (7) 가입자필터 정보변경 요청(차단문구 추가)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[1, \"\", \"OhOh\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (8) 가입자필터 정보변경 요청(차단국번 추가)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPrefix\"]&blackPrefix=[[1, \"\", \"999\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo "" >> ./result_$1.log

#==== 가입자필터링 정보 변경요청(변경)

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select rowID, cust_num, phone_num from TM_SFS_USR_WHITE_LST  where cust_num='$MDN' and phone_num='0101234';
spool off
 quit
EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
wn_row=`cat dbResult_$today.log | awk '{print $1}'`
rm -rf ./dbResult_$today.log

sleep 1

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select rowID, cust_num, pattern from TM_SFS_USR_HAM_PATTERN  where cust_num='$MDN' and pattern='test1';
spool off
 quit
EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
wp_row=`cat dbResult_$today.log | awk '{print $1}'`
rm -rf ./dbResult_$today.log

sleep 1
query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select rowID, cust_num, PHONE_NUM from $SNUMTABLE where cust_num='$MDN' and phone_num='15779999';
spool off
 quit
EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
bn_row=`cat dbResult_$today.log | awk '{print $1}'`

rm -rf ./dbResult_$today.log

sleep 1

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select rowID, cust_num, pattern from $SPATABLE where cust_num='$MDN' and pattern='OhOh';
spool off
 quit
EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
bp_row=`cat dbResult_$today.log | awk '{print $1}'`
rm -rf ./dbResult_$today.log

sleep 1

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select rowID, cust_num, pfx from TM_SFS_USR_PFX_BLACK_LST where cust_num='$MDN' and pfx='999';
spool off
 quit
EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
bpfx_row=`cat dbResult_$today.log | awk '{print $1}'`
rm -rf ./dbResult_$today.log
echo "" >> ./result_$1.log

#==== 가입자필터링 정보 변경요청(삭제)
echo ""
echo ">>>>>>>>> (9) 가입자필터 정보변경 요청(허용번호 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[2, \"${wn_row}\", \"01012345\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (10) 가입자필터 정보변경 요청(허용패턴 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[2, \"${wp_row}\", \"test2\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (11) 가입자필터 정보변경 요청(차단번호 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[2, \"${bn_row}\", \"15778888\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
>> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (12) 가입자필터 정보변경 요청(차단문구 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[2, \"${bp_row}\", \"OhOh1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (13) 가입자필터 정보변경 요청(차단국번 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPrefix\"]&blackPrefix=[[2 , \"${bpfx_row}\", \"9991\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log

#==== Spasm 메시지 리스트 요청

echo "" >> ./result_$1.log
echo ">>>>>>>>> (14) 메시지 정보 전달 확인" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

curl -H $addHeader -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v3/getSpamMsgList >> ./result_$1.log
echo ""

echo ""
echo ""
echo "" >> ./result_$1.log


#==== Spam 메시지 복원 요청

echo "" >> ./result_$1.log
echo ">>>>>>>>> (15) 스팸으로 차단된 메시지 복원 요청(sms)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select sms_seq, cust_num, sms_clc  from $MSGTABLE where cust_num='$MDN' and sms_kind='1'  and rownum<2;
spool off
 quit
EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`

recover_date=`cat dbResult_$today.log | awk '{print $3}'`
recover_row=`cat dbResult_$today.log | awk '{print $1}'`


rm -rf ./dbResult_$today.log
curl -H $addHeader -d "userID=${wifi_id}&seqNO=${recover_row}" http://127.0.0.1:9003/api/v3/recoverySpamMsg >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log


echo "" >> ./result_$1.log
echo ">>>>>>>>> (15_2) 스팸으로 차단된 메시지 복원 요청(mms)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select sms_seq, cust_num, sms_clc  from $MSGTABLE where cust_num='$MDN' and sms_kind='4' and image_file_name is null and rownum<2;
spool off
 quit
EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`

recover_date=`cat dbResult_$today.log | awk '{print $3}'`
recover_row=`cat dbResult_$today.log | awk '{print $1}'`


rm -rf ./dbResult_$today.log
curl -H $addHeader -d "userID=${wifi_id}&seqNO=${recover_row}" http://127.0.0.1:9003/api/v3/recoverySpamMsg >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log




#==== MMS 이미지 데이터 요청

echo "" >> ./result_$1.log
########echo ">>>>>>>>> (20) 스팸으로 차단된 이미지 요청" > ./result_title_$1.log
########iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off linesize 300 pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select sms_seq,image_file_name  from $MSGTABLE where cust_num='$MDN' and image_file_name is not null;
spool off
 quit
EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`

img_file=`cat dbResult_$today.log | head -1 |  awk '{print $2}'`
img_row=`cat dbResult_$today.log | head -1 | awk '{print $1}'`


rm -rf ./dbResult_$today.log

#######curl -H $addHeader -d "userID=${wifi_id}&seqNO=${img_row}&fileName=[\"${img_file}\"]" http://127.0.0.1:9003/api/v3/getSpamMMSImgae >> ./result_$1.log
#curl -H $addHeader -d "userID=${wifi_id}&seqNO=${img_row}&fileName=[\"${img_file}\"]" http://127.0.0.1:9003/api/v3/getSpamMMSImgae >> /dev/null

echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
#==== 메시지 삭제요청
query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select sms_seq, cust_num from $MSGTABLE where cust_num='$MDN' and rownum<2;
spool off
 quit
EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`

msg_row=`cat dbResult_$today.log | awk '{print $1}'`

rm -rf ./dbResult_$today.log

echo "" >> ./result_$1.log
echo ">>>>>>>>> (16) 메시지 삭제요청" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&seqNO=${msg_row}" http://127.0.0.1:9003/api/v3/removeSpamMsg >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log

#==== 주소록 데이터 요청
echo ">>>>>>>>> (17) 주소록 데이터 요청" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v3/getAddressbook >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
#==== 주소록 업데이트 요청
echo ">>>>>>>>> (18) 주소록 업데이트 요청" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&addressbookCnt=1&addressbookList=[[1, \"\", \"000111\",1]]" http://127.0.0.1:9003/api/v3/updateAddressbook >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log

#==== 가입자 통합정보 요청
echo ">>>>>>>>> (19) 가입자 통합정보 요청" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=6&typeList=[\"whiteNUM\", \"whitePattern\",  \"blackNUM\", \"blackPattern\", \"blackPrefix\", \"prefixPool\"]" http://127.0.0.1:9003/api/v3/getUserAllInfo >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log


#==== Spam 랭킹 요청
echo ">>>>>>>>> (20) 스미싱 랭킹 요청(1일)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
beforeDay=`date +%Y%m%d -d '3day ago'`
curl -H $addHeader -d "userID=${wifi_id}&rankingTypeCnt=1&rankingRange=[\"${beforeDay}000000\",1]&rankingTypeList=[\"avdUrl\"]" http://127.0.0.1:9003/api/v3/getSpamRangking >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo ">>>>>>>>> (21) 스미싱 랭킹 요청(7일)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&rankingTypeCnt=1&rankingRange=[\"${beforeDay}000000\",7]&rankingTypeList=[\"avdUrl\"]" http://127.0.0.1:9003/api/v3/getSpamRangking >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log

#==== 공지사항 정보 요청
echo ">>>>>>>>> (22) 공지사항" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&noticeNumber=-1&noticeCnt=-1" http://127.0.0.1:9003/api/v3/getNotice >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log

#==== 간편신고_별도로 테스트2 (db에서 조회해서---외부연동이라 현재 불가능)
######echo ">>>>>>>>> (28) 간편신고" > ./result_title_$1.log
######iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
spool $resultPath/dbResult_$today.log
select sms_seq, cust_num, sms_clc  from $MSGTABLE where cust_num='$MDN' and sms_kind='1'  and rownum<2;
spool off
quit
EOF`
echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
report_date=`cat dbResult_$today.log | awk '{print $3}'`
report_row=`cat dbResult_$today.log | awk '{print $1}'`

reportData="S0lTQSBTUEFNIL3FsO0guN69w8H2IFYzLjAKMDAwMQowMDAwCjAzMjE1NjYzMTE3CjE3MDcyMTAwMTAwMAowMTAyMTAxMDAwNAoxNzA3MjMxNjE2MzMKU01TLy0KTEdNLUc2MDBTCjAwMDAKWzA2MC04MDMtNTA0NV1fwve03LmusbhfwPwgwfax3SCx17DUP7i5wMwgu/2wosDMs6q/5CEyOTC/+LmuwMctvPawxTA4MC04MDUtMDA1NVtGV10K"
######curl -H $addHeader -d "userID=${wifi_id}&reportData=${reportData}&smsType=1&smsSeq=${report_row}" http://127.0.0.1:9003/api/v3/reportSpamMsg >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log









#==== 메시지 전체 삭제 요청(스크립트로 실행 안함. 주석처리)
#####echo ">>>>>>>>>  (29) 메시지 전체 삭제 요청(테스트위해 전체삭제는 주석처리)" > ./result_title_$1.log
#####iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
######curl -H $addHeader -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v3/removeAllSpamMsg >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log



  rm -rf ./dbResult_$today.log
    rm -rf ./dbResult2_$today.log


#-----서비스로그에서 grep

echo "########################################" > ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "#	서비스로그 확인">> ./result_title_$1.log
echo "#"  >> ./result_title_$1.log
echo "#   1000 : 성공">> ./result_title_$1.log
echo "#   1510 : 보관기간 지나 복원실패">> ./result_title_$1.log
echo "#   1511 : 보관기간 지나 확인 실패">> ./result_title_$1.log
echo "#   1512 : 복원할 메시지 없음">> ./result_title_$1.log
echo "#   ">> ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "########################################">> ./result_title_$1.log
today=`date +%Y%m%d`
nowTime=`date +%H%M%S`
temp=${nowTime:0:2}:${nowTime:2:2}
cat /home/vmgw/logs/SVCE_${today}.log | grep -a "$temp" | grep -a "127.0.0.1" | grep ${wifi_id} >> ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

### convert from UTF-8 to euckr
iconv -c -f UTF-8 -t euckr result_$1.log > result_conv_$1.log
rm ./result_$1.log
rm ./result_title_$1.log
mv ./result_conv_$1.log ./result_$1.log

