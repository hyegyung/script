
/* Result Sets Interface */
#ifndef SQL_CRSR
#  define SQL_CRSR
  struct sql_cursor
  {
    unsigned int curocn;
    void *ptr1;
    void *ptr2;
    unsigned int magic;
  };
  typedef struct sql_cursor sql_cursor;
  typedef struct sql_cursor SQL_CURSOR;
#endif /* SQL_CRSR */

/* Thread Safety */
typedef void * sql_context;
typedef void * SQL_CONTEXT;

/* Object support */
struct sqltvn
{
  unsigned char *tvnvsn; 
  unsigned short tvnvsnl; 
  unsigned char *tvnnm;
  unsigned short tvnnml; 
  unsigned char *tvnsnm;
  unsigned short tvnsnml;
};
typedef struct sqltvn sqltvn;

struct sqladts
{
  unsigned int adtvsn; 
  unsigned short adtmode; 
  unsigned short adtnum;  
  sqltvn adttvn[1];       
};
typedef struct sqladts sqladts;

static struct sqladts sqladt = {
  1,1,0,
};

/* Binding to PL/SQL Records */
struct sqltdss
{
  unsigned int tdsvsn; 
  unsigned short tdsnum; 
  unsigned char *tdsval[1]; 
};
typedef struct sqltdss sqltdss;
static struct sqltdss sqltds =
{
  1,
  0,
};

/* File name & Package Name */
struct sqlcxp
{
  unsigned short fillen;
           char  filnam[13];
};
static const struct sqlcxp sqlfpn =
{
    12,
    "skt_table.pc"
};


static unsigned int sqlctx = 333315;


static struct sqlexd {
   unsigned long  sqlvsn;
   unsigned int   arrsiz;
   unsigned int   iters;
   unsigned int   offset;
   unsigned short selerr;
   unsigned short sqlety;
   unsigned int   occurs;
      const short *cud;
   unsigned char  *sqlest;
      const char  *stmt;
   sqladts *sqladtp;
   sqltdss *sqltdsp;
   unsigned char  **sqphsv;
   unsigned long  *sqphsl;
            int   *sqphss;
            short **sqpind;
            int   *sqpins;
   unsigned long  *sqparm;
   unsigned long  **sqparc;
   unsigned short  *sqpadto;
   unsigned short  *sqptdso;
   unsigned int   sqlcmax;
   unsigned int   sqlcmin;
   unsigned int   sqlcincr;
   unsigned int   sqlctimeout;
   unsigned int   sqlcnowait;
            int   sqfoff;
   unsigned int   sqcmod;
   unsigned int   sqfmod;
   unsigned char  *sqhstv[7];
   unsigned long  sqhstl[7];
            int   sqhsts[7];
            short *sqindv[7];
            int   sqinds[7];
   unsigned long  sqharm[7];
   unsigned long  *sqharc[7];
   unsigned short  sqadto[7];
   unsigned short  sqtdso[7];
} sqlstm = {12,7};

/* SQLLIB Prototypes */
extern void sqlcxt (void **, unsigned int *,
                    struct sqlexd *, const struct sqlcxp *);
extern void sqlcx2t(void **, unsigned int *,
                    struct sqlexd *, const struct sqlcxp *);
extern void sqlbuft(void **, char *);
extern void sqlgs2t(void **, char *);
extern void sqlorat(void **, unsigned int *, void *);

/* Forms Interface */
static const int IAPSUCC = 0;
static const int IAPFAIL = 1403;
static const int IAPFTL  = 535;
extern void sqliem(unsigned char *, signed int *);

typedef struct { unsigned short len; unsigned char arr[1]; } VARCHAR;
typedef struct { unsigned short len; unsigned char arr[1]; } varchar;

/* cud (compilation unit data) array */
static const short sqlcud0[] =
{12,4274,846,0,0,
5,0,0,0,0,0,27,12,0,0,4,4,0,1,0,1,5,0,0,1,10,0,0,1,10,0,0,1,10,0,0,
36,0,0,2,0,0,30,22,0,0,0,0,0,1,0,
51,0,0,3,0,0,17,36,0,0,1,1,0,1,0,1,5,0,0,
70,0,0,3,0,0,45,40,0,0,0,0,0,1,0,
85,0,0,3,0,0,13,48,0,0,7,0,0,1,0,2,5,0,0,2,5,0,0,2,5,0,0,2,5,0,0,2,5,0,0,2,5,0,
0,2,5,0,0,
128,0,0,3,0,0,15,55,0,0,0,0,0,1,0,
143,0,0,3,0,0,15,75,0,0,0,0,0,1,0,
158,0,0,4,22,0,1,89,0,0,0,0,0,1,0,
173,0,0,5,0,0,17,98,0,0,1,1,0,1,0,1,5,0,0,
192,0,0,5,0,0,21,100,0,0,7,7,0,1,0,1,5,0,0,1,5,0,0,1,5,0,0,1,5,0,0,1,5,0,0,1,5,
0,0,1,5,0,0,
235,0,0,6,0,0,29,112,0,0,0,0,0,1,0,
250,0,0,7,0,0,17,124,0,0,1,1,0,1,0,1,5,0,0,
269,0,0,7,0,0,45,128,0,0,0,0,0,1,0,
284,0,0,7,0,0,13,132,0,0,1,0,0,1,0,2,3,0,0,
303,0,0,7,0,0,15,140,0,0,0,0,0,1,0,
318,0,0,7,0,0,15,144,0,0,0,0,0,1,0,
333,0,0,8,0,0,17,161,0,0,1,1,0,1,0,1,5,0,0,
352,0,0,8,0,0,45,165,0,0,0,0,0,1,0,
367,0,0,8,0,0,13,173,0,0,2,0,0,1,0,2,5,0,0,2,5,0,0,
390,0,0,8,0,0,15,180,0,0,0,0,0,1,0,
405,0,0,8,0,0,15,189,0,0,0,0,0,1,0,
420,0,0,9,22,0,1,206,0,0,0,0,0,1,0,
435,0,0,5,0,0,17,220,0,0,1,1,0,1,0,1,5,0,0,
454,0,0,5,0,0,21,221,0,0,2,2,0,1,0,1,5,0,0,1,5,0,0,
477,0,0,10,0,0,29,236,0,0,0,0,0,1,0,
492,0,0,11,22,0,1,263,0,0,0,0,0,1,0,
507,0,0,5,0,0,17,301,0,0,1,1,0,1,0,1,5,0,0,
526,0,0,5,0,0,21,302,0,0,5,5,0,1,0,1,3,0,0,1,5,0,0,1,5,0,0,1,5,0,0,1,5,0,0,
561,0,0,12,0,0,29,318,0,0,0,0,0,1,0,
576,0,0,13,22,0,1,332,0,0,0,0,0,1,0,
591,0,0,5,0,0,17,336,0,0,1,1,0,1,0,1,5,0,0,
610,0,0,5,0,0,21,338,0,0,3,3,0,1,0,1,3,0,0,1,5,0,0,1,5,0,0,
637,0,0,14,0,0,29,349,0,0,0,0,0,1,0,
652,0,0,15,22,0,1,359,0,0,0,0,0,1,0,
667,0,0,5,0,0,17,363,0,0,1,1,0,1,0,1,5,0,0,
686,0,0,5,0,0,21,365,0,0,3,3,0,1,0,1,5,0,0,1,5,0,0,1,5,0,0,
713,0,0,16,0,0,29,376,0,0,0,0,0,1,0,
728,0,0,17,0,0,17,389,0,0,1,1,0,1,0,1,5,0,0,
747,0,0,17,0,0,45,393,0,0,0,0,0,1,0,
762,0,0,17,0,0,13,395,0,0,1,0,0,1,0,2,3,0,0,
781,0,0,17,0,0,15,398,0,0,0,0,0,1,0,
796,0,0,17,0,0,15,403,0,0,0,0,0,1,0,
811,0,0,18,0,0,17,417,0,0,1,1,0,1,0,1,5,0,0,
830,0,0,18,0,0,45,421,0,0,0,0,0,1,0,
845,0,0,18,0,0,13,423,0,0,1,0,0,1,0,2,3,0,0,
864,0,0,18,0,0,15,426,0,0,0,0,0,1,0,
879,0,0,18,0,0,15,431,0,0,0,0,0,1,0,
894,0,0,19,0,0,17,457,0,0,1,1,0,1,0,1,5,0,0,
913,0,0,19,0,0,45,461,0,0,0,0,0,1,0,
928,0,0,19,0,0,13,470,0,0,6,0,0,1,0,2,5,0,0,2,5,0,0,2,5,0,0,2,5,0,0,2,5,0,0,2,
3,0,0,
967,0,0,19,0,0,15,473,0,0,0,0,0,1,0,
982,0,0,19,0,0,15,488,0,0,0,0,0,1,0,
};


#include "skt_table.h"

#include <sqlca.h>
#include <stdlib.h>
#include <sqlcpr.h>

/* EXEC SQL INCLUDE SQLCA;
 */ 
/*
 * $Header: sqlca.h 24-apr-2003.12:50:58 mkandarp Exp $ sqlca.h 
 */

/* Copyright (c) 1985, 2003, Oracle Corporation.  All rights reserved.  */
 
/*
NAME
  SQLCA : SQL Communications Area.
FUNCTION
  Contains no code. Oracle fills in the SQLCA with status info
  during the execution of a SQL stmt.
NOTES
  **************************************************************
  ***                                                        ***
  *** This file is SOSD.  Porters must change the data types ***
  *** appropriately on their platform.  See notes/pcport.doc ***
  *** for more information.                                  ***
  ***                                                        ***
  **************************************************************

  If the symbol SQLCA_STORAGE_CLASS is defined, then the SQLCA
  will be defined to have this storage class. For example:
 
    #define SQLCA_STORAGE_CLASS extern
 
  will define the SQLCA as an extern.
 
  If the symbol SQLCA_INIT is defined, then the SQLCA will be
  statically initialized. Although this is not necessary in order
  to use the SQLCA, it is a good pgming practice not to have
  unitialized variables. However, some C compilers/OS's don't
  allow automatic variables to be init'd in this manner. Therefore,
  if you are INCLUDE'ing the SQLCA in a place where it would be
  an automatic AND your C compiler/OS doesn't allow this style
  of initialization, then SQLCA_INIT should be left undefined --
  all others can define SQLCA_INIT if they wish.

  If the symbol SQLCA_NONE is defined, then the SQLCA variable will
  not be defined at all.  The symbol SQLCA_NONE should not be defined
  in source modules that have embedded SQL.  However, source modules
  that have no embedded SQL, but need to manipulate a sqlca struct
  passed in as a parameter, can set the SQLCA_NONE symbol to avoid
  creation of an extraneous sqlca variable.
 
MODIFIED
    lvbcheng   07/31/98 -  long to int
    jbasu      12/12/94 -  Bug 217878: note this is an SOSD file
    losborne   08/11/92 -  No sqlca var if SQLCA_NONE macro set 
  Clare      12/06/84 - Ch SQLCA to not be an extern.
  Clare      10/21/85 - Add initialization.
  Bradbury   01/05/86 - Only initialize when SQLCA_INIT set
  Clare      06/12/86 - Add SQLCA_STORAGE_CLASS option.
*/
 
