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


#----- <1��° /�� 6ȸ> 10�ʸ��� 5ȸ �� �������а� �߻� (60�� ���� �� 30�� �߻�)
sleep 10

echo "" >> ./result_$1.log
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

#----- <2��° /�� 6ȸ> 10�ʸ��� 5ȸ �� �������а� �߻� (60�� ���� �� 30�� �߻�)
sleep 10

echo "" >> ./result_$1.log
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


#----- <3��° /�� 6ȸ> 10�ʸ��� 5ȸ �� �������а� �߻� (60�� ���� �� 30�� �߻�)
sleep 10

echo "" >> ./result_$1.log
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


#----- <4��° /�� 6ȸ> 10�ʸ��� 5ȸ �� �������а� �߻� (60�� ���� �� 30�� �߻�)
sleep 10

echo "" >> ./result_$1.log
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

#----- <5��° /�� 6ȸ> 10�ʸ��� 5ȸ �� �������а� �߻� (60�� ���� �� 30�� �߻�)
sleep 10 

echo "" >> ./result_$1.log
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


#----- <6��° /�� 6ȸ> 10�ʸ��� 5ȸ �� �������а� �߻� (60�� ���� �� 30�� �߻�)



#-----���񽺷α׿��� grep

echo "########################################" > ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "#	���񽺷α� Ȯ�� (���Ը޽��� 5���̻�, �̹������� 1���̻��̸� �����ڵ� ��� 1000 �߻�)">> ./result_title_$1.log
echo "#"  >> ./result_title_$1.log
echo "#   1000 : ����">> ./result_title_$1.log
echo "#   1510 : �����Ⱓ ���� ��������">> ./result_title_$1.log
echo "#   1511 : �����Ⱓ ���� Ȯ�� ����">> ./result_title_$1.log
echo "#   1512 : ������ �޽��� ����">> ./result_title_$1.log
echo "#   1403 : ��������">> ./result_title_$1.log
echo "#   ">> ./result_title_$1.log
echo "#">> ./result_title_$1.log
echo "########################################">> ./result_title_$1.log
today=`date +%Y%m%d`
nowTime=`date +%H%M%S`
temp=${nowTime:0:2}:${nowTime:2:2}
cat /home/vmgw/logs/vmgw/SVCE_${today}.log | grep -a "$temp" | grep -a "127.0.0.1" | grep ${wifi_id} >> ./result_title_$1.log

temp2=`expr ${nowTime:3:1} + 1`
after1min=${nowTime:0:2}:${nowTime:2:1}${temp2}
cat /home/vmgw/logs/vmgw/SVCE_${today}.log | grep -a "$after1min" | grep -a "127.0.0.1" | grep ${wifi_id} >> ./result_title_$1.log
iconv -c -f euckr -t utf8 result_title_$1.log >> ./result_$1.log

### convert from utf8 to euckr
iconv -c -f utf8 -t euckr result_$1.log > result_conv_$1.log
rm ./result_$1.log
rm ./result_title_$1.log
mv ./result_conv_$1.log ./result_$1.log

