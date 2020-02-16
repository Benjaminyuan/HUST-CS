/*#include<stdio.h>
int  main()
{
	int  c;
	printf("输入字符，如果它是大写字母，则将它转换成对应的小写，否则原样输出：");
	c = getchar();  //通过getchar()来获得字符对应的ASCII码
	if (c <= 'Z' && c >= 'A')   //判断字符c是否为大写字母
		c = c - ('A' - 'a');  //将大写字母变为小写
	printf("处理结果是： %c", c);
	return 0;
}
*/
