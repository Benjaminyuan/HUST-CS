
#include<cstdio>
#include<cstring>
#include<cmath>
#include<algorithm>
#include<map>
using namespace std;
const int mod=9191891;
int n,m;
char wd[100005][12],s[50],tt;
int hs[10000050];
int geths(char *s)
{
	int len=strlen(s),ans=0;
	for (int i=0;i<len;i++) ans=(ans*29+s[i]-'a')%mod;
	return ans;
}
int main()
{
	while ((wd[++n][0]=getchar())!='\n')
	{
		scanf("%s%s",wd[n]+1,s);
		hs[geths(s)]=n;
		tt=getchar();
	}
	while (scanf("%s",s)!=EOF)
	{
		int t=geths(s);
		if (hs[t]) printf("%s\n",wd[hs[t]]);else printf("eh\n");
	}
	return 0;
}
