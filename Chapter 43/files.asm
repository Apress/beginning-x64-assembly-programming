;files.asm
%include "win32n.inc"
extern printf
extern CreateFileA
extern WriteFile
extern SetFilePointer
extern ReadFile
extern CloseHandle

section .data
    msg			db 'Hello, Windows World!',0
    nNumberOfBytesToWrite	equ $-msg
    filename    db  'mytext.txt',0
    nNumberOfBytesToRead	equ 30
    fmt 		db "The result of reading the file: %s",10,0
section .bss
    fHandle 				resq 1
    lpNumberOfBytesWritten 	resq 1
    lpNumberOfBytesRead 	resq 1
    readbuffer 				resb 64
section .text
	global main
main:
push	rbp
mov 	rbp,rsp    

;HANDLE CreateFileA(
;  LPCSTR                lpFileName,
;  DWORD                 dwDesiredAccess,
;  DWORD                 dwShareMode,
;  LPSECURITY_ATTRIBUTES lpSecurityAttributes,
;  DWORD                 dwCreationDisposition,
;  DWORD                 dwFlagsAndAttributes,
;  HANDLE                hTemplateFile
;);   
 	sub		rsp,8
    lea 	rcx,[filename]                    	;filename
    mov 	rdx, GENERIC_READ|GENERIC_WRITE   	;desired access
    mov 	r8,0                              	;no sharing
    mov 	r9,0                              	;default security
    ; push in reverse order
    push 	NULL                           ;no template
    push 	FILE_ATTRIBUTE_NORMAL          ;flags and attributes   
    push 	CREATE_ALWAYS                  ;disposition

    sub 	rsp,32							;shadow
    call 	CreateFileA
    add     rsp,32+8 
    mov 	[fHandle],rax

;BOOL WriteFile(
;  HANDLE       hFile,
;  LPCVOID      lpBuffer,
;  DWORD        nNumberOfBytesToWrite,
;  LPDWORD      lpNumberOfBytesWritten,
;  LPOVERLAPPED lpOverlapped
;);
           
	mov 	rcx,[fHandle]					;handle
	lea 	rdx,[msg]						;msg to write
	mov 	r8,nNumberOfBytesToWrite		;# bytes to write
	mov 	r9,[lpNumberOfBytesWritten]		;returns # bytes written
	push 	NULL
	sub 	rsp,32							;shadow
	call 	WriteFile
	add 	rsp,32

;DWORD SetFilePointer(
;  HANDLE hFile,
;  LONG   lDistanceToMove,
;  PLONG  lpDistanceToMoveHigh,
;  DWORD  dwMoveMethod
;);   
     
	mov 	rcx,[fHandle]			;handle
	mov 	rdx, 7       			;low bits of position
	mov 	r8,0         			;no high order bits in position
	mov 	r9,FILE_BEGIN     		;start from beginning
	call	SetFilePointer

;BOOL ReadFile(
;  HANDLE       hFile,
;  LPCVOID      lpBuffer,
;  DWORD        nNumberOfBytesToRead,
;  LPDWORD      lpNumberOfBytesRead,
;  LPOVERLAPPED lpOverlapped
;);           
	sub		rsp,8						;align
	mov 	rcx,[fHandle]				;handle
	lea 	rdx,[readbuffer]			;buffer to read into
	mov 	r8,nNumberOfBytesToRead		;# bytes to read
	mov 	r9,[lpNumberOfBytesRead]	;# bytes read
	push 	NULL
	sub 	rsp,32						;shadow
	call 	ReadFile
	add 	rsp,32+8

;print result of ReadFile
	mov 	rcx, fmt
    mov 	rdx, readbuffer
    sub 	rsp,32+8
    call 	printf
    add 	rsp,32+8
    
;BOOL WINAPI CloseHandle(
;  _In_ HANDLE hObject
;);
 
	mov 	rcx,[fHandle]
	sub 	rsp,32+8
	call 	CloseHandle
	add 	rsp,32+8       
leave
ret

