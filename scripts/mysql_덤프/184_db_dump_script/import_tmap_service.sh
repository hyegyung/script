
# 입력된 인수가 부족하면 usage를 출력하고 종료함.
if [ $# -lt 4 ]
then
echo "Usage : import_tmap_service.sh [id] [pw] [DB] [PATH]"
echo "ex : import_tmap_service.sh 1234 5678 mysql_test /log/"
exit 0
fi




# 일괄적으로 dump 파일 작성
for table_nm in TMAP_MAP_DOWN_QI_FROM_BUILD_VERSION TMAP_MAP_DOWN_QI_FROM_MOBILE        TMAP_MAP_DOWN_QI_FROM_OS_NAME       TMAP_MAP_DOWN_QI_FROM_OS_VERSION    TMAP_MAP_DOWN_QI_FROM_TMAP_VERSION  TMAP_MAP_DOWN_QI_FROM_TOTAL         TMAP_QI_FROM_BUILD_VERSION          TMAP_QI_FROM_MOBILE                 TMAP_QI_FROM_OS_NAME                TMAP_QI_FROM_OS_VERSION             TMAP_QI_FROM_TMAP_VERSION           TMAP_QI_FROM_TOTAL                  TMAP_SAFE_QI_FROM_BUILD_VERSION     TMAP_SAFE_QI_FROM_MOBILE            TMAP_SAFE_QI_FROM_OS_NAME           TMAP_SAFE_QI_FROM_OS_VERSION        TMAP_SAFE_QI_FROM_TMAP_VERSION      TMAP_SAFE_QI_FROM_TOTAL    
do
mysql -u$1 -p$2 $3  < ./$4$table_nm.sql
done




