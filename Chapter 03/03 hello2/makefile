#makefile for hello2.asm
hello2: hello2.o
	gcc -o hello2 hello2.o -no-pie
hello2.o: hello2.asm
	nasm -f elf64 -g -F dwarf hello2.asm -l hello2.lst
