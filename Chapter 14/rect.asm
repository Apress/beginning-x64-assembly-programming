; rect.asm
section .data										
section .bss							
section .text

global r_area
r_area:
	section .text
		push rbp
		mov  rbp,rsp
		mov		rax, rsi	
		imul	rax, rdi
		mov rsp,rbp
		pop rbp
		ret									
global r_circum
r_circum:
	section .text
		push rbp
		mov  rbp,rsp
		mov		rax, rsi	
		add		rax, rdi
		add		rax, rax
		mov rsp,rbp
		pop rbp
		ret
