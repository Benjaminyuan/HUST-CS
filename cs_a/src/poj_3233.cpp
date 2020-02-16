#include <iostream>
#include <cstdio>
#include <string>
#include <cstring>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>
#include <queue>
#include <map>
#include <set>
#include <algorithm>

using namespace std;
int mod;
int n;
struct matrix
{
    int ma[40][40];
}init, res;
matrix Mult(matrix x, matrix y)
{
    int i, j, k;
    matrix tmp;
    for(i=0;i<n;i++)
    {
        for(j=0;j<n;j++)
        {
            tmp.ma[i][j]=0;
            for(k=0;k<n;k++)
            {
                tmp.ma[i][j]=(tmp.ma[i][j]+x.ma[i][k]*y.ma[k][j])%mod;
            }
        }
    }
    return tmp;
}
matrix Pow(matrix x, int k)
{
    matrix tmp;
    int i, j;
    for(i=0;i<n;i++) for(j=0;j<n;j++) tmp.ma[i][j]=(i==j);
    while(k)
    {
        if(k&1) tmp=Mult(tmp,x);
        x=Mult(x,x);
        k>>=1;
    }
    return tmp;
}
matrix add(matrix x, matrix y)
{
    int i, j;
    matrix tmp;
    for(i=0;i<n;i++)
    {
        for(j=0;j<n;j++)
        {
            tmp.ma[i][j]=(x.ma[i][j]+y.ma[i][j])%mod;
        }
    }
    return tmp;
}
matrix sum(matrix x, int k)
{
    matrix tmp;
    if(k==1) return x;
    if(k&1)
        return add(sum(x,k-1),Pow(x,k));
    tmp=sum(x,k>>1);
    return add(tmp,Mult(tmp,Pow(x,k>>1)));
}
int main()
{
    int k, m, x, i, j;
    scanf("%d%d%d",&n,&k,&mod);
    for(i=0;i<n;i++)
    {
        for(j=0;j<n;j++)
        {
            scanf("%d",&x);
            init.ma[i][j]=x%mod;
        }
    }
    res=sum(init, k);
    for(i=0;i<n;i++)
    {
        for(j=0;j<n;j++)
        {
            printf("%d",res.ma[i][j]);
            if(j!=n-1) printf(" ");
        }
        puts("");
    }
    return 0;
}