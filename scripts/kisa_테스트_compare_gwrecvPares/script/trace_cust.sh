if [ $# -lt 2 ]
then
echo "Usage : trace_onoff.sh [cust_num] [0 or 1]"
echo "        2nd parameter is for trace On or OFF"
echo "ex : trace_onoff.sh 01088776502 1"
exit 0
fi

tab_no=`expr \( $1 \% 4 \) + 1`
tab_name=TM_SFS_CUST_0$tab_no

echo "update $tab_name set TRACE_FLAG='$2' where CUST_NUM='$1';" > testSQL.sql 
sqlplus oraasfs/oraasfs2301@asfs < testSQL.sql
rm testSQL.sql

