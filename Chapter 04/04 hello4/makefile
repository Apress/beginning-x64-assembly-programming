# makefile for hello4.asm
hello4: hello4.o
		gcc -o hello4 hello4.o -no-pie
hello4.o: hello4.asm
	nasm -f elf64 -g -F dwarf hello4.asm -l hello4.lst
