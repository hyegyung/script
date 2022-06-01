#include "skt_table.h"
#define USER_STATE_CHARGING_AGREE                                       (0x0001<<0)  // 1 ��Ű����̿� ����
#define USER_STATE_EXCEED_LIMIT                                                 (0x0001<<1)  // 2 ������ ��ȭ�� �ѵ� ������
#define USER_STATE_INTERNET_CUTOFF_TING                         (0x0001<<2)  // 4 Ting ���� ���ͳ� ����
#define USER_STATE_INTERNET_CUTOFF_ADULT                (0x0001<<3)  // 8 ���� ���� ���ͳ� ����
#define USER_STATE_PRE_CHARGING                                         (0x0001<<4)  // 16 �úθ�Ƚ� ����(�ǽð�����)
#define USER_STATE_HALT                                                                         (0x0001<<5)  // 32 �Ͻ����� �����
#define USER_STATE_NON_DB_DATA                                          (0x0001<<31)  // 2^31 ���� ����


#define MAX_USERS 63


void set_select_date(char *szStartTime, char *szEndTime, int nIdx)
{
	   char szBeday[8], szCuday[8];

	   memset(szBeday, 0x00, sizeof(szBeday));
	   memset(szCuday, 0x00, sizeof(szCuday));

	   get_yday(szBeday);
	   get_tday(szCuday);

	   switch(nIdx)
	   {
			 case 0:
				    sprintf(szStartTime, "%s%s%s", szBeday, "00", "0000");
				    sprintf(szEndTime, "%s%s%s", szBeday, "03", "0000");
				    break;

			 case 1:
				    sprintf(szStartTime, "%s%s%s", szBeday, "03", "0000");
				    sprintf(szEndTime, "%s%s%s", szBeday, "06", "0000");
				    break;

			 case 2:
				    sprintf(szStartTime, "%s%s%s", szBeday, "06", "0000");
				    sprintf(szEndTime, "%s%s%s", szBeday, "09", "0000");
				    break;

			 case 3:
				    sprintf(szStartTime, "%s%s%s", szBeday, "09", "0000");
				    sprintf(szEndTime, "%s%s%s", szBeday, "12", "0000");
				    break;

			 case 4:
				    sprintf(szStartTime, "%s%s%s", szBeday, "12", "0000");
				    sprintf(szEndTime, "%s%s%s", szBeday, "15", "0000");
				    break;

			 case 5:
				    sprintf(szStartTime, "%s%s%s", szBeday, "15", "0000");
				    sprintf(szEndTime, "%s%s%s", szBeday, "18", "0000");
				    break;

			 case 6:
				    sprintf(szStartTime, "%s%s%s", szBeday, "18", "0000");
				    sprintf(szEndTime, "%s%s%s", szBeday, "21", "0000");
				    break;

			 case 7:
					sprintf(szStartTime, "%s%s%s", szBeday, "21", "0000");
					sprintf(szEndTime, "%s%s%s", szCuday, "00", "0000");
					break;

			 default:
					sprintf(szStartTime, "%s%s", szBeday, "000000");
					sprintf(szEndTime, "%s%s", szCuday, "000000");
					break;
	   }
}

int main(int argc, char *argv[])
{
	int i, nIdx, nTimeIdx, nRet, k;
	int nCnt = 0;
	int s_count=0;
	char szQuery[MAX_SIZE];
	char szTableName[MAX_SIZE];
	char filePath[256];
	char file_name[256];
	char szDay[16];
	FILE* in;
	int ustate = 0;
	char num[9][16];
    char cmd[128];
    long long int custnum;
    char table_name[4];

	nRet = connect_db("oraasfs/oraasfs2301@ASFS");
	if(nRet != ROK)
	{
		return RFAIL;
	}

	memset(szDay, 0x00, sizeof(szDay));
	get_yesterday(szDay);

    for(k = 1;k < 257;k++)
	{
		sprintf(table_name, "%03d", k);
		sprintf(file_name, "/home/asfs/GET_SPAM_MSG/msg/spam_%s.txt", szDay);
		select_msg(table_name, file_name, szDay); 

		if( (k%10) == 0 ) {
			sleep(5);
		}
	}

	nRet = disconnect_db();
	if(nRet != ROK)
	{
		return RFAIL;
	}
	return ROK;
}
