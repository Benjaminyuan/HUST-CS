#include<cstdio>
#include<iostream>
#include<cstring>

#define MAXR 110
#define MAXC 15
#define MAXM 70
#define max(a,b) a>b?a:b
#define zero(a) memset(a,0,sizeof(a))
// 合法为true
#define legal(a,b) (a&b) 
int row,col;
int nums;
int base[MAXR];
int state[MAXM];
int soldier[MAXM];
int dp[MAXR][MAXM][MAXM];
char g[MAXR][MAXM];

using namespace std;
int main(){
    zero(base),zero(state),zero(soldier),zero(dp);
    nums = 0;
    scanf("%d%d",&row,&col);
    for(int i=0;i<row;i++){
        scanf("%s",g[i]);
        for(int j=0; j<col;j++){
            if(g[i][j] == 'H'){
                //第i行的状态
                 base[i] += 1<<j;
            }
        }
    }
    // 用整数表示状态 每一位 0 ,1 
    for(int i=0;i<(1<<col);i++){
        if(legal(i,i<<1) || legal(i,i<<2)){
            continue;
        }
        int k =i;
        while (k)
        {
            soldier[nums] += k&1;
            k = k >>1;
        }
        state[nums++] = i;
    }
    for(int i=0;i<nums;i++){
        if(legal(state[i],base[0])) continue;
        dp[0][i][0] = soldier[i];
    }
    for(int r =1;r<row;r++){
        // 对每一行dp
        for(int i=0;i<nums;i++){
            // 原本base[r] 中的位是一个 1 的话，肯定不能放置
            if(legal(state[i],base[r])){
                continue;
            }
            // r-1行
            for(int j=0;j<nums;j++){
                if(legal(state[j],base[r-1])){
                    continue;
                }
                // 两行同一位置不能同时放置 
                if(legal(state[i],state[j])){
                    continue;
                }
                // r-2行
                for(int k=0;k<nums;k++){
                    if(legal(state[k],base[r-2])){
                        continue;
                    }
                    if(legal(state[k],state[i])){
                        continue;
                    }
                    if(legal(state[k],state[j]))
                    {
                        continue;
                    }
                    dp[r][i][j] = max(dp[r][i][j],dp[r-1][j][k] + soldier[i]);
                }
            }
        }
    }

    int ans = 0;
    for(int i=0;i<nums;i++){
        for(int j=0;j<nums;j++){
            ans = max(ans,dp[row-1][i][j]);
        }
    }
    printf("%d\n",ans);
    return 0;
}