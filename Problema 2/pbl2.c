#include <stdio.h>
#include <stdlib.h>

extern void uartPut(int);
extern int uartGet();
extern void uartConfig();
//#include "libpbl1.a" as funções externas trazidas da biblioteca que criamos e que foi compilada junto a esse código

int endereco;

int sensor (){
    printf("\n\nINFORME O ENDEREÇO DO SENSOR: ");
    scanf("%d", &endereco);
}

int main (){

    int exit = 0;
    int param;
    uartConfig();

    while(exit != 4){
        printf("############ PBL DE SISTEMAS DIGITAIS - SD - TEC499 ############\n\n\n");
        printf("SELECIONE O TIPO DE REQUISIÇÃO:\n\n[1] Humidade\n[2] Temperatura\n[3] Status do sensor\n[4] Sair\n\n");
        printf("INSERIR: ");
        scanf("%d", &param);
        if (param == 4){break;}
        switch (param)
        {
            case 1: {
                uartPut(5);
                sensor();
                //uartPut(endereco);
                int receive = uartGet();
                system("clear");
                printf("\033[0;34m");
                printf("Umidade: %d UR\n----------------------------------------------------------------------\n\n" , receive);
                printf("\033[0m");
                break;
            }
            case 2: {
                uartPut(4);
                sensor();
                //uartPut(endereco);
                int receive = uartGet();
                system("clear");
                printf("\033[0;33m");
                printf("Temperatura: %dº C\n----------------------------------------------------------------------\n\n" , receive);
                printf("\033[0m");
                break;
            }case 3: {
                uartPut(3);
                sensor();
                //uartPut(endereco);
                int receive = uartGet();
                if(receive == 0){
                    printf("\033[0;31m");
                    printf("### ERROR: SENSOR APRESENTA DEFEITO ###\n\n----------------------------------------------------------------------\n\n");
                    printf("\033[0m");
                }else{
                    printf("\033[0;32m");
                    printf("### STATUS: OK ###\n\n----------------------------------------------------------------------\n\n");
                    printf("\033[0m");
                }        
                break;
            }default: {
                system("clear");
                printf("\033[0;31m");
                printf("### ERROR: SOLICITAÇÃO INVÁLIDA ###\n\n----------------------------------------------------------------------\n\n");
                printf("\033[0m");
                break;
            }
        }
    }
}
