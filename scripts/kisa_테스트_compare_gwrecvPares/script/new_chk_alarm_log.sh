#!/bin/bash
source /home/sfs/.bash_profile

export LANG=C
export LC_ALL=C


User='sfs'
logPath='/var/log'
savePath='/home/sfs/log/stat/alarm'
scriptPath='/home/sfs/script/CRON'
alarm_list=`cat $scriptPath/alarm_list_new.txt | tr -d '\r'`

minAgo=`date -d '1 minute ago' +'%c' | awk '{printf("%s %2s %s",$2,$3,substr($4,0,5))}'`

CURT=`date  +'%Y%m%d%H%M%S'`
CURH=`date  +'%Y%m%d%H%M'`
CURH2=${CURH:0:11}
CUR_DATE=`date  +'%Y%m%d'`
SYSTEMID="13"
code="1005"
echo -n `su -c "mkdir -p '$savePath'/'$CUR_DATE'" - $User`

while read -r line;
do 
alarmLevel=`echo $line | cut -d '|' -f 1`
buff=`echo $line | cut -d '|' -f 2`
infoStr=`echo $line | cut -d '|' -f 3`
chkalarm=`fgrep -- "$minAgo" $logPath/messages| fgrep -- "$buff"`

#debugging echo $minAgo $chkalarm $buff
if [ -n "$chkalarm" ]
then
  if [ ${CURH:11:1} -lt 5 ]
  then
   temp1="$CURT|$SYSTEMID|$code|$alarmLevel|$infoStr"
   temp2="${savePath}/${CUR_DATE}/${CURH2}0.log"
   echo -n `su -c "echo '${temp1}' >> '${temp2}'" - $User`

  else
   temp1="$CURT|$SYSTEMID|$code|$alarmLevel|$infoStr"
   temp2="${savePath}/${CUR_DATE}/${CURH2}5.log"
   echo -n `su -c "echo '${temp1}' >> '${temp2}'" - $User`
  fi
fi
done <<< "$alarm_list"
