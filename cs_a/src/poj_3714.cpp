#include <iostream>
#include <stdio.h>
#include <iomanip>
#include <algorithm>
#include <cmath>
using namespace std;
const int N = 200000 + 1;
const double INF = 1e100;
struct Point
{
    double x, y;
    bool flag;
};
Point m[N + 1];
int tmp[N + 1];
double dis(Point p1, Point p2)
{
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}
double minL(double l1, double l2)
{
    return l1 <= l2 ? l1 : l2;
}
bool cmpy(Point a, Point b)
{
    return b.y < b.y;
}
bool cmpx(Point a, Point b)
{
    return a.x < b.x;
}
double getMinLen(Point *s, int left, int right)
{
    double rs = INF;
    if (left == right)
        return rs;
    if (left + 1 == right)
    {
        if (s[left].flag == s[right].flag)
            return rs;
        return dis(s[left], s[right]);
    }
    int mid = (left + right) >> 1;
    rs = getMinLen(s, left, mid);
    rs = minL(rs, getMinLen(s, mid + 1, right)); //rs现在是两边中最点值了
    sort(s+left,s+right+1,cmpy);
    double d = INF;
    for(int i=left;i <= right;i++){
        if(fabs(s[i].x-s[mid].x) < rs){
            for(int j= i+1;j<=right;j++){
                if(s[i].flag != s[j].flag && (d = dis(s[i],s[j]))<rs){
                    rs= d;
                }
            }
        }
    }
    return rs;
}
int main()
{
    int t, n, i;
    scanf("%d", &t);
    while (t--)
    {
        scanf("%d", &n);
        for (i = 0; i < n; ++i)
        {
            scanf("%lf%lf", &m[i].x, &m[i].y);
            m[i].flag = 0;
        }
        for (i = 0; i < n; ++i)
        {
            scanf("%lf%lf", &m[i + n].x, &m[i + n].y);
            m[i + n].flag = 1;
        }
        n <<= 1;
        sort(m, m + n, cmpx);
        double ans = getMinLen(m, 0, n - 1);
        cout << setiosflags(ios::fixed) << setprecision(3) << ans << endl;
    }
    return 0;
}