# makefile for function4, circle and rect.
function4: function4.o circle.o rect.o
	gcc -g -o function4 function4.o circle.o rect.o -no-pie
function4.o: function4.asm
	nasm -f elf64 -g -F dwarf function4.asm -l function4.lst
circle.o: circle.asm
	nasm -f elf64 -g -F dwarf circle.asm -l circle.lst
rect.o: rect.asm
	nasm -f elf64 -g -F dwarf rect.asm -l rect.lst
