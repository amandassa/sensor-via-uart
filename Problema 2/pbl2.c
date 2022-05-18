#include <stdio.h>
#include <stdlib.h>

extern void uartPut(int);
extern int uartGet();
extern void uartConfig();
//#include "libpbl1.a" as funções externas trazidas da biblioteca que criamos e que foi compilada junto a esse código

int main (){

int laco = 1;

int param;
    uartConfig();
    while(laco == 1){
        printf("############ PBL DE SISTEMAS DIGITAIS - SD - TEC499 ############\n\n\n");
        printf("SELECIONE O TIPO DE REQUISIÇÃO:\n\n[1] Humidade\n[2] Temperatura\n\n");
        printf("INSERIR: ");
        scanf("%d", &param);
        uartPut(param);
        if(param == 1){
                int receive = uartGet();
                system("clear");
                printf("\033[0;34m");
                printf("Umidade: %d UR\n----------------------------------------------------------------------\n\n" , receive);
                printf("\033[0m");
        }else if(param == 2){
                int receive = uartGet();
                system("clear");
                printf("\033[0;31m");
                printf("Temperatura: %dº C\n----------------------------------------------------------------------\n\n" , receiv$
                printf("\033[0m");
        }else{
                printf("### ERROR: SOLICITAÇÃO INVÁLIDA ###");
        }
    }
}
