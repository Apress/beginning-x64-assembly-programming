%include "win32n.inc"
extern ExitProcess
extern MessageBoxA

section .data
	msg	db 'Welcome to Windows World!',0
	cap	db "Windows 10 says:",0

section .text
	global main
main:
push    rbp
mov     rbp,rsp
  
;int MessageBoxA(
;        HWND hWnd,             owner window
;        LPCSTR lpText,         text to display
;        LPCSTR lpCaption,      window caption
;        UINT    uType          window behaviour
;       )
                    
	mov     rcx,0               ; no window owner
	lea     rdx,[msg]           ; lpText
	lea     r8,[cap]            ; lpCaption
	mov     r9d,MB_OK               ; window with OK button
	sub     rsp,32              ; shadowspace
	call    MessageBoxA         ; returns IDOK=1 if OK button selected
	add     rsp,32
leave
ret