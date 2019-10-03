; stack_float.asm
extern printf
section .data
	zero	dq	0.0		;0x0000000000000000
	one		dq	1.0		;0x3FF0000000000000				
	two		dq	2.0		;0x4000000000000000
	three	dq	3.0		;0x4008000000000000
	four	dq	4.0		;0x4010000000000000	
	five	dq	5.0		;0x4014000000000000
	six		dq	6.0		;0x4018000000000000
	seven	dq	7.0		;0x401C000000000000
	eight  	dq	8.0		;0x4020000000000000
	nine   	dq	9.0		;0x4022000000000000	 
section .bss													
section .text									
	global main						
main:
push rbp
mov rbp,rsp
	movq xmm0, [zero]
	movq xmm1, [one]
	movq xmm2, [two]
	movq xmm3, [three]
	
	movq xmm4, [nine]
	sub rsp, 8
	movq [rsp], xmm4

	movq xmm4, [eight]
	sub rsp, 8
	movq [rsp], xmm4

	movq xmm4, [seven]
	sub rsp, 8
	movq [rsp], xmm4

	movq xmm4, [six]
	sub rsp, 8
	movq [rsp], xmm4

	movq xmm4, [five]
	sub rsp, 8
	movq [rsp], xmm4

	movq xmm4, [four]
	sub rsp, 8
	movq [rsp], xmm4
	
	sub rsp,32  	; shadow
	call lfunc
    add rsp,32
leave
ret	
;---------------------------------------------------------------------------											
lfunc:	
push 	rbp
mov 	rbp,rsp

	movsd xmm4,[rbp+8+8+32]	
	movsd xmm5,[rbp+8+8+32+8]
	movsd xmm6,[rbp+8+8+32+16]	
	movsd xmm7,[rbp+8+8+32+24]
	movsd xmm8,[rbp+8+8+32+32]	
	movsd xmm9,[rbp+8+8+32+40]
leave
ret
								
