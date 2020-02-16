
#include <iostream>
#include <cstdio>
#include <algorithm>

using namespace std;

#define N 10005

int dx[4] = {0, 1, 0, -1};
int dy[4] = {1, 0, -1, 0};
struct Node
{
    int x;
    int y;
} a[N];

int x[N], y[N];
int minn, plan;

int main()
{
    int n;
    scanf("%d", &n);
    for (int i = 1; i <= n; i++)
    {
        scanf("%d%d", &a[i].x, &a[i].y);
        x[i] = a[i].x;
        y[i] = a[i].y;
    }
    sort(x + 1, x + n + 1); //对x排序
    sort(y + 1, y + n + 1); //对y排序
    if (n % 2)              //n为奇数时
    {
        int temp = (n / 2) + 1;
        for (int i = 1; i <= n; i++)
        {
            if (a[i].x == x[temp] && a[i].y == y[temp]) //若点为给出点
            {
                int Min = INT_MAX;
                for (int l = 0; l < 4; l++) //枚举四个方向
                {
                    int xx = x[temp] + dx[l];
                    int yy = y[temp] + dy[l];
                    int sum = 0;
                    for (i = 1; i <= n; i++) //求最小的距离
                        sum += abs(a[i].x - xx) + abs(a[i].y - yy);
                    if (sum < Min)
                    {
                        Min = sum;
                        plan = 1;
                    }
                    else if (sum == Min)
                        plan++;
                }
                printf("%d %d\n", Min, plan);
                return 0;
            }
            else //若点不为给出点
            {
                minn += abs(a[i].x - x[temp]) + abs(a[i].y - y[temp]); //记录最小距离
                plan = 1;                                              //方案数为1
            }
        }
        printf("%d %d\n", minn, plan);
    }
    else //n为偶数时
    {
        int temp1 = n / 2, temp2 = n / 2 + 1;
        plan = (x[temp2] - x[temp1] + 1) * (y[temp2] - y[temp1] + 1); //令方案数等于点的个数
        for (int i = 1; i <= n; i++)
        {
            minn += abs(a[i].x - x[temp1]) + abs(a[i].y - y[temp1]); //记录最小距离
            int x0 = a[i].x, y0 = a[i].y;
            if (x[temp1] <= x0 && x0 <= x[temp2] && y[temp1] <= y0 && y0 <= y[temp2]) //更新方案数
                plan--;
        }
        printf("%d %d\n", minn, plan);
    }
    return 0;
}