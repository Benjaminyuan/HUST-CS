
#include <stdio.h>
int main()
{
	double a[100], max=0;
	int i,k = 0;
	char s = 0;
	while (s != '\n')
	{
		++k;
		scanf("%lf", &a[k]);
		s = getchar();
	}

	for (i = 1; i < k; i++)
	{
		double temp;
		if ((temp = a[i] - a[i + 1]) > max)
			max = temp;
		else if ((temp = a[i + 1] - a[i]) > max) max = temp;
	}
	printf("��%d������󲨶�ֵΪ%.2lf",k, max);
}

