; fcalc.asm
extern printf
section .data							
	number1	dq	9.0					
	number2	dq	73.0
	fmt	db	"The numbers are %f and %f",10,0					
	fmtfloat	db	"%s %f",10,0 
	f_sum	db	"The float sum of %f and %f is %f",10,0
	f_dif	db	"The float difference of %f and %f is %f",10,0
	f_mul	db	"The float product of %f and %f is %f",10,0
	f_div	db	"The float division of %f by %f is %f",10,0
        f_sqrt	db	"The float squareroot of %f is %f",10,0
section .bss
section .text							
	global main					
main:
    push	rbp		; necessary because of printf with float
    mov     rbp,rsp
; print the numbers
	movsd xmm0, [number1]
	movsd xmm1, [number2]
	mov	rdi,fmt
	mov	rax,2	; two floats
	call 	printf
; sum	
    movsd xmm2, [number1]	; double precision float into xmm
    addsd xmm2, [number2]	; add into to xmm
		; print the result
		movsd xmm0, [number1]
		movsd xmm1, [number2]
		mov	rdi,f_sum
		mov	rax,3	; one float
		call 	printf
; difference    
    movsd xmm2, [number1]	; double precision float into xmm
    subsd xmm2, [number2]	; subtract from xmm
		; print the result
		movsd xmm0, [number1]
		movsd xmm1, [number2]
            	mov	rdi,f_dif
		mov	rax,3	; three floats
		call 	printf
; multiplication  
    movsd xmm2, [number1]	; double precision float into xmm
    mulsd xmm2, [number2]	; multiply with xmm 
		; print the result
            	mov	rdi,f_mul
            	movsd xmm0, [number1]
		movsd xmm1, [number2]
		mov	rax,3	; three floats
		call 	printf
; division
    movsd xmm2, [number1]	; double precision float into xmm
    divsd xmm2, [number2]	; divide xmm0 
		; print the result
            	mov	rdi,f_div
            	movsd xmm0, [number1]
		movsd xmm1, [number2]
		mov	rax,1	; one float
		call 	printf
; squareroot
   sqrtsd xmm1, [number1]	; squareroot double precision float in xmm
		; print the result
            	mov	rdi,f_sqrt
            	movsd xmm0, [number1]
		mov	rax,2	; one float
		call 	printf
; exit
    mov rsp,rbp              
    pop	rbp		; undo the push at the beginning
    ret
