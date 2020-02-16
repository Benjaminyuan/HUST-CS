/*#include<stdio.h>
int prime(int n)
{
	int i;
	for(i=2;i*i<=n;i++)
	if(n%i==0) return 0;
	return 1;
}
int main(void)
{
	int x,i;
	while(1)
    {


	scanf("%d",&x);
	if(x==0)
        break;
    else if(x%2==0)
	{
		for(i=2;i<=x/2;i++)
	{
		if(prime(i)&&prime(x-i))
            printf("%d=%d+%d\n",x,i,x-i);
	}
	}
    }
	return 0;
}
*/

