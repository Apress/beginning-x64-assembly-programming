sse_string5: sse_string5.o print16b.o
	gcc -o sse_string5 sse_string5.o print16b.o -no-pie
sse_string5.o: sse_string5.asm
	nasm -f elf64 -g -F dwarf sse_string5.asm -l sse_string5.lst
printb: print16b.c 
	gcc -c print16b.c 
