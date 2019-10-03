; stack.asm
extern printf
section .data							
	strng 		db	"ABCDE",0
	strngLen	equ	$ - strng-1		; stringlength without 10 and 0
  	fmt1    	db  "The original string: %s",10,0
 	fmt2    	db  "The reversed string: %s",10,0
section .bss
section .text							
	global main						
main:
    push rbp
    mov rbp,rsp

; Print the original string
    mov		rdi, fmt1
    mov    	rsi, strng
    mov		rax, 0		
    call  	printf		

;push the string char per char on the stack    
    	xor rax, rax            
		mov rbx, strng		; address of strng in rbx
		mov rcx, strngLen	; length in rcx counter		
		mov r12, 0		; use r12 as pointer
	pushLoop:
; push char per char on the stack
		mov al, byte [rbx+r12] ; move char into rax
    	push rax			;push rax on the stack	
		inc r12			; increase char pointer with 1
		loop pushLoop		; continue loop

;pop the string char per char from the stack
;this will reverse the original string 
		mov rbx, strng		; address of strng in rbx
		mov rcx, strngLen	; length in rcx counter	
		mov r12, 0		; use r12 as pointer
	popLoop:
		pop rax			; pop a char from the stack
		mov byte [rbx+r12], al ;move the popped char into strng
		inc r12			; increase char pointer with 1
		loop popLoop		; continue loop
     	mov byte [rbx+r12],0        ; terminate string with 0

; Print the reversed string
    mov		rdi, fmt2
    mov   	rsi, strng
    mov		rax, 0		
    call   	printf	                

    mov rsp,rbp
    pop rbp
    ret
