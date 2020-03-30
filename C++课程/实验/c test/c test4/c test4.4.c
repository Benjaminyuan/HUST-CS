/*#define R
#include<stdio.h>
#include<assert.h>
int integer_fraction(float x);
int main(void)
{
    float r,s;
    int s_integer=0;
    printf("input a number:");
    scanf("%f",&r);
    #ifdef R
    s=3.14159*r*r;
    printf("area of round is:%f\n",s);
    s_integer=integer_fraction(s);
    assert((s-s_integer)<0.5);
    printf("the integer fraction of area is%d\n",s_integer);
    #endif // R
    return 0;
}
int integer_fraction(float x)
{
    int t=x;
    int i;
    if((x-t)<0.5)
        i=t;
    else
        i=t+1;


    return i;
}
*/
