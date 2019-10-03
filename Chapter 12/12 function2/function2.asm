; function2.asm
extern printf
section .data							
	radius	dq	10.0								
section .bss							
section .text
area:
	section .data
		.pi	dq	3.141592654	; local to area
	section .text 
push rbp
mov rbp, rsp
		movsd xmm0, [radius]
		mulsd xmm0, [radius]
		mulsd xmm0, [.pi]
leave
ret
circum:
	section .data
		.pi	dq	3.14		; local to circum
	section .text
push rbp
mov rbp, rsp	
		movsd xmm0, [radius]
		addsd xmm0, [radius]
		mulsd xmm0, [.pi]
leave
ret
circle:
	section .data
		.fmt_area	db	"The area is %f",10,0
		.fmt_circum	db	"The circumference is %f",10,0
	section .text
push rbp
mov rbp, rsp		
		call area	
		mov	rdi,.fmt_area
		mov	rax,1			; area in xmm0
		call printf
		call circum
		mov	rdi,.fmt_circum
		mov	rax,1			; circumference in xmm0
		call printf
leave
ret
	global main						
main:
    mov rbp, rsp; for correct debugging
push rbp
mov rbp, rsp
	call circle
leave
ret
