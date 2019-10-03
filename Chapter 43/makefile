files.exe: files.obj
	gcc -o files.exe files.obj
files.obj: files.asm
	nasm -f win64 -g -F cv8 files.asm -l files.lst