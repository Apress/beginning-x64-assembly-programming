sse_string_search: sse_string_search.o
	gcc -o sse_string_search sse_string_search.o -no-pie
sse_string_search.o: sse_string_search.asm
	nasm -f elf64 -g -F dwarf sse_string_search.asm -l sse_string_search.lst
