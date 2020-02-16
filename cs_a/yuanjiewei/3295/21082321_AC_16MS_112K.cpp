
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX 110
int main()
{
    char s[MAX], s1[MAX], str[MAX];
    int t, k, i, j, flat;
    int num[32][5] =
    {
        1,1,1,1,1,
        1,1,1,1,0,
        1,1,1,0,1,
        1,1,1,0,0,
        1,1,0,1,1,
        1,1,0,1,0,
        1,1,0,0,1,
        1,1,0,0,0,
        1,0,1,1,1,
        1,0,1,1,0,
        1,0,1,0,1,
        1,0,1,0,0,
        1,0,0,1,1,
        1,0,0,1,0,
        1,0,0,0,1,
        1,0,0,0,0,
        0,1,1,1,1,
        0,1,1,1,0,
        0,1,1,0,1,
        0,1,1,0,0,
        0,1,0,1,1,
        0,1,0,1,0,
        0,1,0,0,1,
        0,1,0,0,0,
        0,0,1,1,1,
        0,0,1,1,0,
        0,0,1,0,1,
        0,0,1,0,0,
        0,0,0,1,1,
        0,0,0,1,0,
        0,0,0,0,1,
        0,0,0,0,0,
    };
    while(~scanf("%s",s))
    {
        flat = 0;
        k = strlen(s);
        if(k == 1 && s[0] == '0')
            break;
        for(i = 0; i < 32; i++)
        {
            t = 0;
            for(j = 0; j < k; j++)
            {
                if(s[j] == 'p')
                    s1[j] = num[i][0] + '0';
                else if(s[j] == 'q')
                    s1[j] = num[i][1] + '0';
                else if(s[j] == 'r')
                    s1[j] = num[i][2] + '0';
                else if(s[j] == 's')
                    s1[j] = num[i][3] + '0';
                else if(s[j] == 't')
                    s1[j] = num[i][4] + '0';
                else
                    s1[j] = s[j];
            }
            for(j = k-1; j >= 0; j--)
            {
                if(s1[j] == '0' || s1[j] == '1')
                {
                    str[t++] = s1[j];
                }
                else if(s1[j] == 'K')
                {
                    str[t-2] = ((str[t-2]-'0')&&(str[t-1]-'0'))+'0';
                    t--;
                }
                else if(s1[j] == 'A')
                {
                    str[t-2] = ((str[t-2]-'0')||(str[t-1]-'0'))+'0';
                    t--;
                }
                else if(s1[j] == 'C')
                {
                    str[t-2] = ((!(str[t-2]-'0'))||(str[t-1]-'0'))+'0';
                    t--;
                }
                else if(s1[j] == 'E')
                {
                    str[t-2] = ((str[t-2]-'0')==(str[t-1]-'0'))+'0';
                    t--;
                }
                else if(s1[j] == 'N')
                {
                    str[t-1] = (!(str[t-1]-'0'))+'0';
                }
            }
            if(str[0] == '0')
                flat = 1;
        }
        if(flat == 0)
            printf("tautology\n");
        else
            printf("not\n");
    }
    return 0;

}