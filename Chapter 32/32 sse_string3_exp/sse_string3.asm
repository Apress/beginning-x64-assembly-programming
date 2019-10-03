; sse_string3_exp.asm
; compare strings explicit length
extern printf
section .data					    
	string1	db	"the quick brown fox jumps over the "
			db	"lazy river" 
	string1Len equ $ - string1
	string2	db	"the quick brown fox jumps over the "
			db	"lazy river"
	string2Len equ $ - string2 
	dummy	db "confuse the world"       
	string3   db	"the quick brown fox jumps over the " 
			db	"lazy dog"     
	string3Len  equ $ - string3  
             
	fmt1 	db "Strings 1 and 2 are equal.",10,0
	fmt11   	db "Strings 1 and 2 differ at position %i.",10,0               
	fmt2 	db "Strings 2 and 3 are equal.",10,0
	fmt22   	db "Strings 2 and 3 differ at position %i.",10,0   
 
section .bss
        buffer resb 64
section .text							
	global main					
main:
push	rbp
mov	rbp,rsp
  
; compare string 1 and 2
    mov 	rdi, string1
    mov 	rsi, string2
    mov 	rdx, string1Len
    mov 	rcx, string2Len
    call 	pstrcmp
    push 	rax    ;push result on stack for later use

; print the string1 and 2 and the result
;-------------------------------------------------------------
; first build the string with newline and terminating 0
; string1
    mov 	rsi,string1
    mov 	rdi,buffer
    mov 	rcx,string1Len
    rep 	movsb        
    mov 	byte[rdi],10	; add NL to buffer
    inc 	rdi         	; add terminating 0 to buffer
    mov 	byte[rdi],0
;print
    mov 	rdi, buffer
    xor 	rax,rax
    call 	printf 
; string2
    mov 	rsi,string2
    mov 	rdi,buffer
    mov 	rcx,string2Len
    rep 	movsb        
    mov 	byte[rdi],10	; add NL to buffer
    inc 	rdi         	; add terminating 0 to buffer
    mov 	byte[rdi],0
;print
    mov 	rdi, buffer
    xor 	rax,rax
    call 	printf     
;-------------------------------------------------------------       
; now print the result of the comparison
    pop 	rax     ;recall the return value      
    mov 	rdi,fmt1
    cmp 	rax,0
    je 	eql1
    mov 	rdi,fmt11
 eql1:
    mov 	rsi, rax
    xor 	rax,rax
    call 	printf
;-------------------------------------------------------------
;-------------------------------------------------------------
; compare string 2 and 3
    mov 	rdi, string2
    mov 	rsi, string3
    mov 	rdx, string2Len
    mov 	rcx, string3Len
    call 	pstrcmp
    push 	rax

; print the string3 and the result
;-------------------------------------------------------------
; first build the string with newline and terminating 0
; string3
    mov 	rsi,string3
    mov 	rdi,buffer
    mov 	rcx,string3Len
    rep 	movsb        
    mov 	byte[rdi],10	; add NL to buffer
    inc 	rdi         	; add terminating 0 to buffer
    mov 	byte[rdi],0
;print
    mov 	rdi, buffer
    xor 	rax,rax
    call 	printf
;-------------------------------------------------------------       
; now print the result of the comparison
    pop 	rax     		; recall the return value               
    mov 	rdi,fmt2
    cmp 	rax,0
    je 	eql2
    mov 	rdi,fmt22
 eql2:
    mov 	rsi, rax
    xor 	rax,rax
    call 	printf   

; exit
leave
ret
;-------------------------------------------------------------  

pstrcmp:
push	rbp		
mov	rbp,rsp
	xor     rbx, rbx
	mov     rax, rdx         ;rax contains length of 1st string
	mov     rdx, rcx         ;rdx contains length of 2nd string    
	xor     rcx, rcx         ;rcx as index
.loop:      
	movdqu   	xmm1, [rdi + rbx]
	pcmpestri	xmm1, [rsi + rbx], 0x18	; equal each | neg. polarity
	jc      	.differ
	jz      	.equal
	add      	rbx, 16
	sub     	rax, 16
	sub      	rdx, 16
	jmp     	.loop

.differ:
    	mov 	rax,rbx         
    	add 	rax,rcx			; rcx contains the differing position
    	inc 	rax                 ; because the counter starts at 0
    	jmp 	exit
.equal: 
    	xor 	rax,rax
exit:
leave
ret
