#!/bin/bash
source ~/.bash_profile

if [ $# -lt 1 ]
then
echo "<Usage> : [sh] [cust_num] "
echo ""
exit 0
fi

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

#echo " $MSGTABLE / $USRTABLE / $SNUMTABLE / $SPATABLE"
#exit 0
#====
resultPath='/home/vmgw/script/monitor'
today=`date +%Y%m%d`
#==== DB 조회

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select cust_num, wifi_id from $USRTABLE where cust_num='$MDN'; 
spool off
 quit
 EOF`

#==== db확인
echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
wifi_id=`cat dbResult_$today.log | awk '{print $2}'`
#rm -rf ./dbResult_$today.log


#>>>>>>>>>>> 1403 에러확인위해 wifi_id 조작
wifi_id=e28c49b8-d2b6-40ac-af5f-276b94c29e6b1801
#==== 가입자정보요청


echo "########################################" > ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "# 각 API별 JSON 응답 확인">> ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "########################################">> ./result_title_$1.log




echo "" > ./result_$1.log
echo ">>>>>>>>> (1) 가입자정보요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v2/getUserInfo >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

#==== 가입자정보변경 요구

echo ""
echo ">>>>>>>>> (2) 가입자정보 변경요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&userState=[1,1,1,1,1]&emailAddress=spam@hunter.com&notifySMSTime=1000&notifySMSCycle=256&referenceFilterValue=4" http://127.0.0.1:9003/api/v2/setUserInfo >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log


#==== 가입자필터설정 정보요청

echo ""
echo ">>>>>>>>> (3) 가입자필터설정 정보요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]" http://127.0.0.1:9003/api/v2/getUserfilter >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log

#==== 가입자필터링 정보 변경요청(추가)
echo ""
echo ">>>>>>>>> (4) 가입자필터 정보변경 요청(허용번호 추가)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[1, \"\", \"0101234\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (5) 가입자필터 정보변경 요청(허용패턴 추가)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[1, \"\", \"test1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (6) 가입자필터 정보변경 요청(차단번호 추가)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[1, \"\", \"15779999\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (7) 가입자필터 정보변경 요청(차단문구 추가)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[1, \"\", \"ShutUP\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (8) 가입자필터 정보변경 요청(차단국번 추가)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPrefix\"]&blackPrefix=[[1, \"\", \"999\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log

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
select rowID, cust_num, pattern from $SPATABLE where cust_num='$MDN' and pattern='ShutUP';
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
echo ">>>>>>>>> (9) 가입자필터 정보변경 요청(허용번호 변경)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log

curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[3, \"${wn_row}\", \"01012345\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
>> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (10) 가입자필터 정보변경 요청(허용패턴 변경)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[3, \"${wp_row}\", \"test2\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (11) 가입자필터 정보변경 요청(차단번호 변경)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[3, \"${bn_row}\", \"15778888\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
>> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (12) 가입자필터 정보변경 요청(차단문구 변경)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[3, \"${bp_row}\", \"ShutUP1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log


#==== 가입자필터링 정보 변경요청(삭제)
echo ">>>>>>>>> (13) 가입자필터 정보변경 요청(허용번호 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[2, \"${wn_row}\", \"01012345\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (14) 가입자필터 정보변경 요청(허용패턴 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[2, \"${wp_row}\", \"test2\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (15) 가입자필터 정보변경 요청(차단번호 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[2, \"${bn_row}\", \"15778888\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
>> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (16) 가입자필터 정보변경 요청(차단문구 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[2, \"${bp_row}\", \"ShutUP1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (17) 가입자필터 정보변경 요청(차단국번 삭제)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPrefix\"]&blackPrefix=[[2 , \"${bpfx_row}\", \"9991\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== Spasm 메시지 리스트 요청
echo ">>>>>>>>> (18) 메시지 정보 전달 확인" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v2/getSpamMsgList >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log


#==== Spam 메시지 복원 요청

echo ">>>>>>>>> (19) 스팸으로 차단된 메시지 복원 요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select sms_seq, cust_num from $MSGTABLE where cust_num='$MDN' and image_file_name is null and rownum<2;
spool off
 quit
 EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`

recover_row=`cat dbResult_$today.log | awk '{print $1}'`

rm -rf ./dbResult_$today.log
curl -d "userID=${wifi_id}&seqNO=${recover_row}" http://127.0.0.1:9003/api/v2/recoverySpamMsg >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log


#==== MMS 이미지 데이터 요청

echo ">>>>>>>>> (20) 스팸으로 차단된 이미지 요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off linesize 300 pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select sms_seq,image_file_name  from $MSGTABLE where cust_num='$MDN' and image_file_name is not null;
spool off
 quit
 EOF`

echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`

img_file=`cat dbResult_$today.log | awk '{print $2}'`
img_row=`cat dbResult_$today.log | awk '{print $1}'`

rm -rf ./dbResult_$today.log

curl -d "userID=${wifi_id}&seqNO=${img_row}&fileName=[\"${img_file}\"]" http://127.0.0.1:9003/api/v2/getSpamMMSImgae >> ./result_$1.log
echo "">> ./result_$1.log
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

echo ">>>>>>>>> (21) 메시지 삭제요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&seqNO=${msg_row}" http://127.0.0.1:9003/api/v2/removeSpamMsg >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== 주소록 데이터 요청
echo ">>>>>>>>> (22) 주소록 데이터 요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v2/getAddressbook >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== 주소록 업데이트 요청
echo ">>>>>>>>> (23) 주소록 업데이트 요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&addressbookCnt=1&addressbookList=[[1, \"\", \"000111\",1]]" http://127.0.0.1:9003/api/v2/updateAddressbook >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log

#==== 가입자 통합정보 요청
echo ">>>>>>>>> (24) 가입자 통합정보 요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=6&typeList=[\"whiteNUM\", \"whitePattern\",  \"blackNUM\", \"blackPattern\", \"blackPrefix\", \"prefixPool\"]" http://127.0.0.1:9003/api/v2/getUserAllInfo >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

#==== Spam 랭킹 요청
echo ">>>>>>>>> (25) 스미싱 랭킹 요청(1일)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
beforeDay=`date +%Y%m%d -d '3day ago'`
curl -d "userID=${wifi_id}&rankingTypeCnt=1&rankingRange=[\"${beforeDay}000000\",1]&rankingTypeList=[\"avdUrl\"]" http://127.0.0.1:9003/api/v2/getSpamRangking >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (26) 스미싱 랭킹 요청(7일)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&rankingTypeCnt=1&rankingRange=[\"${beforeDay}000000\",7]&rankingTypeList=[\"avdUrl\"]" http://127.0.0.1:9003/api/v2/getSpamRangking >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== 공지사항 정보 요청
echo ">>>>>>>>> (27) 공지사항" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&noticeNumber=-1&noticeCnt=-1" http://127.0.0.1:9003/api/v2/getNotice >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== 메시지 전체 삭제 요청
echo ">>>>>>>>>  (28) 메시지 전체 삭제 요청" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v2/removeAllSpamMsg >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log

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
cat /home/vmgw/logs/vmgw/SVCE_${today}.log | grep -a "$temp" | grep -a "127.0.0.1" | grep ${wifi_id} >> ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log

### convert from utf8 to euckr
iconv -c -f utf8 -t euckr result_$1.log > result_conv_$1.log
rm ./result_$1.log
rm ./result_title_$1.log
mv ./result_conv_$1.log ./result_$1.log

