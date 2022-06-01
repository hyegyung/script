#include "emul.h"

static pthread_attr_t *get_detachstate_thread_attr(int state);
static int conn_proxyA(int sockfd, const char *addr, uint16_t port, int timeout);
static void *emul_start(void *arg);
static void cre_bind_recv(struct SmppMessage *bindReceiver,char interface_version, char addr_ton, char addr_npi);
int nb_send(int sock, void *buf, size_t buf_size, int timeout);
int nb_recv(int sock, void *buf, size_t buf_size, int timeout);
static int evalueate_bind_receiver_resp(struct SmppHeader *bindReceiver, struct SmppHeader *bindReceiverResp);
static void recv_mes_from_asfsGw(int sock);
static int recv_smpp_message(int sockfd, unsigned char *msg_buf, int buf_len, int timeout);
static int smpp_enquire_link_resp(int sockfd, int sequence_no, int timeout);


char svr_ip[100];


static int recv_smpp_message(int sockfd, unsigned char *msg_buf, int buf_len, int timeout)
{
	int res; 
	int32_t command_length;
	struct SmppHeader *header;
	//SmppBody *body; 
	int cmd_id;


	header = (struct SmppHeader*)msg_buf;
	//body = (SmppBody*)(msg_buf + sizeof(struct SmppHeader));


	res = nb_recv(sockfd, header, sizeof(struct SmppHeader), timeout);

	if(res != sizeof(struct SmppHeader))
	{    
		if(res == -4)
		{
			printf("error %d\n",__LINE__);
		}
		else
		{
			printf("error %d\n",__LINE__);
		}

		return res; 
	}    

	command_length = ntohl(header->command_length);
	cmd_id = ntohl(header->command_id);
	//printf("len = %d\n",command_length);

	if(command_length > buf_len)
	{   
		printf("command_length (%d) buflen (%d)\n", command_length, buf_len);
		pthread_exit(0);
		return -1;
	}    

	if(cmd_id == SMSC_SVCREQ)
	{
		res = nb_recv(sockfd, msg_buf + sizeof(struct SmppHeader), command_length - sizeof(struct SmppHeader) + 4, timeout);
		//res = nb_recv(sockfd, body, command_length - sizeof(struct SmppHeader), timeout);

		if(res != (command_length - sizeof(struct SmppHeader) + 4))
		{    
			if(res == -4)
			{
				printf("error %d\n",__LINE__);
			}
			else
			{
				printf("error %d\n",__LINE__);
			}

			return res; 
		}    
	}
	return 0;
}


