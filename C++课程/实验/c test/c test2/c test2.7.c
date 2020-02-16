/*#include <stdio.h>
void main()
{
 int year,day,d,m,leap;
 int i;
 int Month[12]={31,28,31,30,31,30,31,31,30,31,30,31};
 printf("输入年份和这一年的第多少天:\n");
 scanf("%d",&year);
 scanf("%d",&day);
 if( (year%4!=0) ||( (year%100==0)&& (year%400!=0)))
    leap=0;
 else
    leap=1;
 if(leap==1)
    Month[1]=29;
    m=1;
 for(i=0;i<12;i++)
{

    d=day-Month[i];
    if(d>0)
   {
      day=d;
      m++;
    }
    else
    {
      d = d+Month[i];
      break;
    }
}
    printf("The date is:%d年%d月%d日",year,m,d);
}
*/
