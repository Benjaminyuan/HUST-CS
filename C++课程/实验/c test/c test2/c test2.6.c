/*#include<stdio.h>
int  main()
{   int c;
	unsigned long int ip, m1, m2, m3, m4, p1, p2, p3, p4;

	printf("����IP��ַ��");
	do{
	scanf("%lu", &ip);
	m1 = 0xff000000; //���ֶ��߼���
	m2 = 0x00ff0000; //���ֶ��߼���
	m3 = 0x0000ff00; //���ֶ��߼���
	m4 = 0x000000ff; //���ֶ��߼���
	p1 = (ip & m1) >> 24; //ȡ�������ֶ�������
	p2 = (ip & m2) >> 16; //ȡ�������ֶ�������
	p3 = (ip & m3) >> 8; //ȡ�������ֶ�������
	p4 = (ip & m4);
	//ȡ�������ֶ�������
	printf("���IP��ַ������ʽΪ�� %lu.%lu.%lu.%lu", p1, p2, p3, p4); //��Ҫ���ʽ���
	}
	while((c=getchar())!=EOF);
	return 0;
}*/

