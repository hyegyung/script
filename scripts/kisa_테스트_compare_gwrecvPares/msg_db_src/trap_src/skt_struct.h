#ifndef __SKT_STRUCT_H__
#define __SKT_STRUCT_H__

typedef struct __tmsfssms_st_ {
	char szSmsSeq[19];
	char szSrcNum[25];
	char szCbNum[25];
	char szSmsMsg[201];
	char szSpamPattern1[31];
	char szSpamPattern2[31];
	char szSaveDt[15];
} TmSfsSms, *TMSFSSMS;

typedef struct __tmsfsstassktresult_st_ {
	char szSmsSeq[19];
	char szSrcNum[25];
	char szCbNum[25];
	char szSmsMsg[201];
	char szSpamPattern1[31];
	char szSpamPattern2[31];
	char szSaveDt[15];
} TmSfsStasSktResult, *TMSFSSTASSKTRESULT;




#endif
