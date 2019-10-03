; matrix4x4.asm
extern printf

section .data
	fmt0	db	10,"4x4 DOUBLE PRECISION FLOATING POINT MATRICES",10,0
    	fmt1	db	10,"This is matrixA:",10,0
	fmt2	db	10,"This is matrixB:",10,0
	fmt3	db	10,"This is matrixA x matrixB:",10,0
	fmt4	db	10,"This is matrixC:",10,0
	fmt5	db	10,"This is the inverse of matrixC:",10,0
	fmt6	db	10,"Proof: matrixC x inverse =",10,0
 	fmt7	db	10,"This is matrixS:",10,0
	fmt8	db	10,"This is the inverse of matrixS:",10,0
	fmt9	db	10,"Proof: matrixS x inverse =",10,0
	fmt10	db	10,"This matrix is singular!",10,10,0
   
	align 32							
        matrixA     dq	 1.,  3.,  5.,  7.
                    dq	 9., 11., 13., 15.
                    dq	17., 19., 21., 23.
                    dq	25., 27., 29., 31.  

        matrixB     dq	 2.,  4.,  6.,  8.
                    dq	10., 12., 14., 16.
                    dq	18., 20., 22., 24.
                    dq	26., 28., 30., 32. 
 
        matrixC     dq	2.,		11.,		21.,     	37.
                    dq	3.,		13.,    	23.,     	41.
                    dq	5.,		17.,    	29.,     	43.
                    dq	7.,		19.,    	31.,    	47.   
 

        matrixS     dq	 1.,       2.,     	 3.,     	 4.
                    dq	 5.,       6.,     	 7.,     	 8.
                    dq	 9.,      10.,     	11.,     	12.
                    dq	13.,      14.,     	15.,     	16. 

section .bss
    	alignb 32
	product resq 16
	inverse resq 16
section .text							
	global main					
main:
push	rbp
mov	rbp,rsp
; print title
	mov 	rdi, fmt0
	call printf
; print matrixA
	mov 	rdi,fmt1
	call printf
	mov 	rsi,matrixA
	call printm4x4
; print matrixB
	mov 	rdi,fmt2
	call printf
	mov 	rsi,matrixB
	call printm4x4       
; compute the product matrixA x matrixB      
	mov 	rdi,matrixA 
	mov 	rsi,matrixB
	mov 	rdx,product
	call multi4x4   
; print the product
	mov 	rdi,fmt3
	call printf
	mov 	rsi,product
	call printm4x4

; print matrixC
	mov 	rdi,fmt4
	call printf
	mov 	rsi,matrixC
	call printm4x4 
; compute the inverse of matrixC         
	mov 	rdi,matrixC
	mov 	rsi,inverse
	call inverse4x4
	cmp 	rax,1
	je 	singular             
; print the inverse
	mov 	rdi,fmt5
	call printf
	mov 	rsi,inverse
	call printm4x4
; proof multiply matrixC and inverse
	mov 	rsi,matrixC 
	mov 	rdi,inverse
	mov 	rdx,product
	call multi4x4          
; print the proof
	mov 	rdi,fmt6
	call printf
	mov 	rsi,product
	call printm4x4

; Singular matrix
; print matrixS
	mov 	rdi,fmt7
	call printf
	mov 	rsi,matrixS
	call printm4x4 
; compute the inverse of matrixS         
	mov 	rdi,matrixS
	mov 	rsi,inverse
	call inverse4x4
	cmp 	rax,1
	je 	singular   
; print the inverse
	mov 	rdi,fmt8
	call printf
	mov 	rsi,inverse
	call printm4x4
; proof multiply matrixS and inverse
	mov 	rsi,matrixS 
	mov 	rdi,inverse
	mov 	rdx,product
	call multi4x4          
; print the proof
	mov 	rdi,fmt9
	call printf
	mov 	rsi,product
	call printm4x4  
	jmp	exit
singular:
; print error
	mov 	rdi,fmt10
	call printf                                                          
exit:                                                                                                                                                                                                            
leave
ret

inverse4x4: 
section .data
	align 32                                                                                    
	.identity	dq       1., 0., 0., 0.
			dq       0., 1., 0., 0.
          	dq       0., 0., 1., 0.
        		dq       0., 0., 0., 1. 
      
	.minus_mask  dq      8000000000000000h
	.size        dq      4                 ;4 x 4 matrices
	.one         dq      1.0
	.two         dq      2.0
	.three       dq      3.0
	.four        dq      4.0

