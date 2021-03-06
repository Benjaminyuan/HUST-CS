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
    STACK(STACK &&s) noexcept;
    virtual int size() const;               
    virtual operator int() const;             
    virtual int operator[](int x) const;     
    virtual STACK& operator<<(int e);         
    virtual STACK& operator>>(int &e);        
    virtual STACK& operator=(const STACK &s); 
    virtual STACK& operator=(STACK &&s);      
    virtual void print() const;              
    virtual ~STACK();                         
};

class QUEUE : public STACK {
private:
    STACK s2;

public:
    QUEUE(int m);
    QUEUE(const QUEUE &s);
    QUEUE(QUEUE &&q) noexcept ;
    virtual operator int() const;
    virtual int full() const;
    virtual int operator[](int x)const;
    virtual QUEUE &operator<<(int e);
    virtual QUEUE &operator>>(int &e);
    virtual QUEUE &operator=(const QUEUE &s);
    virtual void print() const;
    virtual ~QUEUE();
};