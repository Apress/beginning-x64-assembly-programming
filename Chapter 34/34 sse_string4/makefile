sse_string4: sse_string4.o print16b.o
	gcc -o sse_string4 sse_string4.o print16b.o -no-pie
sse_string4.o: sse_string4.asm
	nasm -f elf64 -g -F dwarf sse_string4.asm -l sse_string4.lst
printb: print16b.c 
	gcc -c print16b.c 
