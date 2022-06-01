#!/bin/sh

function prnUsage {
    echo "Usage: sh /home/sfs/script/getdelimg.sh MMDD"
    exit;
}

if test $# -lt 1
then
    prnUsage
fi


 
awk '{if(substr($3, 0, 2)=="00" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="01" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="02" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="03" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="04" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="05" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="06" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="07" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="08" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="09" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="10" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="11" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="12" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="13" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="14" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="15" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="16" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="17" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="18" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="19" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="20" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="21" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="22" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
awk '{if(substr($3, 0, 2)=="23" && $10==2 && $15==200) print $15}' /home/eif/log/eifKisaImage/kisaimage_$1.log | wc -l
