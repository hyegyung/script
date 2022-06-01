#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <iostream>
#include <algorithm>
#define OTL_ORA11G_R2
#include <otlv4.h>
#include <time.h>
#include <sys/time.h>

#define MSG_LEN 2001
#define LIST_NUM_D 4000
#define PATH_NUM 70



#define STRLEN(a)	((int)strlen(a?a:""))


otl_connect exa_db;

typedef struct CHARARRAY_ST {
	unsigned char spchar[3];
	unsigned char lowerchar[3];
}chararray_st;

typedef struct mafs_in_parameter_t_
{
	char msg[MSG_LEN+1];
	int  org_len;
}mafs_in_parameter_t;


static const chararray_st chararray1[] = {
	{"ⓐ","a"}, {"ⓑ","b"}, {"ⓒ","c"},
	{"ⓓ","d"}, {"ⓔ","e"}, {"ⓕ","f"},
	{"ⓖ","g"}, {"ⓗ","h"}, {"ⓘ","i"},
	{"ⓙ","j"}, {"ⓚ","k"}, {"ⓛ","l"},
	{"ⓜ","m"}, {"ⓝ","n"}, {"ⓞ","o"},
	{"ⓟ","p"}, {"ⓠ","q"}, {"ⓡ","r"},
	{"ⓢ","s"}, {"ⓣ","t"}, {"ⓤ","u"},
	{"ⓥ","v"}, {"ⓦ","w"}, {"ⓧ","x"},
	{"ⓨ","y"}, {"ⓩ","z"}, {"①","1"},
	{"②","2"}, {"③","3"}, {"④","4"},
	{"⑤","5"}, {"⑥","6"}, {"⑦","7"},
	{"⑧","8"}, {"⑨","9"}
};
static const chararray_st chararray2[] = {
	{"⒜","a"}, {"⒝","b"}, {"⒞","c"},
	{"⒟","d"}, {"⒠","e"}, {"⒡","f"},
	{"⒢","g"}, {"⒣","h"}, {"⒤","i"},
	{"⒥","j"}, {"⒦","k"}, {"⒧","l"},
	{"⒨","m"}, {"⒩","n"}, {"⒪","o"},
	{"⒫","p"}, {"⒬","q"}, {"⒭","r"},
	{"⒮","s"}, {"⒯","t"}, {"⒰","u"},
	{"⒱","v"}, {"⒲","w"}, {"⒳","x"},
	{"⒴","y"}, {"⒵","z"}, {"⑴","1"},
	{"⑵","2"}, {"⑶","3"}, {"⑷","4"},
	{"⑸","5"}, {"⑹","6"}, {"⑺","7"},
	{"⑻","8"}, {"⑼","9"}
};
static const chararray_st chararray3[] = {
	{"A","a"}, {"B","b"}, {"C","c"},
	{"D","d"}, {"E","e"}, {"F","f"},
	{"G","g"}, {"H","h"}, {"I","i"},
	{"J","j"}, {"K","k"}, {"L","l"},
	{"M","m"}, {"N","n"}, {"O","o"},
	{"P","p"}, {"Q","q"}, {"R","r"},
	{"S","s"}, {"T","t"}, {"U","u"},
	{"V","v"}, {"W","w"}, {"X","x"},
	{"Y","y"}, {"Z","z"}
};

int replaceString(unsigned char *s, const unsigned char *olds, const unsigned char *news) 
{
	int s_len, i, count = 0;
	int oldlen = STRLEN((char*)olds); if (oldlen < 1) return 0;
	int newlen = STRLEN((char*)news);

	if (newlen != oldlen) {
		for (i = 0; s[i] != '\0';) {
			if (memcmp(&s[i], olds, oldlen) == 0) count++, i += oldlen;
			else i++;
		}
	} else i = STRLEN((char*)s);

	s_len = i;

	unsigned char result[i+1];
	int result_len = 0;

	memset(result, 0x00, sizeof(result));

	while(*s) 
	{
		if (memcmp(s, olds, oldlen) == 0) 
		{
			memcpy(&result[result_len], news, newlen);
			result_len += newlen;
			s += oldlen;
			i -= oldlen;
		} 
		else 
		{
			memcpy(&result[result_len], s, 1);
			result_len++;
			s++;
			i--;
		}
	}
	
	s -= s_len;
	sprintf((char*)s, "%s", (char*)result);

	return 1;
}



