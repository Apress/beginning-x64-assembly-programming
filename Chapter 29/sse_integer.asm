; sse_integer.asm
extern printf


section .data
	
	dummy   db      13
align 16						
	pdivector1	dd 	1
                 	dd 	2
                 	dd 	3
                 	dd 	4
	pdivector2   	dd 	5
                 	dd 	6
                 	dd	7
                 	dd 	8
                 
        fmt1 db "Packed Integer Vector 1: %d, %d, %d, %d",10,0
        fmt2 db "Packed Integer Vector 2: %d, %d, %d, %d",10,0
        fmt3 db "Sum Vector: %d, %d, %d, %d",10,0
        fmt4 db "Reverse of Sum Vector: %d, %d, %d, %d",10,0

section .bss
alignb 16
	pdivector_res 		resd 4
	pdivector_other 	resd 4

section .text							
	global main					
main:
push	rbp	
mov	rbp,rsp
    
; print vector 1
    mov	rsi,pdivector1
    mov 	rdi,fmt1
    call 	printpdi 
; print vector 2
    mov 	rsi,pdivector2
    mov 	rdi,fmt2
    call 	printpdi 

; add 2 aligned double int vectors        
    movdqa	xmm0, [pdivector1]          
    paddd 	xmm0, [pdivector2] 
           
; store the result in memory
    movdqa 	[pdivector_res], xmm0
; print the vector in memory
    mov 	rsi,pdivector_res
    mov 	rdi,fmt3
    call 	printpdi 
 
; copy the memory vector to xmm3   
    movdqa xmm3,[pdivector_res]

; extract the packed values from xmm3   
    pextrd eax, xmm3, 0
    pextrd ebx, xmm3, 1
    pextrd ecx, xmm3, 2
    pextrd edx, xmm3, 3
; insert in xmm0 in reverse order   
    pinsrd xmm0, eax, 3
    pinsrd xmm0, ebx, 2
    pinsrd xmm0, ecx, 1
    pinsrd xmm0, edx, 0

; print the reversed vector
    movdqa [pdivector_other], xmm0
    mov 	rsi,pdivector_other
    mov 	rdi,fmt4
    call 	printpdi   
    

; exit
mov 	rsp,rbp              
pop	rbp	
ret

;print function-----------------------------------------------
printpdi:    
push rbp
mov 	rbp,rsp
	movdqa xmm0, [rsi]
; extract the packed values from xmm3
        pextrd esi, xmm0,0
        pextrd edx, xmm0,1
        pextrd ecx, xmm0,2
        pextrd r8d, xmm0,3
	mov	rax,0	; no floats
	call 	printf
leave
ret



