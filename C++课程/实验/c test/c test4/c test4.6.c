/*#include <stdio.h>

  long int my_pow(int a, int n)
  {
      long result = 1;
      int i = 0;
      for (i; i < n; i++)
         result *= a;

     return result;
 }

 // 判断是否为水仙花数
 int isNarNum(long int num, int n)
 {
     long int number = num;
     long int result = 0;

     int i;
     //获取各个位数,并求n次幂之和
    for (i = n-1; i >= 0; i--)
     {
        result += my_pow(number%10, n);
         number /= 10;
     }

    return result == num ? 1 : 0;
 }

 // 打印n位的水仙花数
 void printNarNum(int n)
 {
     long start = my_pow(10, n-1);   //n位数的起始位数
     int count = 0;
     long num = 0;
     for ( num = start; num < start*10; num++)
     {
        if (isNarNum(num, n))
         {
             printf("%ld 是自幂数。", num);
            count++;
        }
     }
    printf("%d 位的自幂数有 %d 个。", n, count);
 }

 int main(void)
 {
    int n;


    while(1)
    {
    printf("\n请输入求几位数的自幂数：");scanf("%d",&n) ;
        if(n==0)
            break;
        printNarNum(n);
    }


     return 0;
 }
*/
