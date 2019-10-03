avx_unaligned: avx_unaligned.o
	gcc -o avx_unaligned avx_unaligned.o -no-pie
avx_unaligned.o: avx_unaligned.asm
	nasm -f elf64 -g -F dwarf avx_unaligned.asm -l avx_unaligned.lst
