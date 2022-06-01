#include <iostream>
using namespace std;

#include <stdio.h>
#include <time.h>
#define OTL_ORA11G_R2
#include <otlv4.h>

#define MAXBUF 10000
#define COL_NUM 4

otl_connect exa_db;
char* RTrim(char *s){
   char t[512];
   char *end;
   strcpy(t, s);
   end = t + strlen(t) - 1;
  while ((end != t) && ((*end)==' '))
      end--;
   *(end + 1) = '\0';
   s = t;
   return s;
}

int filesize(FILE *stream);
int insertSpamString(char *option, char *filename){
	
	FILE *fp;
	char buff[MAXBUF];
	char *tempbuff1=NULL;
        char *tempbuff2=NULL;	
	int fsize;
	int i, div;
	char msg_kind[2];
	char msg[200];
	char recv_dt[15];
	char save_dt[15];
	char tmp[MAXBUF];
	char query[] = "INSERT INTO SFS_MSG_LIST(MSG_KIND, MSG, RECV_DT, SAVE_DT) VALUES(:f1<char[2]>,:f2<char[201]>,:f3<char[15]>,:f4<char[15]>)";
	int count=0;
	int idx;
	struct tm *today;
	char timeNow[15];
	time_t ltime;
	time(&ltime);
	today  = localtime(&ltime);

	sprintf(timeNow,"%4d%.2d%.2d%.2d%.2d%.2d",(today->tm_year+1900)
                                        ,today->tm_mon+1
                                        ,today->tm_mday
                                        ,today->tm_hour
                                        ,today->tm_min
                                        ,today->tm_sec);
	//exit(1);

	fp = fopen(filename,"rt");

	fsize = filesize(fp);
        for (i = 0; i < fsize; i++){
                buff[i] = fgetc(fp);
		if('\n'==buff[i]){
		count++;
		}
        }

	i=0;
	div=0;
	idx=0;
	strcpy(tmp,buff);
	tempbuff1=&tmp[0];

	
	otl_stream o(1, query, exa_db);
	

	if((tempbuff1=strtok(tempbuff1,"\n"))==NULL){
                printf("strtok error\n");
                exit(1);
        }
        else{
		strcpy(&msg_kind[0],option);
		strcpy(&msg[0],tempbuff1);
		strcpy(&recv_dt[0],timeNow);
		strcpy(&save_dt[0],timeNow);
	o << msg_kind <<  msg << recv_dt << save_dt;

		i++;
		while(i<count){
			tempbuff2=strtok(NULL,"\n");
			strcpy(&msg_kind[0],option);
			strcpy(&msg[0],tempbuff2);
			strcpy(&recv_dt[0],timeNow);
			strcpy(&save_dt[0],timeNow);
		o << msg_kind <<  msg << recv_dt << save_dt;
		i++;
		}
	}
}
int selectSpamString(char *option, char *startDate, char *endDate)
{
	char save_dt1[15];
	char save_dt2[15];


	char query1[110]="SELECT ";
	char query2[]=" from SFS_MSG_LIST where SAVE_DT >=:f1<char[15]> and SAVE_DT <=:f2<char[15]>";

	char subQ[50];
	char title[20];
	sprintf(save_dt1, "%s000000", startDate);
	sprintf(save_dt2, "%s240000", endDate);


	if(!strcmp(option,"a")){
	strcpy(title,"MSG_KIND | MSG | RECV_DT | SAVE_DT");
	strcpy(&subQ[0],"*");
	}
	else if(!strcmp(option,"k")){
	strcpy(title,"MSG_KIND | MSG");
	strcpy(&subQ[0],"MSG_KIND, MSG");
	}
	else if(!strcmp(option,"d")){
	strcpy(title,"MSG_KIND | MSG | SAVE_DT");
	strcpy(&subQ[0],"MSG_KIND, MSG, SAVE_DT");
	}
	else{
	printf("\n [!] check Usage!! \n");
	exit(1);
	}
	strcat(query1,subQ);
	strcat(query1,query2);
	
	otl_stream i(1,	query1, exa_db );

	i << save_dt1 << save_dt2;

	char msg_kind[2];
	char msg[200];
	char sdate[15];
	char rdate[15];

	printf("\n\n%s\n",&title[0]);
	while(!i.eof()){ // while not end-of-data

		if(!strcmp(option,"a")){
		i >> msg_kind >> msg >> rdate >> sdate;
		printf("\n%s	%s	%s	%s\n", msg_kind, msg, rdate, sdate);
		}
		else if(!strcmp(option,"k")){
		i >> msg_kind >> msg;
		printf("\n%s	%s\n", msg_kind, msg);
		}
		else if(!strcmp(option,"d")){
		i >> msg_kind >> msg >> sdate;
		printf("\n%s	%s	%s\n", msg_kind, msg, sdate);
		}
		
	}
	return 0;
}