section .bss
	alignb 32
	.matrix1 resq 16		;intermediate matrix
	.matrix2 resq 16		;intermediate matrix
	.matrix3 resq 16		;intermediate matrix
	.matrix4 resq 16		;intermediate matrix
	.matrixI resq 16      

	.mxcsr resd 1		;used for checking zero division

section .text							
push	rbp
mov	rbp,rsp
	push	rsi                 ; save address of inverse matrix
	vzeroall		;clear all ymm registers

; compute the intermediate matrices
; compute the intermediate matrix2 
; rdi contains address of the original matrix    
	mov 	rsi,rdi 
	mov 	rdx,.matrix2
	push rdi
	call multi4x4
	pop 	rdi
 
; compute the intermediate matrix3 
 	mov 	rsi,.matrix2 
	mov 	rdx,.matrix3 
	push rdi   
	call multi4x4
	pop 	rdi
  
; compute the intermediate matrix4 
 	mov 	rsi,.matrix3 
	mov 	rdx,.matrix4
	push rdi    
	call multi4x4
	pop 	rdi

;compute the traces
;compute trace1
	mov 	rsi,[.size]
	call vtrace
	movsd xmm8,xmm0   ;trace 1 in xmm8
;compute trace2
	push rdi            ; save address of the original matrix 
	mov 	rdi,.matrix2
	mov 	rsi,[.size]
	call vtrace
	movsd xmm9,xmm0   ;trace 2 in xmm9    
;compute trace3
	mov 	rdi,.matrix3
	mov 	rsi,[.size]
	call vtrace
	movsd xmm10,xmm0   ;trace 3 in xmm10                              
;compute trace4
	mov 	rdi,.matrix4
	mov 	rsi,[.size]
	call vtrace
	movsd xmm11,xmm0   ;trace 4 in xmm11

; compute the coefficients
; compute coefficient p1
; p1 = -s1
	vxorpd	xmm12,xmm8,[.minus_mask] ;p1 in xmm12
; compute coefficient p2
; p2 = -1/2 * (p1 * s1 + s2) 
	movsd 		xmm13,xmm12   ;copy p1 to xmm13
	vfmadd213sd 	xmm13,xmm8,xmm9 ;xmm13=xmm13*xmm8+xmm9
	vxorpd 		xmm13,xmm13,[.minus_mask]
	divsd 		xmm13,[.two]	;divide by 2 and p2 in xmm13
; compute coefficient p3
; p3 = -1/3 * (p2 * s1 + p1 * s2 + s3)
	movsd 		xmm14,xmm12               ;copy p1 to xmm14
	vfmadd213sd 	xmm14,xmm9,xmm10 ;p1*s2+s3;xmm14=xmm14*xmm9+xmm10
	vfmadd231sd 	xmm14,xmm13,xmm8 ;xmm14+p2*s1;xmm14=xmm14+xmm13*xmm8
	vxorpd 		xmm14,xmm14,[.minus_mask]
	divsd 		xmm14,[.three]             ;p3 in xmm14
; compute coefficient p4
; p4 = -1/4 * (p3 * s1 + p2 * s2 + p1 * s3 + s4)
	movsd 		xmm15,xmm12   ;copy p1 to xmm15
	vfmadd213sd 	xmm15,xmm10,xmm11 ;p1*s3+s4;xmm15=xmm15*xmm10+xmm11
	vfmadd231sd 	xmm15,xmm13,xmm9 ;xmm15+p2*s2;xmm15=xmm15+xmm13*xmm9
	vfmadd231sd 	xmm15,xmm14,xmm8 ;xmm15+p3*s1;xmm15=xmm15+xmm14*xmm8 
	vxorpd 		xmm15,xmm15,[.minus_mask]               
	divsd 		xmm15,[.four]	;p4 in xmm15
       
;multiply matrices with proper coefficient

	mov rcx,[.size]
	xor rax,rax

	vbroadcastsd	ymm1,xmm12 ; p1
	vbroadcastsd 	ymm2,xmm13 ; p2
	vbroadcastsd 	ymm3,xmm14 ; p3
    
	pop rdi     ; restore the address of the original matrix

.loop1:
	vmovapd 	ymm0,[rdi+rax]	
	vmulpd 	ymm0,ymm0,ymm2
	vmovapd 	[.matrix1+rax],ymm0

	vmovapd 	ymm0,[.matrix2+rax]	
	vmulpd 	ymm0,ymm0,ymm1
	vmovapd 	[.matrix2+rax],ymm0

	vmovapd 	ymm0,[.identity+rax]
	vmulpd 	ymm0,ymm0,ymm3
	vmovapd 	[.matrixI+rax],ymm0

	add		rax,32
	loop 	.loop1

