shuffle: shuffle.o
	gcc -o shuffle shuffle.o -no-pie
shuffle.o: shuffle.asm
	nasm -f elf64 -g -F dwarf shuffle.asm -l shuffle.lst

