#include <stdio.h>
int main()
{
	double x, sum;
	int flag;
	printf("请输入工资\n");
	scanf("%lf", &x);
	if (x < 1000) flag = 0;
	else if (x >= 1000 && x < 2000)flag = 1;
	else if (x >= 2000 && x < 3000)flag = 2;
	else if (x >= 3000 && x < 4000)flag = 3;
	else if (x >= 4000 && x < 5000)flag = 4;
	else flag = 5;
	switch (flag)
	{
	case(0): {sum = x; printf("税:%.2lf", sum); break; }
	case(1): {sum =(x-1000) * 0.05; printf("税:%.2lf", sum); break; }
	case(2): {sum = (x-2000) * 0.1+50; printf("税:%.2lf", sum); break; }
	case(3): {sum = (x-3000)*0.15+150; printf("税:%.2lf", sum); break; }
	case(4): {sum = (x-4000) * 0.2+300; printf("税:%.2lf", sum); break; }
	case(5): {sum = (x-5000) * 0.25+500; printf("税:%.2lf", sum); break; }
	}
	return 0;

}

