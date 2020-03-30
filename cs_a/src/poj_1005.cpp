#include<iostream>
#include<math.h>
#define M_PI_MY 3.14159265358979323846264338327950288
int main(){
    int n;
    std::cin>> n;
    double x,y;
    for(int i=0;i<n;i++){
        std::cin>>x>>y;
        double year = M_PI_MY*(x*x+y*y)/100;
        std::cout<<"Property "<<i+1<<": This property will begin eroding in year "<<(int)year+1<<"."<<std::endl;
    }
    std::cout<<"END OF OUTPUT."<<std::endl;
    return 0;
}