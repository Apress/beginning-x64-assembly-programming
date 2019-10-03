arguments2: arguments2.obj
	gcc -g -o arguments2 arguments2.obj 
arguments2.obj: arguments2.asm
	nasm -f win64  -g -F cv8  arguments2.asm -l arguments2.lst
