TARGET = run_insert_mafs

INCLUDE =  -I./ -I$(ORACLE_HOME)/precomp/public -I$(ORACLE_HOME)/rdbms/public -I$(ORACLE_HOME)/plsql/public-I$(ORACLE_HOME)/netwrk/public
LIBS    =  -L$(ORACLE_HOME)/lib `cat $(ORACLE_HOME)/lib/ldflags` `cat $(ORACLE_HOME)/lib/sysliblist` -lclntsh

CFLAGS  = -g3 -Wall
DFLAGS  =
CC	= g++

CSRCS = main.c
COBJS = $(CSRCS:.c=.o)

.SUFFIXES: .c .o
.c.o:
	$(CC) $(CFLAGS) -o $*.o -c $*.c $(INCLUDE)

$(TARGET) : $(COBJS)
	$(CC) -o $(TARGET) $(COBJS) $(LIBS)

clean:
	rm -rf *.o run_insert_mafs
