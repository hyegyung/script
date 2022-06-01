#include "skt_table.h"

char *pInitDir = "/home/sfmen/skt";
char *pFileName = "collect_spam";

char *get_env(char *env)
{
	char *ptr;

	if((ptr = getenv(env)) == NULL)
		return "";

	return ptr;
}

int get_day_time(char *szDayTime)
{
	time_t t;
	struct tm *tm;

	time(&t);
	tm = localtime(&t);

	sprintf(szDayTime, "%04d%02d%02d%02d%02d%02d", tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec);

	return ROK;
}

int get_tday(char *szDay)
{
	time_t t;
	struct tm *tm;

	time(&t);
	tm = localtime(&t);

	sprintf(szDay, "%04d%02d%02d", tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday);

	return ROK;
}

int get_yday(char *szDay)
{
	time_t t;
	struct tm *tm;

	t = time(NULL) - (24 * 60 * 60);
	tm = localtime(&t);

	sprintf(szDay, "%04d%02d%02d", tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday);

	return ROK;
}

int get_time(char *szTime)
{
	time_t t;
	struct tm *tm;

	time(&t);
	tm = localtime(&t);

	sprintf(szTime, "%02d:%02d.%02d", tm->tm_hour, tm->tm_min, tm->tm_sec);

	return ROK;
}

void check_log_dir(void)
{
	DIR *dp;

	if((dp = opendir(pInitDir)) == NULL)
	{
		if(mkdir(pInitDir, 0775) != 0)
			printf("failed mkdir() [%s]\n", pInitDir);
		else
			printf("Make Directory [%s]\n", pInitDir);
	}

	closedir(dp);
}

int logwrite(char *fname, int line, const char *fmt, ...)
{
	char szLogFile[4096];
	char szLogMsg[4096], szTemp[4096];
	char szCuday[8], szCutime[10];
	va_list va;
	FILE *fd = NULL;

	va_start(va, fmt);
	vsnprintf(szTemp, sizeof(szTemp), fmt, va);
	va_end(va);

	get_tday(szCuday);
	get_time(szCutime);

	snprintf(szLogMsg, sizeof(szLogMsg), "[%s - %s] : %s(%d): %s\n", szCuday, szCutime, fname, line, szTemp);

	snprintf(szLogFile, sizeof(szLogFile), "%s/%s_%s.log", pInitDir, pFileName, szCuday);
	fd = fopen(szLogFile, "a");
	if(fd == NULL)
		return RFAIL;

	fprintf(fd, "%s", szLogMsg);

	fclose(fd);

	return ROK;
}

void db_right_trim(char *buff)
{
	int nIdx, nLen;

	nLen = strlen(buff);

	for(nIdx = nLen-1; nIdx >= 0; nIdx--)
	{
		if(buff[nIdx] == ' ' || buff[nIdx] == 0x0a || buff[nIdx] == 0x0d)
			buff[nIdx] = 0x00;
		else
			break;
	}

	return;
}

void wRiteSfm(char *filepath, char *time, char *srcNum,char *tbname)
{
        char tftpfileName[256];  
        char filename[256];
        FILE *mfp=NULL;
        
        snprintf(filename,256,"%s",tbname);
        snprintf(tftpfileName,256,"%s/%s",filepath,filename);

        if ((mfp = fopen(tftpfileName, "a")) == NULL) {
                printf("tmp ftp file Open Fail [%s]\n", tftpfileName);
                return;
        }
        
        fprintf(mfp,"%s %s\n",time,srcNum);
        
        fclose(mfp); 
}

int get_yesterday(char *szDay)
{
	time_t t;
	struct tm *tm;

	time(&t);
	t = t - 86400;
	tm = localtime(&t);

	sprintf(szDay, "%04d%02d%02d", tm->tm_year+1900, tm->tm_mon+1, tm->tm_mday);

	return ROK;
}
