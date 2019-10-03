cpu_sse: cpu_sse.o
	gcc -o cpu_sse cpu_sse.o -no-pie
cpu_sse.o: cpu_sse.asm
	nasm -f elf64 -g -F dwarf cpu_sse.asm -l cpu_sse.lst