;add the four matrices and multiply by -1/p4
	mov 		rcx,[.size]
	xor 		rax,rax
 ;compute -1/p4
	movsd 	xmm0, [.one]
	vdivsd 	xmm0,xmm0,xmm15	;1/p4
 ;check for zero division
	stmxcsr 	[.mxcsr]
	and 		dword[.mxcsr],4
	jnz 		.singular         

; no zero division
	pop 		rsi         ;recall address of inverse matrix
	vxorpd 	xmm0,xmm0,[.minus_mask]  ;-1/p4
	vbroadcastsd ymm2,xmm0
         
 ;loop through the rows
.loop2:
	;add the rows
	vmovapd	ymm0,[.matrix1+rax]
	vaddpd 	ymm0, ymm0, [.matrix2+rax]
	vaddpd 	ymm0, ymm0, [.matrix3+rax]
	vaddpd 	ymm0, ymm0, [.matrixI+rax] 
	vmulpd 	ymm0,ymm0,ymm2  		;multiply the row with -1/p4     
	vmovapd 	[rsi+rax],ymm0
	add 		rax,32 
	loop 	.loop2
        
	xor 		rax,rax     ;return 0, no error
leave
ret

.singular:
	mov 		rax,1       ;return 1, singular matrix
leave
ret
;------------------------------------------------------
; trace computation
vtrace:
push	rbp
mov	rbp,rsp
;build the matrix in memory
	vmovapd	ymm0, [rdi]
	vmovapd	ymm1, [rdi+32]
	vmovapd	ymm2, [rdi+64]
	vmovapd	ymm3, [rdi+96]
	vblendpd 	ymm0,ymm0,ymm1,0010b
	vblendpd 	ymm0,ymm0,ymm2,0100b
	vblendpd 	ymm0,ymm0,ymm3,1000b
	vhaddpd 	ymm0,ymm0,ymm0
	vpermpd 	ymm0,ymm0,00100111b
	haddpd 	xmm0,xmm0
leave
ret
;------------------------------------------------------
printm4x4:
section .data
	.fmt db	"%f",9,"%f",9, "%f",9,"%f",10,0
section .text
push	rbp
mov	rbp,rsp
push rbx	       	;callee saved
push r15        	;callee saved
	mov rdi,.fmt
	mov rcx,4
	xor rbx,rbx     	;row counter
.loop:        
	movsd xmm0, [rsi+rbx]
	movsd xmm1, [rsi+rbx+8]
	movsd xmm2, [rsi+rbx+16]
	movsd xmm3, [rsi+rbx+24]
	mov	rax,4		;four floats
	push rcx			;caller saved
	push rsi			;caller saved
	push rdi			;caller saved
        ;align stack if needed
        xor r15,r15
        test rsp,0xf        ;last byte is 8 (not aligned)? 
        setnz r15b          ;set if not aligned
        shl r15,3           ;multiply by 8
        sub rsp,r15         ;substract 0 or 8
	call 	printf
        add rsp,r15         ;add 0 or 8 to restore rsp
        pop rdi
        pop rsi
        pop rcx
        add rbx,32      ;next row
        loop .loop
pop r15
pop rbx
leave
ret
;------------------------------------------------------
multi4x4:
    push	rbp
    mov     rbp,rsp

        xor rax,rax
        mov rcx,4
	vzeroall		;zero all ymm	
.loop:       
        vmovapd ymm0, [rsi]
        
        vbroadcastsd ymm1,[rdi+rax]
        vfmadd231pd ymm12,ymm1,ymm0
        
        vbroadcastsd ymm1,[rdi+32+rax]
        vfmadd231pd ymm13,ymm1,ymm0
        
        vbroadcastsd ymm1,[rdi+64+rax]
        vfmadd231pd ymm14,ymm1,ymm0
        
        vbroadcastsd ymm1,[rdi+96+rax]
        vfmadd231pd ymm15,ymm1,ymm0

        add rax,8   ;one element has 8 bytes, 64 bits
        add rsi,32 ;every row has 32 bytes, 256 bits

        loop .loop

;move the result to memory, row per row
       vmovapd  [rdx], ymm12
       vmovapd  [rdx+32], ymm13
       vmovapd  [rdx+64], ymm14
       vmovapd  [rdx+96], ymm15
   	xor rax,rax   ;return value   
leave
ret