int main(int argc, char* argv[])
{
	int i;
	FILE *fp1;
	char* end;
	char inp[2];
	long val;

	otl_connect::otl_initialize(); // initialize the database API environment
	try{
		exa_db.rlogon("oraasfs/oraasfs2301@asfs"); // connect to the database

		if(3==argc){
			strcpy(&inp[0],argv[1]);
			if((inp[0]>='0') && (inp[0]<='9')){
				if ((fp1 = fopen(argv[2], "r")) == NULL){	
					printf("\n [!] msg file doesn't exist \n\n");
					exit(0);
				}
				else{
					insertSpamString(argv[1],argv[2]);
				}
			}
			else{
				printf("\n [!] check msg type !!\n");
	                        printf("\n\n Insert Mode : [exe] [option] [file_name]\n");
        	                printf(" (ex) kisa_msg_mgr 1 msg1.txt\n");
        	                printf(" (option) \n	1 : Kisa test spam \n	2 : Kisa test HAM \n	3 : BIZ\n	4 : ��ü���� �߼���Ȳ\n	5 : �������� \n\n=============\n");
                                exit(0);
			}
		}
		else if(4==argc){
			if((strlen(argv[2])!=8) || (strlen(argv[3])!=8)){
				printf("\n [!] check date size !!\n");
				exit(0);
			}
			else {
				for(i=0;i<2;i++){
				      val = strtol(argv[i+2], &end, 10);
				      if (end[0] && val >= 0){
                                        printf("\n [!] date is number !!\n");
                                        exit(0);
      					}
				}		
				
                             selectSpamString(argv[1],argv[2],argv[3]); 

			}	
				
					
		}
		else{
			printf("\n=============\n< Usage >");
			printf("\n Select Mode : [exe] [option ][start_date] [end_date]\n");
			printf(" (ex) kisa_msg_mgr a 20150101 20150130\n");
			printf(" (option) \n	a (all): select * from sfs_msg_list;\n	k (kind): select msg_kind, msg from sfs_msg_list;\n	d (date): select msg_kind, msg, save_dt from sfs_msg_list;");
			printf("\n\n Insert Mode : [exe] [option] [file_name]\n");
			printf(" (ex) kisa_msg_mgr 1 msg1.txt\n");
			printf(" (option) \n	1 : Kisa test spam \n	2 : Kisa test HAM \n	3 : BIZ\n	4 : ��ü���� �߼���Ȳ\n	5 : �������� \n\n=============\n");
			exit(0);
		}

	}
	catch(otl_exception& p){ // intercept OTL exceptions
		cerr<<p.msg<<endl; // print out error message
		cerr<<p.stm_text<<endl; // print out SQL that caused the error
		cerr<<p.var_info<<endl; // print out the variable that caused the error
	}
	
	exa_db.logoff(); 
	//printf("End\n");
	return 0;
}
int filesize(FILE *stream){

        long curpos, length;

        curpos = ftell(stream);
        fseek(stream, 0L, SEEK_END);
        length = ftell(stream);
        fseek(stream, curpos, SEEK_SET);

        return (int)length;
}

