console1: console1.o
	gcc -o console1 console1.o -no-pie
console1.o: console1.asm
	nasm -f elf64 -g -F dwarf console1.asm -l console1.lst
