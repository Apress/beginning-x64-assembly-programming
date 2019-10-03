stack_float: stack_float.obj 
	gcc -g -o stack_float stack_float.obj
stack_float.obj: stack_float.asm
	nasm -f win64 -g -F cv8 stack_float.asm -l stack_float.lst
