#include "jkfunc.h"

// 문자열의 공백을 제거하는 함수 
void spaceelm(char *s) {
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

// strstr 한글 비교
char *strstr_han(const char *in, const char *str)
{
	char c;
	size_t len;

	c = *str++;
	if (!c)
		return (char *) in; // Trivial empty string case

	len = strlen(str);
	do {
		char sc;

		do {
			if(sc & 0x80)
				*in++;
			sc = *in++;
			if (!sc)
				return (char *) 0;
		} while (sc != c);
	} while (strncmp(in, str, len) != 0);

	return (char *) (in - 1);
}

// 문자열 치환
char *replaceAll(char *s, const char *olds, const char *news) {
	char *result, *sr;
	size_t i, count = 0;
	size_t oldlen = strlen(olds); if (oldlen < 1) return s;
	size_t newlen = strlen(news);


	if (newlen != oldlen) {
		for (i = 0; s[i] != '\0';) {
			if (memcmp(&s[i], olds, oldlen) == 0) count++, i += oldlen;
			else i++;
		}
	} else i = strlen(s);


	result = (char *) malloc(i + 1 + count * (newlen - oldlen));
	if (result == NULL) return NULL;


	sr = result;
	while (*s) {
		if (memcmp(s, olds, oldlen) == 0) {
			memcpy(sr, news, newlen);
			sr += newlen;
			s += oldlen;
		} else *sr++ = *s++;
	}
	*sr = '\0';

	return result;
}

char *GetCurDateA(char *buff)
{
	struct tm *tm;
	struct timeval tv, otv={0, 0};
	static char day[20] = "19700101000000000";

	gettimeofday(&tv, NULL);
	tv.tv_usec = tv.tv_usec / 1000;
	if(otv.tv_sec == tv.tv_sec && otv.tv_sec == tv.tv_usec)
	{
		strcpy(buff, day);
		return buff;
	}

	memcpy(&otv, &tv, sizeof(otv));
	tm = localtime(&tv.tv_sec);
	sprintf(buff, "%04d%02d%02d%02d%02d%02d%03d",
			tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday,
			tm->tm_hour, tm->tm_min, tm->tm_sec, (int)tv.tv_usec);
	strcpy(day, buff);

	return buff;
}

char *GetCurTime(char *buff)
{
	struct tm *tm;
	struct timeval tv, otv={0,0};
	static char day[20] = "00:00:00.000";

	gettimeofday(&tv, NULL);
	tv.tv_usec = tv.tv_usec / 1000;
	if(otv.tv_sec == tv.tv_sec && otv.tv_sec == tv.tv_usec)
	{
		strcpy(buff, day);
		return buff;
	}
	memcpy(&otv, &tv, sizeof(otv));
	tm = localtime(&tv.tv_sec);
	sprintf(buff, "%02d:%02d:%02d.%03d", tm->tm_hour, tm->tm_min, tm->tm_sec, (int)tv.tv_usec);
	strcpy(day, buff);
	return buff;
}

int WriteLogMsg(const char *format, ...) 
{ 
	va_list arg; 
	int count; 
	char buff[2048]; 
	char n_format[1024] = "%s :%4d "; 
	char curdate[20]; 
	char logdate[20]; 
	FILE *fd; 
	char log_path[100]; 
	char logmsg[2048]; 

	va_start( arg, format); 
	strcat(n_format, format); 
	count = vsprintf(buff, n_format, arg); 
	va_end( arg); 

	memset(logdate, 0x00, sizeof(logdate)); 
	GetCurDateA(logdate); 

	memset(log_path, 0x00, sizeof(log_path)); 
	snprintf(log_path, 100, "./log/%.8s.log", logdate); 

	if((fd=fopen(log_path, "a+")) == NULL) 
	{ 
		printf("log file path error!!!!\n"); 
		exit(-1); 
	} 

	memset(curdate, 0x00, sizeof(curdate)); 
	GetCurTime(curdate); 

	memset(logmsg, 0x00, sizeof(logmsg)); 
	snprintf(logmsg, 2048, "%s %s\n", curdate, buff); 
	fwrite(logmsg, strlen(logmsg), 1, fd); 
	fclose(fd); 

	// printf("%s %s\n", curdate, buff); 
	return 0; 
}

int readline(FILE *fp, char *buff, int len)
{
	char *line_p;

	memset(buff, 0x00, sizeof(buff));	
	if(fgets(buff, len, fp) == NULL)
		return -1;

	if((line_p = strchr(buff, '\n')) != NULL) *line_p = '\0';
	if((line_p = strchr(buff, '\r')) != NULL) *line_p = '\0';

	return 0;

/* 사용법
	FILE *fp = fopen("temp.txt", "r");
	char buff[BUFFSIZE];

	while(readline(fp, buff, BUFFSIZE) != -1)
	{
		logmsg(buff);
	}

	fclose(fp);
*/ 
}

char* token(char* str, char* src, const char* sep) {
	int i = 0;
	if (*src == '\0') return(NULL);
	while (1) {
		if (sep[i] == '\0') {
			str -= strlen(sep);
			break;
		} else if (*src == sep[i]) {
			i++;
		} else i = 0;
		if (*src == '\0') break;
		*str++ = *src++;
	}
	*str = '\0';
	return(src);
}

int HangleExtract(char *str, char *result)
{
	char han[3];
	int i;

	memset(result, 0x00, sizeof(result));
	memset(han, 0x00, sizeof(han));

	for(i=0; i<strlen(str); i++)
	{
		if(str[i] & 0x80 )  // 2byte 글자만 추출
		{
			if(((unsigned char)str[i] > 175 && (unsigned char)str[i] < 201) || (unsigned char)str[i] == 168) // 한글  추출 또는 ㉮같은 원문자기호 추출
			{
				han[0] = str[i];
				han[1] = str[i+1];
				strcat(result, han);
			}

			i++;
		}
#if 0
		else if (str[i] == '\n') // 1byte 줄바꿈 추출 
			strcat(result, "\n");
		else if (str[i] == ' ' && str[i+1] == ' ') // 2개의 공백 추출
		{
			strcat(result, "　"); // 2byte 공백으로 치환 
			i++;
		}
#endif
	}

	return 0;
}

int cvtHexToInt(char hex)
{
	hex = toupper(hex);
	int ret=0;

	switch(hex)
	{
		case '0' : ret = 0; break;
		case '1' : ret = 1; break;
		case '2' : ret = 2; break;
		case '3' : ret = 3; break;
		case '4' : ret = 4; break;
		case '5' : ret = 5; break;
		case '6' : ret = 6; break;
		case '7' : ret = 7; break;
		case '8' : ret = 8; break;
		case '9' : ret = 9; break;
		case 'A' : ret = 10; break;
		case 'B' : ret = 11; break;
		case 'C' : ret = 12; break;
		case 'D' : ret = 13; break;
		case 'E' : ret = 14; break;
		case 'F' : ret = 15; break;
		default  : ret = 0; break;
	}
	return ret;
}

int makeHexString(char *inString, char *result)
{
//	if(strlen(inString)%2 != 0)
//		return -1;

	int i=0,j=0;
	int sum;
	int ret;
	char sum_str[3];

	memset(result, 0x00, sizeof(result));
	memset(sum_str, 0x00, sizeof(sum_str));

	for(i=0, j=0; i<strlen(inString)-1; i=i+2, j++)
	{
		sum = cvtHexToInt(inString[i]) * 16;
		sum += cvtHexToInt(inString[i+1]);
		
		result[j] = sum;
	}

	return 0;
}














