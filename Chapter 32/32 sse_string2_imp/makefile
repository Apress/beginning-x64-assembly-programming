sse_string2: sse_string2.o
	gcc -o sse_string2 sse_string2.o -no-pie
sse_string2.o: sse_string2.asm
	nasm -f elf64 -g -F dwarf sse_string2.asm -l sse_string2.lst
