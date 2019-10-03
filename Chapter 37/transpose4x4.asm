; transpose4x4.asm
extern printf

section .data
	fmt0	db	"4x4 DOUBLE PRECISION FLOATING POINT MATRIX TRANSPOSE",10,0
	fmt1	db	10,"This is the matrix:",10,0
	fmt2	db	10,"This is the transpose (unpack):",10,0
	fmt3	db	10,"This is the transpose (shuffle):",10,0

	align 	32							
	matrix	dq       1.,     2.,     3.,     4.      
              	dq       5.,     6.,     7.,     8.        
             	dq       9.,    10.,    11.,    12.  
            	dq      13.,    14.,    15.,    16.  
section .bss
	alignb 	32
	transpose	resd	16

section .text							
	global main					
main:
push	rbp
mov	rbp,rsp

; print title
	mov	rdi, fmt1
	call	printf

; print matrix
	mov	rdi,fmt1
	call printf
	mov	rsi,matrix
	call	printm4x4
               
; compute transpose unpack  
	mov	rdi, matrix        
	mov	rsi, transpose 
	call	transpose_unpack_4x4

;print the result 
	mov	rdi, fmt2
	xor	rax,rax
	call	printf
	mov	rsi, transpose
	call	printm4x4 

; compute transpose shuffle  
	mov	rdi, matrix        
	mov	rsi, transpose 
	call	transpose_shuffle_4x4

;print the result 
	mov	rdi, fmt3
	xor	rax,rax
	call	printf
	mov	rsi, transpose
	call	printm4x4 
leave
ret
;--------------------------------------------------------
transpose_unpack_4x4:
push	rbp
mov	rbp,rsp    
;load matrix into the registers             
	vmovapd 	ymm0,[rdi]	;  1   2   3   4
    	vmovapd 	ymm1,[rdi+32]	;  5   6   7   8     
    	vmovapd 	ymm2,[rdi+64]	;  9  10  11  12
    	vmovapd 	ymm3,[rdi+96]	; 13  14  15  16
;unpack
    	vunpcklpd	ymm12,ymm0,ymm1	;  1   5   3   7
    	vunpckhpd ymm13,ymm0,ymm1	;  2   6   4   8
    	vunpcklpd ymm14,ymm2,ymm3	;  9  13  11  15
    	vunpckhpd ymm15,ymm2,ymm3    	; 10  14  12  16
;permutate  
    	vperm2f128 ymm0,ymm12,ymm14,	00100000b    ; 1   5   9  13
    	vperm2f128 ymm1,ymm13,ymm15, 	00100000b    ; 2   6  10  14
    	vperm2f128 ymm2,ymm12,ymm14,  00110001b    ; 3   7  11  15 
    	vperm2f128 ymm3,ymm13,ymm15, 	00110001b    ; 4   8  12  16
;write to memory
    	vmovapd 	[rsi],   ymm0
    	vmovapd 	[rsi+32],ymm1      
    	vmovapd 	[rsi+64],ymm2
    	vmovapd 	[rsi+96],ymm3
leave
ret
;--------------------------------------------------------    
transpose_shuffle_4x4:
push	rbp
mov	rbp,rsp
;load matrix into the registers             
	vmovapd 	ymm0,[rdi]	;  1   2   3   4
	vmovapd 	ymm1,[rdi+32]	;  5   6   7   8     
    	vmovapd 	ymm2,[rdi+64]	;  9  10  11  12
    	vmovapd 	ymm3,[rdi+96]	; 13  14  15  16
;shuffle
    	vshufpd 	ymm12,ymm0,ymm1, 0000b	;  1   5   3   7 
    	vshufpd 	ymm13,ymm0,ymm1, 1111b	;  2   6   4   8
    	vshufpd 	ymm14,ymm2,ymm3, 0000b	;  9  13  11  15    
    	vshufpd 	ymm15,ymm2,ymm3, 1111b	; 10  14  12  16 
;permutate  
    	vperm2f128 ymm0,ymm12,ymm14,	00100000b    ; 1   5   9  13
    	vperm2f128 ymm1,ymm13,ymm15, 	00100000b    ; 2   6  10  14
    	vperm2f128 ymm2,ymm12,ymm14,  00110001b    ; 3   7  11  15 
    	vperm2f128 ymm3,ymm13,ymm15, 	00110001b    ; 4   8  12  16
;write to memory
    	vmovapd 	[rsi],   ymm0
    	vmovapd 	[rsi+32],ymm1      
    	vmovapd 	[rsi+64],ymm2
    	vmovapd 	[rsi+96],ymm3
leave
ret
;--------------------------------------------------------
printm4x4:
section .data
	.fmt 	db	"%.f",9,"%.f",9, "%.f",9,"%.f",10,0
section .text
push	rbp
mov	rbp,rsp
push	rbx	       	;callee saved
push	r15            ;callee saved
	mov 	rdi,.fmt
	mov 	rcx,4
	xor 	rbx,rbx	;row counter
.loop:        
	movsd 	xmm0, [rsi+rbx]
	movsd 	xmm1, [rsi+rbx+8]
	movsd 	xmm2, [rsi+rbx+16]
	movsd 	xmm3, [rsi+rbx+24]
	mov    	rax,4	;four floats
        push 	rcx		;caller saved
        push 	rsi		;caller saved
        push 	rdi		;caller saved
        ;align stack if needed
        xor 	r15,r15
        test 	rsp,0fh	;last byte is 8 (not aligned)? 
        setnz 	r15b     	;set if not aligned
        shl 	r15,3    	;multiply by 8
        sub 	rsp,r15  	;substract 0 or 8
	call 	printf
        add 	rsp,r15	;add 0 or 8
        pop 	rdi
        pop 	rsi
        pop 	rcx
        add 	rbx,32	;next row
        loop 	.loop
pop r15
pop rbx
leave
ret
