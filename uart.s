@ Mapping -> UART Config

@ declaração de constantes
.equ sys_open, 5 @ open and possibly create a file
.equ sys_mmap2, 192 @ call system linux para mapear os endereços de memória
.equ sys_nanosleep, 162 @ high-resolution sleep
.equ sys_write, 4 @ write to a file descriptor
.equ S_RDWR, 0666 @ liberar para leitura e escrita
.equ pagelen, 4096	@ tamanho da página de memória
.equ setregoffset, 28 
.equ clrregoffset, 40
.equ PROT_READ, 1
.equ PROT_WRITE, 2
.equ MAP_SHARED, 1
.equ O_RDWR,	00000002
.equ O_SYNC,	00010000
@ OFFSETS DOS REGISTRADORES DA UART
.equ UART_CR, 0x30 @ REGISTRADOR DE CONTROLE
.equ UART_FR, 0X18 @ REGISTRADOR DE FLAGS (STATUS DA TRANSMSSÃO)
.equ UART_DR, 0x0  @ REGISTRADOR DE DADOS
.equ UART_LCR, 0x2c @ REGISTRADOR DE LINHA DE CONTROLE (FIFO) 
.equ UART_IBRD, 0x24 @ integer baud rate divisor
.equ UART_FBRD, 0x28 @ fractional baud rate divisor
@ CONDICIONAIS DE CHECAGEM DOS BITS DO REGISTRADOR DE FLAGS
.equ UART_TXFF, (1<<5)
.equ UART_RXE, (1<<9) @ Enable receiver
.equ UART_TXE, (1<<8) @ Enable transmitter
.equ UART_UARTEN, (1<<0) @ Enable UART
.equ FINALBITS, (UART_RXE|UART_TXE|UART_UARTEN)
.equ UART_FIFOCLR, (0<<4)
.equ UART_FIFOEN, (1<<4)
.equ BITS, (UART_WLEN1|UART_WLEN0|UART_FEN|UART_STP2)
.equ UART_WLEN1, (1<<6) @ MSB of word length
.equ UART_WLEN0, (1<<5) @ LSB of word length
.equ UART_FEN, (1<<4) @ Enable FIFOs
.equ UART_STP2, (1<<3) @ Use 2 stop bits

.align 2

.data
flags:	.word O_RDWR + O_SYNC
openMode:	.word 0666
devmem: .asciz "/dev/mem"
.align 2  @ realign after strings
gpioaddr: .word 0x20200 @ offset base do gpio
uartaddr: .word 0x20201 @ offset base da uart
@ UART_CR: .word 0x30 @ registrador de controle da uart
pin6: .word 0 @ offset to select register
 .word 18 @ bit offset in select register
 .word 6 @ bit offset in set & clr register
pinTX: .word 4 @ offset to select register
 .word 15 @ bit offset in select register
 .word 5 @ bit offset in set & clr register
.align 2

.section .text
@	.include "macros.s"
.global _start
_start: @ mapMem
	@ open file
	ldr r0, =devmem
        ldr r1, =(O_RDWR + O_SYNC)
        mov r7, #sys_open
        svc 0
	@ segmento do mapmem
 	movs r4, r0 @ fd for memmap
 	
 	BPL 1f @ pos number file opened ok

@ Set up can call the mmap2 Linux service
1:      ldr r5, =uartaddr @ address we want / 4096
 	ldr r5, [r5] @ load the address
 	mov r1, #pagelen @ size of mem we want
@ mem protection options
 	mov r2, #(PROT_READ + PROT_WRITE)
 	mov r3, #MAP_SHARED @ mem share options
 	mov r0, #0 @ let linux choose a virtual address
 	mov r7, #sys_mmap2 @ mmap2 service num
 	svc 0 @ call service
 	movs r8, r0 @ keep the returned virt addr
@ MAPEANDO GPIO
@	ldr r5, =gpioaddr @ address we want / 4096
@ 	ldr r5, [r5] @ load the address
@ 	mov r1, #pagelen @ size of mem we want
@ 	mov r2, #(PROT_READ + PROT_WRITE)
@ 	mov r3, #MAP_SHARED @ mem share options
@ 	mov r0, #0 @ let linux choose a virtual address
@ 	mov r7, #sys_mmap2 @ mmap2 service num
@ 	svc 0 @ call service
@	movs r6, r0 @ vir

@ DESLIGAR A UART
	mov r0, #0 @ desliga a uart 0 em CR
    str r0, [r8, #UART_CR]  @ UART_CR = 0000 0000 0000 0000 0000 0000 0000 0000 
	@ setando o dado enviado em r0

@ AGUARDAR O FIM DA RECEPÇÃO OU TRANSMISSÃO DO CARACTERE ATUAL (OLHAR FIFO)
loop: 	ldr r2, [r8, #UART_FR]
	    tst r2, #UART_TXFF @ VERIFICAR SE TA CHEIO O FIFO
        bne loop
        
@ LIMPANDO/DESABILITTANDO FIFO
	ldr r1, [r8, #UART_LCR]
	mov r0, #1
	lsl r0, #4
	bic r1, r0
	str r1, [r8, #UART_LCR]

@ CONFIGURANDO BAUD RATE
	@ SUPONDO QUE TEMOS NOSSA BAUDRATE DESEJADA
	@lsl r1,r0,#4 @ mulipliquei por 16 a baud que estava em r0.
	@ldr r0,=(3000000<<6)
	@lsr r0, r1 @ CLOCK/BAUD*16 R0/R1
	@srt r0, [r8, #]	
	
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
loop1:	mov r0, #0b10101
	    str r0, [r8, #UART_DR]
		bl loop1
_end:   mov r0, #0 @ Use 0 return code
        mov r7, #1 @ Command code 1 terminates
        svc 0 @ Linux command to terminate

@ #156 int #25 frac
@ ou
@#1 em ibrd e 0b111000 em ir
	@mov r0, #1
	@lsl r0, #8 @ dado 0000 0000 0000 0000 0000 0000 1000 0000

	@str r0, [r8, #UART_DR]