#include "stdio.h"
extern void uartPut(int);
extern int uartGet();
//#include "libpbl1.a" as funções externas trazidas da biblioteca que criamos e que foi compilada junto a esse código

int main (){

int param;

    printf("Digite um Dado para enviar: ");
    scanf("%d", &param);
    uartPut(param);

    int receive = uartGet();
    printf("%s,%d", "Dado Recebido: ", receive);

    
}