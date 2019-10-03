# makefile for bits1 and printb
bits1: bits1.o printb.o
	gcc -g -o bits1 bits1.o printb.o -no-pie
bits1.o: bits1.asm
	nasm -f elf64 -g -F dwarf bits1.asm -l bits1.lst
printb: printb.c 
	gcc -c printb.c 
