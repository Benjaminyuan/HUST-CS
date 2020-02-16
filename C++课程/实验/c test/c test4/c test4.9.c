/*#include<stdio.h>
int main(void)
{
    int i,k;
    long long sum=0,fabonacci(int n);
    printf("input n:");
    scanf("%d",&k);
    for(i=1;i<=k;i++)
    {

        printf("i=%d\tthe sum is %lld\n",i,fabonacci(i));
    }
    return 0;

}
long long fabonacci(int n)
{static long long LLastRes=0;//保存上上一层的结果
	long long res=0;//这一层得出的结果
	if (n == 1 || n == 2)
	{
		LLastRes = 1;
		return 1;
	}
	long long LastRes = fabonacci(n - 1);
	res = LastRes + LLastRes;//本层结果等于上一层结果加上上一层结果  即 n = (n-1) + (n-2);
	LLastRes = LastRes;//更新上上层的结果
	return res;




}*/

