#include<iostream>
using namespace std;
class STACK
{
    int *const elems;
    const int max;
    int pos;

private:
    /* data */
public:
    STACK(/* args */ int m);
    STACK(/* args */ const STACK &s);
    STACK(STACK &&s);
    virtual int size() const;                 //返回栈的最大元素个数max
    virtual operator int() const;             //返回栈的实际元素个数pos
    virtual int operator[](int x) const;      //取下标x处的栈元素，第1个元素x=0
    virtual STACK& operator<<(int e);         //将e入栈,并返回栈
    virtual STACK& operator>>(int &e);        //出栈到e,并返回栈
    virtual STACK& operator=(const STACK &s); //赋s给栈,并返回被赋值栈
    virtual STACK& operator=(STACK &&s);      //移动赋值
    virtual void print() const;               //打印栈
    virtual ~STACK();                         //销毁栈
};


class QUEUE{
    STACK s1, s2;
public:
QUEUE(int m); //每个栈最多m个元素，要求实现的队列最多能入2m个元素
QUEUE(const QUEUE&q); 			//用队列q拷贝初始化队列
QUEUE(QUEUE &&q);				//移动构造
virtual operator int ( ) const;			//返回队列的实际元素个数
virtual int full ( ) const;		       //返回队列是否已满，满返回1，否则返回0
virtual int operator[ ](int x)const;   //取下标为x的元素,第1个元素下标为0
virtual QUEUE& operator<<(int e); 	//将e入队列,并返回队列
virtual QUEUE& operator>>(int &e);	//出队列到e,并返回队列
virtual QUEUE& operator=(const QUEUE&q); //赋q给队列,并返回被赋值的队列
virtual QUEUE& operator=(QUEUE&&q);	//移动赋值
virtual int size() const;                 //����ջ�����Ԫ�ظ���max
virtual void print( ) const;			//打印队列
virtual ~QUEUE( );					//销毁队列
};