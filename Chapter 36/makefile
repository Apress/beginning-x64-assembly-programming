matrix4x4: matrix4x4.o
	gcc -o matrix4x4 matrix4x4.o -no-pie
matrix4x4.o: matrix4x4.asm
	nasm -f elf64 -g -F dwarf matrix4x4.asm -l matrix4x4.lst


