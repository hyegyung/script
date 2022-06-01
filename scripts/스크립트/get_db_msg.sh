#!/bin/bash
source /home/asfs/.bash_profile

rm -f print_trap.txt
rm -f print_mmsc.txt

startDate=$1'000000'
endDate=$2'240000'

if [ $# -lt 2 ]
then
echo "Usage : (sh) (start_date) (end_date) "
echo ""
echo "   sh get_db_msg.sh 20150707 20150713"
echo ""
exit 0
fi
query_trap=`sqlplus orastas/orastas2301@stas <<EOF
set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
spool /home/asfs/print_trap.txt
select replace(replace(msg,chr(10),' '),chr(13),' ') from TM_SFS_SPAM_DATA where SPAM_TYPE='2' and save_dt >= '${startDate}' and save_dt<= '${endDate}';
spool off
quit
EOF
`
echo "spool trap !"

#echo `sed -i '/SQL>/d' /home/asfs/print_trap.txt`

query_mmsc=`sqlplus orastas/orastas2301@stas <<EOF
set define off pagesize 0 term off feedback off ver off heading off verify off echo off trimout on trimspool on
spool /home/asfs/print_mmsc.txt
select replace(replace(msg,chr(10),' '),chr(13),' ') from TM_SFS_SPAM_DATA where SPAM_TYPE='1' and save_dt >= '${startDate}' and save_dt<= '${endDate}';
spool off
quit
EOF
`
echo "spool mmsc !"

#echo `sed -i '$d' /home/asfs/print_mmsc.txt`

echo "msg extract complete"
echo "please check files [ print_mmsc.txt / print_trap.txt ]"
echo ""

#echo `scp ./print_trap.txt asfs@211.63.6.242:/home/asfs/`
#echo `scp ./print_mmsc.txt asfs@211.63.6.242:/home/asfs/`
#rm -f print_trap.txt
#rm -f print_mmsc.txt
