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

#-----서비스로그에서 grep

echo "########################################" > ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "#	서비스로그 확인 (스팸메시지 5건이상, 이미지스팸 1건이상이면 에러코드 모두 1000 발생)">> ./result_title_$1.log
echo "#"  >> ./result_title_$1.log
echo "#   1000 : 성공">> ./result_title_$1.log
echo "#   1510 : 보관기간 지나 복원실패">> ./result_title_$1.log
echo "#   1511 : 보관기간 지나 확인 실패">> ./result_title_$1.log
echo "#   1512 : 복원할 메시지 없음">> ./result_title_$1.log
echo "#   1403 : 인증실패">> ./result_title_$1.log
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

