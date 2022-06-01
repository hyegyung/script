#include <iostream>
using namespace std;

#define OTL_ORA11G_R2
#include <otlv4.h>

#include "main.h"
#include "jkfunc.h"
#include "urlparser.h"

int gfd;

char ginput_urlfile[128];
char ginput_stringfile[128];
char ginput_sentencefile[128];

char gwhite_urlfile[128];
char gwhite_stringfile[128];
char gwhite_sentencefile[128];

char gOracle_login[128];
char gJavaurl_ip[16];
int gJavaurl_port;

otl_connect exa_db;

int load_config()
{
	FILE *pfd;
	char config_file[1024];
	char buf[1024];
	char *pbuf;
	char *ptr;

	memset(config_file, 0x00, sizeof(config_file));
	memset(buf, 0x00, sizeof(buf));

	snprintf(config_file, sizeof(config_file), "%s", "conf/insertAdminFilter.conf");

	pfd = fopen(config_file, "r");
	if(pfd == 0 || pfd == NULL) return -1;

	while((pbuf = fgets(buf, sizeof(buf), pfd)) != NULL)
	{
		if(feof(pfd))	break;
		if(!strncmp(pbuf, "#", 1))
		{
			memset( buf, 0x00, sizeof(buf));
			continue;
		}

		else if(!strncmp(pbuf, "input_urlfile", 13))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				ptr = ptr+1;
				whole_trim(ptr, "\t\n ");
				memset(ginput_urlfile, 0x00, sizeof(ginput_urlfile));
				strncpy(ginput_urlfile, ptr, strlen(ptr));
			}
		}

		else if(!strncmp(pbuf, "input_stringfile", 16))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				ptr = ptr+1;
				whole_trim(ptr, "\t\n ");
				memset(ginput_stringfile, 0x00, sizeof(ginput_stringfile));
				strncpy(ginput_stringfile, ptr, strlen(ptr));
			}
		}

		else if(!strncmp(pbuf, "input_sentencefile", 18))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				ptr = ptr+1;
				whole_trim(ptr, "\t\n ");
				memset(ginput_sentencefile, 0x00, sizeof(ginput_sentencefile));
				strncpy(ginput_sentencefile, ptr, strlen(ptr));
			}
		}

		else if(!strncmp(pbuf, "white_urlfile", 13))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				ptr = ptr+1;
				whole_trim(ptr, "\t\n ");
				memset(gwhite_urlfile, 0x00, sizeof(gwhite_urlfile));
				strncpy(gwhite_urlfile, ptr, strlen(ptr));
			}
		}

		else if(!strncmp(pbuf, "white_stringfile", 16))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				ptr = ptr+1;
				whole_trim(ptr, "\t\n ");
				memset(gwhite_stringfile, 0x00, sizeof(gwhite_stringfile));
				strncpy(gwhite_stringfile, ptr, strlen(ptr));
			}
		}

		else if(!strncmp(pbuf, "white_sentencefile", 18))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				ptr = ptr+1;
				whole_trim(ptr, "\t\n ");
				memset(gwhite_sentencefile, 0x00, sizeof(gwhite_sentencefile));
				strncpy(gwhite_sentencefile, ptr, strlen(ptr));
			}
		}

		else if(!strncmp(pbuf, "oracle_login", 12))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				ptr = ptr+1;
				whole_trim(ptr, "\t\n ");
				memset(gOracle_login, 0x00, sizeof(gOracle_login));
				strncpy(gOracle_login, ptr, strlen(ptr));
			}
		}

		else if(!strncmp(pbuf, "javaurl_ip", 10))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				ptr = ptr+1;
				whole_trim(ptr, "\t\n ");
				memset(gJavaurl_ip, 0x00, sizeof(gJavaurl_ip));
				strncpy(gJavaurl_ip, ptr, strlen(ptr));
			}
		}

		else if(!strncmp(pbuf, "javaurl_port", 12))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				gJavaurl_port = atoi(ptr+1);
			}

		}

		memset(buf, 0, sizeof(buf));
	}
	fclose(pfd);

	return 0;
}

