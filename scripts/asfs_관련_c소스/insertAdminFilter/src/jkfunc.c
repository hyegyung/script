#include "jkfunc.h"

static int chrcmp(char ch, const char *del)
{
	if ( del == NULL ) return 0;

	while( *del != 0x00 )
	{
		if( ch == *del )
		{
			return 1;
		}
		else del++;
	}
	return 0;
}

int whole_trim(char *p, const char *delim)
{
	char *str;
	str = p;

	do
	{
		if( chrcmp( *p, delim) )
		{
			p++;
			continue;
		}

		*str = *p;
		str++;
		p++;

	}while( *p != 0x00 );

	*str = 0x00;
	return 0;
}

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

int printlog(const char *format, ...)
{
	va_list arg; 
	int count; 
	char buff[2048]; 
	char n_format[1024] = "%s :%4d "; 
	char curdate[20]; 
	char logdate[20]; 
	char logmsg[2048]; 

	va_start( arg, format); 
	strcat(n_format, format); 
	count = vsprintf(buff, n_format, arg); 
	va_end( arg); 

	memset(logdate, 0x00, sizeof(logdate)); 
	GetCurDateA(logdate); 

	memset(curdate, 0x00, sizeof(curdate)); 
	GetCurTime(curdate); 

	memset(logmsg, 0x00, sizeof(logmsg)); 
	snprintf(logmsg, 2048, "%s %s\n", curdate, buff); 
	printf(logmsg);

	return 0; 
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

















