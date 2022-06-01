#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <stdarg.h>
#include <time.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <sys/poll.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>

int get_url_from_javaurl(int fd, char* msg, int thread_idx, char* url, int* urllen);
int epoll_connect_block_mode(char *ip, int port);