#ifndef SQLCA
#define SQLCA 1
 
struct   sqlca
         {
         /* ub1 */ char    sqlcaid[8];
         /* b4  */ int     sqlabc;
         /* b4  */ int     sqlcode;
         struct
           {
           /* ub2 */ unsigned short sqlerrml;
           /* ub1 */ char           sqlerrmc[70];
           } sqlerrm;
         /* ub1 */ char    sqlerrp[8];
         /* b4  */ int     sqlerrd[6];
         /* ub1 */ char    sqlwarn[8];
         /* ub1 */ char    sqlext[8];
         };

#ifndef SQLCA_NONE 
#ifdef   SQLCA_STORAGE_CLASS
SQLCA_STORAGE_CLASS struct sqlca sqlca
#else
         struct sqlca sqlca
#endif
 
#ifdef  SQLCA_INIT
         = {
         {'S', 'Q', 'L', 'C', 'A', ' ', ' ', ' '},
         sizeof(struct sqlca),
         0,
         { 0, {0}},
         {'N', 'O', 'T', ' ', 'S', 'E', 'T', ' '},
         {0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0},
         {0, 0, 0, 0, 0, 0, 0, 0}
         }
#endif
         ;
#endif
 
#endif
 
/* end SQLCA */
/* EXEC SQL INCLUDE SQLDA;
 */ 
/*
 * $Header: sqlda.h 08-may-2007.05:58:33 ardesai Exp $ sqlda.h 
 */

/***************************************************************
*      The SQLDA descriptor definition                         *
*--------------------------------------------------------------*
*      VAX/3B Version                                          *
*                                                              *
* Copyright (c) 1987, 2007, Oracle. All rights reserved.  *
***************************************************************/


/* NOTES
  **************************************************************
  ***                                                        ***
  *** This file is SOSD.  Porters must change the data types ***
  *** appropriately on their platform.  See notes/pcport.doc ***
  *** for more information.                                  ***
  ***                                                        ***
  **************************************************************
*/

/*  MODIFIED
    ardesai    05/08/07  - Bug[6037057] Undef Y
    apopat     05/08/02  - [2362423] MVS PE to make lines shorter than 79
    apopat     07/31/99 -  [707588] TAB to blanks for OCCS
    lvbcheng   10/27/98 -  change long to int for sqlda
    lvbcheng   08/15/97 -  Move sqlda protos to sqlcpr.h
    lvbcheng   06/25/97 -  Move sqlda protos to this file
    jbasu      01/29/95 -  correct typo
    jbasu      01/27/95 -  correct comment - ub2->sb2
    jbasu      12/12/94 - Bug 217878: note this is an SOSD file
    Morse      12/01/87 - undef L and S for v6 include files
    Richey     07/13/87 - change int defs to long 
    Clare      09/13/84 - Port: Ch types to match SQLLIB structs
    Clare      10/02/86 - Add ifndef SQLDA
*/

#ifndef SQLDA_
#define SQLDA_ 1
 
#ifdef T
# undef T
#endif
#ifdef F
# undef F
#endif

#ifdef S
# undef S
#endif
#ifdef L
# undef L
#endif

#ifdef Y
 # undef Y
#endif
 
struct SQLDA {
  /* ub4    */ int        N; /* Descriptor size in number of entries        */
  /* text** */ char     **V; /* Ptr to Arr of addresses of main variables   */
  /* ub4*   */ int       *L; /* Ptr to Arr of lengths of buffers            */
  /* sb2*   */ short     *T; /* Ptr to Arr of types of buffers              */
  /* sb2**  */ short    **I; /* Ptr to Arr of addresses of indicator vars   */
  /* sb4    */ int        F; /* Number of variables found by DESCRIBE       */
  /* text** */ char     **S; /* Ptr to Arr of variable name pointers        */
  /* ub2*   */ short     *M; /* Ptr to Arr of max lengths of var. names     */
  /* ub2*   */ short     *C; /* Ptr to Arr of current lengths of var. names */
  /* text** */ char     **X; /* Ptr to Arr of ind. var. name pointers       */
  /* ub2*   */ short     *Y; /* Ptr to Arr of max lengths of ind. var. names*/
  /* ub2*   */ short     *Z; /* Ptr to Arr of cur lengths of ind. var. names*/
  };
 
typedef struct SQLDA SQLDA;
 
#endif

/* ----------------- */
/* defines for sqlda */
/* ----------------- */

#define SQLSQLDAAlloc(arg1, arg2, arg3, arg4) sqlaldt(arg1, arg2, arg3, arg4) 

#define SQLSQLDAFree(arg1, arg2) sqlclut(arg1, arg2) 





