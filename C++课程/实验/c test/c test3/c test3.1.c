

#include <stdio.h>
int iscom(int x);
int main()
{
	int i, flag = 0;
	printf("���������");
		for (i = 100; i<1000; i++)
			if (iscom(i)&&iscom(i/10)&&iscom(i/100))
			{
				printf("%d  ",i);
			}

	return 0;
}

int iscom(x)
{
	int i, k, flag=0;
	for (i = 2, k = x >> 1; i <= k; i++)
		if (!(x % i))
		{
			flag = 1;
			break;
		}
	if (flag == 1)  return 1;
	else return 0;
}