int checkSC(char *str, int len)
{
	int i=0;
	int flag = false;

	for (i=0; i<len; i++)
	{
		if (str[i] & 0x80 )
		{
			if(((unsigned char)str[i] < 175 || (unsigned char)str[i] > 201))
			{
				flag=true;
				break;
			}
			i++;
		} else
		{
			if ( !isalnum(str[i]) && !isblank(str[i]) )
			{
				flag=true;
				break;
			}
		}
	}

	// Ư�����ڰ� ������ 1, ������ 0
	if (flag)
		return 1;
	else 
		return 0;
}

int printHelp(void)
{
	printf(
			"��� ���� ���ڿ�, ���� URL, ���� ���� ��� ���α׷� (version 1.0)\n"
			"\n"
			"��� ������ ���Ϸ� �޽��ϴ�.\n"
			"�Է� ���ϸ�, ȭ��Ʈ����Ʈ ���ϸ� ��� ȯ�漳�� ������\n"
			"./conf/insertAdminFilter.conf ���Ͽ� ���ǵǾ� �ֽ��ϴ�.\n"
			"\n"
			"Javaurl, DB �� ����Ǿ�� �۵��մϴ�.\n"
			"\n"
			"��� �����ϴ� �˻� ��å�� ������ �����ϴ�.\n"
			"\n"
			"1. ���̰� 4byte �̸��� ���\n"
			"2. ��� ���� ���ڿ� ���̰� 7byte �̸��� ��� Ư�����ڰ� ���� ��\n"
			"3. ��� ���� ���� ���̰� 20~40byte �� �ƴ� ���\n"
			"4. ��� ���� URL ���� URL �Ľ��� ���� �ʴ� ���\n"
			"5. ������ ��� �� white list �� �����ϴ� ��� (white list�� ���Ϸ� ����)\n"
			"6. db�� ���� ���� ��ϵǾ� �ִ� ���\n"
			"\n"
			"DB�� ���Ե� �����ʹ� ���Ϸ� ��� �����մϴ�.\n\n" );
	return 0;
}
int removeSpace(struct INSERTTYPE *insertType)
{
	struct LIST templist;
	char tmpMsg[256];

	int i,j,k=0;
	for (i=0; i<insertType->inputlist.count; i++)
	{
		memset(tmpMsg, 0x00, sizeof(tmpMsg));
		for (j=0,k=0; j<strlen(insertType->inputlist.text[i]); j++)
		{
			if(insertType->inputlist.text[i][j] == ' ')
				continue;
			tmpMsg[k++] = insertType->inputlist.text[i][j];
		}
		sprintf(templist.text[templist.count++], "%s", tmpMsg);
	}

	memset(&insertType->inputlist, 0x00, sizeof(insertType->inputlist));
	insertType->inputlist = templist;

	return 0;
}

int urlParseList(struct INSERTTYPE *insertType)
{
	struct LIST templist;
	char url[1024] ="";
	int urllen;

	int i=0;
	for (i=0; i < insertType->inputlist.count; i++)
	{
		memset(url, 0x00, sizeof(url));
		get_url_from_javaurl(gfd, insertType->inputlist.text[i], 0, url, &urllen);
		if(urllen > 0)
		{
			sprintf(templist.text[templist.count++], "%s", url);
		}
		else
		{ 
			sprintf(insertType->rejectlist.text[insertType->rejectlist.count++], "URL�Ǻ��Ұ�\t%s", insertType->inputlist.text[i]);
		}
	}

	memset(&insertType->inputlist, 0x00, sizeof(insertType->inputlist));
	insertType->inputlist = templist;
	return 0;
}

int printList(struct LIST *list)
{
	int i=0;
	for (i=0; i < list->count; i++)
		printf("%05d\t%s\n", i, list->text[i]);
	printf("%c[1;33mTOTAL COUNT : [%d]%c[0m\n",27,list->count,27);

	return 0;
}

