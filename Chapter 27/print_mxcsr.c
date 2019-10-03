// print_mxcsr.c

#include <stdio.h>

void print_mxcsr(long long n){
	long long s,c;	
	for (c = 15; c >= 0; c--)
  	{
		s = n >> c;
		// space after every 8th bit
 		if ((c+1) % 4 == 0) printf(" ");

		if (s & 1)
      			printf("1");
    		else
      			printf("0");
	}	
	printf("\n");
}
