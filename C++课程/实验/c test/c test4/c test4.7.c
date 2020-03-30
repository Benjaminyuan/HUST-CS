/*#define s(a,b,c) (a+b+c)/2
#define area(s,a,b,c) sqrt(s*(s-a)*(s-b)*(s-c))
#include<stdio.h>
#include<math.h>
int main()
{
	double a1,b1,c1;
	double s1,area1;
	printf("Please input the three side of the triangle:");
	scanf("%lf %lf %lf",&a1,&b1,&c1);
	if((a1+b1)>c1&&(a1+c1>b1)&&(b1+c1>a1))
        {
		s1=s(a1,b1,c1);
		area1=area(s1,a1,b1,c1);
		printf("output:%f",area1);
	}
	else{
		printf("errow");
	}
	return 0;
}*/

