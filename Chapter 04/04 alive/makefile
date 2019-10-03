# makefile for alive.asm
alive: alive.o
	gcc -o alive alive.o -ggdb -no-pie
alive.o: alive.asm
	nasm -f elf64 -g -F dwarf alive.asm -l alive.lst
#	yasm -f elf64 -g dwarf2 alive.asm -l alive.lst
