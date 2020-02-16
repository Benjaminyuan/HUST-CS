/*#include <stdio.h>
void main()
{
    int a[100];
    int n;
    int i;
    int j;
    int count=0;
    scanf("%d",&n);
    for(i=0;i<=n-1;i++)
    {scanf("%d",&a[i]);}

    for(j=0;j<=n-2;j++)
    {
        if(a[j]>a[j-1]&&a[j]>a[j+1])
        {
            count++;
        }
       else if(a[j]<a[j-1]&&a[j]<a[j+1])
        {
            count++;
        }
    }
    printf("%d",count);
}*/