int saveList(struct LIST *list)
{
	char filepath[125];
	memset(filepath, 0x00, sizeof(filepath));
	printf("%c[1;34m������ ���ϸ� �Է� : %c[0m", 27, 27);
	scanf("%s", filepath); getchar();

	int i=0;
	FILE *fd = fopen(filepath, "w");
	for (i=0; i < list->count; i++)
	{
		fwrite(list->text[i], strlen(list->text[i]), 1, fd);
		fwrite("\n", 1,1,fd);
	}
	fclose(fd);
	printf("%c[1;34m%s ���� �Ϸ�%c[0m\n",27,filepath,27);
	
	return 0;
}

int selectList(char *query, struct LIST *list)
{
	char result[257];

	otl_stream i(50, query, exa_db);
	while(!i.eof()){
		i >> result;
		sprintf(list->text[list->count++] , "%s", result);
	}

	printf("DB SELECT[%s], count[%d]\n", query, list->count);
	return 0;
}

int insertList(int type, struct LIST *list)
{
	int i=0;
	char query[256];
	memset(query,0x00, sizeof(query));

	char check;
	printf("DB �� �ش� ���� �Է��Ͻðڽ��ϱ�?(y/n) : ");
	scanf("%c", &check);

	if(check != 'y')
		return 0;

	fflush(stdin);
	char rmk[256];
	int rmkMenu;
	memset(rmk, 0x00, sizeof(rmk));
	printf("RMK �� �����ϼ��� : \n1) TRAP/MMSC/���ո���͸�  2) SO���ǽð�����  3) BIZ �޽���  4) DNSN���ܵ�� : ");
	scanf("%d", &rmkMenu);

	switch(rmkMenu)
	{
		case 1 :
			sprintf(rmk, "TRAP/MMSC/���ո���͸�");
			break;
		case 2 : 
			 sprintf(rmk, "SO���ǽð�����");
			break;
		case 3 :
			sprintf(rmk, "BIZ �޽���");
			break;
		case 4 :
			sprintf(rmk, "DNSN���ܵ��");
			break;
		default :
			printf("�Է� ����!\n");
			return 0;
	}

	switch(type)
	{
		case 1 :
			sprintf(query, "insert into SFS_SPAM_STRING (STRING, SAVE_DT, RMK) values (:f1<char[256]>, to_char(sysdate,'yyyymmddhh24miss'), '%s') ", rmk);
			break; 
		case 2 :
			sprintf(query, "insert into SFS_SPAM_SENTENCE (STRING, SAVE_DT, RMK) values (:f1<char[256]>, to_char(sysdate,'yyyymmddhh24miss'), '%s') ", rmk);
			break; 
		case 3 :
			sprintf(query, "insert into TO_SFS_ADM_CUTURL_LST (CUTURL, SAVE_DT) values (:f1<char[256]>, to_char(sysdate,'yyyymmddhh24miss')) ");
			break; 
		default :
			printf("insert type error\n");
			return -1;
	}

	try {
		otl_stream o(1, query, exa_db);
		for(i=0; i<list->count; i++){
			printf("query[%s], [%s]\n", query, list->text[i]);
			o << list->text[i];
		}
	} catch (otl_exception& p){ // intercept OTL exceptions
		cerr<<p.msg<<endl; // print out error message
		cerr<<p.stm_text<<endl; // print out SQL that caused the error
		cerr<<p.var_info<<endl; // print out the variable that caused the error
	}

	return 0;
}

int readList(char *file, struct LIST *list)
{
	FILE *fp;
	char buff[BUFFSIZE];
	memset(buff, 0x00, sizeof(buff));

	if ((fp=fopen(file, "r")) == NULL)
	{
		printf("Error : File Does Not Exist [%s]\n", file);
		return -1;
	}

	while(readline(fp, buff, BUFFSIZE) != -1)
	{
		sprintf(list->text[list->count++] , "%s", buff);
	}

	fclose(fp);
	
	printf("FILE READ[%s], line[%d]\n", file, list->count);
	return 0;
}

