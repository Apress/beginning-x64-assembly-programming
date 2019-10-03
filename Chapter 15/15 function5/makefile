function5: function5.o 
	gcc -g -o function5 function5.o -no-pie
function5.o: function5.asm
	nasm -f elf64 -g -F dwarf function5.asm -l function5.lst
