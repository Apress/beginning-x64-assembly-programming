aligned: aligned.o
	gcc -g -o aligned aligned.o -no-pie
aligned.o: aligned.asm
	nasm -f elf64 -g -F dwarf aligned.asm -l aligned.lst
