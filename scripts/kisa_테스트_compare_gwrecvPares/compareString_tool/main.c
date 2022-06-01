#include <stdio.h>
#include <string.h>

#define BUFF_SIZE 1024

void spaceelm(char *s) /* 문자열의 공백을 제거하는 함수 */
{
	char *t;
	t=s;
	while(*s) {
		if(*s==' ' || *s=='\t') {
			s++;
			continue;
		}
		*t++=*s++;
	}
	*t=0;
}

int compareString(char *str, char *retStr, FILE *fp, int len)
{
	int index = 1;
	char haystack_line[BUFF_SIZE];
	char buff[BUFF_SIZE];
	char *line_p;

	memset(haystack_line, 0x00, sizeof(haystack_line));
	rewind(fp);
	while(fgets(haystack_line, BUFF_SIZE, fp) != NULL)
	{
		if((line_p = strchr(haystack_line, '\n')) != NULL)*line_p ='\0';
		if((line_p = strchr(haystack_line, '\r')) != NULL)*line_p ='\0';

		strcpy(buff, haystack_line);
		//spaceelm(str);
		//spaceelm(buff);

		if(strncmp(str, buff, len) == 0)
		{
			strcpy(retStr, haystack_line);
			return index;
		}
		memset(haystack_line, 0x00, sizeof(haystack_line));
		index++;
	}

	return -1;
}

int main(int argc, char *argv[])
{
	if(argc < 3)
	{
		printf("Error :: ./compareString \"haystack_file_path\" \"needle_file_path\" \"compare length\"\n");
		exit(1);
	}

	int i, len, ret;
	int count=0;

	FILE *haystack_fp;
	FILE *needle_fp;

	char *haystack_path = argv[1];
	char *needle_path = argv[2];

	char haystack_line[BUFF_SIZE];
	char needle_line[BUFF_SIZE];

	char *line_p;

	if(argc < 4)
	{
		len = BUFF_SIZE;
	}
	else
	{
		len = atoi(argv[3]);
	}



	memset(haystack_line, 0x00, sizeof(haystack_line));
	memset(needle_line, 0x00, sizeof(needle_line));

	i=0;
//	printf("haystack_path[%s], needle_path[%s]\n", haystack_path, needle_path);

	if((haystack_fp = fopen(haystack_path, "r")) == NULL)
	{
		printf( "%s Not Exist\n", haystack_path);
		exit(1);
	}

	if((needle_fp = fopen(needle_path, "r")) == NULL)
	{
		printf( "%s Not Exist\n", needle_path);
		exit(1);
	}

	printf("찾은 문자열\t원문 문자열\t위치\n");
	while(fgets(needle_line, BUFF_SIZE, needle_fp) != NULL)
	{
		if((line_p = strchr(needle_line, '\n')) != NULL)*line_p ='\0';
		if((line_p = strchr(needle_line, '\r')) != NULL)*line_p ='\0';
		printf("%s", needle_line);
		ret = compareString(needle_line, haystack_line, haystack_fp, len);
		if(ret != -1)
		{
			printf("\t%s\t%d\n", haystack_line, ret);
			count++;
			continue;
		}
		else
		{
			printf("\tnot found\t-1\n");
		}

		memset(haystack_line, 0x00, sizeof(haystack_line));
		memset(needle_line, 0x00, sizeof(needle_line));
	}
	
	printf("\nmatching count : %d\n", count);
	fclose(needle_fp);
	fclose(haystack_fp);

	return 0;
}
