LIBOBJS = pbl1.o
DEBUGFLGS = -g
LSTFLGS =
all: pbl1
%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@
libpbl1.a: $(LIBOBJS)
	ar -cvq libpbl1.a uartPut.o uartGet.o
pbl2: pbl2.c libpbl1.a
	gcc $(DEBUGFLGS) -o pbl2 pbl2.c libpbl1.a