int connect_db(char *cstr)
{
	/* EXEC SQL CONNECT :cstr; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 4;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )10;
 sqlstm.offset = (unsigned int  )5;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqhstv[0] = (unsigned char  *)cstr;
 sqlstm.sqhstl[0] = (unsigned long )0;
 sqlstm.sqhsts[0] = (         int  )0;
 sqlstm.sqindv[0] = (         short *)0;
 sqlstm.sqinds[0] = (         int  )0;
 sqlstm.sqharm[0] = (unsigned long )0;
 sqlstm.sqadto[0] = (unsigned short )0;
 sqlstm.sqtdso[0] = (unsigned short )0;
 sqlstm.sqphsv = sqlstm.sqhstv;
 sqlstm.sqphsl = sqlstm.sqhstl;
 sqlstm.sqphss = sqlstm.sqhsts;
 sqlstm.sqpind = sqlstm.sqindv;
 sqlstm.sqpins = sqlstm.sqinds;
 sqlstm.sqparm = sqlstm.sqharm;
 sqlstm.sqparc = sqlstm.sqharc;
 sqlstm.sqpadto = sqlstm.sqadto;
 sqlstm.sqptdso = sqlstm.sqtdso;
 sqlstm.sqlcmax = (unsigned int )100;
 sqlstm.sqlcmin = (unsigned int )2;
 sqlstm.sqlcincr = (unsigned int )1;
 sqlstm.sqlctimeout = (unsigned int )0;
 sqlstm.sqlcnowait = (unsigned int )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	if(SQLCODE != ORA_SQLOK)
		return SQLCODE;

	return ROK;
}

int disconnect_db(void)
{
	/* EXEC SQL COMMIT WORK RELEASE; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 4;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )36;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	if(SQLCODE != ORA_SQLOK)
		return SQLCODE;

	return ROK;
}

int select_tm_sfs_sms(char *szQuery, TmSfsSms *pTmSfsSms, int *nTmSfsSmsCnt)
{
	int i, nCnt = 0;
	char szVal[7][512];
	TmSfsSms temp[MAX_SELECT_CNT];

	/* EXEC SQL PREPARE tm_sfs_sms FROM :szQuery; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 4;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )51;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqhstv[0] = (unsigned char  *)szQuery;
 sqlstm.sqhstl[0] = (unsigned long )0;
 sqlstm.sqhsts[0] = (         int  )0;
 sqlstm.sqindv[0] = (         short *)0;
 sqlstm.sqinds[0] = (         int  )0;
 sqlstm.sqharm[0] = (unsigned long )0;
 sqlstm.sqadto[0] = (unsigned short )0;
 sqlstm.sqtdso[0] = (unsigned short )0;
 sqlstm.sqphsv = sqlstm.sqhstv;
 sqlstm.sqphsl = sqlstm.sqhstl;
 sqlstm.sqphss = sqlstm.sqhsts;
 sqlstm.sqpind = sqlstm.sqindv;
 sqlstm.sqpins = sqlstm.sqinds;
 sqlstm.sqparm = sqlstm.sqharm;
 sqlstm.sqparc = sqlstm.sqharc;
 sqlstm.sqpadto = sqlstm.sqadto;
 sqlstm.sqptdso = sqlstm.sqtdso;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	/* EXEC SQL DECLARE tm_sfs_sms_cur CURSOR FOR tm_sfs_sms; */ 


	/* EXEC SQL OPEN tm_sfs_sms_cur; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 4;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )70;
 sqlstm.selerr = (unsigned short)1;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqcmod = (unsigned int )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	memset(&temp, 0x00, sizeof(temp));

	for(nCnt = 0; nCnt < MAX_SELECT_CNT; )
	{
		memset(szVal, 0x00, sizeof(szVal));

		/* EXEC SQL FETCH tm_sfs_sms_cur INTO :szVal[0], :szVal[1], :szVal[2], :szVal[3], :szVal[4], :szVal[5], :szVal[6]; */ 

{
  struct sqlexd sqlstm;
  sqlstm.sqlvsn = 12;
  sqlstm.arrsiz = 7;
  sqlstm.sqladtp = &sqladt;
  sqlstm.sqltdsp = &sqltds;
  sqlstm.iters = (unsigned int  )1;
  sqlstm.offset = (unsigned int  )85;
  sqlstm.selerr = (unsigned short)1;
  sqlstm.cud = sqlcud0;
  sqlstm.sqlest = (unsigned char  *)&sqlca;
  sqlstm.sqlety = (unsigned short)4352;
  sqlstm.occurs = (unsigned int  )0;
  sqlstm.sqfoff = (         int )0;
  sqlstm.sqfmod = (unsigned int )2;
  sqlstm.sqhstv[0] = (unsigned char  *)szVal[0];
  sqlstm.sqhstl[0] = (unsigned long )512;
  sqlstm.sqhsts[0] = (         int  )0;
  sqlstm.sqindv[0] = (         short *)0;
  sqlstm.sqinds[0] = (         int  )0;
  sqlstm.sqharm[0] = (unsigned long )0;
  sqlstm.sqadto[0] = (unsigned short )0;
  sqlstm.sqtdso[0] = (unsigned short )0;
  sqlstm.sqhstv[1] = (unsigned char  *)szVal[1];
  sqlstm.sqhstl[1] = (unsigned long )512;
  sqlstm.sqhsts[1] = (         int  )0;
  sqlstm.sqindv[1] = (         short *)0;
  sqlstm.sqinds[1] = (         int  )0;
  sqlstm.sqharm[1] = (unsigned long )0;
  sqlstm.sqadto[1] = (unsigned short )0;
  sqlstm.sqtdso[1] = (unsigned short )0;
  sqlstm.sqhstv[2] = (unsigned char  *)szVal[2];
  sqlstm.sqhstl[2] = (unsigned long )512;
  sqlstm.sqhsts[2] = (         int  )0;
  sqlstm.sqindv[2] = (         short *)0;
  sqlstm.sqinds[2] = (         int  )0;
  sqlstm.sqharm[2] = (unsigned long )0;
  sqlstm.sqadto[2] = (unsigned short )0;
  sqlstm.sqtdso[2] = (unsigned short )0;
  sqlstm.sqhstv[3] = (unsigned char  *)szVal[3];
  sqlstm.sqhstl[3] = (unsigned long )512;
  sqlstm.sqhsts[3] = (         int  )0;
  sqlstm.sqindv[3] = (         short *)0;
  sqlstm.sqinds[3] = (         int  )0;
  sqlstm.sqharm[3] = (unsigned long )0;
  sqlstm.sqadto[3] = (unsigned short )0;
  sqlstm.sqtdso[3] = (unsigned short )0;
  sqlstm.sqhstv[4] = (unsigned char  *)szVal[4];
  sqlstm.sqhstl[4] = (unsigned long )512;
  sqlstm.sqhsts[4] = (         int  )0;
  sqlstm.sqindv[4] = (         short *)0;
  sqlstm.sqinds[4] = (         int  )0;
  sqlstm.sqharm[4] = (unsigned long )0;
  sqlstm.sqadto[4] = (unsigned short )0;
  sqlstm.sqtdso[4] = (unsigned short )0;
  sqlstm.sqhstv[5] = (unsigned char  *)szVal[5];
  sqlstm.sqhstl[5] = (unsigned long )512;
  sqlstm.sqhsts[5] = (         int  )0;
  sqlstm.sqindv[5] = (         short *)0;
  sqlstm.sqinds[5] = (         int  )0;
  sqlstm.sqharm[5] = (unsigned long )0;
  sqlstm.sqadto[5] = (unsigned short )0;
  sqlstm.sqtdso[5] = (unsigned short )0;
  sqlstm.sqhstv[6] = (unsigned char  *)szVal[6];
  sqlstm.sqhstl[6] = (unsigned long )512;
  sqlstm.sqhsts[6] = (         int  )0;
  sqlstm.sqindv[6] = (         short *)0;
  sqlstm.sqinds[6] = (         int  )0;
  sqlstm.sqharm[6] = (unsigned long )0;
  sqlstm.sqadto[6] = (unsigned short )0;
  sqlstm.sqtdso[6] = (unsigned short )0;
  sqlstm.sqphsv = sqlstm.sqhstv;
  sqlstm.sqphsl = sqlstm.sqhstl;
  sqlstm.sqphss = sqlstm.sqhsts;
  sqlstm.sqpind = sqlstm.sqindv;
  sqlstm.sqpins = sqlstm.sqinds;
  sqlstm.sqparm = sqlstm.sqharm;
  sqlstm.sqparc = sqlstm.sqharc;
  sqlstm.sqpadto = sqlstm.sqadto;
  sqlstm.sqptdso = sqlstm.sqtdso;
  sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


		if(SQLCODE == HSNODATA)
		{
			break;
		}
		else if(SQLCODE != ORA_SQLOK)
		{
			/* EXEC SQL CLOSE tm_sfs_sms_cur; */ 

{
   struct sqlexd sqlstm;
   sqlstm.sqlvsn = 12;
   sqlstm.arrsiz = 7;
   sqlstm.sqladtp = &sqladt;
   sqlstm.sqltdsp = &sqltds;
   sqlstm.iters = (unsigned int  )1;
   sqlstm.offset = (unsigned int  )128;
   sqlstm.cud = sqlcud0;
   sqlstm.sqlest = (unsigned char  *)&sqlca;
   sqlstm.sqlety = (unsigned short)4352;
   sqlstm.occurs = (unsigned int  )0;
   sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


			return SQLCODE;
		}

		for(i = 0; i < 7; i++)
		{
			db_right_trim(szVal[i]);
		}

		MoveChrVal(temp[nCnt].szSmsSeq			, szVal[0]);
		MoveChrVal(temp[nCnt].szSrcNum			, szVal[1]);
		MoveChrVal(temp[nCnt].szCbNum			, szVal[2]);
		MoveChrVal(temp[nCnt].szSmsMsg			, szVal[3]);
		MoveChrVal(temp[nCnt].szSpamPattern1	, szVal[4]);
		MoveChrVal(temp[nCnt].szSpamPattern2	, szVal[5]);
		MoveChrVal(temp[nCnt].szSaveDt			, szVal[6]);

		nCnt++;
	}

	/* EXEC SQL CLOSE tm_sfs_sms_cur; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )143;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	memcpy(pTmSfsSms, &temp, sizeof(struct __tmsfssms_st_) * nCnt);
	*nTmSfsSmsCnt = nCnt;

	return ROK;
}

int insert_tm_sfs_stas_skt_result(TmSfsStasSktResult *szSpamData, int nCnt)
{
	int	i;
	int nInsert = 0;
	char szStrQuery[2048] = {0, };

	/* EXEC SQL savepoint stas_skt_ins; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "savepoint stas_skt_ins";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )158;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	for(i = 0; i < nCnt; i++)
	{
		if((strlen(szSpamData[i].szSrcNum) == 0) || (strlen(szSpamData[i].szSmsMsg) == 0))
			continue;

		sprintf(szStrQuery, "INSERT INTO TM_SFS_STAS_SKT_RESULT (SMS_SEQ, SRC_NUM, CB_NUM, SMS_MSG, SPAM_PATTERN1, SPAM_PATTERN2, SAVE_DT) VALUES(:v1, :v2, :v3, :v4, :v5, :v6, :v7)");

		/* EXEC SQL PREPARE stas_skt_result FROM :szStrQuery; */ 

{
  struct sqlexd sqlstm;
  sqlstm.sqlvsn = 12;
  sqlstm.arrsiz = 7;
  sqlstm.sqladtp = &sqladt;
  sqlstm.sqltdsp = &sqltds;
  sqlstm.stmt = "";
  sqlstm.iters = (unsigned int  )1;
  sqlstm.offset = (unsigned int  )173;
  sqlstm.cud = sqlcud0;
  sqlstm.sqlest = (unsigned char  *)&sqlca;
  sqlstm.sqlety = (unsigned short)4352;
  sqlstm.occurs = (unsigned int  )0;
  sqlstm.sqhstv[0] = (unsigned char  *)szStrQuery;
  sqlstm.sqhstl[0] = (unsigned long )2048;
  sqlstm.sqhsts[0] = (         int  )0;
  sqlstm.sqindv[0] = (         short *)0;
  sqlstm.sqinds[0] = (         int  )0;
  sqlstm.sqharm[0] = (unsigned long )0;
  sqlstm.sqadto[0] = (unsigned short )0;
  sqlstm.sqtdso[0] = (unsigned short )0;
  sqlstm.sqphsv = sqlstm.sqhstv;
  sqlstm.sqphsl = sqlstm.sqhstl;
  sqlstm.sqphss = sqlstm.sqhsts;
  sqlstm.sqpind = sqlstm.sqindv;
  sqlstm.sqpins = sqlstm.sqinds;
  sqlstm.sqparm = sqlstm.sqharm;
  sqlstm.sqparc = sqlstm.sqharc;
  sqlstm.sqpadto = sqlstm.sqadto;
  sqlstm.sqptdso = sqlstm.sqtdso;
  sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



		/* EXEC SQL EXECUTE stas_skt_result USING :szSpamData[i]; */ 

{
  struct sqlexd sqlstm;
  sqlstm.sqlvsn = 12;
  sqlstm.arrsiz = 7;
  sqlstm.sqladtp = &sqladt;
  sqlstm.sqltdsp = &sqltds;
  sqlstm.stmt = "";
  sqlstm.iters = (unsigned int  )1;
  sqlstm.offset = (unsigned int  )192;
  sqlstm.cud = sqlcud0;
  sqlstm.sqlest = (unsigned char  *)&sqlca;
  sqlstm.sqlety = (unsigned short)4352;
  sqlstm.occurs = (unsigned int  )0;
  sqlstm.sqhstv[0] = (unsigned char  *)szSpamData[i].szSmsSeq;
  sqlstm.sqhstl[0] = (unsigned long )19;
  sqlstm.sqhsts[0] = (         int  )0;
  sqlstm.sqindv[0] = (         short *)0;
  sqlstm.sqinds[0] = (         int  )0;
  sqlstm.sqharm[0] = (unsigned long )0;
  sqlstm.sqadto[0] = (unsigned short )0;
  sqlstm.sqtdso[0] = (unsigned short )0;
  sqlstm.sqhstv[1] = (unsigned char  *)szSpamData[i].szSrcNum;
  sqlstm.sqhstl[1] = (unsigned long )25;
  sqlstm.sqhsts[1] = (         int  )0;
  sqlstm.sqindv[1] = (         short *)0;
  sqlstm.sqinds[1] = (         int  )0;
  sqlstm.sqharm[1] = (unsigned long )0;
  sqlstm.sqadto[1] = (unsigned short )0;
  sqlstm.sqtdso[1] = (unsigned short )0;
  sqlstm.sqhstv[2] = (unsigned char  *)szSpamData[i].szCbNum;
  sqlstm.sqhstl[2] = (unsigned long )25;
  sqlstm.sqhsts[2] = (         int  )0;
  sqlstm.sqindv[2] = (         short *)0;
  sqlstm.sqinds[2] = (         int  )0;
  sqlstm.sqharm[2] = (unsigned long )0;
  sqlstm.sqadto[2] = (unsigned short )0;
  sqlstm.sqtdso[2] = (unsigned short )0;
  sqlstm.sqhstv[3] = (unsigned char  *)szSpamData[i].szSmsMsg;
  sqlstm.sqhstl[3] = (unsigned long )201;
  sqlstm.sqhsts[3] = (         int  )0;
  sqlstm.sqindv[3] = (         short *)0;
  sqlstm.sqinds[3] = (         int  )0;
  sqlstm.sqharm[3] = (unsigned long )0;
  sqlstm.sqadto[3] = (unsigned short )0;
  sqlstm.sqtdso[3] = (unsigned short )0;
  sqlstm.sqhstv[4] = (unsigned char  *)szSpamData[i].szSpamPattern1;
  sqlstm.sqhstl[4] = (unsigned long )31;
  sqlstm.sqhsts[4] = (         int  )0;
  sqlstm.sqindv[4] = (         short *)0;
  sqlstm.sqinds[4] = (         int  )0;
  sqlstm.sqharm[4] = (unsigned long )0;
  sqlstm.sqadto[4] = (unsigned short )0;
  sqlstm.sqtdso[4] = (unsigned short )0;
  sqlstm.sqhstv[5] = (unsigned char  *)szSpamData[i].szSpamPattern2;
  sqlstm.sqhstl[5] = (unsigned long )31;
  sqlstm.sqhsts[5] = (         int  )0;
  sqlstm.sqindv[5] = (         short *)0;
  sqlstm.sqinds[5] = (         int  )0;
  sqlstm.sqharm[5] = (unsigned long )0;
  sqlstm.sqadto[5] = (unsigned short )0;
  sqlstm.sqtdso[5] = (unsigned short )0;
  sqlstm.sqhstv[6] = (unsigned char  *)szSpamData[i].szSaveDt;
  sqlstm.sqhstl[6] = (unsigned long )15;
  sqlstm.sqhsts[6] = (         int  )0;
  sqlstm.sqindv[6] = (         short *)0;
  sqlstm.sqinds[6] = (         int  )0;
  sqlstm.sqharm[6] = (unsigned long )0;
  sqlstm.sqadto[6] = (unsigned short )0;
  sqlstm.sqtdso[6] = (unsigned short )0;
  sqlstm.sqphsv = sqlstm.sqhstv;
  sqlstm.sqphsl = sqlstm.sqhstl;
  sqlstm.sqphss = sqlstm.sqhsts;
  sqlstm.sqpind = sqlstm.sqindv;
  sqlstm.sqpins = sqlstm.sqinds;
  sqlstm.sqparm = sqlstm.sqharm;
  sqlstm.sqparc = sqlstm.sqharc;
  sqlstm.sqpadto = sqlstm.sqadto;
  sqlstm.sqptdso = sqlstm.sqtdso;
  sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



		if(SQLCODE != ORA_SQLOK || sqlca.sqlerrd[2] != 1)
		{
			logwrite(FL, "failed Insert : SQLCODE(%d)(%d) ORA_SQLMSG(%*s) - SEQ(%s) MINNO(%s)", SQLCODE, sqlca.sqlerrd[2], ORA_SQLMSG, szSpamData[i].szSmsSeq, szSpamData[i].szCbNum);
		}
		else
		{
			nInsert++;
		}
	}

	/* EXEC SQL commit work; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )235;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	logwrite(FL, "INSERT Count[%d] TM_SFS_STAS_SKT_RESULT OK!!!", nInsert);

	return ORA_SQLOK;
}

int count_tm_sfs_nate(char *szQuery, int *nTmSfsSmsCnt)
{
	int nCnt = 0;


	/* EXEC SQL PREPARE tm_sfs_nate_count FROM :szQuery; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )250;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqhstv[0] = (unsigned char  *)szQuery;
 sqlstm.sqhstl[0] = (unsigned long )0;
 sqlstm.sqhsts[0] = (         int  )0;
 sqlstm.sqindv[0] = (         short *)0;
 sqlstm.sqinds[0] = (         int  )0;
 sqlstm.sqharm[0] = (unsigned long )0;
 sqlstm.sqadto[0] = (unsigned short )0;
 sqlstm.sqtdso[0] = (unsigned short )0;
 sqlstm.sqphsv = sqlstm.sqhstv;
 sqlstm.sqphsl = sqlstm.sqhstl;
 sqlstm.sqphss = sqlstm.sqhsts;
 sqlstm.sqpind = sqlstm.sqindv;
 sqlstm.sqpins = sqlstm.sqinds;
 sqlstm.sqparm = sqlstm.sqharm;
 sqlstm.sqparc = sqlstm.sqharc;
 sqlstm.sqpadto = sqlstm.sqadto;
 sqlstm.sqptdso = sqlstm.sqtdso;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	/* EXEC SQL DECLARE tm_sfs_nate_count_cur CURSOR FOR tm_sfs_nate_count; */ 


	/* EXEC SQL OPEN tm_sfs_nate_count_cur; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )269;
 sqlstm.selerr = (unsigned short)1;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqcmod = (unsigned int )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}





	/* EXEC SQL FETCH tm_sfs_nate_count_cur INTO :nCnt; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )284;
 sqlstm.selerr = (unsigned short)1;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqfoff = (         int )0;
 sqlstm.sqfmod = (unsigned int )2;
 sqlstm.sqhstv[0] = (unsigned char  *)&nCnt;
 sqlstm.sqhstl[0] = (unsigned long )sizeof(int);
 sqlstm.sqhsts[0] = (         int  )0;
 sqlstm.sqindv[0] = (         short *)0;
 sqlstm.sqinds[0] = (         int  )0;
 sqlstm.sqharm[0] = (unsigned long )0;
 sqlstm.sqadto[0] = (unsigned short )0;
 sqlstm.sqtdso[0] = (unsigned short )0;
 sqlstm.sqphsv = sqlstm.sqhstv;
 sqlstm.sqphsl = sqlstm.sqhstl;
 sqlstm.sqphss = sqlstm.sqhsts;
 sqlstm.sqpind = sqlstm.sqindv;
 sqlstm.sqpins = sqlstm.sqinds;
 sqlstm.sqparm = sqlstm.sqharm;
 sqlstm.sqparc = sqlstm.sqharc;
 sqlstm.sqpadto = sqlstm.sqadto;
 sqlstm.sqptdso = sqlstm.sqtdso;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	if(SQLCODE == HSNODATA)
	{
		return RFAIL ;
	}
	else if(SQLCODE != ORA_SQLOK)
	{
		/* EXEC SQL CLOSE tm_sfs_nate_count_cur; */ 

{
  struct sqlexd sqlstm;
  sqlstm.sqlvsn = 12;
  sqlstm.arrsiz = 7;
  sqlstm.sqladtp = &sqladt;
  sqlstm.sqltdsp = &sqltds;
  sqlstm.iters = (unsigned int  )1;
  sqlstm.offset = (unsigned int  )303;
  sqlstm.cud = sqlcud0;
  sqlstm.sqlest = (unsigned char  *)&sqlca;
  sqlstm.sqlety = (unsigned short)4352;
  sqlstm.occurs = (unsigned int  )0;
  sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


		return SQLCODE;
	}

	/* EXEC SQL CLOSE tm_sfs_nate_count_cur; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )318;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	*nTmSfsSmsCnt = nCnt;

	return ROK;
}




int select_tm_sfs_sms_file(char *szQuery,char *filePath, int SELECT_CNT,char *tbName)
{
	int i,nCnt;
	char num1[13];
	char num2[13];


	/* EXEC SQL PREPARE tm_sfs_nate1 FROM :szQuery; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )333;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqhstv[0] = (unsigned char  *)szQuery;
 sqlstm.sqhstl[0] = (unsigned long )0;
 sqlstm.sqhsts[0] = (         int  )0;
 sqlstm.sqindv[0] = (         short *)0;
 sqlstm.sqinds[0] = (         int  )0;
 sqlstm.sqharm[0] = (unsigned long )0;
 sqlstm.sqadto[0] = (unsigned short )0;
 sqlstm.sqtdso[0] = (unsigned short )0;
 sqlstm.sqphsv = sqlstm.sqhstv;
 sqlstm.sqphsl = sqlstm.sqhstl;
 sqlstm.sqphss = sqlstm.sqhsts;
 sqlstm.sqpind = sqlstm.sqindv;
 sqlstm.sqpins = sqlstm.sqinds;
 sqlstm.sqparm = sqlstm.sqharm;
 sqlstm.sqparc = sqlstm.sqharc;
 sqlstm.sqpadto = sqlstm.sqadto;
 sqlstm.sqptdso = sqlstm.sqtdso;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	/* EXEC SQL DECLARE tm_sfs_nate_cur1 CURSOR FOR tm_sfs_nate1; */ 


	/* EXEC SQL OPEN tm_sfs_nate_cur1; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )352;
 sqlstm.selerr = (unsigned short)1;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqcmod = (unsigned int )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}




	for(nCnt = 0; nCnt < SELECT_CNT; )
	{
		memset(num1, 0x00, sizeof(num1));
		memset(num2, 0x00, sizeof(num2));

		/* EXEC SQL FETCH tm_sfs_nate_cur1 INTO :num1, :num2; */ 

{
  struct sqlexd sqlstm;
  sqlstm.sqlvsn = 12;
  sqlstm.arrsiz = 7;
  sqlstm.sqladtp = &sqladt;
  sqlstm.sqltdsp = &sqltds;
  sqlstm.iters = (unsigned int  )1;
  sqlstm.offset = (unsigned int  )367;
  sqlstm.selerr = (unsigned short)1;
  sqlstm.cud = sqlcud0;
  sqlstm.sqlest = (unsigned char  *)&sqlca;
  sqlstm.sqlety = (unsigned short)4352;
  sqlstm.occurs = (unsigned int  )0;
  sqlstm.sqfoff = (         int )0;
  sqlstm.sqfmod = (unsigned int )2;
  sqlstm.sqhstv[0] = (unsigned char  *)num1;
  sqlstm.sqhstl[0] = (unsigned long )13;
  sqlstm.sqhsts[0] = (         int  )0;
  sqlstm.sqindv[0] = (         short *)0;
  sqlstm.sqinds[0] = (         int  )0;
  sqlstm.sqharm[0] = (unsigned long )0;
  sqlstm.sqadto[0] = (unsigned short )0;
  sqlstm.sqtdso[0] = (unsigned short )0;
  sqlstm.sqhstv[1] = (unsigned char  *)num2;
  sqlstm.sqhstl[1] = (unsigned long )13;
  sqlstm.sqhsts[1] = (         int  )0;
  sqlstm.sqindv[1] = (         short *)0;
  sqlstm.sqinds[1] = (         int  )0;
  sqlstm.sqharm[1] = (unsigned long )0;
  sqlstm.sqadto[1] = (unsigned short )0;
  sqlstm.sqtdso[1] = (unsigned short )0;
  sqlstm.sqphsv = sqlstm.sqhstv;
  sqlstm.sqphsl = sqlstm.sqhstl;
  sqlstm.sqphss = sqlstm.sqhsts;
  sqlstm.sqpind = sqlstm.sqindv;
  sqlstm.sqpins = sqlstm.sqinds;
  sqlstm.sqparm = sqlstm.sqharm;
  sqlstm.sqparc = sqlstm.sqharc;
  sqlstm.sqpadto = sqlstm.sqadto;
  sqlstm.sqptdso = sqlstm.sqtdso;
  sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


		if(SQLCODE == HSNODATA)
		{
			break;
		}
		else if(SQLCODE != ORA_SQLOK)
		{
			/* EXEC SQL CLOSE tm_sfs_nate_cur1; */ 

{
   struct sqlexd sqlstm;
   sqlstm.sqlvsn = 12;
   sqlstm.arrsiz = 7;
   sqlstm.sqladtp = &sqladt;
   sqlstm.sqltdsp = &sqltds;
   sqlstm.iters = (unsigned int  )1;
   sqlstm.offset = (unsigned int  )390;
   sqlstm.cud = sqlcud0;
   sqlstm.sqlest = (unsigned char  *)&sqlca;
   sqlstm.sqlety = (unsigned short)4352;
   sqlstm.occurs = (unsigned int  )0;
   sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


			return SQLCODE;
		}

		wRiteSfm(filePath,num1,num2,tbName);

		nCnt++;
	}

	/* EXEC SQL CLOSE tm_sfs_nate_cur1; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )405;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}




	return ROK;
}



int insert_tm_sfs_sms(char *filePath, char *tbName)
{
	int     i;
	int nInsert = 0;
	char szStrQuery[2048] = {0, };
	FILE* in;
	char num[2][14];


	/* EXEC SQL savepoint stas_skt_ins; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "savepoint stas_skt_ins";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )420;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	if ( (in = fopen(filePath, "r")) == NULL)
	{
		printf(" Cannot open file : %s\n", filePath);

		return -1;

	}
	else{
		while( 0 < fscanf( in, "%s %s", num[0],num[1]))
		{
			sprintf(szStrQuery, "INSERT INTO %s  VALUES(:v1, :v2)",tbName);
			printf("%s %s %s\n",szStrQuery,num[0],num[1]);
			/* EXEC SQL PREPARE stas_skt_result FROM :szStrQuery; */ 

{
   struct sqlexd sqlstm;
   sqlstm.sqlvsn = 12;
   sqlstm.arrsiz = 7;
   sqlstm.sqladtp = &sqladt;
   sqlstm.sqltdsp = &sqltds;
   sqlstm.stmt = "";
   sqlstm.iters = (unsigned int  )1;
   sqlstm.offset = (unsigned int  )435;
   sqlstm.cud = sqlcud0;
   sqlstm.sqlest = (unsigned char  *)&sqlca;
   sqlstm.sqlety = (unsigned short)4352;
   sqlstm.occurs = (unsigned int  )0;
   sqlstm.sqhstv[0] = (unsigned char  *)szStrQuery;
   sqlstm.sqhstl[0] = (unsigned long )2048;
   sqlstm.sqhsts[0] = (         int  )0;
   sqlstm.sqindv[0] = (         short *)0;
   sqlstm.sqinds[0] = (         int  )0;
   sqlstm.sqharm[0] = (unsigned long )0;
   sqlstm.sqadto[0] = (unsigned short )0;
   sqlstm.sqtdso[0] = (unsigned short )0;
   sqlstm.sqphsv = sqlstm.sqhstv;
   sqlstm.sqphsl = sqlstm.sqhstl;
   sqlstm.sqphss = sqlstm.sqhsts;
   sqlstm.sqpind = sqlstm.sqindv;
   sqlstm.sqpins = sqlstm.sqinds;
   sqlstm.sqparm = sqlstm.sqharm;
   sqlstm.sqparc = sqlstm.sqharc;
   sqlstm.sqpadto = sqlstm.sqadto;
   sqlstm.sqptdso = sqlstm.sqtdso;
   sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


			/* EXEC SQL EXECUTE stas_skt_result USING :num[0],:num[1]; */ 

{
   struct sqlexd sqlstm;
   sqlstm.sqlvsn = 12;
   sqlstm.arrsiz = 7;
   sqlstm.sqladtp = &sqladt;
   sqlstm.sqltdsp = &sqltds;
   sqlstm.stmt = "";
   sqlstm.iters = (unsigned int  )1;
   sqlstm.offset = (unsigned int  )454;
   sqlstm.cud = sqlcud0;
   sqlstm.sqlest = (unsigned char  *)&sqlca;
   sqlstm.sqlety = (unsigned short)4352;
   sqlstm.occurs = (unsigned int  )0;
   sqlstm.sqhstv[0] = (unsigned char  *)num[0];
   sqlstm.sqhstl[0] = (unsigned long )14;
   sqlstm.sqhsts[0] = (         int  )0;
   sqlstm.sqindv[0] = (         short *)0;
   sqlstm.sqinds[0] = (         int  )0;
   sqlstm.sqharm[0] = (unsigned long )0;
   sqlstm.sqadto[0] = (unsigned short )0;
   sqlstm.sqtdso[0] = (unsigned short )0;
   sqlstm.sqhstv[1] = (unsigned char  *)num[1];
   sqlstm.sqhstl[1] = (unsigned long )14;
   sqlstm.sqhsts[1] = (         int  )0;
   sqlstm.sqindv[1] = (         short *)0;
   sqlstm.sqinds[1] = (         int  )0;
   sqlstm.sqharm[1] = (unsigned long )0;
   sqlstm.sqadto[1] = (unsigned short )0;
   sqlstm.sqtdso[1] = (unsigned short )0;
   sqlstm.sqphsv = sqlstm.sqhstv;
   sqlstm.sqphsl = sqlstm.sqhstl;
   sqlstm.sqphss = sqlstm.sqhsts;
   sqlstm.sqpind = sqlstm.sqindv;
   sqlstm.sqpins = sqlstm.sqinds;
   sqlstm.sqparm = sqlstm.sqharm;
   sqlstm.sqparc = sqlstm.sqharc;
   sqlstm.sqpadto = sqlstm.sqadto;
   sqlstm.sqptdso = sqlstm.sqtdso;
   sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


			if(SQLCODE != ORA_SQLOK || sqlca.sqlerrd[2] != 1)
			{
				printf("failed Insert : SQLCODE(%d)(%d) ORA_SQLMSG(%*s)\n", SQLCODE, sqlca.sqlerrd[2], ORA_SQLMSG);
			}
			else
			{
				nInsert++;
			}

		}

		fclose( in);
	}

	/* EXEC SQL commit work; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )477;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}




	return ROK;
}

int update_cds_user(char *filePath, char *tbName)
{
	int     i;
	int nInsert = 0;
	char szStrQuery[2048] = {0, };
	FILE* in;
	char num[3][14];
	char ustc1[2];
	char ustc2[2];
	char ustc3[2];
	char ustc4[2];
	char ustc5[2];
	int ustate=0;
	int tmp_ust1=0;
	int tmp_ust2=0;
	int tmp_ust3=0;
	int tmp_ust4=0;
	int tmp_ust5=0;

	memset(num,0x00,sizeof(num));

	/* EXEC SQL savepoint stas_skt_ins; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "savepoint stas_skt_ins";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )492;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	if ( (in = fopen(filePath, "r")) == NULL)
	{
									printf(" Cannot open file : %s\n", filePath);

									return -1;

	}
	else{
									sprintf(szStrQuery, "UPDATE CDS_USER SET USERSTATE=(:v1 + (select NVL(MOD(USERSTATE,2),1) from cds_user where   carrier=:v2 and min_num=:v3)) where carrier=:v4 and min_num=:v5 and  TO_CHAR(UDATE,'YYYYMMDD') < 20131022");
									while( 0 < fscanf( in, "%s %s %s %s %s %s %s", num[0],num[1],ustc1,ustc2,ustc3,ustc4,ustc5))
									{
																	if( strlen(ustc1) > 0)             
																	{
																									tmp_ust1=atoi(ustc1);
																									tmp_ust2=atoi(ustc2);
																									tmp_ust3=atoi(ustc3);
																									tmp_ust4=atoi(ustc4);
																									tmp_ust5=atoi(ustc5);
																									printf("%d %d %d %d %d\n",tmp_ust1,tmp_ust2,tmp_ust3,tmp_ust4,tmp_ust5);
																									if(tmp_ust1 == 1)
																																	ustate+=32;
																									if(tmp_ust2 == 1)
																																	ustate+=16;
																									if(tmp_ust3 == 1)
																																	ustate+=8;
																									if(tmp_ust4 == 1)
																																	ustate+=4;
																									if(tmp_ust5 == 1)
																																	ustate+=2;
																	}
																	else
																	{
																									printf("data error\n");
																									break;
																	}
																	printf("%s\n %s %s %d \n",szStrQuery,num[0],num[1],ustate);
																	/* EXEC SQL PREPARE stas_skt_result FROM :szStrQuery; */ 

{
                 struct sqlexd sqlstm;
                 sqlstm.sqlvsn = 12;
                 sqlstm.arrsiz = 7;
                 sqlstm.sqladtp = &sqladt;
                 sqlstm.sqltdsp = &sqltds;
                 sqlstm.stmt = "";
                 sqlstm.iters = (unsigned int  )1;
                 sqlstm.offset = (unsigned int  )507;
                 sqlstm.cud = sqlcud0;
                 sqlstm.sqlest = (unsigned char  *)&sqlca;
                 sqlstm.sqlety = (unsigned short)4352;
                 sqlstm.occurs = (unsigned int  )0;
                 sqlstm.sqhstv[0] = (unsigned char  *)szStrQuery;
                 sqlstm.sqhstl[0] = (unsigned long )2048;
                 sqlstm.sqhsts[0] = (         int  )0;
                 sqlstm.sqindv[0] = (         short *)0;
                 sqlstm.sqinds[0] = (         int  )0;
                 sqlstm.sqharm[0] = (unsigned long )0;
                 sqlstm.sqadto[0] = (unsigned short )0;
                 sqlstm.sqtdso[0] = (unsigned short )0;
                 sqlstm.sqphsv = sqlstm.sqhstv;
                 sqlstm.sqphsl = sqlstm.sqhstl;
                 sqlstm.sqphss = sqlstm.sqhsts;
                 sqlstm.sqpind = sqlstm.sqindv;
                 sqlstm.sqpins = sqlstm.sqinds;
                 sqlstm.sqparm = sqlstm.sqharm;
                 sqlstm.sqparc = sqlstm.sqharc;
                 sqlstm.sqpadto = sqlstm.sqadto;
                 sqlstm.sqptdso = sqlstm.sqtdso;
                 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


																	/* EXEC SQL EXECUTE stas_skt_result USING :ustate,:num[0],:num[1],:num[0],:num[1]; */ 

{
                 struct sqlexd sqlstm;
                 sqlstm.sqlvsn = 12;
                 sqlstm.arrsiz = 7;
                 sqlstm.sqladtp = &sqladt;
                 sqlstm.sqltdsp = &sqltds;
                 sqlstm.stmt = "";
                 sqlstm.iters = (unsigned int  )1;
                 sqlstm.offset = (unsigned int  )526;
                 sqlstm.cud = sqlcud0;
                 sqlstm.sqlest = (unsigned char  *)&sqlca;
                 sqlstm.sqlety = (unsigned short)4352;
                 sqlstm.occurs = (unsigned int  )0;
                 sqlstm.sqhstv[0] = (unsigned char  *)&ustate;
                 sqlstm.sqhstl[0] = (unsigned long )sizeof(int);
                 sqlstm.sqhsts[0] = (         int  )0;
                 sqlstm.sqindv[0] = (         short *)0;
                 sqlstm.sqinds[0] = (         int  )0;
                 sqlstm.sqharm[0] = (unsigned long )0;
                 sqlstm.sqadto[0] = (unsigned short )0;
                 sqlstm.sqtdso[0] = (unsigned short )0;
                 sqlstm.sqhstv[1] = (unsigned char  *)num[0];
                 sqlstm.sqhstl[1] = (unsigned long )14;
                 sqlstm.sqhsts[1] = (         int  )0;
                 sqlstm.sqindv[1] = (         short *)0;
                 sqlstm.sqinds[1] = (         int  )0;
                 sqlstm.sqharm[1] = (unsigned long )0;
                 sqlstm.sqadto[1] = (unsigned short )0;
                 sqlstm.sqtdso[1] = (unsigned short )0;
                 sqlstm.sqhstv[2] = (unsigned char  *)num[1];
                 sqlstm.sqhstl[2] = (unsigned long )14;
                 sqlstm.sqhsts[2] = (         int  )0;
                 sqlstm.sqindv[2] = (         short *)0;
                 sqlstm.sqinds[2] = (         int  )0;
                 sqlstm.sqharm[2] = (unsigned long )0;
                 sqlstm.sqadto[2] = (unsigned short )0;
                 sqlstm.sqtdso[2] = (unsigned short )0;
                 sqlstm.sqhstv[3] = (unsigned char  *)num[0];
                 sqlstm.sqhstl[3] = (unsigned long )14;
                 sqlstm.sqhsts[3] = (         int  )0;
                 sqlstm.sqindv[3] = (         short *)0;
                 sqlstm.sqinds[3] = (         int  )0;
                 sqlstm.sqharm[3] = (unsigned long )0;
                 sqlstm.sqadto[3] = (unsigned short )0;
                 sqlstm.sqtdso[3] = (unsigned short )0;
                 sqlstm.sqhstv[4] = (unsigned char  *)num[1];
                 sqlstm.sqhstl[4] = (unsigned long )14;
                 sqlstm.sqhsts[4] = (         int  )0;
                 sqlstm.sqindv[4] = (         short *)0;
                 sqlstm.sqinds[4] = (         int  )0;
                 sqlstm.sqharm[4] = (unsigned long )0;
                 sqlstm.sqadto[4] = (unsigned short )0;
                 sqlstm.sqtdso[4] = (unsigned short )0;
                 sqlstm.sqphsv = sqlstm.sqhstv;
                 sqlstm.sqphsl = sqlstm.sqhstl;
                 sqlstm.sqphss = sqlstm.sqhsts;
                 sqlstm.sqpind = sqlstm.sqindv;
                 sqlstm.sqpins = sqlstm.sqinds;
                 sqlstm.sqparm = sqlstm.sqharm;
                 sqlstm.sqparc = sqlstm.sqharc;
                 sqlstm.sqpadto = sqlstm.sqadto;
                 sqlstm.sqptdso = sqlstm.sqtdso;
                 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


																	if(SQLCODE != ORA_SQLOK || sqlca.sqlerrd[2] != 1)
																	{
																									printf("failed Insert : SQLCODE(%d)(%d) ORA_SQLMSG(%*s)\n", SQLCODE, sqlca.sqlerrd[2], ORA_SQLMSG);
																	}
																	else
																	{
																									nInsert++;
																									ustate=0;
																	}

									}

									fclose( in);
	}

	/* EXEC SQL commit work; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )561;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}




	return ROK;
}


int update_cds_user2(char *carrier, char *minnum,int ustate)
{
				int     i;
				int nInsert = 0;
				char szStrQuery[2048] = {0, };


				/* EXEC SQL savepoint stas_skt_ins; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "savepoint stas_skt_ins";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )576;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



				sprintf(szStrQuery, "UPDATE CDS_USER SET USERSTATE=:v1  where carrier=:v2 and min_num=:v3");

				/* EXEC SQL PREPARE stas_skt_result FROM :szStrQuery; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )591;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlstm.sqhstv[0] = (unsigned char  *)szStrQuery;
    sqlstm.sqhstl[0] = (unsigned long )2048;
    sqlstm.sqhsts[0] = (         int  )0;
    sqlstm.sqindv[0] = (         short *)0;
    sqlstm.sqinds[0] = (         int  )0;
    sqlstm.sqharm[0] = (unsigned long )0;
    sqlstm.sqadto[0] = (unsigned short )0;
    sqlstm.sqtdso[0] = (unsigned short )0;
    sqlstm.sqphsv = sqlstm.sqhstv;
    sqlstm.sqphsl = sqlstm.sqhstl;
    sqlstm.sqphss = sqlstm.sqhsts;
    sqlstm.sqpind = sqlstm.sqindv;
    sqlstm.sqpins = sqlstm.sqinds;
    sqlstm.sqparm = sqlstm.sqharm;
    sqlstm.sqparc = sqlstm.sqharc;
    sqlstm.sqpadto = sqlstm.sqadto;
    sqlstm.sqptdso = sqlstm.sqtdso;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



				/* EXEC SQL EXECUTE stas_skt_result USING :ustate,:carrier,:minnum; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )610;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlstm.sqhstv[0] = (unsigned char  *)&ustate;
    sqlstm.sqhstl[0] = (unsigned long )sizeof(int);
    sqlstm.sqhsts[0] = (         int  )0;
    sqlstm.sqindv[0] = (         short *)0;
    sqlstm.sqinds[0] = (         int  )0;
    sqlstm.sqharm[0] = (unsigned long )0;
    sqlstm.sqadto[0] = (unsigned short )0;
    sqlstm.sqtdso[0] = (unsigned short )0;
    sqlstm.sqhstv[1] = (unsigned char  *)carrier;
    sqlstm.sqhstl[1] = (unsigned long )0;
    sqlstm.sqhsts[1] = (         int  )0;
    sqlstm.sqindv[1] = (         short *)0;
    sqlstm.sqinds[1] = (         int  )0;
    sqlstm.sqharm[1] = (unsigned long )0;
    sqlstm.sqadto[1] = (unsigned short )0;
    sqlstm.sqtdso[1] = (unsigned short )0;
    sqlstm.sqhstv[2] = (unsigned char  *)minnum;
    sqlstm.sqhstl[2] = (unsigned long )0;
    sqlstm.sqhsts[2] = (         int  )0;
    sqlstm.sqindv[2] = (         short *)0;
    sqlstm.sqinds[2] = (         int  )0;
    sqlstm.sqharm[2] = (unsigned long )0;
    sqlstm.sqadto[2] = (unsigned short )0;
    sqlstm.sqtdso[2] = (unsigned short )0;
    sqlstm.sqphsv = sqlstm.sqhstv;
    sqlstm.sqphsl = sqlstm.sqhstl;
    sqlstm.sqphss = sqlstm.sqhsts;
    sqlstm.sqpind = sqlstm.sqindv;
    sqlstm.sqpins = sqlstm.sqinds;
    sqlstm.sqparm = sqlstm.sqharm;
    sqlstm.sqparc = sqlstm.sqharc;
    sqlstm.sqpadto = sqlstm.sqadto;
    sqlstm.sqptdso = sqlstm.sqtdso;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


				if(SQLCODE != ORA_SQLOK || sqlca.sqlerrd[2] != 1)
				{
								printf("failed Insert : SQLCODE(%d)(%d) ORA_SQLMSG(%*s)\n", SQLCODE, sqlca.sqlerrd[2], ORA_SQLMSG);
				}
				else
				{
				//				printf("SUC %s%s %d\n",carrier,minnum,ustate);	
				}


				/* EXEC SQL commit work; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )637;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


				return ROK;
}
int update_cds_user3(char *carrier, char *minnum,char *mvnocorp)
{
				int     i;
				int nInsert = 0;
				char szStrQuery[2048] = {0, };


				/* EXEC SQL savepoint stas_skt_ins; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "savepoint stas_skt_ins";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )652;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



				sprintf(szStrQuery, "UPDATE CDS_USER SET MVNOCORP=:v1  where carrier=:v2 and min_num=:v3");

				/* EXEC SQL PREPARE stas_skt_result FROM :szStrQuery; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )667;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlstm.sqhstv[0] = (unsigned char  *)szStrQuery;
    sqlstm.sqhstl[0] = (unsigned long )2048;
    sqlstm.sqhsts[0] = (         int  )0;
    sqlstm.sqindv[0] = (         short *)0;
    sqlstm.sqinds[0] = (         int  )0;
    sqlstm.sqharm[0] = (unsigned long )0;
    sqlstm.sqadto[0] = (unsigned short )0;
    sqlstm.sqtdso[0] = (unsigned short )0;
    sqlstm.sqphsv = sqlstm.sqhstv;
    sqlstm.sqphsl = sqlstm.sqhstl;
    sqlstm.sqphss = sqlstm.sqhsts;
    sqlstm.sqpind = sqlstm.sqindv;
    sqlstm.sqpins = sqlstm.sqinds;
    sqlstm.sqparm = sqlstm.sqharm;
    sqlstm.sqparc = sqlstm.sqharc;
    sqlstm.sqpadto = sqlstm.sqadto;
    sqlstm.sqptdso = sqlstm.sqtdso;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



				/* EXEC SQL EXECUTE stas_skt_result USING :mvnocorp,:carrier,:minnum; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )686;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlstm.sqhstv[0] = (unsigned char  *)mvnocorp;
    sqlstm.sqhstl[0] = (unsigned long )0;
    sqlstm.sqhsts[0] = (         int  )0;
    sqlstm.sqindv[0] = (         short *)0;
    sqlstm.sqinds[0] = (         int  )0;
    sqlstm.sqharm[0] = (unsigned long )0;
    sqlstm.sqadto[0] = (unsigned short )0;
    sqlstm.sqtdso[0] = (unsigned short )0;
    sqlstm.sqhstv[1] = (unsigned char  *)carrier;
    sqlstm.sqhstl[1] = (unsigned long )0;
    sqlstm.sqhsts[1] = (         int  )0;
    sqlstm.sqindv[1] = (         short *)0;
    sqlstm.sqinds[1] = (         int  )0;
    sqlstm.sqharm[1] = (unsigned long )0;
    sqlstm.sqadto[1] = (unsigned short )0;
    sqlstm.sqtdso[1] = (unsigned short )0;
    sqlstm.sqhstv[2] = (unsigned char  *)minnum;
    sqlstm.sqhstl[2] = (unsigned long )0;
    sqlstm.sqhsts[2] = (         int  )0;
    sqlstm.sqindv[2] = (         short *)0;
    sqlstm.sqinds[2] = (         int  )0;
    sqlstm.sqharm[2] = (unsigned long )0;
    sqlstm.sqadto[2] = (unsigned short )0;
    sqlstm.sqtdso[2] = (unsigned short )0;
    sqlstm.sqphsv = sqlstm.sqhstv;
    sqlstm.sqphsl = sqlstm.sqhstl;
    sqlstm.sqphss = sqlstm.sqhsts;
    sqlstm.sqpind = sqlstm.sqindv;
    sqlstm.sqpins = sqlstm.sqinds;
    sqlstm.sqparm = sqlstm.sqharm;
    sqlstm.sqparc = sqlstm.sqharc;
    sqlstm.sqpadto = sqlstm.sqadto;
    sqlstm.sqptdso = sqlstm.sqtdso;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


				if(SQLCODE != ORA_SQLOK || sqlca.sqlerrd[2] != 1)
				{
								printf("failed Insert : SQLCODE(%d)(%d) ORA_SQLMSG(%*s)\n", SQLCODE, sqlca.sqlerrd[2], ORA_SQLMSG);
				}
				else
				{
								//printf("SUC %s%s %s\n",carrier,minnum,mvnocorp);	
				}


				/* EXEC SQL commit work; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )713;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


				return ROK;
}




int select_cdsuser(char *carrier,char *minnum)
{
				char szQuery[2048] = {0, };
        int  ustate=0;
				sprintf(szQuery, "%s%s%s%s'","select NVL(USERSTATE,1) from cds_user where carrier='",carrier,"' and min_num='",minnum);

				/* EXEC SQL PREPARE select_cds_user FROM :szQuery; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )728;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlstm.sqhstv[0] = (unsigned char  *)szQuery;
    sqlstm.sqhstl[0] = (unsigned long )2048;
    sqlstm.sqhsts[0] = (         int  )0;
    sqlstm.sqindv[0] = (         short *)0;
    sqlstm.sqinds[0] = (         int  )0;
    sqlstm.sqharm[0] = (unsigned long )0;
    sqlstm.sqadto[0] = (unsigned short )0;
    sqlstm.sqtdso[0] = (unsigned short )0;
    sqlstm.sqphsv = sqlstm.sqhstv;
    sqlstm.sqphsl = sqlstm.sqhstl;
    sqlstm.sqphss = sqlstm.sqhsts;
    sqlstm.sqpind = sqlstm.sqindv;
    sqlstm.sqpins = sqlstm.sqinds;
    sqlstm.sqparm = sqlstm.sqharm;
    sqlstm.sqparc = sqlstm.sqharc;
    sqlstm.sqpadto = sqlstm.sqadto;
    sqlstm.sqptdso = sqlstm.sqtdso;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



				/* EXEC SQL DECLARE select_cds_user_cur CURSOR FOR select_cds_user; */ 


				/* EXEC SQL OPEN select_cds_user_cur; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )747;
    sqlstm.selerr = (unsigned short)1;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlstm.sqcmod = (unsigned int )0;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



								/* EXEC SQL FETCH select_cds_user_cur INTO :ustate; */ 

{
        struct sqlexd sqlstm;
        sqlstm.sqlvsn = 12;
        sqlstm.arrsiz = 7;
        sqlstm.sqladtp = &sqladt;
        sqlstm.sqltdsp = &sqltds;
        sqlstm.iters = (unsigned int  )1;
        sqlstm.offset = (unsigned int  )762;
        sqlstm.selerr = (unsigned short)1;
        sqlstm.cud = sqlcud0;
        sqlstm.sqlest = (unsigned char  *)&sqlca;
        sqlstm.sqlety = (unsigned short)4352;
        sqlstm.occurs = (unsigned int  )0;
        sqlstm.sqfoff = (         int )0;
        sqlstm.sqfmod = (unsigned int )2;
        sqlstm.sqhstv[0] = (unsigned char  *)&ustate;
        sqlstm.sqhstl[0] = (unsigned long )sizeof(int);
        sqlstm.sqhsts[0] = (         int  )0;
        sqlstm.sqindv[0] = (         short *)0;
        sqlstm.sqinds[0] = (         int  )0;
        sqlstm.sqharm[0] = (unsigned long )0;
        sqlstm.sqadto[0] = (unsigned short )0;
        sqlstm.sqtdso[0] = (unsigned short )0;
        sqlstm.sqphsv = sqlstm.sqhstv;
        sqlstm.sqphsl = sqlstm.sqhstl;
        sqlstm.sqphss = sqlstm.sqhsts;
        sqlstm.sqpind = sqlstm.sqindv;
        sqlstm.sqpins = sqlstm.sqinds;
        sqlstm.sqparm = sqlstm.sqharm;
        sqlstm.sqparc = sqlstm.sqharc;
        sqlstm.sqpadto = sqlstm.sqadto;
        sqlstm.sqptdso = sqlstm.sqtdso;
        sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


								if(SQLCODE != ORA_SQLOK)
								{
												/* EXEC SQL CLOSE select_cds_user_cur; */ 

{
            struct sqlexd sqlstm;
            sqlstm.sqlvsn = 12;
            sqlstm.arrsiz = 7;
            sqlstm.sqladtp = &sqladt;
            sqlstm.sqltdsp = &sqltds;
            sqlstm.iters = (unsigned int  )1;
            sqlstm.offset = (unsigned int  )781;
            sqlstm.cud = sqlcud0;
            sqlstm.sqlest = (unsigned char  *)&sqlca;
            sqlstm.sqlety = (unsigned short)4352;
            sqlstm.occurs = (unsigned int  )0;
            sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


												return -1;
								}


				/* EXEC SQL CLOSE select_cds_user_cur; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )796;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}




				return ustate;
}



int select_cust(char *custnumber,int tablenum)
{
	char szQuery[2048] = {0, };
	int  ustate=0;
	sprintf(szQuery, "%s%d%s%s%s","select count(cust_num)  from tm_sfs_cust_0",tablenum+1,  " where cust_num='",custnumber,"'");

	/* EXEC SQL PREPARE select_cust_user FROM :szQuery; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )811;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqhstv[0] = (unsigned char  *)szQuery;
 sqlstm.sqhstl[0] = (unsigned long )2048;
 sqlstm.sqhsts[0] = (         int  )0;
 sqlstm.sqindv[0] = (         short *)0;
 sqlstm.sqinds[0] = (         int  )0;
 sqlstm.sqharm[0] = (unsigned long )0;
 sqlstm.sqadto[0] = (unsigned short )0;
 sqlstm.sqtdso[0] = (unsigned short )0;
 sqlstm.sqphsv = sqlstm.sqhstv;
 sqlstm.sqphsl = sqlstm.sqhstl;
 sqlstm.sqphss = sqlstm.sqhsts;
 sqlstm.sqpind = sqlstm.sqindv;
 sqlstm.sqpins = sqlstm.sqinds;
 sqlstm.sqparm = sqlstm.sqharm;
 sqlstm.sqparc = sqlstm.sqharc;
 sqlstm.sqpadto = sqlstm.sqadto;
 sqlstm.sqptdso = sqlstm.sqtdso;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	/* EXEC SQL DECLARE select_cust_user_cur CURSOR FOR select_cust_user; */ 


	/* EXEC SQL OPEN select_cust_user_cur; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.stmt = "";
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )830;
 sqlstm.selerr = (unsigned short)1;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqcmod = (unsigned int )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	/* EXEC SQL FETCH select_cust_user_cur INTO :ustate; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )845;
 sqlstm.selerr = (unsigned short)1;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlstm.sqfoff = (         int )0;
 sqlstm.sqfmod = (unsigned int )2;
 sqlstm.sqhstv[0] = (unsigned char  *)&ustate;
 sqlstm.sqhstl[0] = (unsigned long )sizeof(int);
 sqlstm.sqhsts[0] = (         int  )0;
 sqlstm.sqindv[0] = (         short *)0;
 sqlstm.sqinds[0] = (         int  )0;
 sqlstm.sqharm[0] = (unsigned long )0;
 sqlstm.sqadto[0] = (unsigned short )0;
 sqlstm.sqtdso[0] = (unsigned short )0;
 sqlstm.sqphsv = sqlstm.sqhstv;
 sqlstm.sqphsl = sqlstm.sqhstl;
 sqlstm.sqphss = sqlstm.sqhsts;
 sqlstm.sqpind = sqlstm.sqindv;
 sqlstm.sqpins = sqlstm.sqinds;
 sqlstm.sqparm = sqlstm.sqharm;
 sqlstm.sqparc = sqlstm.sqharc;
 sqlstm.sqpadto = sqlstm.sqadto;
 sqlstm.sqptdso = sqlstm.sqtdso;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


	if(SQLCODE != ORA_SQLOK)
	{
		/* EXEC SQL CLOSE select_cust_user_cur; */ 

{
  struct sqlexd sqlstm;
  sqlstm.sqlvsn = 12;
  sqlstm.arrsiz = 7;
  sqlstm.sqladtp = &sqladt;
  sqlstm.sqltdsp = &sqltds;
  sqlstm.iters = (unsigned int  )1;
  sqlstm.offset = (unsigned int  )864;
  sqlstm.cud = sqlcud0;
  sqlstm.sqlest = (unsigned char  *)&sqlca;
  sqlstm.sqlety = (unsigned short)4352;
  sqlstm.occurs = (unsigned int  )0;
  sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


		return -1;
	}


	/* EXEC SQL CLOSE select_cust_user_cur; */ 

{
 struct sqlexd sqlstm;
 sqlstm.sqlvsn = 12;
 sqlstm.arrsiz = 7;
 sqlstm.sqladtp = &sqladt;
 sqlstm.sqltdsp = &sqltds;
 sqlstm.iters = (unsigned int  )1;
 sqlstm.offset = (unsigned int  )879;
 sqlstm.cud = sqlcud0;
 sqlstm.sqlest = (unsigned char  *)&sqlca;
 sqlstm.sqlety = (unsigned short)4352;
 sqlstm.occurs = (unsigned int  )0;
 sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}




	return ustate;
}

void select_msg(char *table_name, char *file_name, char *select_day)
{
    char szQuery[2048] = {0, };
    char sms_masage[201];
	char srcnum[25];
	char cbnum[25];
	char rcv_dt[15];
	char save_dt[15];
	int sms_leng;

	FILE *mfp = NULL;

    sprintf(szQuery, "%s%s%s","select SAVE_DT, RCV_TIME, SRC_NUM, CB_NUM, replace(replace(MSG, chr(10),' '),chr(13),' '), length(MSG) from TM_SFS_SPAM_DATA where save_dt like '", select_day, "%' and SPAM_TYPE=2");

	memset(sms_masage,0x00,201);
	memset(srcnum,0x00,25);
	memset(cbnum,0x00,25);
	memset(rcv_dt,0x00,15);
	memset(save_dt,0x00,15);

    /* EXEC SQL PREPARE select_msg_user FROM :szQuery; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )894;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlstm.sqhstv[0] = (unsigned char  *)szQuery;
    sqlstm.sqhstl[0] = (unsigned long )2048;
    sqlstm.sqhsts[0] = (         int  )0;
    sqlstm.sqindv[0] = (         short *)0;
    sqlstm.sqinds[0] = (         int  )0;
    sqlstm.sqharm[0] = (unsigned long )0;
    sqlstm.sqadto[0] = (unsigned short )0;
    sqlstm.sqtdso[0] = (unsigned short )0;
    sqlstm.sqphsv = sqlstm.sqhstv;
    sqlstm.sqphsl = sqlstm.sqhstl;
    sqlstm.sqphss = sqlstm.sqhsts;
    sqlstm.sqpind = sqlstm.sqindv;
    sqlstm.sqpins = sqlstm.sqinds;
    sqlstm.sqparm = sqlstm.sqharm;
    sqlstm.sqparc = sqlstm.sqharc;
    sqlstm.sqpadto = sqlstm.sqadto;
    sqlstm.sqptdso = sqlstm.sqtdso;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



    /* EXEC SQL DECLARE select_msg_user_cur CURSOR FOR select_msg_user; */ 


    /* EXEC SQL OPEN select_msg_user_cur; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.stmt = "";
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )913;
    sqlstm.selerr = (unsigned short)1;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlstm.sqcmod = (unsigned int )0;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}



	if ((mfp = fopen(file_name, "a")) == NULL) {
        printf("tmp ftp file Open Fail [%s]\n", file_name);
        return;
    }

    while(1)
	{
        /* EXEC SQL FETCH select_msg_user_cur INTO :save_dt,:rcv_dt,:srcnum,:cbnum,:sms_masage,:sms_leng; */ 

{
        struct sqlexd sqlstm;
        sqlstm.sqlvsn = 12;
        sqlstm.arrsiz = 7;
        sqlstm.sqladtp = &sqladt;
        sqlstm.sqltdsp = &sqltds;
        sqlstm.iters = (unsigned int  )1;
        sqlstm.offset = (unsigned int  )928;
        sqlstm.selerr = (unsigned short)1;
        sqlstm.cud = sqlcud0;
        sqlstm.sqlest = (unsigned char  *)&sqlca;
        sqlstm.sqlety = (unsigned short)4352;
        sqlstm.occurs = (unsigned int  )0;
        sqlstm.sqfoff = (         int )0;
        sqlstm.sqfmod = (unsigned int )2;
        sqlstm.sqhstv[0] = (unsigned char  *)save_dt;
        sqlstm.sqhstl[0] = (unsigned long )15;
        sqlstm.sqhsts[0] = (         int  )0;
        sqlstm.sqindv[0] = (         short *)0;
        sqlstm.sqinds[0] = (         int  )0;
        sqlstm.sqharm[0] = (unsigned long )0;
        sqlstm.sqadto[0] = (unsigned short )0;
        sqlstm.sqtdso[0] = (unsigned short )0;
        sqlstm.sqhstv[1] = (unsigned char  *)rcv_dt;
        sqlstm.sqhstl[1] = (unsigned long )15;
        sqlstm.sqhsts[1] = (         int  )0;
        sqlstm.sqindv[1] = (         short *)0;
        sqlstm.sqinds[1] = (         int  )0;
        sqlstm.sqharm[1] = (unsigned long )0;
        sqlstm.sqadto[1] = (unsigned short )0;
        sqlstm.sqtdso[1] = (unsigned short )0;
        sqlstm.sqhstv[2] = (unsigned char  *)srcnum;
        sqlstm.sqhstl[2] = (unsigned long )25;
        sqlstm.sqhsts[2] = (         int  )0;
        sqlstm.sqindv[2] = (         short *)0;
        sqlstm.sqinds[2] = (         int  )0;
        sqlstm.sqharm[2] = (unsigned long )0;
        sqlstm.sqadto[2] = (unsigned short )0;
        sqlstm.sqtdso[2] = (unsigned short )0;
        sqlstm.sqhstv[3] = (unsigned char  *)cbnum;
        sqlstm.sqhstl[3] = (unsigned long )25;
        sqlstm.sqhsts[3] = (         int  )0;
        sqlstm.sqindv[3] = (         short *)0;
        sqlstm.sqinds[3] = (         int  )0;
        sqlstm.sqharm[3] = (unsigned long )0;
        sqlstm.sqadto[3] = (unsigned short )0;
        sqlstm.sqtdso[3] = (unsigned short )0;
        sqlstm.sqhstv[4] = (unsigned char  *)sms_masage;
        sqlstm.sqhstl[4] = (unsigned long )201;
        sqlstm.sqhsts[4] = (         int  )0;
        sqlstm.sqindv[4] = (         short *)0;
        sqlstm.sqinds[4] = (         int  )0;
        sqlstm.sqharm[4] = (unsigned long )0;
        sqlstm.sqadto[4] = (unsigned short )0;
        sqlstm.sqtdso[4] = (unsigned short )0;
        sqlstm.sqhstv[5] = (unsigned char  *)&sms_leng;
        sqlstm.sqhstl[5] = (unsigned long )sizeof(int);
        sqlstm.sqhsts[5] = (         int  )0;
        sqlstm.sqindv[5] = (         short *)0;
        sqlstm.sqinds[5] = (         int  )0;
        sqlstm.sqharm[5] = (unsigned long )0;
        sqlstm.sqadto[5] = (unsigned short )0;
        sqlstm.sqtdso[5] = (unsigned short )0;
        sqlstm.sqphsv = sqlstm.sqhstv;
        sqlstm.sqphsl = sqlstm.sqhstl;
        sqlstm.sqphss = sqlstm.sqhsts;
        sqlstm.sqpind = sqlstm.sqindv;
        sqlstm.sqpins = sqlstm.sqinds;
        sqlstm.sqparm = sqlstm.sqharm;
        sqlstm.sqparc = sqlstm.sqharc;
        sqlstm.sqpadto = sqlstm.sqadto;
        sqlstm.sqptdso = sqlstm.sqtdso;
        sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


        if(SQLCODE != ORA_SQLOK)
        {
            /* EXEC SQL CLOSE select_msg_user_cur; */ 

{
            struct sqlexd sqlstm;
            sqlstm.sqlvsn = 12;
            sqlstm.arrsiz = 7;
            sqlstm.sqladtp = &sqladt;
            sqlstm.sqltdsp = &sqltds;
            sqlstm.iters = (unsigned int  )1;
            sqlstm.offset = (unsigned int  )967;
            sqlstm.cud = sqlcud0;
            sqlstm.sqlest = (unsigned char  *)&sqlca;
            sqlstm.sqlety = (unsigned short)4352;
            sqlstm.occurs = (unsigned int  )0;
            sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


            return -1;
        }

		// printf("[%s][%s][%s][%s][%s][%d]\n", save_dt,rcv_dt,srcnum,cbnum,sms_masage,sms_leng);
		fprintf(mfp, "%c%s%c%s%c%s%c%s%c%s%c%c%d%c%c%d%c%d%c%c%c\n", 
			0x02, save_dt, 0x02, rcv_dt, 0x02, srcnum, 0x02, cbnum, 0x02, sms_masage, 0x02, 0x02, 1, 0x02, 0x02, sms_leng, 0x02, 1, 0x02, 0x02);

		memset(sms_masage,0x00,201);
		memset(srcnum,0x00,25);
		memset(cbnum,0x00,25);
		memset(rcv_dt,0x00,15);
		memset(save_dt,0x00,15);
	}

    /* EXEC SQL CLOSE select_msg_user_cur; */ 

{
    struct sqlexd sqlstm;
    sqlstm.sqlvsn = 12;
    sqlstm.arrsiz = 7;
    sqlstm.sqladtp = &sqladt;
    sqlstm.sqltdsp = &sqltds;
    sqlstm.iters = (unsigned int  )1;
    sqlstm.offset = (unsigned int  )982;
    sqlstm.cud = sqlcud0;
    sqlstm.sqlest = (unsigned char  *)&sqlca;
    sqlstm.sqlety = (unsigned short)4352;
    sqlstm.occurs = (unsigned int  )0;
    sqlcxt((void **)0, &sqlctx, &sqlstm, &sqlfpn);
}


	fclose(mfp);
    return;
}
