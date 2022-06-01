#!/bin/bash
today=`date +%Y%m%d`
recDate=`date +%Y%m%d -d '-1days'`
path=/home/asfs/Kwon/script/$today*/test
kisa_num=(01093174965 01071474451)
hamCnt=`grep -r "test" $path/*`

#	hamCnt=`grep -r "test" $path/$today*/*`
echo "HERE !! ===> $hamCnt"







