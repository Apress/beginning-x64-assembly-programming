console2: console2.o
	gcc -o console2 console2.o -no-pie
console2.o: console2.asm
	nasm -f elf64 -g -F dwarf console2.asm -l console2.lst
