; adouble.asm
section .data							
section .bss							
section .text

global adouble
adouble:
	section .text	
;double the elements
		mov	rcx, rsi	;array length
		mov	rbx, rdi	;address of array
		mov	r12, 0
	aloop:
		movsd	xmm0, qword [rbx+r12*8] ;take an element from array
		addsd	xmm0,xmm0				; double it
		movsd	qword [rbx+r12*8], xmm0	;move it to array
		inc r12
		loop aloop
ret
