; trace.asm
extern printf
section .data
	fmt0		db	"8x8 SINGLE PRECISION FLOATING POINT MATRIX TRACE",10,0
	fmt1		db 	10,"This is the matrix:",10,0
	fmt2  	db  	10,"This is the trace (sequential version): %f",10,0
	fmt5  	db 	"This is the trace (AVX blend version): %f",10,0
	fmt6   	db  	10,"This is the tranpose: ",10,0
	fmt30 	db 	"Sequential version elapsed cycles: %u",10,0
	fmt31  	db 	"AVX blend  version elapsed cycles: %d",10,10,0
	fmt4		db  	10,"Number of loops: %d",10,0
  
	align 	32							
	matrix 	dd      1.,     2.,     3.,     4.,      5.,     6.,     7.,     8.   
           	dd      9.,     10.,    11.,    12.,     13.,    14.,    15.,    16.
        		dd      17.,    18.,    19.,    20.,     21.,    22.,    23.,    24.      
        		dd      25.,    26.,    27.,    28.,     29.,    30.,    31.,    32.
          	dd      33.,    34.,    35.,    36.,     37.,    38.,    39.,    40.
          	dd      41.,    42.,    43.,    44.,     45.,    46.,    47.,    48.
        		dd      49.,    50.,    51.,    52.,     53.,    54.,    55.,    56.
         		dd      57.,    58.,    59.,    60.,     61.,    62.,    63.,    64.
                                                            
	loops	dq	1000
	permps 	dd   	0,1,4,5,2,3,6,7  ;mask for permutation sp values in ymm
section .bss
	alignb 	32
	transpose	resq	16
        
	trace 		resq 	1

	bbhi_cy		resq 	1  
	bblo_cy   	resq 	1
	ebhi_cy   	resq 	1  
	eblo_cy   	resq 	1  

	bshi_cy   	resq 	1  
	bslo_cy   	resq 	1
	eshi_cy   	resq 	1  
	eslo_cy   	resq 	1

section .text							
	global main					
main:
push	rbp
mov	rbp,rsp
; print title
	mov 	rdi, fmt0
	call	printf
; print matrix
	mov 	rdi,fmt1
	call	printf
	mov 	rsi,matrix
	call	printm8x8
        
; SEQUENTIAL VERSION        
; compute trace   
	mov	rdi, matrix
	mov	rsi, [loops]         

;start measuring the cycles
	cpuid
    	rdtsc 
    	mov	[bshi_cy],edx
    	mov	[bslo_cy],eax         
                                   
	call	seq_trace 
        
;stop measuring the cycles
    	rdtscp
    	mov	[eshi_cy],edx
    	mov	[eslo_cy],eax  
    	cpuid

;print the result 
    	mov 	rdi, fmt2
    	mov 	rax,1
    	call printf    

; BLEND VERSION        
; compute trace   
	mov	rdi, matrix
	mov	rsi, [loops]         

;start measuring the cycles
    	cpuid
    	rdtsc 
    	mov 	[bbhi_cy],edx
    	mov 	[bblo_cy],eax         
                                   
	call	blend_trace 

;stop measuring the cycles
    	rdtscp
    	mov 	[ebhi_cy],edx
    	mov 	[eblo_cy],eax  
    	cpuid

;print the result 
    	mov 	rdi, fmt5
    	mov 	rax,1
    	call printf

;print the loops   
    	mov 	rdi,fmt4 
    	mov 	rsi,[loops]  
    	call 	printf
    
;print the cycles
;cycles sequential version
    	mov 	rdx,[eslo_cy]        
    	mov 	rsi,[eshi_cy]  
    	shl 	rsi,32   
    	or 	rsi,rdx          

    	mov 	r8,[bslo_cy]
    	mov 	r9,[bshi_cy] 
    	shl 	r9,32
    	or 	r9,r8           
    
    	sub 	rsi,r9          ;rsi contains elapsed    
    ;print
    	mov 	rdi,fmt30
    	call printf
    
;cycles AVX blend version
    	mov 	rdx,[eblo_cy]        
    	mov 	rsi,[ebhi_cy]
    	shl 	rsi,32     
    	or 	rsi,rdx         

    	mov 	r8,[bblo_cy]
    	mov 	r9,[bbhi_cy]
    	shl 	r9,32 
    	or 	r9,r8            
    
    	sub 	rsi,r9         
    ;print
    	mov 	rdi,fmt31
    	call printf           
