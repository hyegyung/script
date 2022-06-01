#include $(ORACLE_HOME)/precomp/lib/env_precomp.mk

PROC = proc
CC   = gcc
CP   = cp

.SUFFIXES: .pc .c .o

SRCS = main.c skt_util.c

PSRCS = skt_table.pc \
    $(NULL)

OBJS    = $(SRCS:.c=.o)
POBJS   = $(PSRCS:.pc=.o)
PCFILES = $(PSRCS:.pc=.c)

BIN_PATH = $(HOME)/bin

ALLOBJS = $(OBJS) $(POBJS)

# ----------------------------------------------------------------------
# Include Define
# ----------------------------------------------------------------------
ORACFLAG1 = -DPRECOMP
ORACFLAG  = $(ORACFLAG1) $(ORACFLAG2)
ORAINCL1  = -I$(ORACLE_HOME)/precomp/public -I$(ORACLE_HOME)/rdbms/public
ORAINCL2  = -I$(ORACLE_HOME)/plsql/public -I$(ORACLE_HOME)/network/public
ORAINCL   = $(ORAINCL1) $(ORAINCL2)
INCLUDE   = -I. -I/usr/include

# ----------------------------------------------------------------------
# System Define
# ----------------------------------------------------------------------
SYSLIBS   = -ldl -lpthread -lnsl -lz -lc -lm

# ----------------------------------------------------------------------
# Library Define
# ----------------------------------------------------------------------
APPLIB    =
ORALIB1   = -L$(ORACLE_HOME)/lib -lclntsh
ORALIB2   = `cat $(ORACLE_HOME)/lib/sysliblist`
LIBS      = $(APPLIB) $(ORALIB1)  $(ORALIB2) $(SYSLIBS)
CFLAG  = $(PKGCFLAG) $(PKGCDFVAL) -g -c -Wall
PCFLAG = $(PKGPCFLAG) $(PKGPCDFVAL)

TARGET = collecttrap

.pc.o:
	$(PROC) $(PCFLAG) iname=$< unsafe_null=yes CHAR_MAP=STRING dbms=v8 CODE=ANSI
	$(CC) $(CFLAG) $(ORACFLAG) $(INCLUDE) $(ORAINCL) $*.c

.pc.c:
	$(PROC) $(PCFLAG) iname=$<

.c.o:
	$(CC) $(CFLAG) $(INCLUDE) $<

all:$(TARGET)
$(TARGET) : $(ALLOBJS)
	$(CC) -o $(TARGET) $(ALLOBJS) $(LIBS)

clean:
	rm -f $(TARGET) $(TARGET).lis core $(PCFILES) *.o *.lis

install:
	$(CP) $(TARGET) $(BIN_PATH)
