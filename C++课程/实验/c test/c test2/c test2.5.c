/*#include<stdio.h>
int main()
{
	unsigned short x, m, n, i;
	printf("����x��m��0~15����n��1~16-m����");
	scanf("%hx%hu%hu", &x, &m, &n);
	if(m>=0&&m<=15&&n>=1&&n<=16-m)  //�ж������Ƿ����
	{
		i = 0xffff;        //׼��λ���������߼���
		i >>= m;         //ȷ���任��ʼλ��
		i <<= 16 - n;      //ȷ���任���ó���
		i >>= 16 - m - n;   //����任λ��
		x &= i;
        x <<= 16 - m - n;  //����
		printf("�����任�õ��� %hx", x);
	}
	else printf("�������������������");  //��ʾ���벻����
	return 0;
}
*/

