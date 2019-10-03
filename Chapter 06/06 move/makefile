move: move.o
	gcc -o move move.o -no-pie
move.o: move.asm
	nasm -f elf64 -g -F dwarf -l move.lst move.asm
