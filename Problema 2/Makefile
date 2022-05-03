LIBOBJS = pbl1.o
DEBUGFLGS = -g
LSTFLGS =
all: pbl1
%.o : %.s
	as $(DEBUGFLGS) $(LSTFLGS) $< -o $@
libpbl1.a: $(LIBOBJS)
	ar -cvq libpbl1.a pbl1.o
pbl2: pbl2.c libpbl1.a
	gcc -o pbl2 pbl2.c libpbl1.a