hellow.exe: hellow.obj
	gcc -o hellow.exe hellow.obj
hellow.obj: hellow.asm
	nasm -f win64  -g -F cv8 hellow.asm -l hellow.lst