transpose: transpose.o
	gcc -o transpose transpose.o -no-pie
transpose.o: transpose.asm
	nasm -f elf64 -g -F dwarf transpose.asm -l transpose.lst
