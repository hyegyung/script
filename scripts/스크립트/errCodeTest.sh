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
#==== DB ��ȸ

query=`sqlplus oraasfs/oraasfs2301@asfs << EOF
 set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
 spool $resultPath/dbResult_$today.log
select cust_num, wifi_id from $USRTABLE where cust_num='$MDN'; 
spool off
 quit
 EOF`

#==== dbȮ��
echo `sed -i '$d' $resultPath/dbResult_$today.log | sed -i '/SQL>/d' $resultPath/dbResult_$today.log | tr -d '\r'`
wifi_id=`cat dbResult_$today.log | awk '{print $2}'`
#rm -rf ./dbResult_$today.log


#>>>>>>>>>>> 1403 ����Ȯ������ wifi_id ����
wifi_id=e28c49b8-d2b6-40ac-af5f-276b94c29e6b1801
#==== ������������û


echo "########################################" > ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "# �� API�� JSON ���� Ȯ��">> ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "########################################">> ./result_title_$1.log




echo "" > ./result_$1.log
echo ">>>>>>>>> (1) ������������û" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v2/getUserInfo >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

#==== �������������� �䱸

echo ""
echo ">>>>>>>>> (2) ���������� �����û" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&userState=[1,1,1,1,1]&emailAddress=spam@hunter.com&notifySMSTime=1000&notifySMSCycle=256&referenceFilterValue=4" http://127.0.0.1:9003/api/v2/setUserInfo >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log


#==== ���������ͼ��� ������û

echo ""
echo ">>>>>>>>> (3) ���������ͼ��� ������û" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]" http://127.0.0.1:9003/api/v2/getUserfilter >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log

#==== ���������͸� ���� �����û(�߰�)
echo ""
echo ">>>>>>>>> (4) ���������� �������� ��û(����ȣ �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[1, \"\", \"0101234\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (5) ���������� �������� ��û(������� �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[1, \"\", \"test1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (6) ���������� �������� ��û(���ܹ�ȣ �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[1, \"\", \"15779999\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (7) ���������� �������� ��û(���ܹ��� �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[1, \"\", \"ShutUP\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (8) ���������� �������� ��û(���ܱ��� �߰�)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPrefix\"]&blackPrefix=[[1, \"\", \"999\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log

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
echo ">>>>>>>>> (9) ���������� �������� ��û(����ȣ ����)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log

curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[3, \"${wn_row}\", \"01012345\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
>> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (10) ���������� �������� ��û(������� ����)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[3, \"${wp_row}\", \"test2\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (11) ���������� �������� ��û(���ܹ�ȣ ����)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[3, \"${bn_row}\", \"15778888\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
>> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (12) ���������� �������� ��û(���ܹ��� ����)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[3, \"${bp_row}\", \"ShutUP1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log


#==== ���������͸� ���� �����û(����)
echo ">>>>>>>>> (13) ���������� �������� ��û(����ȣ ����)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whiteNUM\"]&whiteNUM=[[2, \"${wn_row}\", \"01012345\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (14) ���������� �������� ��û(������� ����)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"whitePattern\"]&whitePattern=[[2, \"${wp_row}\", \"test2\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (15) ���������� �������� ��û(���ܹ�ȣ ����)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackNUM\"]&blackNUM=[[2, \"${bn_row}\", \"15778888\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
>> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (16) ���������� �������� ��û(���ܹ��� ����)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPattern\"]&blackPattern=[[2, \"${bp_row}\", \"ShutUP1\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (17) ���������� �������� ��û(���ܱ��� ����)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=1&typeList=[\"blackPrefix\"]&blackPrefix=[[2 , \"${bpfx_row}\", \"9991\", \"\", \"\"]]" http://127.0.0.1:9003/api/v2/setUserfilter >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== Spasm �޽��� ����Ʈ ��û
echo ">>>>>>>>> (18) �޽��� ���� ���� Ȯ��" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v2/getSpamMsgList >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log


#==== Spam �޽��� ���� ��û

echo ">>>>>>>>> (19) �������� ���ܵ� �޽��� ���� ��û" > ./result_title_$1.log
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


#==== MMS �̹��� ������ ��û

echo ">>>>>>>>> (20) �������� ���ܵ� �̹��� ��û" > ./result_title_$1.log
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

echo ">>>>>>>>> (21) �޽��� ������û" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&seqNO=${msg_row}" http://127.0.0.1:9003/api/v2/removeSpamMsg >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== �ּҷ� ������ ��û
echo ">>>>>>>>> (22) �ּҷ� ������ ��û" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v2/getAddressbook >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== �ּҷ� ������Ʈ ��û
echo ">>>>>>>>> (23) �ּҷ� ������Ʈ ��û" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&addressbookCnt=1&addressbookList=[[1, \"\", \"000111\",1]]" http://127.0.0.1:9003/api/v2/updateAddressbook >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log

#==== ������ �������� ��û
echo ">>>>>>>>> (24) ������ �������� ��û" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&typeCnt=6&typeList=[\"whiteNUM\", \"whitePattern\",  \"blackNUM\", \"blackPattern\", \"blackPrefix\", \"prefixPool\"]" http://127.0.0.1:9003/api/v2/getUserAllInfo >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

#==== Spam ��ŷ ��û
echo ">>>>>>>>> (25) ���̽� ��ŷ ��û(1��)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
beforeDay=`date +%Y%m%d -d '3day ago'`
curl -d "userID=${wifi_id}&rankingTypeCnt=1&rankingRange=[\"${beforeDay}000000\",1]&rankingTypeList=[\"avdUrl\"]" http://127.0.0.1:9003/api/v2/getSpamRangking >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log

echo ">>>>>>>>> (26) ���̽� ��ŷ ��û(7��)" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&rankingTypeCnt=1&rankingRange=[\"${beforeDay}000000\",7]&rankingTypeList=[\"avdUrl\"]" http://127.0.0.1:9003/api/v2/getSpamRangking >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== �������� ���� ��û
echo ">>>>>>>>> (27) ��������" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}&noticeNumber=-1&noticeCnt=-1" http://127.0.0.1:9003/api/v2/getNotice >> ./result_$1.log
echo "">> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log
echo "">> ./result_$1.log

#==== �޽��� ��ü ���� ��û
echo ">>>>>>>>>  (28) �޽��� ��ü ���� ��û" > ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log
curl -d "userID=${wifi_id}" http://127.0.0.1:9003/api/v2/removeAllSpamMsg >> ./result_$1.log
echo "" >> ./result_$1.log
echo "">> ./result_$1.log

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
cat /home/vmgw/logs/vmgw/SVCE_${today}.log | grep -a "$temp" | grep -a "127.0.0.1" | grep ${wifi_id} >> ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log

### convert from utf8 to euckr
iconv -c -f utf8 -t euckr result_$1.log > result_conv_$1.log
rm ./result_$1.log
rm ./result_title_$1.log
mv ./result_conv_$1.log ./result_$1.log

