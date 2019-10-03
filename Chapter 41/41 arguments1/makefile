arguments1: arguments1.obj 
	gcc -g -o arguments1 arguments1.obj 
arguments1.obj: arguments1.asm
	nasm -f win64  -g -F cv8  arguments1.asm -l arguments1.lst