static void recv_mes_from_asfsGw(int sock)
{
	int res;
	unsigned char *response;
	struct SmppHeader *header;
	//SmppBody *body;
	int command_id;
	int i; 
	int k;
	char s_id[6];
	char m_id[9];
	char s_addr[21];
	char d_addr[21];	

	int     hlen, pos, len, blen;
	SmscRsp spack;
	char    sendbuff[256], buf[256];
	//char *SI;
	unsigned char *SI;
	TlvInt  tval;
	int seq_no;
	int32_t command_length;

	response = (unsigned char*)calloc(1024,sizeof(unsigned char));

	header = (struct SmppHeader *)response;

	res = recv_smpp_message(sock,response,1024,3);

	command_id = ntohl(header->command_id);
	seq_no = ntohl(header->sequence_no); 


	if(command_id == ESME_QRYLINK)
	{
		res = smpp_enquire_link_resp(sock, ntohl(header->command_id), 10);
		printf("q_rink_send  %d\n",res);
	}

	if(command_id == SMSC_SVCREQ)
	{
		snprintf(s_id,6,"%s",response + 16);

		command_length = ntohl(header->command_length);

		SI = (response + command_length);

		for(i = 0, k= 0 ; i < 184 ; i++)
		{  
			if(k < 3)
			{
				if(response[sizeof(struct SmppHeader)+ i] == '\0')
				{
					if(k==0)
					{
						snprintf(m_id,9,"%s",response + 16 + i +1);
					}

					if(k==1)
					{
						snprintf(s_addr,21,"%s",response + 16 + i + 3);
					}

					if(k==2)
					{
						snprintf(d_addr,21,"%s",response + 16 +i + 3);
					}

					k++;
				}
			}
		} 
		printf("REQUEST MESSAGE_ID = [%s]",m_id);		

		hlen = 16;
		memset(&spack, 0x00, sizeof(SmscRsp));
		memcpy(spack.body.source_addr, s_addr,(size_t)21);
		memcpy(spack.body.destination_addr, d_addr, (size_t)21);
		memcpy(spack.body.service_id, s_id,(size_t)6);
		memcpy(spack.body.msg_id, m_id, (size_t)9);

		memset(&tval, 0x00, sizeof(TlvInt));
		tval.tag    = TAG_ACTION;
		tval.length = 2;
		tval.val = (HsInt)SMS_HAM;  /* HAM */

		tval.tag    = ntohl(tval.tag);
		tval.length = ntohl(tval.length);
		tval.val    = ntohl(tval.val);

		memcpy(&spack.body.tlv_action, &tval, sizeof(TlvInt));

		blen = 0;
		memset(buf, 0x00, sizeof(buf));
		len =  STRLEN(spack.body.service_id);
		memcpy(buf+blen, spack.body.service_id, (size_t)(len+1));   blen = blen + len +1;
		len =  STRLEN(spack.body.msg_id);
		memcpy(buf+blen, spack.body.msg_id, (size_t)(len+1));   blen = blen + len +1;
		memcpy(buf+blen, &tval, (size_t)6);                     blen = blen + 6;    /* 6:action_code */

		spack.head.command_id     = htonl(ESME_SVCREQ_RESP);
		spack.head.command_status = htonl( ESME_ROK);
		spack.head.command_length = htonl( hlen + blen);
		spack.head.sequence_no = htonl(seq_no);



		pos = 0;
		memset(sendbuff, 0x00, sizeof(sendbuff));
		memcpy(sendbuff+pos, &spack.head, (size_t)hlen);        pos = pos + hlen;
		memcpy(sendbuff+pos, buf, (size_t)blen);                pos = pos + blen;
		//memcpy(sendbuff+pos, SI, (size_t)4);                    pos = pos + 4;
		memcpy(sendbuff+pos, SI, (size_t)4);                    pos = pos + 4;

		printf("RESPONSE MESSAGE_ID = [%s]\n",spack.body.msg_id);		
		res = nb_send(sock, sendbuff, ntohl(spack.head.command_length ) + 4 , 3);

	}
	free(response);
}


static int evalueate_bind_receiver_resp(struct SmppHeader *bindReceiver, struct SmppHeader *bindReceiverResp)
{
	if(bindReceiverResp->command_id != htonl(ESME_BNDRCV_RESP))
	{
		return -1;
	}

	if(bindReceiver->sequence_no != bindReceiverResp->sequence_no)
	{
		return -2;
	}

	return 0;
}



static void cre_bind_recv(struct SmppMessage *bindReceiver,char interface_version, char addr_ton, char addr_npi)
{
	int command_length;
	int sys_id_len = 5;
	int pwd_len = 4;
	int sys_type_len = 4;
	int addr_range_len = 5;
	unsigned char *p;


	command_length = SMPP_MESSAGE_HEADER_LEN
		+ sys_id_len + pwd_len + sys_type_len + addr_range_len
		+ 7;    // 4 NULLs + interface_version + addr_ton + addr_npi

	bindReceiver->message = (unsigned char*)calloc(command_length, sizeof(unsigned char));
	bindReceiver->header = (struct SmppHeader*)bindReceiver->message;
	bindReceiver->header->command_length = htonl(command_length);
	bindReceiver->header->command_id = htonl(ESME_BNDRCV);
	bindReceiver->header->sequence_no = htonl(1);

	p = bindReceiver->message + SMPP_MESSAGE_HEADER_LEN;
	memcpy(p, "P-SFS", sys_id_len);

	p = bindReceiver->message + SMPP_MESSAGE_HEADER_LEN + 1
		+ sys_id_len;
	memcpy(p, "SFSS", pwd_len);

	p = bindReceiver->message + SMPP_MESSAGE_HEADER_LEN + 2
		+ sys_id_len + pwd_len;
	memcpy(p, "ESME", sys_type_len);

	p = bindReceiver->message + SMPP_MESSAGE_HEADER_LEN + 3
		+ sys_id_len + pwd_len + sys_type_len;
	*p = interface_version;

	p = bindReceiver->message + SMPP_MESSAGE_HEADER_LEN + 4
		+ sys_id_len + pwd_len + sys_type_len;
	*p = addr_ton;

	p = bindReceiver->message + SMPP_MESSAGE_HEADER_LEN + 5
		+ sys_id_len + pwd_len + sys_type_len;
	*p++ = addr_npi;

	memcpy(p, "8881*", addr_range_len);

	return ;

}


