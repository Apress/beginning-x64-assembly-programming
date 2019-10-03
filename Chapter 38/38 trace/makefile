trace: trace.o
	gcc -o trace trace.o -no-pie
trace.o: trace.asm
	nasm -f elf64 -g -F dwarf trace.asm -l trace.lst
