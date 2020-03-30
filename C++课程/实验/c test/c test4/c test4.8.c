/*#include<stdio.h>
#define CHANGE
int  main( )
{
    char str[100];
    printf("ÇëÊäÈë×Ö·û´®£º");
    gets(str);
    int i=0;

    while(str[i]!='\0')
    {

        #ifdef CHANGE
        if(str[i]>='A'&&str[i]<='Z')
            str[i]=str[i]+32;
        else if(str[i]>='a'&&str[i]<='z')
            str[i]=str[i]-32;
        #endif // CHANGE
        i++;
    }
    puts(str);


    return 0;
}
*/
