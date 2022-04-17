@ UNIVERSIDADE ESTADUAL DE FEIRA DE SANTANA
@ PROBLEMA 1 - TEC499- MI SISTEMAS DIGITAIS
@ CÓDIGO QUE MAPEIA A UART PL011 DA RASBERRY PI ZERO E A HABILITA PARA RECEBER E TRANSMITIR DADOS SERIAIS
@ SEMESTRE 2022.1
@ AUTORES - ABEL RAMALHO, AMANDA, AURÉLIO BARRETO

@ declaração de constantes
@ SYSCALLS UTILIZADAS
.equ sys_open, 5 @ SYSCALL DE ABERTURA E POSSIBILIDADE DE CRIAR ARQUIVO
.equ sys_mmap2, 192 @ SYSCALL DO SISTEMA LINUX PARA MAPEAMENTO DE MEMÓRIA (GERA ENDEREÇO VIRTUAL)
@ MANIPUALAÇÃO DE ARQUIVOS
.equ S_RDWR, 0666 @ LIBERAR PARA LEITURA E ESCRITA 
.equ pagelen, 4096	@ TAMANHO/PAGINAÇÃO DE MEMÓRIA 
.equ PROT_READ, 1 @ MODO DE LEITURA
.equ PROT_WRITE, 2 @ MODO DE ESCRITA
.equ MAP_SHARED, 1 @ LIBERAR COMPARTILHAMENTO DE MEMÓRIA (PARA NÃO SER DE USO EXCLUSIVO)
.equ O_RDWR,	00000002 @ MODO DE LEITURA E ESCRITA
.equ O_SYNC,	00010000 @ SINCRONIZAÇÃO
@ OFFSETS DOS REGISTRADORES DA UART
.equ UART_CR, 0x30 @ REGISTRADOR DE CONTROLE
.equ UART_FR, 0X18 @ REGISTRADOR DE FLAGS (STATUS DA TRANSMSSÃO)
.equ UART_DR, 0x0  @ REGISTRADOR DE DADOS
.equ UART_LCR, 0x2c @ REGISTRADOR DE LINHA DE CONTROLE (FIFO) 
.equ UART_IBRD, 0x24 @ DIVISOR DE BAUDRATE INTEIRO
.equ UART_FBRD, 0x28 @ DIVIDOR DE BAURDATE FRACIONÁRIO
@ MANIPULAÇÃO DOS BITS DE REGISTRADORES (DESLOCAMENTO)
.equ UART_TXFF, (1<<5) @ CHECAR SE O FIFO ESTÁ CHEIO
.equ UART_RXE, (1<<9) @ ATIVAR RECEBIMENTO  EX: (1>>9) DESLOCAR O BIT 1 PARA O NONO(9º) BIT DO REGISTRADOR ESCOLHIDO
.equ UART_TXE, (1<<8) @ ATIVAR TRANSMIÇÃO
.equ UART_UARTEN, (1<<0) @ LIGAR UART
.equ FINALBITS, (UART_RXE|UART_TXE|UART_UARTEN) @ LIGAR UART, TRANSMISSÃO E RECEPÇÃO AO MESMO TEMPO
.equ UART_FIFOCLR, (0<<4) @ DESABILITAR O FIFO
.equ UART_FIFOEN, (1<<4) @ HABILITAR O FIFO
.equ BITS, (UART_WLEN1|UART_WLEN0|UART_FEN|UART_STP2) @ CONIFUGRAÇÕES DA UART (TAMANHO DO DADO, STOP BITS E HABILITAR FIFO) 
.equ UART_WLEN1, (1<<6) @ BIT MAIS A DIREITA (MAIS SIGNIFICATIVO) REFRENTE AO TAMANHO DA PALAVRA
.equ UART_WLEN0, (1<<5) @ BIT MAIS A ESQUERDA (MENOS SIGNIFICATIVO) REFERENTE AO TAMANHO DA PALAVRA
.equ UART_FEN, (1<<4) @ HABILITAR FIFO
.equ UART_STP2, (1<<3) @ USAR 2 STOP BITS



.align 2

.data
flags:	.word O_RDWR + O_SYNC
openMode:	.word 0666
devmem: .asciz "/dev/mem" @ DIRETÓRIO USADO PARA MAPEAMENTO DE MEMÓRIA
.align 2  
gpioaddr: .word 0x20200 @ OFFSET BASE DOS GPIO
uartaddr: .word 0x20201 @ OFFSET BASE DA UART PL011

