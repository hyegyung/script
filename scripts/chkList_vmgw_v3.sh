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
#==== DB ��ȸ

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select cust_num, wifi_id from $USRTABLE where cust_num='$MDN'; 
spool off
 quit
EOF`
#==== DB ��ȸ(2)

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off linesize 200 pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult2_$today.log
select push_key from $USRTABLE where cust_num='$MDN'; 
spool off
 quit
EOF`

#==== dbȮ��
echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
cat dbResult_$today.log | awk '{print $2}'

wifi_id=`cat dbResult_$today.log | awk '{print $2}'`
#rm -rf ./dbResult_$today.log
#==== dbȮ��2
echo `sed -i '$d' $resultPath/dbResult2_$today.log | sed -i '/SQL>/d' $resultPath/dbResult2_$today.log | tr -d '\r'`
push_key=`cat dbResult2_$today.log | awk '{print $1}'`
#rm -rf ./dbResult2_$today.log
#
echo ">>> $wifi_id"
echo ">>> $push_key"
echo "" > ./result_$1.log
echo "" >> ./result_$1.log
echo "########################################" > ./result_title_$1.log
echo "#      ���� ��û �� ���� Ȯ��          #" >> ./result_title_$1.log
echo "########################################" >> ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

#==== ������������û

addHeader="carrier-name:SKTelecom"

echo "" >> ./result_$1.log
echo ">>>>>>>>> (1) ������������û" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v3/getUserInfo >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
#==== �������������� �䱸

echo ""
echo "" >> ./result_$1.log
echo ">>>>>>>>> (2) ���������� �����û(push ���� ON)" > ./result_title_$1.log
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
echo ">>>>>>>>> (2_2) ���������� �����û(push ���� OFF)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&userState=[1,1,1,1,1,0]&emailAddress=spam@hunter.com&notifySMSTime=1000&notifySMSCycle=256&referenceFilterValue=4&pushKey=" http://127.0.0.1:9003/api/v3/setUserInfo >> ./result_$1.log
echo "" >> ./result_$1.log
echo ""

echo ""
echo "" >> ./result_$1.log
echo ">>>>>>>>> (2_3) ���������� �����û(kisa���� OFF)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&userState=[1,1,0,1,1,1]&emailAddress=spam@hunter.com&notifySMSTime=1000&notifySMSCycle=256&referenceFilterValue=4&pushKey=" http://127.0.0.1:9003/api/v3/setUserInfo >> ./result_$1.log
echo "" >> ./result_$1.log
echo ""



#==== ���������ͼ��� ������û

echo ""
echo "" >> ./result_$1.log
echo ">>>>>>>>> (3) ���������ͼ��� ������û" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]" http://127.0.0.1:9003/api/v3/getUserfilter >> ./result_$1.log
echo "" >> ./result_$1.log

