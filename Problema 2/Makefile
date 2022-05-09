uartPut.o: uartPut.s
  as -g -o uartPut.o uartPut.s
uartGet.o: uartGet.s
  as -g -o uartGet.o uartGet.s
libpbl1.a: uartPut.o uartGet.o
	ar -cvq libpbl1.a uartPut.o uartGet.o
pbl2: pbl2.c libpbl1.a
	gcc -g -o pbl2 pbl2.c libpbl1.a