; sse_string4.asm
; find a character
extern print16b
extern printf
section .data
	string1   db	"qdacdekkfijlmdozabecdfgdklkmdddaffffffffdedeee",10,0 
	string2	db	"e",0
	string3	db	"a",0             
	fmt 		db 	"Find all the characters '%s' and '%s' in:",10,0
	fmt_oc 	db 	"I found %ld characters '%s'and '%s'",10,0
	NL  		db 	10,0
section .bss
section .text							
	global main					
main:
push	rbp
mov	rbp,rsp

;print the search characters
	mov 	rdi, fmt
	mov 	rsi, string2
	mov 	rdx, string3
	xor 	rax,rax
	call printf
;print the target string
    	mov 	rdi, string1
    	xor 	rax,rax
    	call printf 
; search the string and print mask
    	mov 	rdi, string1
    	mov 	rsi, string2
    	mov 	rdx, string3
    	call pcharsrch
;print the number of occurences of string2    
	mov 	rdi, fmt_oc
	mov 	rsi, rax
	mov 	rdx, string2
	mov 	rcx, string3
	call printf
; exit
    leave
    ret
;-------------------------------------------------------------
;function searching for and printing the mask
pcharsrch:           ;packed character search
push	rbp		
mov	rbp,rsp
    	sub	rsp,16      ;provide stack space for pushing xmm1
	xor 	r12,r12     ;for the running total of occurrences
    	xor 	rcx,rcx     ;for signaling the end
    	xor 	rbx,rbx     ;for address calculation
    	mov 	rax,-16     ;for counting bytes, avoid flag setting
;build xmm1, load the search character
    	pxor 	xmm1,xmm1  	; clear xmm1
	pinsrb 	xmm1,byte[rsi],0  	; first char at index 0
	pinsrb 	xmm1,byte[rdx],1	;second char at index 1
.loop:
    	add 		rax,16    	;avoid ZF flag setting
    	mov 		rsi,16       	;if no terminating 0, print 16 bytes
    	movdqu 	xmm2,[rdi+rbx]	;load 16 bytes of the string in xmm2
    	pcmpistrm xmm1,xmm2,40h 	;'equal each' and 'byte mask in xmm0'
    	setz  	cl            	;if terminating 0 detected
;if terminating 0 found, determine position
	cmp 	cl,0
	je 	.gotoprint   	;no terminating 0 found
	;terminating null found
	;less than 16 bytes left
	;rdi contains address of string
	;rbx contains #bytes in blocks handled so far
 	add 	rdi,rbx		;address of remaining part of string
	push	rcx			;caller saved (cl in use)
	call pstrlen       	;rax returns the length
	pop	rcx			;caller saved
	dec 	rax			;length without 0
	mov 	rsi,rax		;length of remaining mask bytes

;print the mask
.gotoprint:
	call print_mask
;keep running total of matches
    	popcnt  	r13d,r13d     	;count the number of 1 bits 
    	add 		r12d,r13d   	;keep the number of occurences in r12d
    	or  		cl,cl       	; terminating 0 detected?
    	jnz 		.exit    
    	add 		rbx,16      	;preprare for the next 16 bytes
    	jmp 		.loop
.exit:
   	mov 	rdi, NL         ;add a newline
    	call printf
    	mov 	rax,r12         ;number of occurences
leave
ret
;-------------------------------------------------------------
;function for finding the terminating 0
pstrlen:
push	rbp		
mov	rbp,rsp
	sub 		rsp,16 		;for saving xmm0
   	movdqu 	[rbp-16],xmm0	;push xmm0
	mov		rax, -16		;avoid flag setting later
	pxor      xmm0, xmm0	;search for 0 (end of string)	
.loop:  add	rax, 16    	;avoid setting ZF when rax = 0 after pcmpistri
	pcmpistri	xmm0, [rdi + rax], 0x08 ;'equal each'
	jnz     	.loop         	;0 found?
	add    	rax, rcx		;rax = bytes already handled
                             	;rcx = bytes handled in terminating loop
    movdqu 	xmm0,[rbp-16]	;pop xmm0
leave
ret
;-------------------------------------------------------------
;function for printing the mask
;xmm0 contains the mask
;rsi contains the number of bits to print (16 or less)
print_mask:
push	rbp		
mov	rbp,rsp
	sub 		rsp,16 		;for saving xmm0
    	call 	reverse_xmm0	;little endian
    	pmovmskb 	r13d,xmm0  	;mov byte mask to edx
    	movdqu 	[rbp-16],xmm1	;push xmm1 because of printf
    	push 	rdi        	;rdi contains string1
    	mov 		edi,r13d		;contains mask to be printed
    	push 	rdx			;contains the mask
    	push 	rcx        	;contains end of string flag
    	call 	print16b
    	pop 		rcx
    	pop 		rdx
    	pop 		rdi
    	movdqu 	xmm1,[rbp-16]	;pop xmm1
leave
ret
;-------------------------------------------------------------
;function for reversing, shuffling xmm0
reverse_xmm0:
section .data
;mask for reversing
        .bytereverse db 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
section .text
push	rbp		
mov	rbp,rsp
    	sub     rsp,16
    	movdqu [rbp-16],xmm2		
    	movdqu xmm2,[.bytereverse]  	;load the mask in xmm2
    	pshufb xmm0,xmm2            	;do the shuffle
    	movdqu xmm2,[rbp-16]	    	;pop xmm2
leave                           	;returns the shuffled xmm0
ret


