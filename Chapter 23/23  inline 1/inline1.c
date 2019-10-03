#include <stdio.h>

int x=11,y=12,sum,prod;
int subtract(void);
void multiply(void);

int main(void)
{
	printf("The numbers are %d and %d\n",x,y);
	__asm__(
		".intel_syntax noprefix;"   
		"mov rax,x;"
		"add rax,y;"
		"mov sum,rax"
		);
	printf("The sum is %d.\n",sum);
	printf("The difference is %d.\n",subtract());
	multiply();
	printf("The product is %d.\n",prod);	
	
}

int subtract(void)
{
	__asm__(
		".intel_syntax noprefix;"   
		"mov rax,x;"
		"sub rax,y"			// return value in rax
		);
}

void multiply(void)
{
	__asm__(
		".intel_syntax noprefix;"   
		"mov rax,x;"
		"imul rax,y;"
		"mov prod,rax"			//no return value, result in prod
		);
}