#==== ���������͸� ���� �����û(�߰�)
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (4) ���������� �������� ��û(����ȣ �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[1, \"\", \"0101234\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (5) ���������� �������� ��û(������� �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[1, \"\", \"test1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (6) ���������� �������� ��û(���ܹ�ȣ �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[1, \"\", \"15779999\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (7) ���������� �������� ��û(���ܹ��� �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[1, \"\", \"OhOh\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (8) ���������� �������� ��û(���ܱ��� �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPrefix\"]&blackPrefix=[[1, \"\", \"999\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo "" >> ./result_$1.log

#==== ���������͸� ���� �����û(����)

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

#==== ���������͸� ���� �����û(����)
echo ""
echo ">>>>>>>>> (9) ���������� �������� ��û(����ȣ ����)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[2, \"${wn_row}\", \"01012345\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (10) ���������� �������� ��û(������� ����)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[2, \"${wp_row}\", \"test2\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (11) ���������� �������� ��û(���ܹ�ȣ ����)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[2, \"${bn_row}\", \"15778888\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
>> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (12) ���������� �������� ��û(���ܹ��� ����)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[2, \"${bp_row}\", \"OhOh1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
echo ">>>>>>>>> (13) ���������� �������� ��û(���ܱ��� ����)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPrefix\"]&blackPrefix=[[2 , \"${bpfx_row}\", \"9991\", \"\", \"\"]]" http://127.0.0.1:9003/api/v3/setUserfilter >> ./result_$1.log
echo ""
echo "" >> ./result_$1.log

#==== Spasm �޽��� ����Ʈ ��û

echo "" >> ./result_$1.log
echo ">>>>>>>>> (14) �޽��� ���� ���� Ȯ��" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log

curl -H $addHeader -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v3/getSpamMsgList >> ./result_$1.log
echo ""

echo ""
echo ""
echo "" >> ./result_$1.log


#==== Spam �޽��� ���� ��û

echo "" >> ./result_$1.log
echo ">>>>>>>>> (15) �������� ���ܵ� �޽��� ���� ��û(sms)" > ./result_title_$1.log
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
echo ">>>>>>>>> (15_2) �������� ���ܵ� �޽��� ���� ��û(mms)" > ./result_title_$1.log
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




#==== MMS �̹��� ������ ��û

echo "" >> ./result_$1.log
########echo ">>>>>>>>> (20) �������� ���ܵ� �̹��� ��û" > ./result_title_$1.log
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
#==== �޽��� ������û
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
echo ">>>>>>>>> (16) �޽��� ������û" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&seqNO=${msg_row}" http://127.0.0.1:9003/api/v3/removeSpamMsg >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log

#==== �ּҷ� ������ ��û
echo ">>>>>>>>> (17) �ּҷ� ������ ��û" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v3/getAddressbook >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log
#==== �ּҷ� ������Ʈ ��û
echo ">>>>>>>>> (18) �ּҷ� ������Ʈ ��û" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&addressbookCnt=1&addressbookList=[[1, \"\", \"000111\",1]]" http://127.0.0.1:9003/api/v3/updateAddressbook >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log

#==== ������ �������� ��û
echo ">>>>>>>>> (19) ������ �������� ��û" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&typeCnt=6&typeList=[\"whiteNUM\", \"whitePattern\",  \"blackNUM\", \"blackPattern\", \"blackPrefix\", \"prefixPool\"]" http://127.0.0.1:9003/api/v3/getUserAllInfo >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log


#==== Spam ��ŷ ��û
echo ">>>>>>>>> (20) ���̽� ��ŷ ��û(1��)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
beforeDay=`date +%Y%m%d -d '3day ago'`
curl -H $addHeader -d "userID=${wifi_id}&rankingTypeCnt=1&rankingRange=[\"${beforeDay}000000\",1]&rankingTypeList=[\"avdUrl\"]" http://127.0.0.1:9003/api/v3/getSpamRangking >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo ">>>>>>>>> (21) ���̽� ��ŷ ��û(7��)" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&rankingTypeCnt=1&rankingRange=[\"${beforeDay}000000\",7]&rankingTypeList=[\"avdUrl\"]" http://127.0.0.1:9003/api/v3/getSpamRangking >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log
echo "" >> ./result_$1.log

#==== �������� ���� ��û
echo ">>>>>>>>> (22) ��������" > ./result_title_$1.log
iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
curl -H $addHeader -d "userID=${wifi_id}&noticeNumber=-1&noticeCnt=-1" http://127.0.0.1:9003/api/v3/getNotice >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log

#==== ����Ű�_������ �׽�Ʈ2 (db���� ��ȸ�ؼ�---�ܺο����̶� ���� �Ұ���)
######echo ">>>>>>>>> (28) ����Ű�" > ./result_title_$1.log
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









#==== �޽��� ��ü ���� ��û(��ũ��Ʈ�� ���� ����. �ּ�ó��)
#####echo ">>>>>>>>>  (29) �޽��� ��ü ���� ��û(�׽�Ʈ���� ��ü������ �ּ�ó��)" > ./result_title_$1.log
#####iconv -c -f euckr -t UTF-8 result_title_$1.log >> ./result_$1.log
######curl -H $addHeader -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v3/removeAllSpamMsg >> ./result_$1.log
echo ""
echo ""
echo ""
echo "" >> ./result_$1.log



  rm -rf ./dbResult_$today.log
    rm -rf ./dbResult2_$today.log


#-----���񽺷α׿��� grep

echo "########################################" > ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "#	���񽺷α� Ȯ��">> ./result_title_$1.log
echo "#"  >> ./result_title_$1.log
echo "#   1000 : ����">> ./result_title_$1.log
echo "#   1510 : �����Ⱓ ���� ��������">> ./result_title_$1.log
echo "#   1511 : �����Ⱓ ���� Ȯ�� ����">> ./result_title_$1.log
echo "#   1512 : ������ �޽��� ����">> ./result_title_$1.log
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