int makeinsertList(int type, struct INSERTTYPE *insertType)
{
	int i,j;

	for(i=0; i<insertType->inputlist.count; i++)
	{
		// 4byte �̸� Error ó��
		if ( strlen(insertType->inputlist.text[i]) < 4)
		{
			sprintf( insertType->rejectlist.text[insertType->rejectlist.count++], "4byte�̸�\t%s", insertType->inputlist.text[i] );
			goto out;
		}
		// ���ڿ��� ��� 7Byte �̸� �̸鼭 Ư�����ڰ� ���°�� Error ó��
		if (type == 0 && strlen(insertType->inputlist.text[i]) < 7 && checkSC(insertType->inputlist.text[i], strlen(insertType->inputlist.text[i])) == 0)
		{
			sprintf( insertType->rejectlist.text[insertType->rejectlist.count++], "Ư�����ھ���\t%s", insertType->inputlist.text[i] );
			goto out;
		}
	#if 1	
		// ������ ��� 20Byte �̸� Error ó��
		if (type == 1 && strlen(insertType->inputlist.text[i]) < 20)
		{
			sprintf( insertType->rejectlist.text[insertType->rejectlist.count++], "20byte�̸�\t%s", insertType->inputlist.text[i] );
			goto out;
		}
	#endif
		// ������ ��� 40Byte �̻� Error ó��
		if (type == 1 && strlen(insertType->inputlist.text[i]) > 40)
		{
			sprintf( insertType->rejectlist.text[insertType->rejectlist.count++], "40byte�̻�\t%s", insertType->inputlist.text[i] );
			goto out;
		}
		// White List �˻�
		for(j=0; j<insertType->whitelist.count; j++)
		{
			// White List �� ���� 
			if(strcmp(insertType->inputlist.text[i], insertType->whitelist.text[j]) == 0)
			{
				sprintf( insertType->rejectlist.text[insertType->rejectlist.count++], "White List ����\t%s", insertType->inputlist.text[i] );
				goto out;
			}
		}
		// DB List �˻�	
		for(j=0; j<insertType->dblist.count; j++)
		{
			// DB List �� ���� 
			if(strcmp(insertType->inputlist.text[i], insertType->dblist.text[j]) == 0)
			{
				sprintf( insertType->rejectlist.text[insertType->rejectlist.count++], "DB������������\t%s", insertType->inputlist.text[i] );
				goto out;
			}
		}



		// insert ���
		sprintf( insertType->insertlist.text[insertType->insertlist.count++], "%s", insertType->inputlist.text[i] );
out:
		;
	}


	return 0;
}

int selectSubMenu(int type, struct INSERTTYPE *list)
{
	int menu=0;
	while(1)
	{
		printf("%c[1;32m\n--------------------------------------------------------%c[0m\n",27,27);
		printf("1. �Էµ� ����Ʈ ���\n");
		printf("2. ��ϵ� ����Ʈ ���\n");
		printf("3. ���ܵ� ����Ʈ ���\n");
		printf("4. ȭ��Ʈ ����Ʈ ���\n");
		printf("5. DB�� ���� �� ���\n");
		printf("6. ��� ����Ʈ ���Ϸ� ����\n\n");
		printf("9. ������ �̵�\n");
		printf("%c[1;32m--------------------------------------------------------%c[0m\n",27,27);
		printf("%c[1;31mSelect menu : %c[0m",27,27);
		scanf("%d", &menu);
		getchar();

		switch(menu)
		{
			case 1 :
				printf("%c[1;33m�Է� ����Ʈ%c[0m\n",27,27);
				printList(&list->originlist);
				break;
			case 2 :
				printf("%c[1;33m��� ����Ʈ%c[0m\n",27,27);
				printList(&list->insertlist);
				break;
			case 3 :
				printf("%c[1;33m���� ����Ʈ%c[0m\n",27,27);
				printList(&list->rejectlist);
				break;
			case 4 : 
				printf("%c[1;33mȭ��Ʈ ����Ʈ%c[0m\n",27,27);
				printList(&list->whitelist);
				break;
			case 5 :
				printf("%c[1;33mDB�� ���%c[0m\n",27,27);
				insertList(type , &list->insertlist);
				break;
			case 6 :
				saveList(&list->insertlist);
				break;
			case 9 : 
				return 0;
			default :
				break;
		}

	}

	return 0;
}

