function6: function6.o 
	gcc -g -o function6 function6.o -no-pie
function6.o: function6.asm
	nasm -f elf64 -g -F dwarf function6.asm -l function6.lst
