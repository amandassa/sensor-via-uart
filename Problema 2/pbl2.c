#include "stdio.h"
//#include "libpbl1.a"  biblioteca a ser criada
extern void uartPut(int);
extern int uartGet();


int main (){

int param;

    printf("Digite um Dado para enviar: ");
    scanf("%d", &param);
    uartPut(param);

    int receive = uartGet();
    printf("%d", "Dado Recebido: ", receive);

    
}