#ifndef __SKT_TABLE_H__
#define __SKT_TABLE_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <stdarg.h>
#include <dirent.h>
#include <sys/stat.h>

#include "skt_struct.h"

#define ROK						0
#define RFAIL					-1

#define ORA_SQLOK				0
#define HSNODATA				1403

#define MAX_SELECT_CNT			8192
#define MAX_INSERT_CNT			8192

#define MAX_SIZE				1024
#define MAX_TABLE				256
#define MAX_PART				8

#define TIME_SLEEP				50000

#define FL						__FILE__,__LINE__

#define SQLCODE					(int)sqlca.sqlcode
#define ORA_SQLMSG				sqlca.sqlerrm.sqlerrml-1,sqlca.sqlerrm.sqlerrmc

#define MoveIntVal(a, b)		a = atoi(b)
#define MoveChrVal(a, b)		strncpy(a, b, sizeof(a))
#define FGETS(a)				fgets(a, sizeof(a), stdin), a[strlen(a)-1] = '\0', fflush(stdin)

// skt_util.c
char *get_env(char *env);
int get_day_time(char *szDayTime);
int get_tday(char *szDay);
int get_yday(char *szDay);
int get_time(char *szTime);
void check_log_dir(void);
int logwrite(char *fname, int line, const char *fmt, ...);
void db_right_trim(char *buff);
void wRiteSfm(char *filepath, char *time, char *srcNum,char *tbname);

// skt_dbtable.pc
int connect_db(char *cstr);
int disconnect_db(void);
int select_tm_sfs_sms(char *szQuery, TmSfsSms *pTmSfsSms, int *nTmSfsSmsCnt);
int insert_tm_sfs_stas_skt_result(TmSfsStasSktResult *szSpamData, int nCnt);
int count_tm_sfs_nate(char *szQuery, int *nTmSfsSmsCnt);
int select_tm_sfs_sms_file(char *szQuery,char *filePath, int SELECT_CNT,char *tbName);
int insert_tm_sfs_sms(char *filePath, char *tbName);
int update_cds_user(char *filePath, char *tbName);
//int update_cds_user2(char *filePath, char *tbName);
int select_cdsuser(char *carrier,char *minnum);
int update_cds_user2(char *carrier, char *minnum,int ustate);
int update_cds_user3(char *carrier, char *minnum,char *mvnocorp);
int select_cust(char *custnumber,int tablenum);
void select_msg(char *table_name, char *file_name, char *select_day);
int get_yesterday(char *szDay);

#endif
