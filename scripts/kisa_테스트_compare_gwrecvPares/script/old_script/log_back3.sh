#!/usr/local/bin/expect -f


HOST1="211.63.6.184"
HOST2="211.63.6.184"

USER="root"
PW="05ghcjfl"
DIR_PATH="~/khg_repo/bak_test_1123/*201411231911*" 
DIR_BAK="/home/asfs/Kwon"
PW_BAK="pltasfs10"
MDN="1911"


#for count in #1 2 3 4 5 6 7 8 9 10 11
spawn -noecho ssh $USER@$HOST1 
expect "root@i$HOST1's password:"
send "05ghcjfl\n"
interact

spawn cat $DIR_PATH | grep $MDN > $DIR_PATH/$HOSTNAME.log
	scp ./$HOSTNAME.log asfs@211.63.6.242:$DIR_BAK/
spawn -noecho ssh $USER@$HOST1 
expect "password:"
send "05ghcjfl\n"
interact

#	$PW_BAK 







