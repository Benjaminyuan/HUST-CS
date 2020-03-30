/*#include<stdio.h>
int main()
{
	unsigned short x, m, n, i;
	printf("输入x、m（0~15）和n（1~16-m）：");
	scanf("%hx%hu%hu", &x, &m, &n);
	if(m>=0&&m<=15&&n>=1&&n<=16-m)  //判断输入是否合理
	{
		i = 0xffff;        //准备位运算所需逻辑尺
		i >>= m;         //确定变换起始位置
		i <<= 16 - n;      //确定变换作用长度
		i >>= 16 - m - n;   //进入变换位置
		x &= i;
        x <<= 16 - m - n;  //左移
		printf("经过变换得到： %hx", x);
	}
	else printf("输入错误，请检查您的输入");  //提示输入不合理
	return 0;
}
*/

