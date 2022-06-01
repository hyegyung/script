
.SUFFIXES:.c .o
CC = gcc

CFLAGS = -g -t -lpthread -Wall

PROGRAM = asfs_emul
OBJS = emul.o
SRCS = emul.c 

all:$(PROGRAM)
$(PROGRAM):$(OBJS)
	$(CC) -o $(PROGRAM) $(OBJS) $(CFLAGS) 

clean:
	rm -rf $(OBJS) $(PROGRAM) core

