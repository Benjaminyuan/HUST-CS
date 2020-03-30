#include<iostream>
#include<vector>
using namespace std;
int getMethod(vector<vector<char>>& path,int n){
    int dp[n][n];
    dp[0][0] = 1;
    dp[1][0] = 0;
    for(int j = 1;j<n;j++){
        for(int i=0;i<2;i++){
            if(path[i][j] == 'X'){
                path[i][j] = 0;
            }else{
                int temp = (i == 0 ?path[i+1][j-1]:path[i-1][j-1]);
                path[i][j] = path[i][j-1] +temp;
            }
        }
    }
    return dp[1][n-1];
    
}
int main(){
    int n;
    cin >> n;
    vector<vector<char>> a(2,vector<char>(n,0));
    for(int i=0;i<n;i++){
        cin >> a[0][i];
    }
    for(int i=0;i<n;i++){
        cin >> a[1][i];
    }
    cout<<"\n";
    for(int i=0;i<n;i++){
        cout << a[0][i];
    }
    for(int i=0;i<n;i++){
        cout << a[1][i];
    }
    cout << getMethod(a,n);
    
}