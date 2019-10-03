transpose4x4: transpose4x4.o
	gcc -o transpose4x4 transpose4x4.o -no-pie
transpose4x4.o: transpose4x4.asm
	nasm -f elf64 -g -F dwarf transpose4x4.asm -l transpose4x4.lst
