#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <algorithm>
const int INF = 1e8;
const int N = 100;
#define ll long long
using namespace std;
int a[251][N];
int b[N] = {0};
int main()
{
    memset(a,0,sizeof(a));
    a[1][0] = 1;
    a[0][0] = 1;
    int st = 0,num,ch;
    for(int i = 2;i<=250;i++)
    {
        st = 0;
        for(int j = 0;j<N;j++)
        {
            memset(b,0,sizeof(b));
            num = a[i-1][j] + a[i-2][j] * 2 + st;
            a[i][j] = num %10;
            st = num / 10;
        }
    }
    int n;
    while(~scanf("%d",&n))
    {
        int wz;
        for(int i = N-1;i>=0;i--)
            {
                if(a[n][i]!=0)
                {
                    wz = i;
                    break;
                }
            }
            for(int i = wz;i>=0;i--)
            printf("%d",a[n][i]);
        printf("\n");
    }
    return 0;
}