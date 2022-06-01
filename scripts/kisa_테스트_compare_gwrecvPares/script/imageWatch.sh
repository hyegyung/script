#!/bin/sh

regexTime=`date +%H%M -d '10 min ago'`
regexTime="${regexTime:0:3}[0-9]\{3\}.[0-9]\{3\}"
echo "$regexTime"
exit 0
today=`date +%Y%m%d -d '10 min ago'`
time=`date +%H%M -d '10 min ago'`


scriptPath="/home/sfs/script/imageCollect"
scriptlogPath="$scriptPath/logs/"

trlogPath="/home/sfs/log/stat/sfs/$today/"
trlogfile=$today$time; trlogfile=${trlogfile:0:11}

filterlogPath=/home/sfs/log/sfs/filter5/"*$today*"
filterDate=`date +%Y%m%d -d '10 min ago'`
filterTime=`date +%H:%M -d '10 min ago'`; filterTime="${filterTime:0:4}"
filterDate=$filterDate"-"$filterTime

imgSaveTime=`date +%Y%m%d_%H -d '10 min ago'`
imgSavePath="$scriptPath/SpamImages/$imgSaveTime/"

sendtime=`date +%M`
movetime=`date +%H%M`
dirname=`date +%Y%m%d -d '1 day ago'`

echo "[`date +%Y%m%d-%H:%M:%S`] START OF SCRIPT "

#------------------------------------------------------------------------------------------------
# transaction log Parse
# �ð�|�߽Ź�|���Ź�|ȸ�Ź�|�޽���ID
#------------------------------------------------------------------------------------------------
echo "[`date +%Y%m%d-%H:%M:%S`] ���� ���� �α� ���� ����"
grep "^$regexTime" $trlogPath$trlogfile* | grep 0x48 | cut -d '|' -f 2,6,7,8,9,16 | 
		sed 's/�̹��� SPAM-//g' | sed 's/-.*-.*/|/g' > $scriptPath/.temp_imglist.txt

#------------------------------------------------------------------------------------------------
# filter5 log Parse
# �ñ״���|���ڵ�Ű|NAS���
#------------------------------------------------------------------------------------------------
echo "[`date +%Y%m%d-%H:%M:%S`] NAS ��� �α� ���� ����"
grep -H "^\[$filterDate" $filterlogPath > $scriptPath/.temp_filter.log
line=`wc -l $scriptPath/.temp_imglist.txt | cut -d " " -f 1`

echo -n "" > $scriptPath/.temp_alldata.txt

while [ $line -gt 0 ]; do

	str=`cat $scriptPath/.temp_imglist.txt | tail -n $line | head -n 1`
	msgid=`echo $str | cut -d '|' -f 5`; sign=`echo $str | cut -d '|' -f 6`
	nasPath=`grep $msgid $scriptPath/.temp_filter.log | 
				 grep -v $sign | awk -F ':' '{ print $14 "|" $15 }'`
	nasPath=`echo $nasPath | sed 's/\].*//g'`

	echo $str $nasPath | sed 's/ //g' | sed 's/]//g' | sed 's/|$//g' >> $scriptPath/.temp_alldata.txt
	let line=$line-1; usleep 100000; # sleep 0.1sec 

done

cat $scriptPath/.temp_alldata.txt >> $scriptlogPath/$today.log

#------------------------------------------------------------------------------------------------
# Copy Images
# �ñ״���|�޽���ID|���ڵ�Ű|NAS���
# cp NAS��� ������/�ñ״���/���ϸ�-���ڵ�Ű
#------------------------------------------------------------------------------------------------
echo "[`date +%Y%m%d-%H:%M:%S`] �̹��� ���� ����"
line=`wc -l $scriptPath/.temp_alldata.txt | cut -d " " -f 1`
#echo line total : $line

while [ $line -gt 0 ]; do

	str=`cat $scriptPath/.temp_alldata.txt | tail -n $line | head -n 1 | sed 's/;/ /g'`
	out=`echo $str | awk -F '|' '{ print $6 " -" $7 " "  $8 }'`; info=($out)

	mkdir -p $imgSavePath/${info[0]}

	for (( i=2 ; i < ${#info[@]}; i++)); do
		if [ ${#info[1]} -gt 2 ]; then # decode key �� ���� �� �� 
			cp ${info[$i]} $imgSavePath/${info[0]}/`basename ${info[$i]}`${info[1]}
		else
			cp ${info[$i]} $imgSavePath/${info[0]}/
		fi
		usleep 100000 # sleep 0.1 sec
	done

	let line=$line-1;

done

#------------------------------------------------------------------------------------------------
# Decode Images
#------------------------------------------------------------------------------------------------
echo "[`date +%Y%m%d-%H:%M:%S`] �̹��� ���ڵ� ����"
find $imgSavePath -type f > $scriptPath/.temp_imgpath.txt

line=`wc -l $scriptPath/.temp_imgpath.txt | cut -d " " -f 1`
#echo line total : $line

while [ $line -gt 0 ]; do

	str=`cat $scriptPath/.temp_imgpath.txt | tail -n $line | head -n 1`
	out=`echo $str | awk -F '-' '{ print $0 " " $1 " " $2 }'`; arg=($out)
	
	if [ ${arg[2]} ]; then
#		echo "$scriptPath/aescrypt2 1 ${arg[0]} ${arg[1]} ${arg[2]}"
		$scriptPath/aescrypt2 1 ${arg[0]} ${arg[1]} ${arg[2]}
		if [ -f ${arg[1]} ]; then
			rm -f  ${arg[0]}
		fi
	fi

	let line=$line-1; usleep 100000; # sleep 0.1sec 

done

#------------------------------------------------------------------------------------------------
# Send Image To EMS Server (�Ž� 5�� ����)
#------------------------------------------------------------------------------------------------
tarname=$imgSaveTime"_"$HOSTNAME.tar.gz

if [ $sendtime = "05" ]; then
	echo -n "[`date +%Y%m%d-%H:%M:%S`] ���� ���� �� ���� $tarname "
	if [ -d $scriptPath/SpamImages/$imgSaveTime ]; then
		echo " - OK"
		cd $scriptPath/SpamImages/
		tar zcf $scriptPath/$tarname $imgSaveTime
		scp $scriptPath/$tarname ems@150.31.22.109:/data/ems/spamImages
		rm $scriptPath/$tarname
	else
	echo " - ����� ���� �̹����� ����"
	fi
fi
#------------------------------------------------------------------------------------------------
# Move Directory
#------------------------------------------------------------------------------------------------
if [ $movetime = "0005" ]; then
	echo "[`date +%Y%m%d-%H:%M:%S`] ���丮 ���� $scriptPath/SpamImages/$dirname"
	mkdir -p $scriptPath/SpamImages/$dirname
	mv $scriptPath/SpamImages/"$dirname"_* $scriptPath/SpamImages/$dirname
fi
#------------------------------------------------------------------------------------------------
# Decode Trace Image
#------------------------------------------------------------------------------------------------
echo "[`date +%Y%m%d-%H:%M:%S`] TRACE Image Decoding ����"
sh /home/sfs/script/imageCollect/autoDecode.sh 

#------------------------------------------------------------------------------------------------
# delete temp files
#------------------------------------------------------------------------------------------------
rm $scriptPath/.temp_imglist.txt
#rm $scriptPath/.temp_alldata.txt
#rm $scriptPath/.temp_imgpath.txt
rm $scriptPath/.temp_filter.log


echo "[`date +%Y%m%d-%H:%M:%S`] END OF SCRIPT "
#------------------------------------------------------------------------------------------------
# END of Script
#------------------------------------------------------------------------------------------------
