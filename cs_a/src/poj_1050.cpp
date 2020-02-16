#include<cstdio>
#include<iostream>
#include<cstring>
#define max(a,b) a>b?a:b
int matrix[101][101];
int max_sub_array(int n,int a[]){
    int sum =0;
    int temp = 0;
    for (int i = 0; i < n; i++)
    {
        temp += a[i];
        sum = max(temp,sum);
        if(temp < 0){
            temp = 0;
        }
    }
    return  sum;
}
int solve(int n){
    int ans  = matrix[0][0];
    int d[n];
    for(int i =0;i<n;i++){
        memset(d,0,sizeof(d));
        for(int j=i;j<n;j++){
            for(int k =0;k<n;k++){
                d[k] += matrix[j][k];
            }
            int sum = max_sub_array(n,d);
            ans = max(sum,ans);
        }
    }
    return ans;
}
int main(){
    int n;
    while(scanf("%d",&n) == 1){
        for(int i=0;i<n;i++){
            for (int j = 0; j < n; j++)
            {
                scanf("%d",&matrix[i][j]);
            }
        }
        printf("%d\n",solve(n));
    }
}
