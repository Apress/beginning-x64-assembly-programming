sse_string6: sse_string6.o print16b.o
	gcc -o sse_string6 sse_string6.o print16b.o -no-pie
sse_string6.o: sse_string6.asm
	nasm -f elf64 -g -F dwarf sse_string6.asm -l sse_string6.lst
printrb: print16b.c 
	gcc -c print16b.c 
