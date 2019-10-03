; cpu.asm
extern printf
section .data							
        fmt_no_sse	db "This cpu does not support SSE",10,0
        fmt_sse42	db "This cpu supports SSE 4.2",10,0
        fmt_sse41	db "This cpu supports SSE 4.1",10,0
        fmt_ssse3	db "This cpu supports SSSE 3",10,0
        fmt_sse3	db "This cpu supports SSE 3",10,0
        fmt_sse2	db "This cpu supports SSE 2",10,0
        fmt_sse	db "This cpu supports SSE",10,0          
section .bss
section .text							
	global main					
main:
push rbp
mov	rbp,rsp
    call cpu_sse    ;returns 1 in rax if sse support, otherwise 0  
leave
ret

cpu_sse:
	push rbp
	mov rbp,rsp
    	xor r12,r12  	;flag SSE available
    	mov eax,1     	;request CPU feature flags
    	cpuid 

;test for SSE
    test edx,2000000h	;test bit 25 (SSE)
    jz sse2     		;SSE available                  
    mov r12,1
    xor rax,rax
    mov rdi,fmt_sse
    push rcx            	;modified by printf
    push rdx			;preserve result of cpuid
    call printf
    pop rdx
    pop rcx
sse2:
    test edx,4000000h   	;test bit 26 (SSE 2)
    jz sse3            	;SSE 2 available                  
    mov r12,1
    xor rax,rax
    mov rdi,fmt_sse2
    push rcx            	;modified by printf
    push rdx			;preserve result of cpuid
    call printf
    pop rdx
    pop rcx
sse3:   
    test ecx,1         	;test bit 0 (SSE 3)
    jz ssse3       		;SSE 3 available                  
    mov r12,1
    xor rax,rax
    mov rdi,fmt_sse3
    push rcx            	;modified by printf
    call printf
    pop rcx
ssse3:   
    test ecx,9h         	;test bit 0 (SSE 3)
    jz sse41          	;SSE 3 available                  
    mov r12,1
    xor rax,rax
    mov rdi,fmt_ssse3
    push rcx            	;modified by printf
    call printf
    pop rcx
sse41:
    test ecx,80000h    	;test bit 19 (SSE 4.1)
    jz sse42            	;SSE 4.1 available
    mov r12,1
    xor rax,rax
    mov rdi,fmt_sse41 
    push rcx            	;modified by printf
    call printf
    pop rcx
sse42:                   
   test ecx,100000h    	;test bit 20 (SSE 4.2)
   jz wrapup           	;SSE 4.2 available
   mov r12,1
   xor rax,rax
   mov rdi,fmt_sse42 
   push rcx            	;modified by printf
   call printf
   pop rcx
wrapup:
    cmp r12,1
    je sse_ok
    mov rdi,fmt_no_sse
    xor rax,rax
    call printf         	;displays message if SSE not available
    jmp the_exit 

sse_ok:
    mov rax,r12      	;returns 1, sse supported

the_exit:      

leave
ret
