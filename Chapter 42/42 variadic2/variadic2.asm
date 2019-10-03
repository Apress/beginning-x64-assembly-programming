; variadic2.asm
extern printf
section .data							
	fmt	db	"%.1f %s %.1f %s %.1f %s %.1f %s %.1f %s",10,0
        one 	dq 1.0
        two 	dq 2.0
        three 	dq 3.0
        four 	dq 4.0
        five 	dq 5.0
        A   	db "A",0
        B   	db "B",0
        C   	db "C",0
        D   	db "D",0
        E   	db "E",0
 
section .bss							
section .text
    global main
main:
push rbp
mov rbp,rsp
	sub		rsp,8			;align the stack first
	mov		rcx,fmt			;first argument
	movq  	xmm0,[one]		;second argument
	movq  	rdx,xmm0
	mov   	r8,A			;third argument	
	movq  	xmm1,[two]		;fourth argument	
	movq  	r9,xmm1
; now push to the stack in reverse
	push  	E				;11th argument

	push	qword[five]		;10th argument
	
	push  	D     			;9th argument

	push	qword[four]		;8th argument

	push  	C  				;7th argument
	
	push	qword[three]	;6th argument

	push  	B  				;5th argument
	
; print	
	sub rsp,32	
	call printf
	add rsp,32
leave
ret
