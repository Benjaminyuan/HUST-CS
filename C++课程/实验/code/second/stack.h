
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