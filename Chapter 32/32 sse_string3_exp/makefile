sse_string3: sse_string3.o
	gcc -o sse_string3 sse_string3.o -no-pie
sse_string3.o: sse_string3.asm
	nasm -f elf64 -g -F dwarf sse_string3.asm -l sse_string3.lst
