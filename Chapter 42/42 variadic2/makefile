variadic2.exe: variadic2.obj
	gcc -g -o variadic2.exe variadic2.obj
variadic2.obj: variadic2.asm
	nasm -f win64 -g -F cv8 variadic2.asm -l variadic2.lst