#include <iostream>
#include <algorithm>
#include <cstring>
#include <queue>
#include <cstdio>

using namespace std;

const int maxn = 1e4 + 100;
const int mod = 998244353;
const int inf = 0x3f3f3f3f;


struct node {
    int x, y;
} e[maxn];


bool cmp1(node a, node b) {
    return a.y < b.y;
}

bool cmp2(node a, node b) {
    return a.x < b.x;
}

int main() {
    freopen("input.txt", "r", stdin);
    int n;
    cin >> n;
    for (int i = 0; i < n; i++)
        cin >> e[i].x >> e[i].y;
    sort(e, e + n, cmp1);
    int ans = 0;
    for (int i = 0; i < n / 2; ++i) {
        ans = ans + e[n - i - 1].y - e[i].y;
    }
    sort(e, e + n, cmp2);
    for (int i = 0; i < n; i++) {
        e[i].x -= i;
    }
    sort(e, e + n, cmp2);
    for (int i = 0; i < n / 2; ++i) {
        ans = ans + e[n - i - 1].x - e[i].x;
    }
    cout << ans << endl;
    return 0;
}