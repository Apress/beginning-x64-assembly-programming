; cmdline.asm
section .data
    NL	  db	10,0
    msg     db "The command and arguments: ",10,0
section .bss
section .text
	global main
main:
push rbp
mov rbp,rsp
    mov r12, rdi ;rdi contains number of arguments
    mov r13, rsi ;rsi contains the address to the array of arguments

printArguments:
    mov rdi, msg
    call printString
    mov rbx, 0 
printLoop:
    mov rdi, qword [r13+rbx*8] 
    call printString
    mov rdi, NL 
    call printString
    inc rbx
    cmp rbx, r12 
    jl printLoop
leave
ret


global printString
printString:
    push rbx
    push rax
    push r12
; Count characters 
    mov r12, rdi
    mov rdx, 0 
strLoop:
    cmp byte [r12], 0
    je strDone
    inc rdx                 ;length in rdx
    inc r12
    jmp strLoop
strDone:
    cmp rdx, 0              ; no string (0 length)
    je prtDone
    mov rsi,rdi
    mov rax, 1 
    mov rdi, 1
    syscall
prtDone:
    pop r12
    pop rax
    pop rbx
    ret
