; move_strings.asm
%macro prnt 2
    mov     rax, 1		; 1 = write		
    mov     rdi, 1		; 1 = to stdout			
    mov     rsi, %1					
    mov     rdx, %2						
    syscall
	mov rax, 1
	mov rdi, 1
	mov rsi, NL
	mov rdx, 1
    syscall

%endmacro

section .data							
	length	equ 95
	NL db 0xa
	string1 db "my_string of ASCII:"
	string2 db 10,"my_string of zeros:"
	string3 db 10,"my_string of ones:"
	string4 db 10,"again my_string of ASCII:"
	string5 db 10,"copy my_string to other_string:"
	string6 db 10,"reverse copy my_string to other_string:"
section .bss
        my_string  resb	length
	other_string resb length

section .text							
	global main						
main:
push	rbp
mov 	rbp, rsp
;-----------------------------------------------------------------------
;fill the string with printable ascii characters
		prnt string1,18
		mov rax,32
		mov rdi,my_string
		mov rcx, length
str_loop1:	mov byte[rdi], al		; the simple method
		inc rdi
        	inc al
		loop str_loop1
		prnt my_string,length
;-----------------------------------------------------------------------
;fill the string with ascii 0's
		prnt string2,20
		mov rax,48
		mov rdi,my_string
		mov rcx, length
str_loop2:	stosb				; no inc rdi needed anymore
		loop str_loop2
		prnt my_string,length
;-----------------------------------------------------------------------
;fill the string with ascii 1's
		prnt string3,19
		mov rax, 49
		mov rdi,my_string
		mov rcx, length
        	rep stosb			; no inc rdi and no loop needed anymore
		prnt my_string,length
;-----------------------------------------------------------------------
;fill the string again with printable ascii characters
		prnt string4,26
		mov rax,32
		mov rdi,my_string
		mov rcx, length
str_loop3:	mov byte[rdi], al		; the simple method
		inc rdi
      	inc al
		loop str_loop3
		prnt my_string,length
;-----------------------------------------------------------------------
;copy my_string to other_string	
		prnt string5,32
		mov rsi,my_string			;rsi source
		mov rdi,other_string		;rdi destination
		mov rcx, length
		rep movsb
		prnt other_string,length
;-----------------------------------------------------------------------
;reverse copy my_string to other_string	
		prnt string6,40
		mov rax, 48			;clear other_string
		mov rdi,other_string
		mov rcx, length
    		rep stosb			
		lea rsi,[my_string+length-4]
		lea rdi,[other_string+length]
		mov rcx, 27			;copy only ten characters
		std					;std sets DF, cld clears DF
		rep movsb
		prnt other_string,length
leave
ret				
