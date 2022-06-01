#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <strings.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <signal.h>
#include <pthread.h>

#define MSG_LIST_NUM 	43053
#define MAXBUF 6000000
#define PRINT_LIST_NUM 10000
#define LEN_MSG 1000


int main(int argc, char *argv[]){

	FILE *fp, *fp_out;
	int fsize;
	int i=0,j=0;
	char msg_path[15];
	char buff[LEN_MSG],buff2[LEN_MSG];
	//char buff[MAXBUF], buff2[MAXBUF];

	char *tempbuff1=NULL;
	char *tempbuff2=NULL;
	char *tempbuff3=NULL;
	char *LastPtr=NULL;
	char spam_chk[10]; //0 : HAM, 1 : SPAM
	unsigned char msg_content[LEN_MSG];
	char *temp_path;
	char ch;

	//temp_path=getenv("MSG_CHK_PATH");
	//snprintf(msg_path,MSG_LIST_NUM,"%s/%s",temp_path,"20141001_10.txt");


	fp=fopen("/root/khg_repo/20141001_10.txt","rt");
	//fp_out=fopen("/root/khg_repo/result.txt","wt");

	fsize=0;


	while(((fgets(buff,LEN_MSG,fp))!=NULL)){//&&(i<PRINT_LIST_NUM)){	
		strcpy(buff2,buff);
		
		if(tempbuff1=strstr(buff2,"[HAM")){
			strcpy(spam_chk, "HAM  ");
			//fprintf(fp_out,"HAM  ");
		}	
		else if(tempbuff1=strstr(buff2,"[SPAM")){
			strcpy(spam_chk, "SPAM ");
			//fprintf(fp_out,"SPAM ");
		}

		if((tempbuff2=strstr(tempbuff1,"]["))==NULL){
			printf("strstr error\n");
			exit(1);
		}
		//sprintf(msg_content,"%s",tempbuff2);		
		strcpy(msg_content, tempbuff2);
		for(j=LEN_MSG-2;j>1;j--){
			if(msg_content[j]==']'){
				msg_content[j]='\0';
				j=0;
			}
		}

		printf("%s  %s\n",&spam_chk[0],&msg_content[2]);
		//fprintf(fp_out,"%s \n", &msg_content[1]);
		memset(msg_content,0x00,sizeof(msg_content));


		
	}
	fcloseall();
	//	fclose(fp_out);
	return 0;

}


