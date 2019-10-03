cpu_avx: cpu_avx.o
	gcc -o cpu_avx cpu_avx.o -no-pie
cpu_avx.o: cpu_avx.asm
	nasm -f elf64 -g -F dwarf cpu_avx.asm -l cpu_avx.lst
