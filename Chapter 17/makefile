bits3: bits3.o printb.o
	gcc -g -o bits3 bits3.o printb.o -no-pie
bits3.o: bits3.asm
	nasm -f elf64 -g -F dwarf bits3.asm -l bits3.lst
printb: printb.c 
	gcc -c printb.c 
