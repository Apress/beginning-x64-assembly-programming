; variadic1.asm
extern printf
section .data				
	one		dq	1.0					
	two		dq	2.0
	three	dq	3.0

 	fmt	dq	"The values are: %.1f %.1f %.1f",10,0 
     
section .bss													
section .text									
	global main						
main:
push	rbp
mov 	rbp,rsp
	sub 	rsp,32   		;shadow space
	mov 	rcx, fmt					
	movq 	xmm0, [one]
	movq  	rdx,xmm0
	movq 	xmm1, [two]
	movq  	r8,xmm1	
	movq 	xmm2, [three]	
	movq  	r9,xmm2	         
	call printf
	add rsp, 32			  	;not needed before leave
leave
ret	
