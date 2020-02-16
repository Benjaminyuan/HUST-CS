#include <cmath>
#include <algorithm>
using namespace std;

int cmp(int a, int b)
{
    return a < b;
}

int main()
{
    int n, i, x_mid, y_mid, sum;
    while (scanf("%d", &n) != EOF)
    {
        sum = 0;
        int *x = (int *)malloc(sizeof(int) * n);
        int *y = (int *)malloc(sizeof(int) * n);
        for (i = 0; i < n; i++)
            scanf("%d %d", &x[i], &y[i]);

        sort(y, y + n, cmp);
        y_mid = y[n / 2];
        for (i = 0; i < n; i++)
            sum += abs(y[i] - y_mid);
        sort(x, x+n, cmp);
        for (i = 0; i < n; i++)
            x[i] -= i;
        sort(x, x+n, cmp);
        x_mid = x[n / 2];
        for (i = 0; i < n; i++)
            sum += abs(x[i] - x_mid);
        printf("%d\n", sum);
    }
    return 0;
}