int selectMainMenu(void)
{	
	int menu=0;
	system("clear");
	while(1)
	{

		printf("%c[1;33m#######################################################%c[0m\n",27,27);
		printf("%c[1;31m ��� ���� ���ڿ�, ���� URL, ���� ���� ��� ���α׷� %c[0m\n",27,27);
		printf("%c[1;33m#######################################################%c[0m\n",27,27);

		printf("%c[1;34m\n#######################################################%c[0m\n",27,27);
		printf("1. ��� ���� ���ڿ� �Է�\n");
		printf("2. ��� ���� ���� �Է�\n");
		printf("3. ��� ���� URL �Է�\n");
		printf("4. ���� �ȳ�\n\n");
		printf("9. ����\n");
		printf("%c[1;34m#######################################################%c[0m\n",27,27);
		printf("%c[1;31mSelect menu : %c[0m",27,27);
		scanf("%d", &menu);
		getchar();


		switch(menu)
		{
			case 1 :
				memset(&SPAM_STRING, 0x00, sizeof(SPAM_STRING));
				if (readList(ginput_stringfile,	&SPAM_STRING.inputlist) != 0)	break;
				if (readList(gwhite_stringfile, &SPAM_STRING.whitelist) != 0)	break;

				selectList("select STRING from SFS_SPAM_STRING",	&SPAM_STRING.dblist);

				SPAM_STRING.originlist = SPAM_STRING.inputlist;
				removeSpace(&SPAM_STRING);

				makeinsertList(0, &SPAM_STRING);
				selectSubMenu(menu, &SPAM_STRING);
				system("clear");
				break;
			case 2 :
				memset(&SPAM_SENTENCE, 0x00, sizeof(SPAM_SENTENCE));
				if (readList(ginput_sentencefile, &SPAM_SENTENCE.inputlist) != 0)	break;
				if (readList(gwhite_sentencefile, 	&SPAM_SENTENCE.whitelist) != 0)	break;
				selectList("select STRING from SFS_SPAM_SENTENCE",	&SPAM_SENTENCE.dblist);

				SPAM_SENTENCE.originlist = SPAM_SENTENCE.inputlist;
				removeSpace(&SPAM_SENTENCE);

				makeinsertList(1, &SPAM_SENTENCE);
				selectSubMenu(menu, &SPAM_SENTENCE);
				system("clear");
				break;
			case 3 :
				memset(&SPAM_URL, 0x00, sizeof(SPAM_URL));
				if (readList(ginput_urlfile, &SPAM_URL.inputlist) != 0)	break;
				if (readList(gwhite_urlfile, &SPAM_URL.whitelist) != 0)	break;
				selectList("select CUTURL from TO_SFS_ADM_CUTURL_LST",	&SPAM_URL.dblist);

				SPAM_URL.originlist = SPAM_URL.inputlist;
				urlParseList(&SPAM_URL);

				makeinsertList(2, &SPAM_URL);
				selectSubMenu(menu, &SPAM_URL);
				system("clear");
				break;
			case 4 : 
				printHelp();
				break;
			case 9 :
				return 0;
			default : 
				break;
		}
 
	}
}

int main(int argc, char* argv[])
{
	int ret=0;


	printf("Loading Config file......\n");

	if(ret != load_config())
	{
		printf("Error : File Does Not Exist [./conf/insertAdminFilter.conf]\n");
		return 0;
	}

	printf("Javaurl ������......\n");
	gfd = epoll_connect_block_mode(gJavaurl_ip, gJavaurl_port);
	if(gfd == 0)
	{
		printf("Error : Not connected Javaurl [%s/%d]\n", gJavaurl_ip, gJavaurl_port);
		return 0;
	}

	printf("Database ������......\n");
	otl_connect::otl_initialize();

	try{
		exa_db.rlogon(gOracle_login);
	}

	catch(otl_exception& p){
		cerr<<p.msg<<endl;
		cerr<<p.stm_text<<endl;
		cerr<<p.var_info<<endl;

		printf("Error : Not connected Database [%s]\n", gOracle_login);
		return 0;
	}

	selectMainMenu();

	printf("%c[1;31mGood bye%c[0m\n",27,27);

	exa_db.logoff();
	close(gfd);
	return 0;
}
