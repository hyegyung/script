#include <stdio.h>

#include "urlparser.h"

#define URLPARSER_VERSION 0x01

static struct linger            s_linger_option;
static int              s_val=1;

typedef enum url_packet_type_e_ {
	URL_REQUEST     =   0x0001,
	URL_RESPONSE    =   0x0002,
	URL_NODATA      =   0x0003
}url_packet_type_e;

#pragma pack(1)

typedef struct url_header_t_
{
	unsigned char   version;
	short int       seqnum;
	unsigned char   reserv;
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
	char    *cp;
	int     ret,sz, w;
	time_t  st;

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

int get_url_from_javaurl(int fd, char* msg, int thread_idx, char* url, int* urllen)
{
	static short int url_seqno=0;
	char buf[2048] = "";
	memset(buf, 0x00, sizeof(buf));

	int len = strlen(msg);
	*urllen = 0;

	url_header_t* url_header = (url_header_t*)buf;
	url_body_t*   url_body = (url_body_t*)(url_header+1);

	url_header->seqnum  = htons(url_seqno++);

	url_header->version = URLPARSER_VERSION;

	url_body->type = htons(URL_REQUEST);
	url_body->len = htons(len);
	memcpy(url_body->value, msg, len);

	struct pollfd pfd;

	pfd.fd = fd;
	pfd.events = (short)(POLLIN | POLLERR | POLLHUP);

	int send_length = sizeof(url_header_t) + offsetof(url_body_t, value) + len;


	if(send_length != HSwrite(fd, buf, send_length))
		//if(send_length != send(fd, buf, send_length, 0))
		//if(send_length != epoll_send_socket(&g_session_info[fd],
		//  buf,
		//  send_length))
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
	return 0;
}


int epoll_connect_block_mode(char *ip, int port)
{

	int connect_fd = 0;
	int result = 0;

	struct sockaddr_in connect_addr;

	if((connect_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	{       
		return -1;
	}   

	memset(&connect_addr, 0x00, sizeof(connect_addr));

	connect_addr.sin_family = AF_INET;
	connect_addr.sin_addr.s_addr = inet_addr(ip);
	connect_addr.sin_port = htons(port);

	setsockopt(connect_fd, SOL_SOCKET, SO_LINGER, &s_linger_option, sizeof(s_linger_option  )); 

	setsockopt(connect_fd, SOL_SOCKET, SO_KEEPALIVE,&s_val, sizeof(int));


	result = connect(connect_fd, (struct sockaddr *)&connect_addr, sizeof(struct sockaddr)  );          

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


