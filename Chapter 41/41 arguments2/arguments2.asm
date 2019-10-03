; arguments2.asm
extern printf
section .data				
	first	db	"A",0					
	second	db	"B",0
	third	db	"C",0
	fourth	db	"D",0			
	fifth	db	"E",0
	sixth	db	"F",0
	seventh	db	"G",0
	eighth  db	"H",0
	ninth   db 	"I",0
	tenth   db 	"J",0
 	fmt	db	"The string is: %s%s%s%s%s%s%s%s%s%s",10,0     
section .bss													
section .text									
	global main						
main:
push 	rbp
mov 	rbp,rsp
	sub 	rsp,32+56+8    ;shadow space + 7 arguments on stack + alignment
	mov 	rcx, fmt			
	mov 	rdx, first	
	mov 	r8, second
	mov 	r9, third			
	mov 	qword[rsp+32],fourth
	mov 	qword[rsp+40],fifth        
	mov 	qword[rsp+48],sixth
	mov 	qword[rsp+56],seventh        
	mov 	qword[rsp+64],eighth        
	mov 	qword[rsp+72],ninth
	mov 	qword[rsp+80],tenth           
	call 	printf
	add 	rsp, 32+56+8        ;not needed before leave
leave
ret	
