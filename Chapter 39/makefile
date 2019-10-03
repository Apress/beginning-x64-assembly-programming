hello.exe: hello.obj
	gcc -o hello.exe hello.obj
hello.obj: hello.asm
	nasm -f win64  -g -F cv8 hello.asm -l hello.lst