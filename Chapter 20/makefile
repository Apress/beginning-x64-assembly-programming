file: file.o
	gcc -o file file.o -no-pie
file.o: file.asm
	nasm -f elf64 -g -F dwarf file.asm -l file.lst
