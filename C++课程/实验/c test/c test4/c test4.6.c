/*#include <stdio.h>

  long int my_pow(int a, int n)
  {
      long result = 1;
      int i = 0;
      for (i; i < n; i++)
         result *= a;

     return result;
 }

 // �ж��Ƿ�Ϊˮ�ɻ���
 int isNarNum(long int num, int n)
 {
     long int number = num;
     long int result = 0;

     int i;
     //��ȡ����λ��,����n����֮��
    for (i = n-1; i >= 0; i--)
     {
        result += my_pow(number%10, n);
         number /= 10;
     }

    return result == num ? 1 : 0;
 }

 // ��ӡnλ��ˮ�ɻ���
 void printNarNum(int n)
 {
     long start = my_pow(10, n-1);   //nλ������ʼλ��
     int count = 0;
     long num = 0;
     for ( num = start; num < start*10; num++)
     {
        if (isNarNum(num, n))
         {
             printf("%ld ����������", num);
            count++;
        }
     }
    printf("%d λ���������� %d ����", n, count);
 }

 int main(void)
 {
    int n;


    while(1)
    {
    printf("\n��������λ������������");scanf("%d",&n) ;
        if(n==0)
            break;
        printNarNum(n);
    }


     return 0;
 }
*/
