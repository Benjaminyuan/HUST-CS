/*#include<stdio.h>
int main()
{
    int m,n,k,p,i,d;
    printf("Input m n\n");
    scanf("%d%d",&m,&n);
    if(m<n)
    {
        m=m+n ;n=m-n;m=m-n;
    }
    k=0;
    while((m>>1)<<1==m&&(n>>1)<<1==n)
    {
        m=m>>1;
        n=n>>1;
        k++;
    }
    for(p=1,i=0;i<k;i++)
        p=1<<k;
        while((d=m-n)!=n)
    {
        if(d>n)
            m=d;
        else{(m=n,n=d);
        }
    }
    d*=p;
    printf("greatest common divisor:%d",d);
    return 0;
}
*/
