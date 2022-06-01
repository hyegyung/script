#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <sys/epoll.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <unistd.h>
#include <time.h>
#include <pthread.h>
#include <sys/poll.h>

#define URLPARSER_VERSION 0x01

static struct linger 			s_linger_option;
static int				s_val=1;

char gIp[16];
int gPort;
int gThreadCount;
int gTps;
int gTime;
int gTimeOutCount;

typedef struct _incross_tmr
{
	long long jiffies_base;
	long long jiffies_prev;
	long long jiffies_curr;
} incross_tmr_t;

void incross_timer_init(incross_tmr_t *ptmr)
{
	long long tv_long;
		struct timeval tv;
		
		gettimeofday(&tv, NULL);
		tv_long = tv.tv_sec*1000LL + (tv.tv_usec/1000LL);
		
		ptmr->jiffies_base = ptmr->jiffies_prev = ptmr->jiffies_curr = tv_long;;
}

void epoll_sleep(long timeout)
{
	struct timespec req, rem;

	req.tv_sec = timeout/1000L;
	req.tv_nsec = 1000000L * (timeout % 1000L);
	while (nanosleep(&req, &rem) < 0 && errno == EINTR)
	{
		req = rem;
	}
}

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

int load_config()
{
	FILE *pfd;
	char config_file[1024];
	char buf[1024];
	char *pbuf;
	char *ptr;
//	struct stat file_info;

	memset(config_file, 0x00, sizeof(config_file));
	memset(buf, 0x00, sizeof(buf));

	snprintf(config_file, sizeof(config_file), "%s", "urltest.cfg");

#if 0
	if((stat(config_file, &file_info)) < 0)
	{
		fprintf(stderr, "config file error (err:[%d])\n", errno);
		return -1;
	}
#endif

	pfd = fopen(config_file, "r");
	if(pfd == 0 || pfd == NULL) return -1;

	while((pbuf = fgets(buf, sizeof(buf), pfd)) != NULL)
	{
		if(feof(pfd))
		{
			break;
		}
		if(!strncmp(pbuf, "#", 1))
		{
			memset( buf, 0x00, sizeof(buf));
			continue;
		}
		else if(!strncmp(pbuf, "ip", 2))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				ptr = ptr+1;
				whole_trim(ptr, "\t\n ");
				memset(gIp, 0x00, sizeof(gIp));
				strncpy(gIp, ptr, strlen(ptr));
			}
		}
		else if(!strncmp(pbuf, "port", 4))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				gPort = atoi(ptr+1);
			}

		}
		else if(!strncmp(pbuf, "thread_count", 12))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				gThreadCount = atoi(ptr+1);
			}

		}	else if(!strncmp(pbuf, "TPS", 3))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				gTps = atoi(ptr+1);
			}

		}	else if(!strncmp(pbuf, "time", 4))
		{
			if((ptr = strchr(pbuf, '=')) != NULL)
			{
				gTime = atoi(ptr+1);
			}

		}
		memset(buf, 0, sizeof(buf));
	}
	fclose(pfd);

	gTimeOutCount = 0;
	return 0;
}

long incross_tmr_elapsed(incross_tmr_t *ptmr)
{
	long delta;
	long long tv_long;
	struct timeval tv;

retry:
	// recalc tv_long
		gettimeofday(&tv, NULL);
		tv_long = tv.tv_sec*1000LL + (tv.tv_usec/1000LL);
		if (ptmr->jiffies_base == 0LL)
		{
			ptmr->jiffies_base = tv_long;
		}
	
		ptmr->jiffies_prev = ptmr->jiffies_curr;
		ptmr->jiffies_curr = tv_long - ptmr->jiffies_base;
		delta = ptmr->jiffies_curr - ptmr->jiffies_prev;
		if (delta < 0L || delta > 5000L)
		{
			ptmr->jiffies_base = 0LL;
				goto retry;
		}
	
		return delta;
}