int chk_spchar(unsigned char *in, unsigned char *out)
{


	int chararray1_flag=0, chararray2_flag=0, chararray3_flag=0;
	int len = STRLEN((char*)in);
	int in_len = 0;
	int j=0, i=0;
	unsigned int k=0;
	int findspcnt=0;
	unsigned char sc, sc2;
	unsigned char spchar[1024][3];
	unsigned char ori_str[1024];

	memset(spchar, 0x00, sizeof(spchar));
	memset(ori_str, 0x00, sizeof(ori_str));

	in_len = len;
	strncpy((char*)ori_str, (char*)in, len);

	while(len)
	{
		sc = *in++;
		if(!sc) break;

		if(sc & 0x80)
		{
			if(sc == 0xA8)
			{
				sc2 = *in++;
				if(!sc2) break;

				if(sc2 >= 0xCD && sc2 <= 0xEF) /* ⓐ~⑨ */
				{
					spchar[i][0] = sc;
					spchar[i][1] = sc2;
					findspcnt++;
					i++;
					chararray1_flag++;
				}
			}
			else if(sc == 0xA9)
			{
				sc2 = *in++;
				if(!sc2) break;

				if(sc2 >= 0xCD && sc2 <= 0xF5) /* ⒜~⒂ */
				{
					spchar[i][0] = sc;
					spchar[i][1] = sc2;
					findspcnt++;
					i++;
					chararray2_flag++;
				}
			}
			else in++;

			len--;len--;
		}
		else
		{
			if(sc >= 0x41 && sc <= 0x5A) /* A~Z */
			{
				spchar[i][0] = sc;
				findspcnt++;
				i++;
				chararray3_flag++;
			}
			len--;
		}
	}

	for(j=0,i=0; j<findspcnt; j++,i++)
	{
		for(k=0; k<sizeof(chararray1)/sizeof(chararray1[0]); k++)
		{
			if(chararray1_flag)
			{
				if(!strncmp((char*)chararray1[k].spchar, (char*)spchar[i], STRLEN((char*)spchar[i])))
				{
					replaceString(ori_str, chararray1[k].spchar, chararray1[k].lowerchar);
					chararray1_flag--;
				}
			}
			if(chararray2_flag)
			{
				if(!strncmp((char*)chararray2[k].spchar, (char*)spchar[i], STRLEN((char*)spchar[i])))
				{
					replaceString(ori_str, chararray2[k].spchar, chararray2[k].lowerchar);
					chararray2_flag--;
				}
			}
			if(chararray3_flag)
			{
				if(!strncmp((char*)chararray3[k].spchar, (char*)spchar[i], STRLEN((char*)spchar[i])))
				{
					replaceString(ori_str, chararray3[k].spchar, chararray3[k].lowerchar);
					chararray3_flag--;
				}
			}
		}
	}

	in -= in_len;

	sprintf((char*)out, "%s", (char*)ori_str);

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

char* generateMsgId(int num, char* date1){ 	//ID 포멧 : YYYYMMDD[0001 ~ 9999 순서대로]

	char *msgID;
	char *tempRand;
	char timeNow[8];
	time_t ltime;
	struct tm *today;
	char *tempStr;
	char *tempStr2;
	char *tempStr3;
	
	tempStr = (char*)calloc(10, sizeof(char*));
	tempStr2 = (char*)calloc(8,sizeof(char*));
	tempStr3 = (char*)calloc(6,sizeof(char*));
	msgID = (char*) malloc (sizeof(char) * 14 );
	tempRand = (char*) malloc (sizeof(char) * 4 );

	time(&ltime);
	today = localtime(&ltime);
	
	strncpy(tempStr3,&date1[strlen(date1)-10],6);
	sprintf(timeNow, "%s%.2d",&tempStr3[0],(today->tm_hour));
	srand(time(NULL));
	struct timeval tv;
	gettimeofday(&tv,NULL);	
	
	sprintf(tempStr,"%.4d%.4d",(int)tv.tv_usec,num);
	strncpy(tempStr2,&tempStr[strlen(tempStr)-6],6);
	
	sprintf(msgID, "%s%s",&timeNow[0],&tempStr2[0]);

	free(tempRand);
        free(tempStr);
        free(tempStr2);

	return &msgID[0];

}

int selectList(int num, mafs_in_parameter_t insertList)
//int selectList(char *query, struct LIST *list)
{
        char result[257];
	int tmpRtn = 0;
	char query[2200];
	char query1[] = "SELECT substr(MSG,1,10) FROM MAFS_CUR_LIST WHERE MSG='";
	char query2[] = "' AND ORG_LEN='";
	char query3[] = "' AND USED='1'";
	sprintf(query,"%s%s%s%d%s",query1,insertList.msg,query2,insertList.org_len,query3);
        otl_stream i(1, query, exa_db);
        while(!i.eof()){
                i >> result;
		
		if(strlen(result)){
			tmpRtn = 2;	
		}
        }

     return tmpRtn;
}


int main(int argc, char* argv[])
{

	FILE *fp1, *fp2, *fp3;  //, *fpw1, *fpw2;
	otl_connect::otl_initialize(); // initialize the database API environment

	try{
		exa_db.rlogon("oraasfs/oraasfs2301@asfs"); // connect to the database

		if(6==argc){
			if ((fp1 = fopen(argv[1], "r")) == NULL){
				printf("\n [!] input file does not exist \n\n");
				exit(0);
			}
		}else{
			printf("\n <Usage> : [exe] [file1] 1 [date] [RMK] [current path]\n\n");
			exit(0);
		}		
		fp1 = fopen(argv[1],"r");

		char Path[PATH_NUM];
		char Path2[PATH_NUM];
		snprintf(Path,PATH_NUM,"%s/insert_list.txt",argv[5]);
		snprintf(Path2,PATH_NUM,"%s/complete_insert_list.txt",argv[5]);
		
		fp2 = fopen(Path,"w");
		fp3 = fopen(Path2,"w");
		
		//fp2 = fopen("/home/vmgw/temp/mafs_test/insert_list.txt","w");
		//fp3 = fopen("/home/vmgw/temp/mafs_test/complete_insert_list.txt","w");
		
	
		int LIST_NUM=LIST_NUM_D;
		int fsize;
		int line_count=0;
		fsize = filesize(fp1);

		//-- allocate
		//unsigned char **in_str = (unsigned char *)aa[MSG_LEN];
		//unsigned char **in_str = (unsigned char *)aa[];
		unsigned char ** in_str = (unsigned char**) calloc (MSG_LEN, sizeof(unsigned char*));
		
		int i;
		for(i=0; i<MSG_LEN; i++){
			in_str[i] = (unsigned char*) calloc (LIST_NUM, sizeof(unsigned char*));
		}

		int idx = 0;
		int idx2 = 0;
		for (i=0;i<fsize;i++){
			in_str[idx][idx2] = fgetc(fp1);
			idx2++;
			if('\n'==in_str[idx][idx2-1])
			{       
				in_str[idx][idx2-1] = '\0';
				idx++;
				idx2 = 0;
			}
			
		}
		line_count=idx;

		mafs_in_parameter_t mafs_in_parameter[line_count];
		mafs_in_parameter_t db_str[line_count]; //--20170404 oracle quot escape for select query
		
		memset(&mafs_in_parameter, 0x00, sizeof(mafs_in_parameter_t)*line_count);
		memset(&db_str, 0x00, sizeof(mafs_in_parameter_t)*line_count);

		int* isExist;
		isExist = (int *) calloc (line_count,sizeof(int));
		
		char db_msg[2000];
		int db_org_len = 0;
		char db_used[1];
		char db_stat_dt[12];
		char db_msg_id[16];
		char db_rmk[128];


		memset(db_msg,0,sizeof(char)*2000);
		memset(db_used,0,sizeof(char)*1);
		memset(db_stat_dt,0,sizeof(char)*12);
		memset(db_msg_id,0,sizeof(char)*16);
		memset(db_rmk,0,sizeof(char)*128);


		strcpy(&db_used[0],argv[2]);
		strcpy(&db_stat_dt[0],argv[3]);
		strcpy(&db_rmk[0],argv[4]);


		

		char query[] = "INSERT INTO MAFS_CUR_LIST(MSG, ORG_LEN, USED, STAT_DT, MSGID, RMK) VALUES(:f1<char[2001]>,:f2<INT>,:f3<char[2]>,:f4<char[13]>, :f5<char[17]>, :f6<char[129]>)";
		
		otl_stream o(1, query, exa_db); //-->50이 커밋전에 최대 변경숫자인가?
		//otl_stream o(50, query, exa_db);

		char* buffMsgID = (char*) malloc (sizeof(char) * 16 );

		char* dateStr = (char*) malloc (sizeof(char) * 6);	
		strcpy(&dateStr[0],argv[3]);
			
		int str_len;
		int h=0;
		int n=0;
		//-- 메시지 정제
		for(h=0;h<line_count;h++){

			/* 메시지 길이 */
			//str_len[h] = strlen((char*)(&in_str[h][0]));
			str_len = strlen((char*)(&in_str[h][0]));
			mafs_in_parameter[h].org_len = str_len;

			/*  메시지 정제 */
			std::string str = (const char*)in_str[h];
			/* 숫자 삭제 */
			str.erase(std::remove_if(str.begin(), str.end(), (int(*)(int))isdigit), str.end());
			/* 알파벳 삭제 */
			str.erase(std::remove_if(str.begin(), str.end(), (int(*)(int))isalpha), str.end());
			/* 공백 삭제 */
			str.erase(std::remove_if(str.begin(), str.end(), (int(*)(int))isspace), str.end());

			memcpy(&mafs_in_parameter[h].msg, str.c_str(), str.size());
			//memcpy(&mafs_in_parameter.msg, str.c_str(), str.size());

			//--20170405 escape quotes for select query
			db_str[h].org_len = str_len;
				
			/* 결과 확인(출력) */
			//std::cout << "ORI::" << &in_str[h][0] << std::endl;
			//std::cout << "CVT::" << mafs_in_parameter[h].msg << std::endl;
			//std::cout << "LEN::" << mafs_in_parameter[h].org_len << std::endl;


			//fprintf(fp2,"%s\t%d\n",mafs_in_parameter[h].msg,mafs_in_parameter[h].org_len);
		}

			
		//--중복제거(msg와 org_len의 pair가 동일한 메시지는 db에 insert하지 않는다)
		h=0;
		n=0;
		for(h=0;h<line_count;h++){
			for(n=0;n<line_count;n++){

				if(h == n)continue;
				

				if( (0==strcmp(mafs_in_parameter[h].msg,mafs_in_parameter[n].msg)) 
						&& (mafs_in_parameter[h].org_len == mafs_in_parameter[n].org_len) ){
					if(h > n)isExist[h] = 1; //제거할 중복항목 체크(중복항목)
					else isExist[n] = 1;
					break;
				}
			}
		}

		//--등록시도한 메시지 리스트 출력
		h=0;
		for(h=0;h<line_count;h++){
			if(0 != isExist[h])continue; //중복항목 skip
			fprintf(fp2,"%s\t%d\n",&in_str[h][0],mafs_in_parameter[h].org_len);	//원본 메시지 출력
			//fprintf(fp2,"%s\t%d\n",mafs_in_parameter[h].msg,mafs_in_parameter[h].org_len); //정제된 메시지 출력

		}

		/* 단일인용구 들어간 경우*/
		//escape ' 이거 있는지 보고하나더 추가

		h=0;
		n=0;
		int n2=0;
		for(h=0;h<line_count;h++){
			//if(0 != isExist[h])continue; //중복항목 skip
			while(n<2001){
				db_str[h].msg[n2] = mafs_in_parameter[h].msg[n];
				if('\''== db_str[h].msg[n2])
				{
					n2++;
					db_str[h].msg[n2] = '\'';
				}
				else if('\0'== db_str[h].msg[n2])
				{
					break;
				}
				n2++;
				n++;
				
			}
			n=0;
			n2=0;
			
		}
		printf("\n>>> 메시지 pool %d 건 입력시도중...\n\n",line_count); 
		
		/* db에서 select하여 결과가 있는 경우 중복처리  */
		h=0;
                for(h=0;h<line_count;h++){
			if(0 != isExist[h])continue; //중복항목 skip
			isExist[h] = selectList(h,db_str[h]); //db에 이미 있는 값이면 중복처리
		}
		
		//--등록시도한 메시지 리스트 출력
		int tempCount1=0;
		h=0;
		for(h=0;h<line_count;h++){
			if(isExist[h]>1)tempCount1++;
		}
		printf(" [!] DB에 이미 등록된 건수: %d \n",tempCount1);

		int uniqCnt = 0;
		
		h=0;
		for(h=0;h<line_count;h++){
			if(0 != isExist[h])continue; //중복항목 skip
			uniqCnt++;
			
		
			buffMsgID = (char *)generateMsgId(uniqCnt, dateStr);
			strcpy(&db_msg[0],mafs_in_parameter[h].msg);
			strcpy(&db_msg_id[0],buffMsgID);
			db_org_len = mafs_in_parameter[h].org_len;
		//	printf("[%d]%s\n",h,db_str[h].msg);
			o << db_msg << db_org_len << db_used << db_stat_dt << db_msg_id << db_rmk;
			//	printf(" <%d> %s\t%d\n",uniqCnt,&db_msg[0],db_org_len);
			fprintf(fp3,"%s\t%d\n",&db_msg[0],db_org_len);//--등록된 메시지
		}


		
//	fpw1 = fopen("/home/vmgw/temp/mafs_test/insert_list.txt","r");		
//	fpw2 = fopen("/home/vmgw/temp/mafs_test/complete_insert_list.txt","r");
	
	//-- memory free
	for(i=0; i<MSG_LEN; i++){
		//for(i=0; i<LIST_NUM; i++){
		free(in_str[i]);
	}
	free(in_str);
	free(buffMsgID);//-msgID
	free(dateStr);//-date
	free(isExist);



	}//try
	catch(otl_exception& p){ // intercept OTL exceptions
		std::cerr<<p.msg<<std::endl; // print out error message
		std::cerr<<p.stm_text<<std::endl; // print out SQL that caused the error
		std::cerr<<p.var_info<<std::endl; // print out the variable that caused the error
	}

	exa_db.logoff();

	fcloseall();

	return 0;
}

