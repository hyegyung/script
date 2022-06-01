#include <stdio.h>
#include <ctype.h>

#define logmsg(a,...)	printlog(a, __FILE__, __LINE__, ##__VA_ARGS__)
#define BUFFSIZE 256
#define LISTSIZE 20480


typedef struct LIST
{
	int count;
	char text[LISTSIZE][BUFFSIZE];
	LIST()
	{
		count=0;
		memset(text, 0x00, sizeof(text));
	}
};

struct INSERTTYPE
{
	struct LIST originlist;
	struct LIST dblist;
	struct LIST whitelist;
	struct LIST inputlist;
	struct LIST rejectlist;
	struct LIST insertlist;
};

struct INSERTTYPE SPAM_URL;
struct INSERTTYPE SPAM_SENTENCE;
struct INSERTTYPE SPAM_STRING;


int checkSC(char *str, int len);

int printList(struct LIST *list);
int urlParseList(struct INSERTTYPE *insertType);
int selectList(char *query, struct LIST *list);
int readList(char *file, struct LIST *list);
int makeinsertList(int type, struct INSERTTYPE *insertType);

int selectSubMenu(int type, struct INSERTTYPE *list);
int selectMainMenu(void);