static int conn_proxyA(int sock, const char *addr, uint16_t port, int timeout)
{
	int res;
	struct sockaddr_in server_addr;
	struct SmppMessage bindReceiver;
	struct SmppMessage bindReceiverResp;
	int32_t command_length;

	cre_bind_recv(&bindReceiver,51,1,1);

	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(port);
	if(!inet_aton(addr, &server_addr.sin_addr))
	{
		pthread_exit(0);
	}

	res = connect(sock, (struct sockaddr *)&server_addr, sizeof(struct sockaddr_in));
	if(res < 0)
	{
		pthread_exit(0);
	}
	else
	{
		printf("CONNECT OK\n");
	}

	res = nb_send(sock, bindReceiver.message, ntohl(bindReceiver.header->command_length),3);


	res = nb_recv(sock, &command_length, sizeof(command_length), 3);

	command_length = ntohl(command_length);

	bindReceiverResp.message = (unsigned char*)calloc(command_length, sizeof(unsigned char));

	if(bindReceiverResp.message == NULL)
	{                       
		free(bindReceiver.message);
		printf("error\n");	
	}

	res = nb_recv(sock, bindReceiverResp.message + 4, command_length - 4, 3);

	res = evalueate_bind_receiver_resp(
			(struct SmppHeader*)bindReceiver.header,
			(struct SmppHeader*)bindReceiverResp.message);

	free(bindReceiver.message);
	free(bindReceiverResp.message);


	return 0;
}


static void *emul_start(void *arg)
{
	int port = *((int*)arg);
	int sockfd;
	int con_result;

	sockfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
	if(sockfd < 0)
	{
		printf("SOCK FD error\n");
		pthread_exit(0);
	}

	//con_result = conn_proxyA(sockfd, "211.63.6.242", (uint16_t)port, 10);
	con_result = conn_proxyA(sockfd,svr_ip , (uint16_t)port, 10);
	if(con_result != 0)
	{
		printf("conn_proxyA error\n");
		pthread_exit(0);
	}

	while(1)
	{
		recv_mes_from_asfsGw(sockfd);
	}

	close(sockfd);
	pthread_exit(0);
}



int main(int argc, char *argv[])
{
	int i;
	//int conn_res;
	char Th_buf[100];
	char Port_buf[100];
	pthread_t *emul_th;
	pthread_attr_t *thread_attr;
	size_t stacksize;
	int emul_th_res;
	int th_num;
	int port;

	thread_attr = get_detachstate_thread_attr(PTHREAD_CREATE_DETACHED);	
	if(thread_attr == NULL)
	{
		printf("pthread attr error\n");
		exit(-1);
	}
	stacksize = 1024 *1024 * 5;
	pthread_attr_setstacksize(thread_attr,stacksize); 

	printf("\n");
	printf("--------------------------------------\n" );
	printf("ASFS Submit Emulation Program\n" );
	printf("--------------------------------------\n" );
	printf("\nThread Number :  ");
	gets(Th_buf);
	if(strlen(Th_buf) > 100)
	{
		printf("length error\n");
		exit(0);
	}

	printf("\nASFS_GW IP : ");
	gets(svr_ip);
	if(strlen(svr_ip) > 100)
	{
		printf("length error\n");
		exit(0);
	}

	printf("\nPORT Number [5001-5999]: ");
	gets(Port_buf);
	if(strlen(Port_buf) > 100)

	{
		printf("length error\n");
		exit(0);
	}

	port = atoi(Port_buf);
	th_num = atoi(Th_buf);
	emul_th = (pthread_t *)malloc(sizeof(pthread_t) * th_num);

	for(i = 0; i < th_num ; i++)
	{
		emul_th_res = pthread_create(&emul_th[i], thread_attr, emul_start, (void *)&port); 

		if(emul_th_res != 0)
		{
			printf("thread created error\n");
			exit(0);
		}
	}

	pthread_attr_destroy(thread_attr);
	free(thread_attr);

	while(1)
	{
		sleep(10);
	}

	free(emul_th);

	return 0;
}


