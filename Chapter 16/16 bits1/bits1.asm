; bits1.asm
extern printb  
extern printf
section .data
	msgn1	db  "Number 1",10,0
	msgn2	db  "Number 2",10,0
    msg1    db  "XOR",10,0
  	msg2    db  "OR",10,0
	msg3    db  "AND",10,0
	msg4	db  "NOT number 1",10,0
	msg5	db  "SHL 2 lower byte of number 1",10,0
	msg6	db  "SHR 2 lower byte of number 1",10,0
	msg7	db  "SAL 2 lower byte of number 1",10,0
	msg8	db  "SAR 2 lower byte of number 1",10,0
	msg9	db  "ROL 2 lower byte of number 1",10,0
	msg10	db  "ROL 2 lower byte of number 2",10,0
	msg11	db  "ROR 2 lower byte of number 1",10,0
	msg12	db  "ROR 2 lower byte of number 2",10,0
	number1	dq	-72
 	number2 dq  	1064
section .bss
section .text							
	global main						
main:
    mov rbp, rsp; for correct debugging
    push rbp
    mov rbp,rsp
; print number1
mov     rsi, msgn1				
call printmsg	
    	mov rdi, [number1]
	call printb
; print number2
mov     rsi, msgn2				
call printmsg
	mov rdi, [number2]
        call printb

; print XOR (exclusive OR)------------------------       
mov     rsi, msg1				
call printmsg			
; xor and print
        mov rax,[number1]
        xor rax,[number2]
        mov rdi, rax
	call printb

; print OR ---------------------------------------             
mov     rsi, msg2				
call printmsg
; or and print
        mov rax,[number1]
        or rax,[number2]
        mov rdi, rax
	call printb

; print AND  ---------------------------------------              
mov     rsi, msg3				
call printmsg			
; and and print
        mov rax,[number1]
        and rax,[number2]
        mov rdi, rax
	call printb

; print NOT  ---------------------------------------              
mov     rsi, msg4				
call printmsg			
; not and print
	mov rax,[number1]
	not rax
	mov rdi, rax
	call printb

; print SHL  (shift left----------------------------              
mov     rsi, msg5				
call printmsg			
; shl and print
	mov rax,[number1]
	shl al,2
 	mov rdi, rax
	call printb

; print SHR  (shift right)--------------------------              
mov     rsi, msg6				
call printmsg			
;shr and print
	mov rax,[number1]
	shr al,2
 	mov rdi, rax
	call printb

; print SAL  (shift arithmetic left)----------------              
mov     rsi, msg7				
call printmsg			
; sal and print
	mov rax,[number1]
	sal al,2
  	mov rdi, rax
	call printb

; print SAR  (shift arithmetic right)----------------              
mov     rsi, msg8				
call printmsg			
; sar and print
 	mov rax,[number1]
	sar al,2
  	mov rdi, rax
	call printb

; print ROL  (rotate left)---------------------------              
mov     rsi, msg9				
call printmsg			
; rol and print
  	mov rax,[number1]
	rol al,2
   	mov rdi, rax
	call printb
mov     rsi, msg10				
call printmsg	
 	mov rax,[number2]
	rol al,2
 	mov rdi, rax
	call printb
; print ROR  (rotate right)---------------------------              
mov     rsi, msg11				
call printmsg			
; ror and print
 	mov rax,[number1]
	ror al,2
  	mov rdi, rax
	call printb
mov     rsi, msg12				
call printmsg	
  	mov rax,[number2]
	ror al,2
  	mov rdi, rax
	call printb
leave
ret		


printmsg:	; print the heading for every bit operation
	section .data
	       	.fmtstr	db	"%s",0
	section .text
		mov	rdi,.fmtstr
		mov	rax,0
		call 	printf
	ret
								
