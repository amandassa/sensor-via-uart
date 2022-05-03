#include "stdio.h"
//#include "libpbl1.a"  biblioteca a ser criada
extern void UART_PUT_BYTE(int *);
extern int UART_GET_BYTE();

int main (){

int *putbyte = 48;  // 0x30 em hexa
UART_PUT_BYTE(putbyte);

int receive = UART_GET_BYTE();
printf("%c", receive);
    
}