static int smpp_enquire_link_resp(int sockfd, int sequence_no, int timeout)
{
	int command_length = 16;
	unsigned char buf[16];
	struct SmppHeader *header;
	int res;

	header = (struct SmppHeader *)buf;
	header->command_length = htonl(command_length);
	header->command_id = htonl(ESME_QRYLINK_RESP);
	header->command_status = 0;
	header->sequence_no = htonl(sequence_no);

	res = nb_send(sockfd, buf, command_length, timeout);

	if(res == 0)
		printf("send_length == %d\n",res);    

	return 0;
}



int nb_send(int sock, void *buf, size_t buf_size, int timeout)
{
	fd_set wset;
	struct timeval t;
	int res;
	int sent_len = 0;
	//int send_opt = MSG_DONTWAIT | MSG_NOSIGNAL;

	if(timeout < 0)
		t.tv_sec = 3;


	while(sent_len < buf_size)
	{
		FD_ZERO(&wset);
		FD_SET(sock, &wset);
		t.tv_sec = timeout;
		t.tv_usec = 0;

		res = select(sock+1, NULL, &wset, NULL, &t);
		//res = select(sock+1, NULL, &wset, NULL, &t);

		//res = send(sock, buf + sent_len, buf_size - sent_len, send_opt);
		res = send(sock, buf + sent_len, buf_size - sent_len, 0);

		sent_len += res;
	}

	return sent_len;
}



int nb_recv(int sock, void *buf, size_t buf_size, int timeout)
{
	fd_set rset;
	struct timeval t, *pt;
	int res;
	int recv_len = 0;
	//int recv_opt = MSG_DONTWAIT | MSG_NOSIGNAL;

	while(recv_len < buf_size)
	{
		if(timeout < 0)
			pt = NULL;
		else
		{
			t.tv_sec = timeout;
			t.tv_usec = 0;
			pt = &t;
		}
		FD_ZERO(&rset);
		FD_SET(sock, &rset);


		res = select(sock+1, &rset, NULL, NULL, pt);
		//		res = select(sock+1, &rset, NULL, NULL, 0);
		if(res == 0)
		{
			printf("%s(%d) SOCKET_WAIT_TIMEOUT\n",
					__func__, __LINE__);
			return -1;
		}

		if(!FD_ISSET(sock, &rset))
		{
			printf("%s(%d) SYSTEM_ERROR\n",
					__func__, __LINE__);
			return -2;
		}

		//res = recv(sock, buf + recv_len, buf_size - recv_len, recv_opt);
		res = recv(sock, buf + recv_len, buf_size - recv_len, 0);


		recv_len += res;
	}

	return recv_len;
}


static pthread_attr_t *get_detachstate_thread_attr(int state)
{       
	pthread_attr_t *thread_attr = NULL;

	thread_attr = (pthread_attr_t*)calloc(1, sizeof(pthread_attr_t));

	if(!thread_attr)
	{       
		return NULL;
	}       

	if(pthread_attr_init(thread_attr))
	{
		free(thread_attr);
		return NULL;
	}

	if(pthread_attr_setdetachstate(thread_attr, state))
	{
		pthread_attr_destroy(thread_attr);
		free(thread_attr);
		return NULL;
	}       

	return thread_attr;
} 
