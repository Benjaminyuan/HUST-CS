#include <iostream>       
#include"stack.h"
void initSTACK(STACK *const p, int m)
{
    p->elems = new int[m];
    p->max = m;
    p->pos = 0;
}

void initSTACK(STACK *const p, const STACK &s)
{
    p->elems = new int[s.max];
    p->pos = s.pos;
    for (int i = 0; i < s.pos; ++i)
        p->elems[i] = s.elems[i];
}

int size(const STACK *const p)
{
    return p->max;
}

int howMany(const STACK *const p)
{
    return p->pos;
}

int getelem(const STACK *const p, int x)
{
    if (x >= p->max)
        throw std::logic_error("index overflow");
    return p->elems[x];
}

STACK *const push(STACK *const p, int e)
{
    if (p->pos == p->max)
        throw std::logic_error("push: stack size not enough");
    p->elems[p->pos] = e;
    ++p->pos;
    return p;
}

STACK *const pop(STACK *const p, int &e)
{
    if (p->pos == 0)
        throw std::logic_error("pop: pop from a empty stack");
    e = p->elems[--p->pos];
    return p;
}

STACK *const assign(STACK *const p, const STACK &s)
{
    p->pos = s.pos;
    p->max = s.max;
    delete p->elems;
    p->elems = new int[p->pos];
    for (int i = 0; i < s.pos; ++i){
        p->elems[i] = s.elems[i];
    }
    return p;
}
void print(const STACK *const p)
{
    for (int i = 0; i < p->pos; ++i)
    {
        std::cout << p->elems[i];
    }
    std::cout << std::flush;
}
void destroySTACK(STACK *const p)
{
    delete[] p->elems;
    p->elems = nullptr;
    p->pos = 0;
    p->max = 0;
}