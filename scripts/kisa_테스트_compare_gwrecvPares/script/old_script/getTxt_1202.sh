testSQL="testGetDB.sql"

echo "set linesize 300" >> testSQL
echo "set heading off" >> testSQL
echo "SPOOL "/home/asfs/spool_result.txt" >> testSQL
echo "SELECT replace(replace(msg,chr(10),' '),chr(13),' ') from TM_SFS_SPAM_DATA where SPAM_TYPE='1' and save_dt >= '20141124000000' and save_dt<= '20141130240000'" >> testSQL
echo "/" >> testSQL
ech "spool off" >> testSQL
echo "quit" >> testSQL
echo "/" >> testSQL
sqlplus orastas/orastas2301@stas \@$testSQL


