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
{static long long LLastRes=0;//��������һ��Ľ��
	long long res=0;//��һ��ó��Ľ��
	if (n == 1 || n == 2)
	{
		LLastRes = 1;
		return 1;
	}
	long long LastRes = fabonacci(n - 1);
	res = LastRes + LLastRes;//������������һ����������һ����  �� n = (n-1) + (n-2);
	LLastRes = LastRes;//�������ϲ�Ľ��
	return res;




}*/