.section .text
.global _start
_start: @ MAPEAMENTO DA MEMÓRIA
	@ ABRINDO ARQUIVO
	ldr r0, =devmem
        ldr r1, =(O_RDWR + O_SYNC)
        mov r7, #sys_open
        svc 0
	@ SEGMENTO DO MAPEAMENTO
 	movs r4, r0 @ fd for memmap
 	
 	BPL 1f @ DIRECIONANDO PARA O LABEL 1:

@ PREPARANDO O MAPEAMENTO
1:  ldr r5, =uartaddr @ ENDEREÇO BASE DA UART/4096 
 	ldr r5, [r5] @ CARREGANDO O VALOR DE R5
 	mov r1, #pagelen @ TAMANHO DA MEMÓRIA QUE PRECISAMOS
 	mov r2, #(PROT_READ + PROT_WRITE) @ HABILITANDO PARA LEITURA E ESCRITA
 	mov r3, #MAP_SHARED @ COMPARTILHAMENTO DE MEMÓRIA
 	mov r0, #0 @ LIMPANDO R0 QUE IRÁ RECEBER O ENDEREÇO VIRTUAL 
 	mov r7, #sys_mmap2 @ CHAMADA DA SYSCALL MMPA2 PARA MAPEAMENDO
 	svc 0 @ CHAMADA DO SERVIÇO
 	movs r8, r0 @ ARMAZENANDO EM R8 NOSSO ENDEREÇO BASE VIRUTAL DA UART

@ DESLIGAR A UART
	mov r0, #0 @ ZERA TODOS OS BITS DE R0
    str r0, [r8, #UART_CR]  @ CARREGA O REGISTRADOR R0 (ZERADO) NO REGISTRADOR UART_CR 
								   @ UART_CR = 0000 0000 0000 0000 0000 0000 0000 0000 	

@ AGUARDAR O FIM DA RECEPÇÃO OU TRANSMISSÃO DO CARACTERE ATUAL (OLHAR FIFO)
loop: 	ldr r2, [r8, #UART_FR] @ CARREGANDO EM R2 O ENDEREÇO DO REGISTRADOR #UART_FR
	    tst r2, #UART_TXFF @ VERIFICAR SE TA CHEIO O FIFO
        bne loop
        
@ LIMPANDO/DESABILITTANDO FIFO
	ldr r1, [r8, #UART_LCR] @ CARREGANDO EM R1 O ENDEREÇO DO REGISTRADOR #UART_FR 
	mov r0, #1 				@ CARREGANDO O BIT 1 EM R0
	lsl r0, #4				@ DESLOCAMENTO A ESQUERDA EM 4 POSIÇÕES (MESMO QUE MULTIPLICAR POR 2^4)
	bic r1, r0				@ LIMPANDO O BIT DESLOCADO (BIC = BIT CLEAR)NO RESGITRADOR R1 
	str r1, [r8, #UART_LCR]	@ CARREGANDO R1 NO REGISTRADOR UART_LCR (LINHA DE CONTROLE)

@ CONFIGURANDO BAUD RATE
	@ SUPONDO QUE TEMOS NOSSA BAUDRATE DESEJADA
	@lsl r1,r0,#4 @ MULTIPLICANDO POR 16 A BAUD QUE ESTAVA EM R0
	@ldr r0,=(3000000<<6)
	@lsr r0, r1 @ CLOCK/BAUD*16 R0/R1
	@srt r0, [r8, #]	
	@ 0010 0101 1000 0000 0000 BINÁRIO DO BAUDDIV DE 9600 KBITS/S DE BAUDRATE
	@ 0x25800 EM HEXADECIMAL DO BAUDDIV DE 9600 KBITS/S DE BAUDRATE
	mov r0, #1
	str r0, [r8, #UART_IBRD]
	mov r0, #0x28
	str r0, [r8, #UART_FBRD]


@ HABILITANDO TX E RX E LIGANDO A UART
	ldr r0, =FINALBITS 
    str r0, [r8, #UART_CR]

@ LIGANDO FIFO, PARIDADE E STOP BITS
	mov r0, #BITS
	str r0, [r8, #UART_LCR]

@ SETANDO O DADO QUE É PRA SER ENVIADO NO REGIRSTRADOR DR
loop1:	mov r0, #0b10101010   @ DECIMAL 170
	    str r0, [r8, #UART_DR]
		bl loop1
_end:   mov r0, #0 @ SETANDO 0 PARA SER RETORNADO
        mov r7, #1 @ SYSCALL PARA ENCERRAR A EXECUÇÃO
        svc 0 @ CHAMADA DE SERVIÇO LINUX


