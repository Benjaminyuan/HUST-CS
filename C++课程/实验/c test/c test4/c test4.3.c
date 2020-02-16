
/*#include<stdio.h>
long long sum_fac(int n);
int main(void)
{
    int k;
    long long sum=0;

    for(k=1;k<=20;k++)
       {
           sum+=sum_fac(k);
           printf("k=%d\tthe sum is%lld\n",k,sum);
       }
    return 0;
}
long long sum_fac(int n)
{
   long long s=0;
   if(n==1)
    {
    s=1;
    return 1;
   }

   else
   {
       s=n*(sum_fac(n-1));
       return s;
   }


}

*/
