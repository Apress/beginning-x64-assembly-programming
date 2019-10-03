; function.asm
extern printf
section .data							
	radius	dq	10.0				
	pi		dq	3.14				
	fmt		db	"The area of the circle is %.2f",10,0
section .bss							
section .text												
	global main						
;----------------------------------------------
main:
push 	rbp
mov 	rbp, rsp 
	call surface			; call the function
	mov	rdi,fmt          	; print format
	movsd xmm1, [radius]	; move float to xmm1
	mov	rax,1				; surface in xmm0
	call printf
        leave
ret
;----------------------------------------------
surface:
push 	rbp
mov 	rbp, rsp  		
	movsd xmm0, [radius]	; move float to xmm0
	mulsd xmm0, [radius]	; multiply xmm0 by float
	mulsd xmm0, [pi]	 	; multiply xmm0 by float
leave
ret				
