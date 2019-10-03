variadic1: variadic1.obj 
	gcc -g -o variadic1 variadic1.obj 
variadic1.obj: variadic1.asm
	nasm -f win64 -g -F cv8 variadic1.asm -l variadic1.lst
