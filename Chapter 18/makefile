macro: macro.o
	gcc -o macro macro.o -no-pie
macro.o: macro.asm
	nasm -f elf64 -g -F dwarf macro.asm -l macro.lst