typedef enum url_packet_type_e_ {
	URL_REQUEST		=	0x0001,
	URL_RESPONSE	=	0x0002,
	URL_NODATA		=	0x0003
}url_packet_type_e;

#define offsetof(struct, field) ((int)((char *)&((struct *)0)->field))

#pragma pack(1)

typedef struct url_header_t_
{
	unsigned char 	version;
	short int 		seqnum;
	unsigned char	reserv;
}url_header_t;

typedef struct url_body_t_
{
	short int type;
	short int len;
	char value[2048];
}url_body_t;
#pragma pack()

int HSwrite(int fd, char *buff, int len)
{
	char 	*cp;
	int 	ret,sz, w;
	time_t 	st; 
	
	for(sz = 0, cp = buff, w = len, st=time(NULL)+5; sz < len; ) {
		if(st < time(NULL)) break;
		errno = 0;
		ret = (int)write(fd, cp, (size_t)w);
		if(ret < 0) { 
			if(errno == EINTR) continue;
			sz = -1; 
			break; 
		}
		sz += ret;
		cp = buff + sz;
		w  = len - sz;
	}

	return sz;
}

int HSread(struct pollfd pfd, char *buff, int len, int tmout)
{
	int ret = 0;

	while(1)
	{
		if(poll(&pfd, 1, tmout) > 0)
		{
			if((pfd.revents&POLLERR)==POLLERR || (pfd.revents&POLLHUP)==POLLHUP)
			{
				return -1;
			}
			else if((pfd.revents & POLLIN) == POLLIN)
			{
				ret = read(pfd.fd, buff, len);
				if(ret <= 0)
				{
					return -1;
				}
				return ret;
			}
		}
	}
}


