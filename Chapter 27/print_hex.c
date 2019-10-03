// print_hex.c

#include <stdio.h>

void print_hex(unsigned char n){
		if (n < 16) printf("0");
		printf("%x",n);
}
