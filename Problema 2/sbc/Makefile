pbl2: pbl2.c libpbl1.a
	gcc -g -o pbl2 pbl2.c libpbl1.a
libpbl1.a: uartPut.o uartGet.o uartConfig.o
	ar -cvq libpbl1.a uartPut.o uartGet.o uartConfig.o
uartConfig.o: uartConfig.s
  as -g -o uartConfig.o uartConfig.s
uartPut.o: uartPut.s
  as -g -o uartPut.o uartPut.s
uartGet.o: uartGet.s
  as -g -o uartGet.o uartGet.s