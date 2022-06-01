#include "../lib/jkfunc.h"
#include <stdio.h>
#include <math.h>

#define logmsg(a,...) WriteLogMsg(a, __FILE__, __LINE__, ##__VA_ARGS__)
#define BUFFSIZE 4096

int reasonParse(char *src)
{
	int i=0;
	char str[128];
	char* next = &src[0];

	while(next = token(str, next, ":")) 
	{
		switch(i)
		{
			case 0 : 
				printf("%s\t", str);
				break;
			case 3 :
				printf("%s\t", next);
				return 0;
		}
		i++;
	}

	return 0;
}

int numberParse(char *src)
{
	int i=0;
	char str[128];
	char* next = &src[0];
	
	while(next = token(str, next, ":")) 
	{
		switch(i)
		{
			case 0 : 
			case 1 :
			case 2 :
				printf("%s\t", str);
				break;
			case 3 :
				return 0;
		}
		i++;
	}

	return 0;
}

int gwrecvParse(char *src)
{
	int i=0;
	char str[BUFFSIZE];
	char* next = &src[0];
	
	while(next = token(str, next, "][")) 
	{
		switch(i)
		{
			case 0 :
				printf("%s\t", str+1);
				break;
			case 4 : 
				numberParse(str);
				break;
			case 6 :
				reasonParse(str);
				next[strlen(next)-1] = 0x00;
				if(next[0] == '\"')
					printf("\"\"\"");
				printf("%s", next);
				break;
		}
		i++;
	}

	return 0;
}

int main(int argc, char *argv[])
{
	if(argc < 2)
	{
		printf("./gwrecvParse filename\n");
		return -1;
	}
	FILE *fp = fopen(argv[1], "r");
	char buff[BUFFSIZE];

	while(readline(fp, buff, BUFFSIZE) != -1)
	{
		if(strstr(buff, "main") != NULL)
		{
			gwrecvParse(buff);
			printf("\r\n");
		}
		memset(buff, 0x00, sizeof(buff));
	}

	fclose(fp);
}




