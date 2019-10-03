; stack.asm
extern printf
section .data				
	first	db	"A"					
	second	db	"B"
	third	db	"C"
	fourth	db	"D"			
	fifth	db	"E"
	sixth	db	"F"
	seventh	db	"G"
	eighth  db	"H"
	ninth   db	"I"
	tenth   db	"J"
 	fmt		db	"The string is: %s",10,0 
section .bss
	flist 	resb	14          ;length of string plus end 0													
section .text									
	global main						
main:
push rbp
mov rbp,rsp
	sub rsp, 8
	mov rcx, flist	
	mov rdx, first
	mov r8, second
	mov r9, third			
	push tenth		; now start pushing in
	push ninth		; reverse order
	push eighth		
	push seventh		
	push sixth
	push fifth
	push fourth
    sub rsp,32  	; shadow
	call lfunc
    add rsp,32+8
; print the result
	mov rcx, fmt
	mov rdx, flist
    sub rsp,32+8             
	call printf
    add rsp,32+8
leave
ret	
;---------------------------------------------------------------------------											
lfunc:	
push 	rbp
mov 	rbp,rsp
    xor rax,rax             ;clear rax (especially higher bits)      
	;arguments in registers
	mov al,byte[rdx]      	; move content argument to al
	mov [rcx], al         	; store al to memory 
	mov al, byte[r8]          
	mov [rcx+1], al           
	mov al, byte[r9]
	mov [rcx+2], al
	;arguments on stack
	xor rbx,rbx
	mov rax, qword [rbp+8+8+32] ; stack + rbp + return address + shadow
	mov bl,[rax]
	mov [rcx+3], bl
	mov rax, qword [rbp+48+8]
	mov bl,[rax]
	mov [rcx+4], bl
	mov rax, qword [rbp+48+16]
	mov bl,[rax]
	mov [rcx+5], bl
	mov rax, qword [rbp+48+24]
	mov bl,[rax]
	mov [rcx+6], bl
	mov rax, qword [rbp+48+32]
	mov bl,[rax]
	mov [rcx+7], bl
	mov rax, qword [rbp+48+40]
	mov bl,[rax]
	mov [rcx+8], bl
	mov rax, qword [rbp+48+48]
	mov bl,[rax]
	mov [rcx+9], bl     
	mov bl,0                ; terminating zero
	mov [rcx+10], bl
leave
ret
								
