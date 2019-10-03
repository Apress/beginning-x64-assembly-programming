bits2: bits2.o 
	gcc -g -o bits2 bits2.o	-no-pie
bits2.o: bits2.asm
	nasm -f elf64 -g -F dwarf bits2.asm -l bits2.lst
