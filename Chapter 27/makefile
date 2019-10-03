mxcsr: mxcsr.o print_mxcsr.o print_hex.o
	gcc -o mxcsr mxcsr.o print_mxcsr.o print_hex.o -no-pie
mxcsr.o: mxcsr.asm
	nasm -f elf64 -g -F dwarf mxcsr.asm -l mxcsr.lst
print_mxcsr: print_mxcsr.c
	gcc -c print_mxcsr.c 
print_hex: print_hex.c
	gcc -c print_hex.c 
