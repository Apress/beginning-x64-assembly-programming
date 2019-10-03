; asum.asm
section .data							
section .bss							
section .text

global asum
asum:
	section .text	
;calculate the sum
		mov	rcx, rsi	;array length
		mov	rbx, rdi	;address of array
		mov	r12, 0
		movsd	xmm0, qword [rbx+r12*8]
		dec rcx	 ; one loop less, first element already in xmm0
	sloop:	
		inc r12
		addsd	xmm0, qword [rbx+r12*8]
		loop sloop
ret		; return sum in xmm0
