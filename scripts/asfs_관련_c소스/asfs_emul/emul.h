#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>
#include <sys/un.h>
#include <sys/uio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/tcp.h>
#include <netinet/in.h>

#define STRLEN(a)                       ((int)strlen(a?a:""))
#define     ESME_ROK                0x00         /* OK - Message                        */ 
#define ESME_BNDRCV             0x00000001  // bind_receiver
#define ESME_BNDRCV_RESP        0x80000001  // bind_receiver_resp
#define SMPP_MESSAGE_HEADER_LEN 16
#define SMSC_SVCREQ             0x000102FF  // Service Request (SMSC=>Gateway=>ASFS)
#define ESME_SVCREQ_RESP        0x800102FF  // Service Req Response (ASFS=>Gateway=>SMSC)
#define ESME_QRYLINK            0x00000015  // enquire_link
#define ESME_QRYLINK_RESP       0x80000015  // enquire_link_resp
#define SMS_NONE                    0               /* 0 : Not Used             */
#define SMS_HAM                     1               /* 1 : HAM call             */
#define SMS_SPAM                    2               /* 2 : SPAM call            */
#define TAG_CALLBACK                0x0381          /* callback_num             */
#define TAG_TELSVCTID               0x0382          /* Teleservice ID           */
#define TAG_SMSTIME                 0x0383          /* sms_time                 */
#define TAG_SMSMSG                  0x0384          /* sms_msg                  */
#define TAG_ACTION                  0x3fff          /* result action            */


typedef short int             HsInt,              *HSINT;


typedef struct __tlvint_st_ {
	HsInt       tag;                /* Service Type: service id */
	HsInt       length;             /* Value Length             */
	HsInt       val;                /* max size 2               */
} TlvInt;                  /*  Total : 6               */

struct SmppHeader {
	int32_t command_length;
	int32_t command_id;
	int32_t command_status;
	int32_t sequence_no;
}__attribute__((packed));

struct SmppMessage {
	unsigned char *message;    
	struct SmppHeader *header; 
	void *body;                
};

typedef struct __smscreqbody_st_ {
	char        service_id[6];                  /* Service ID                   */
	char        msg_id[9];                      /* Message ID                   */
	unsigned char      source_addr_ton;
	unsigned char      source_addr_npi;
	char        source_addr[22];                /* 발신번호(누가)               */
	unsigned char      dest_addr_ton;
	unsigned char      dest_addr_npi;
	char        destination_addr[21];           /* 착신번호 memory hole 1 byte  */
	char        callback_min[22];               /* Callback Number  => H'0381   */
	char        telsvc_id[12];                  /* TeleserviceID(max:8)=>H'0382 */
	char        sms_type;                       /* 1:일반SMS,2:MMS byte : 2     */
	char        sms_time[15];                   /* SMS Time(max:14) => H'0383   */
	char        callback_url[64];               /* Callback URL은 TID로 구분    */
	int         smsc_seq;                       /* SMSC Seqence Number          */
	int         sms_len;                        /* SMS Length                   */
	char        sms_msg[200];                   /* SMS Message(max:200)         */
} SmppBody;                    /* Total : 384                  */


typedef struct __smscrspbody_st_ {      
	/* internal field for response */   
	char        source_addr[21];                /* 발신번호(누가)               */
	char        destination_addr[21];           /* 착신번호 memory hole 1 byte  */

	/* external data */
	char        service_id[6];                  /* Service ID                   */
	char        msg_id[10];                     /* Message ID                   */
	TlvInt      tlv_action;                     /* action result                */
} SmscRspBody;

typedef struct __smscrsp_st_ {                  
	struct SmppHeader  head;                       /* smpp header                  */
	SmscRspBody     body;                       /* smpp body                    */
} SmscRsp;
