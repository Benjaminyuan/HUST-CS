#include<stdio.h>
#include<iostream>
#include<cstring>
using namespace std;
int row,col,height[105][105],ans[105][105];
int dir[4][2] = {0,1,-1,0,0,-1,1,0};
int max(int a,int b){
    return a> b? a:b;
}
bool inside(int x,int y){
    if(x< 0 || x >= row|| y < 0 ||y >=col){
        return false;
    }
    else
    {
        return true;
    }
}
int dfs (int x,int y){
    int temp_x,temp_y;
    if(ans[x][y]){
        return ans[x][y];
    }
    for (int i = 0; i < 4; i++)
    {
        temp_x = x+dir[i][0];
        temp_y = y+dir[i][1];
        if(inside(temp_x,temp_y) && height[temp_x][temp_y]<height[x][y]){
            ans[x][y] = max(ans[x][y],dfs(temp_x,temp_y)+1);
        }
    }
    return ans[x][y];
}
int main(){
    int maxn;
    while(~scanf("%d%d",&row,&col)){
        maxn = 1 ;
        memset(ans,0,sizeof(ans));
        for(int i=0;i<row;i++){
            for(int j=0;j<col;j++){
                scanf("%d",&height[i][j]);
            }
        }
        for(int i=0;i<row;i++){
            for(int j=0;j<col;j++){
                ans[i][j] = dfs(i,j);
                maxn = max(maxn,ans[i][j]+1);
            }
        }
        printf("%d\n",maxn);
    }
}