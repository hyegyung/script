#!/bin/bash
touch /tmp/checkPKG.log
tail -f  /tmp/checkPKG.log | while read LOGLINE

#| awk ' /SUCCESS/ {print "\033[32m" $0 "\033[39m"} /FAIL/ {print "\033[31m" $0 "\033[39m"} /date/ {print "\033[32m" $0 "\033[39m"}' | while read LOGLINE
do
echo $LOGLINE | sed ''/SUCCESS/s//$(printf "\033[32mSUCCESS\033[0m")/'' | sed ''/FAIL/s//$(printf "\033[1;31mFAIL\033[0m")/''
[[ "${LOGLINE}" == *"RESULT"* ]] && pkill -P $$ tail
done
