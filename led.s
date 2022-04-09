@ LED-Blink assembly
@ R8 - endereço base retornado do mapeamento de memoria.
@

@ declaração de constantes
.equ sys_open, 5 @ open and possibly create a file
.equ sys_mmap2, 192 @ call system linux para mapear os endereços de memória
.equ sys_nanosleep, 162 @ high-resolution sleep
.equ sys_write, 4 @ write to a file descriptor
.equ S_RDWR, 0666 @ liberar para leitura e escrita
.equ pagelen, 4096	@ tamanho da memória
.equ setregoffset, 28 
.equ clrregoffset, 40
.equ PROT_READ, 1
.equ PROT_WRITE, 2
.equ MAP_SHARED, 1
.equ O_RDWR,	00000002
.equ O_SYNC,	00010000
.align 2

.data
flags:	.word O_RDWR + O_SYNC
openMode:	.word 0666
timespecsec: .word 1
timespecnano: .word 100000000
devmem: .asciz "/dev/mem"
memOpnErr: .asciz "Failed to open /dev/mem\n"
memOpnsz: .word .-memOpnErr
memMapErr: .asciz "Failed to map memory\n"
memMapsz: .word .-memMapErr
.align  @ realign after strings
gpioaddr: .word 0x20200 @ offset base do gpio
pin6: .word 0 @ offset to select register
 .word 18 @ bit offset in select register
 .word 6 @ bit offset in set & clr register
.align 2
.section .text
.global _start
_start: @ mapMem
	@ open file
	ldr r0, =devmem
        ldr r1, =(O_RDWR + O_SYNC)
        mov r7, #sys_open
        svc 0
	@ segmento do mapmem
 	movs r4, r0 @ fd for memmap
 	@ se abriu o arquivo, chama mmap2 em l1
 	BPL 1f @ pos number file opened ok

@ Set up can call the mmap2 Linux service
1:      
	ldr r5, =gpioaddr @ address we want / 4096
 	ldr r5, [r5] @ load the address
 	mov r1, #pagelen @ size of mem we want
@ mem protection options
 	mov r2, #(PROT_READ + PROT_WRITE)
 	mov r3, #MAP_SHARED @ mem share options
 	mov r0, #0 @ let linux choose a virtual address
 	mov r7, #sys_mmap2 @ mmap2 service num
 	svc 0 @ call service
 	movs r8, r0 @ keep the returned virt addr
	
 	B _end

@ Macro nanoSleep to sleep .1 second
@ Calls Linux nanosleep entry point which is function 162.
@ Pass a reference to a timespec in both r0 and r1
@ First is input time to sleep in seconds and nanoseconds.
@ Second is time left to sleep if interrupted (which we ignore)
	@ nanoSleep
 	ldr r0, =timespecsec
 	ldr r1, =timespecsec
 	mov r7, #sys_nanosleep
 	svc 0
	
@ .macro GPIODirectionOut pin
 	ldr r2, =pin6 @ offset of select register
 	ldr r2, [r2] @ load the value
 	ldr r1, [r8, r2] @ address of register
 	ldr r3, =pin6 @ address of pin table
 	add r3, #4 @ load amount to shift from table
 	ldr r3, [r3] @ load value of shift amt
 	mov r0, #0b111 @ mask to clear 3 bits
 	lsl r0, r3 @ shift into position
 	bic r1, r0 @ clear the three bits
 	mov r0, #1 @ 1 bit to shift into pos
 	lsl r0, r3 @ shift by amount from table
 	orr r1, r0 @ set the bit
 	str r1, [r8, r2] @ save it to reg to do work

	mov	r6, #10
	
loop:	
@ .macro GPIOTurnOn pin, value
 	mov r2, r8 @ address of gpio regs
	add r2, #setregoffset @ off to set reg
 	mov r0, #1 @ 1 bit to shift into pos
 	ldr r3, =pin6 @ base of pin info table
 	add r3, #8 @ add offset for shift amt
 	ldr r3, [r3] @ load shift from table
 	lsl r0, r3 @ do the shift
 	str r0, [r2] @ write to the register
	
	@ nanoSleep
 	ldr r0, =timespecsec
 	ldr r1, =timespecsec
 	mov r7, #sys_nanosleep
 	svc 0
	
	
@ .macro GPIOTurnOff pin, value
 	mov r2, r8 @ address of gpio regs
 	add r2, #clrregoffset @ off set of clr reg
 	mov r0, #1 @ 1 bit to shift into pos
 	ldr r3, =pin6 @ base of pin info table
 	add r3, #8 @ add offset for shift amt
 	ldr r3, [r3] @ load shift from table
 	lsl r0, r3 @ do the shift
 	str r0, [r2] @ write to the register

	@ nanoSleep
 	ldr r0, =timespecsec
 	ldr r1, =timespecsec
 	mov r7, #sys_nanosleep
 	svc 0

brk1:	subs	r6, #1
		bne	loop

_end:   mov r0, #0 @ Use 0 return code
        mov r7, #1 @ Command code 1 terminates
        svc 0 @ Linux command to terminate