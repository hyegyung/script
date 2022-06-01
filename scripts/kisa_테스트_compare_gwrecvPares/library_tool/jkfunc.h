#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <time.h>

void spaceelm(char *s); // 문자열의 공백을 제거하는 함수
char *strstr_han(const char *in, const char *str); // strstr 한글 비교
char *replaceAll(char *s, const char *olds, const char *news); // 문자열 치환

char *GetCurTime(char *buff);
char *GetCurDateA(char *buff);
/* #define logmsg(a,...)   WriteLogMsg(a, __FILE__, __LINE__, ##__VA_ARGS__) */
int WriteLogMsg(const char *format, ...); // 로그 찍는 함수

int readline(FILE *fp, char *buff, int len);
char* token(char* str, char* src, const char* sep);

int HangleExtract(char *str, char *result);
int makeHexString(char *inString, char *result);
