; circle.asm
section .data							
	pi	dq	3.141592654			

section .bss							
section .text

global csurface
csurface:
	section .text	
		movsd	xmm1, qword [pi]
		mulsd	xmm0,xmm0		;radius in xmm0
		mulsd	xmm0, xmm1
		ret
									
global ccircum
ccircum:
	section .text	
		movsd	xmm1, qword [pi]
		addsd	xmm0,xmm0		;radius in xmm0
		mulsd	xmm0, xmm1
		ret