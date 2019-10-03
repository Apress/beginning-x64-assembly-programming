fromc: fromc.c rect.o circle.o sreverse.o adouble.o asum.o
	gcc -o fromc fromc.c rect.o circle.o sreverse.o \
	adouble.o asum.o -no-pie
rect.o: rect.asm
	nasm -f elf64 -g -F dwarf rect.asm -l rect.lst
circle.o: circle.asm
	nasm -f elf64 -g -F dwarf circle.asm -l circle.lst
sreverse.o: sreverse.asm
	nasm -f elf64 -g -F dwarf sreverse.asm -l sreverse.lst
adouble.o: adouble.asm
	nasm -f elf64 -g -F dwarf adouble.asm -l adouble.lst
asum.o: asum.asm
	nasm -f elf64 -g -F dwarf asum.asm -l asum.lst
