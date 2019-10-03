// print16b.c
#include <stdio.h>
#include <string.h>
void print16b(long long n, int length){
	long long s,c;
	int i=0;
	for (c = 15; c >= 16-length; c--)
  	{
		s = n >> c;
		if (s & 1)
      			printf("1");
    		else
      			printf("0");
		
	}

}

