sse_aligned: sse_aligned.o
	gcc -o sse_aligned sse_aligned.o -no-pie
sse_aligned.o: sse_aligned.asm
	nasm -f elf64 -g -F dwarf sse_aligned.asm -l sse_aligned.lst
