#include<algorithm>
#include<iostream>
bool cmp(int a,int b){
    return a < b ;
}
int main(){
    int a[] = {45,23,62,34,565,223,12,1};
    std::sort(a,a+8,cmp);
    for(int i: a){
        std::cout << "a:"<< i << std::endl;
    }
}