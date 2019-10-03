sse_string_length: sse_string_length.o
	gcc -o sse_string_length sse_string_length.o -no-pie
sse_string_length.o: sse_string_length.asm
	nasm -f elf64 -g -F dwarf sse_string_length.asm -l sse_string_length.lst
