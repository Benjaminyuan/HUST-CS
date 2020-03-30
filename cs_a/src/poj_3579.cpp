#include<stdio.h>
#include<algorithm>
using namespace std;
bool check(int x,int a[],int n,int total){
    int count = 0;
    for(int i=0;i<n;i++){
        int left = i,right = n-1;
        while(left <= right){
            int mid = (left +right)>>1;
            if(a[mid] - a[i] < x){
                left = mid+1;
            }else
            {
                right = mid -1;
            }
        }
        count += left-i-1;
    }
    return count >= (total+1)/2;
}
int main(){
    int n ;
    while (scanf("%d",&n) != EOF && n)
    {
        int a[n];
        for(int i=0;i<n;i++){
            scanf("%d",&a[i]);
        }
        sort(a,a+n);
        int total = n*(n-1)/2;
        int left = 0,right = a[n-1];
        while(left <= right){
            int mid = (left+right)/2;
            if(check(mid,a,n,total)){
                right = mid -1;
            }else
            {
                left = mid +1;
            }
        }
        printf("%d\n",right);
    }
    
}