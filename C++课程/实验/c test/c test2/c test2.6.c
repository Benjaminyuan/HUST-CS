/*#include<stdio.h>
int  main()
{   int c;
	unsigned long int ip, m1, m2, m3, m4, p1, p2, p3, p4;

	printf("输入IP地址：");
	do{
	scanf("%lu", &ip);
	m1 = 0xff000000; //各分段逻辑尺
	m2 = 0x00ff0000; //各分段逻辑尺
	m3 = 0x0000ff00; //各分段逻辑尺
	m4 = 0x000000ff; //各分段逻辑尺
	p1 = (ip & m1) >> 24; //取出各部分二进制数
	p2 = (ip & m2) >> 16; //取出各部分二进制数
	p3 = (ip & m3) >> 8; //取出各部分二进制数
	p4 = (ip & m4);
	//取出各部分二进制数
	printf("这个IP地址常规形式为： %lu.%lu.%lu.%lu", p1, p2, p3, p4); //按要求格式输出
	}
	while((c=getchar())!=EOF);
	return 0;
}*/

