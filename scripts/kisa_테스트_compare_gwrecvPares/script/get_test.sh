rm -f testSQL.sql
echo "set heading off" >> testSQL.sql
echo "set linesize 300" >> testSQL.sql
echo "select replace(replace(msg,chr(10),' '),chr(13),' ') from TM_SFS_SPAM_DATA where SPAM_TYPE='2' and save_dt >= '20141130000000' and save_dt<= '20141130240000';" >> testSQL
sqlplus orastas/orastas2301@stas < testSQL.sql > test_trap.txt

rm testSQL.sql
echo "set heading off" >> testSQL.sql
echo "set linesize 300" >> testSQL.sql
echo "select replace(replace(msg,chr(10),' '),chr(13),' ') from TM_SFS_SPAM_DATA where SPAM_TYPE='1' and save_dt >= '20141130000000' and save_dt<= '20141130240000';" >> testSQL
sqlplus orastas/orastas2301@stas < testSQL.sql > test_mmsc.txt


