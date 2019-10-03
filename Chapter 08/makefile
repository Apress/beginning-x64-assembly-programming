memory: memory.o
	gcc -o memory memory.o -no-pie
memory.o: memory.asm
	nasm -f elf64 -g -F dwarf -l memory.lst memory.asm
