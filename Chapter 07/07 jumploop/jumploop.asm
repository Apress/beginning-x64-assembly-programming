; jumploop.asm
extern printf
section .data							
	number	dq	5					
	fmt	db	"The sum from 0 to %ld is %ld",10,0
section .bss
section .text							
	global main						
main:
    push 	rbp
    mov 	rbp, rsp
	mov 	rbx,0	; initialize rax with startnr
  	mov     rax,0               ; sum
jloop:	
	add     rax, rbx
 	inc     rbx
	cmp 	rbx,[number]	; number already reached?
	jle 	jloop		; number not reached yet, loop
						; number reached, continue here
	mov		rdi,fmt		; prepare for displaying
	mov		rsi, [number]	
    mov     rdx,rax
	mov		rax,0
	call 	printf
    mov 	rsp,rbp
    pop 	rbp
	ret

