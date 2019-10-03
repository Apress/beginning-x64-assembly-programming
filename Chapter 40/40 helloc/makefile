helloc.exe: helloc.obj
	gcc -o helloc.exe helloc.obj
helloc.obj: helloc.asm
	nasm -f win64  -g -F cv8 helloc.asm -l helloc.lst