struct STACK
{
    int *elems; //申请内存用于存放栈的元素
    int max;    //栈能存放的最大元素个数
    int pos;    //栈实际已有元素个数，栈空时pos=0;
};
void initSTACK(STACK *const p, int m);               //初始化p指向的栈：最多m个元素
void initSTACK(STACK *const p, const STACK &s);      //用栈s初始化p指向的栈
int size(const STACK *const p);                      //返回p指向的栈的最大元素个数max
int howMany(const STACK *const p);                   //返回p指向的栈的实际元素个数pos
int getelem(const STACK *const p, int x);            //取下标x处的栈元素
STACK *const push(STACK *const p, int e);            //将e入栈，并返回p
STACK *const pop(STACK *const p, int &e);            //出栈到e，并返回p
STACK *const assign(STACK *const p, const STACK &s); //赋s给p指的栈,并返回p
void print(const STACK *const p);                    //打印p指向的栈
void destroySTACK(STACK *const p);   