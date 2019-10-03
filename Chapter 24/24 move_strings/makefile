move_strings: move_strings.o
	gcc -o move_strings move_strings.o -no-pie
move_strings.o: move_strings.asm
	nasm -f elf64 -g -F dwarf move_strings.asm -l move_strings.lst