int epoll_connect_block_mode()
{
	
	int connect_fd = 0;
	int result = 0;
	
	struct sockaddr_in connect_addr;


	int val=0;
	socklen_t val_len = sizeof(val);

	if((connect_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	{
		return -1;
	}

	memset(&connect_addr, 0x00, sizeof(connect_addr));
	
	connect_addr.sin_family = AF_INET;
	//connect_addr.sin_addr.s_addr = inet_addr("150.2.16.239");
	connect_addr.sin_addr.s_addr = inet_addr(gIp);
	connect_addr.sin_port = htons(gPort);

	setsockopt(connect_fd, SOL_SOCKET, SO_LINGER, &s_linger_option, sizeof(s_linger_option));

	setsockopt(connect_fd, SOL_SOCKET, SO_KEEPALIVE,&s_val, sizeof(int));


	result = connect(connect_fd, (struct sockaddr *)&connect_addr, sizeof(struct sockaddr));

	if(result == 0)
	{
		return connect_fd;
	}


	else
	{
		return 0;
	}
		
	return connect_fd;
}




int get_url_from_javaurl(int fd, char* msg, int thread_idx, char* url, int* urllen)
{
	static short int url_seqno=0;
	char buf[2048] = "";
	memset(buf, 0x00, sizeof(buf));

	int len = strlen(msg);
	int seqnum = 0;
	*urllen = 0;

	url_header_t* url_header = (url_header_t*)buf;
	url_body_t*	  url_body = (url_body_t*)(url_header+1);

	url_header->seqnum  = htons(url_seqno++);

	url_header->version = URLPARSER_VERSION;

	url_body->type = htons(URL_REQUEST);
	url_body->len = htons(len);
	memcpy(url_body->value, msg, len);

#if 1

	struct pollfd pfd;

	pfd.fd = fd;
	pfd.events = (short)(POLLIN | POLLERR | POLLHUP);

	int send_length = sizeof(url_header_t) + offsetof(url_body_t, value) + len;


	if(send_length != HSwrite(fd, buf, send_length))
	//if(send_length != send(fd, buf, send_length, 0))
	//if(send_length != epoll_send_socket(&g_session_info[fd],
	//	buf,
	//	send_length))
	{
		return 0;
	}

	memset(buf, 0x00, sizeof(buf));

	len = HSread(pfd, buf, sizeof(url_header_t), 500);
	//len = read(fd, buf, sizeof(url_header_t));

	if(len <= 0)
	{
		return 0;
	}

	len += HSread(pfd, buf+len, 4, 500);
	//len += read(fd, buf+len, 4);
	if(len <= 0)
	{
		return 0;
	}

	url_header_t* pheader = (url_header_t*)buf;
	url_body_t* pbody = (url_body_t*)(pheader+1);

	short int command_id = ntohs(pbody->type);

	if(URL_RESPONSE == command_id)
	{
		//len += HSread(pfd, buf+len, ntohs(pbody->len), 500);
		len += read(fd, buf+len, ntohs(pbody->len));

		strcpy(url, pbody->value);
		*urllen = strlen(url);
	}

	else
		*urllen = 0;
	

#endif

	return 0;
}

void *t_function(void *arg)
{	
	int i=0;
	int fd = epoll_connect_block_mode();

	char url[1024]="";
	int	 urllen=0;

	long time_elapsed = 0;
	incross_tmr_t tmr;
	incross_timer_init(&tmr);

	int loopCount=0;
	int tps = gTps / gThreadCount;

	for(loopCount=0; loopCount < gTime; loopCount ++) // 5분동안 
	{
		time_elapsed = incross_tmr_elapsed(&tmr);

		for(i=0; i<tps; i++) // thread 1개당 1초에 발송할 횟수 
		{
			get_url_from_javaurl(fd, "abc abc abc.co.kr", 0, url, &urllen);
		}

		time_elapsed = incross_tmr_elapsed(&tmr);

		if(time_elapsed < 1000)
		{
			//printf("[%d][%d][%d]\n", tps, 1000-time_elapsed, pthread_self());
			printf("send[%d], timeout[%d], sleep_time[%d]\n", tps, gTimeOutCount, 1001-time_elapsed);
			epoll_sleep(1000 - time_elapsed);
		}
		else
		{
			printf("Warning Incread Send Thread count!!!\n");
			gTimeOutCount++;
			epoll_sleep(10);
		}
	}
	printf("end\n");
}

int main()
{
	pthread_t p_thread;

	int i = 0;
	int status;

	char url[1024]="";
	int	 urllen=0;
	char* line_p;
	char logmsg[2048];

	char line[256]; 
	memset(line, 0x00, sizeof(line));

	FILE *file;
	if((file = fopen("list.txt", "r")) == NULL)
	{
		printf("파일 읽기 오류! urllist.txt 파일이 필요합니다.\n");
		return 0;
	}

	FILE *output = fopen("result.txt", "w");

	load_config();

	printf("##########################\n");
	printf("##      URL PARSER      ##\n");
	printf("##########################\n");
	printf("IP[%s]\n", gIp);
	printf("Port[%d]\n", gPort);
	printf("##########################\n");
	printf("연결 중......\n");
	int fd = epoll_connect_block_mode();
	printf("연결 성공!\n");
	printf("##########################\n");

	printf("분석 시작.....\n");
	while(fgets(line, sizeof(line), file) != NULL)
	{
		memset(url, 0x00, sizeof(url));
		memset(logmsg, 0x00, sizeof(logmsg));
		if((line_p = strchr(line, '\n')) != NULL)*line_p ='\0';
		get_url_from_javaurl(fd, line, 0, url, &urllen);	
		if(strlen(url) > 0)
		{
		sprintf(logmsg, "%s\t%s\n", url, line);
		printf("%-20s\t%s\n", url, line);
		fwrite(logmsg, strlen(logmsg), 1, output); 
		}
		else
			printf("\t%s\n", line);

		epoll_sleep(1);
	}

	fclose(file);
	fclose(output);
	printf("분석 종료 :: result.txt 생성\n");
}