leave
ret
;--------------------------------------------------------------
seq_trace:
push	rbp
mov	rbp,rsp
.loop0:    
    	pxor	xmm0,xmm0
    	mov 	rcx,8
    	xor 	rax,rax
    	xor 	rbx,rbx
    	.loop:
    		addss	xmm0, [rdi+rax]
    		add 	rax,36     ;each row 32 bytes
    	loop 	.loop
    	cvtss2sd 	xmm0,xmm0    
    	dec 		rsi 
	jnz 		.loop0   
leave
ret
;--------------------------------------------------------------
blend_trace:
push	rbp
mov     rbp,rsp
.loop:
    ;build the matrix in memory
	vmovaps 	ymm0, [rdi]
	vmovaps 	ymm1, [rdi+32]
	vmovaps 	ymm2, [rdi+64]
	vmovaps 	ymm3, [rdi+96]
	vmovaps 	ymm4, [rdi+128]
	vmovaps 	ymm5, [rdi+160]
	vmovaps 	ymm6, [rdi+192]
	vmovaps 	ymm7, [rdi+224]

	vblendps 	ymm0,ymm0,ymm1,00000010b
	vblendps 	ymm0,ymm0,ymm2,00000100b
	vblendps 	ymm0,ymm0,ymm3,00001000b
	vblendps 	ymm0,ymm0,ymm4,00010000b        
	vblendps 	ymm0,ymm0,ymm5,00100000b        
	vblendps 	ymm0,ymm0,ymm6,01000000b        
	vblendps 	ymm0,ymm0,ymm7,10000000b
                
	vhaddps 	ymm0,ymm0,ymm0
	vmovdqu 	ymm1,[permps]
	vpermps 	ymm0,ymm1,ymm0
	haddps 		xmm0,xmm0
	vextractps 	r8d,xmm0,0
	vextractps 	r9d,xmm0,1
	vmovd 		xmm0,r8d
	vmovd 		xmm1,r9d
	vaddss 		xmm0,xmm0,xmm1
    	dec 			rsi
    	jnz 			.loop
cvtss2sd xmm0,xmm0
leave
ret

printm8x8:
section .data
	.fmt db	"%.f,",9,"%.f,",9,"%.f,",9,"%.f,",9,"%.f,",9,"%.f,",9,"%.f,",9,"%.f",10,0
section .text
push	rbp
mov     rbp,rsp
    	push 	rbx            ;callee saved
        mov 	rdi,.fmt
        mov 	rcx,8
        xor 	rbx,rbx     ;row counter
        vzeroall
.loop:       
	movss 		xmm0, dword[rsi+rbx]
        cvtss2sd 	xmm0,xmm0
	movss 		xmm1, [rsi+rbx+4]
        cvtss2sd 	xmm1,xmm1
	movss 		xmm2, [rsi+rbx+8]
        cvtss2sd 	xmm2,xmm2
	movss 		xmm3, [rsi+rbx+12]
        cvtss2sd 	xmm3,xmm3
	movss 		xmm4, [rsi+rbx+16]
        cvtss2sd 	xmm4,xmm4
	movss 		xmm5, [rsi+rbx+20]
        cvtss2sd 	xmm5,xmm5
	movss 		xmm6, [rsi+rbx+24]
        cvtss2sd 	xmm6,xmm6
	movss 		xmm7, [rsi+rbx+28]
        cvtss2sd 	xmm7,xmm7
	mov	rax,8	; 8 floats
        push 	rcx		;caller saved
        push 	rsi		;caller saved
        push 	rdi		;caller saved
        ;align stack if needed
        xor 	r15,r15
        test 	rsp,0fh       	;last byte is 8 (not aligned)? 
        setnz 	r15b          	;set if not aligned
        shl 	r15,3           ;multiply by 8
        sub 	rsp,r15         ;substract 0 or 8
	call 	printf
        add 	rsp,r15         ;add 0 or 8
        pop 	rdi
        pop 	rsi
        pop 	rcx
        add 	rbx,32      ;next row
        loop 	.loop
pop rbx     ;callee saved
leave
ret
