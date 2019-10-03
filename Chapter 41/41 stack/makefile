stack: stack.obj 
	gcc -g -o stack stack.obj
stack.obj: stack.asm
	nasm -f win64 -g -F cv8 stack.asm -l stack.lst
