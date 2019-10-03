%include "win32n.inc" 
	extern WriteFile
	extern WriteConsoleA
	extern GetStdHandle

section .data
	msg		db 	'Hello, World!!',10,0
	msglen	EQU	$-msg-1		; leave off the NULL

section .bss
	hFile                   resq	1	; handle to file
	lpNumberOfBytesWritten  resq	1

section .text
	global main
main:
push	rbp
mov		rbp,rsp
         
; get a handle to stdout
;HANDLE WINAPI GetStdHandle(
;  _In_ DWORD nStdHandle
;);

    mov     rcx, STD_OUTPUT_HANDLE
    sub     rsp,32          	;shadowspace
	call    GetStdHandle		;returns INVALID_HANDLE_VALUE if no success
    add	    rsp,32
    mov     qword[hFile],rax 	;save received handle to memory

;BOOL WINAPI WriteConsole(
;  _In_			HANDLE 	hConsoleOutput,
;  _In_	const 	VOID	*lpBuffer,
;  _In_  		DWORD 	nNumberOfCharsToWrite,
;  _Out_		LPDWORD	lpNumberOfCharsWritten,
;  _Reserved_ 	LPVOID 	lpReserved
;);
	sub		rsp, 8				;align the stack
	mov     rcx, qword[hFile]
	lea     rdx, [msg]      	;lpBuffer
	mov     r8, msglen       	;nNumberOfBytesToWrite
	lea     r9, [lpNumberOfBytesWritten] 
	push    NULL                ;lpReserved
	sub     rsp, 32         
	call    WriteConsoleA    	;returns nonzero if success
	add     rsp, 32+8

; BOOL WriteFile(
;		HANDLE      	hFile,
;		LPCVOID     	lpBuffer,
;  		DWORD       	nNumberOfBytesToWrite,
;    	LPDWORD     	lpNumberOfBytesWritten,
;   	LPOVERLAPPED    lpOverlapped
;);

	mov     rcx, qword[hFile]  	; file handle 
	lea     rdx, [msg]      	;lpBuffer
	mov     r8, msglen       	;nNumberOfBytesToWrite
	lea     r9, [lpNumberOfBytesWritten] 
	push 	NULL              	;lpOverlapped
	sub     rsp,32
	call    WriteFile     		;returns nonzero of success
leave
ret


