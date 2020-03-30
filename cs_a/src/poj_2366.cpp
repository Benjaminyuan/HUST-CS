
#include <iostream>
using namespace std;
int a[51000], b[51000];
int main()
{
    int i, j, n, m;
    bool flag;
    scanf("%d", &n);
    for (i = 1; i <= n; i++)
    {
        scanf("%d\n", &a[i]);
    }
    scanf("%d", &m);
    for (j = 1; j <= m; j++)
    {
        scanf("%d\n", &b[j]);
    }
    i = 1;
    j = 1;
    flag = 0;
    while (i <= n && j <= m)
    {
        if (a[i] + b[j] == 10000)
        {
            flag = 1;
            break;
        }
        if (a[i] + b[j] < 10000)
        {
            i++;
        }
        if (a[i] + b[j] > 10000)
        {
            j++;
        }
    }
    if (flag)
    {
        printf("YES\n");
    }
    else
    {
        printf("NO\n");
    }
    return 0;
}