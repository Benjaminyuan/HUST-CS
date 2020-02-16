
// #include"queue.h"
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
STACK::STACK(int m): elems(new int[m]),pos(0),max(m){
}
STACK::STACK( const STACK &s):elems(new int[s.max]),max(s.max){
    pos=0;
    for(int i=0;i<s.pos;i++){
        elems[pos++]= s.elems[i];
    }
};
STACK::STACK(STACK &&s)noexcept:elems(std::move(s.elems)),max(std::move(s.max)),pos(std::move(s.pos)){
}
int STACK::size()const{
    return max;
}
STACK::operator int()const{
    return pos;
}
int STACK::operator[](int x)const{
    if(x>pos){
        throw std::logic_error("index out of range");
    }
    return elems[x];
}
STACK& STACK::operator<<(int e){
    if(pos == max){
        throw std::logic_error("index is full no more memory");
    }
    elems[pos++] = e;
    return *this;
}
STACK& STACK::operator>>(int &e){
    if(pos==0){
        throw std::logic_error("no more items");
    }
    e = elems[--pos];
    return *this;
}
STACK& STACK::operator=(const STACK &s){
    this->pos = s.pos;
    int *temp = (int*)(&max);
    *temp = s.max;
    for(int i=0;i<s.pos;i++){
        elems[i]= s.elems[i];
    }
    return *this;
}
STACK& STACK::operator=(STACK &&s){
    for(int i=0; i < pos; ++i)
        elems[i] = s.elems[i];
    return *this;
}
void STACK::print()const{
    for(int i=0;i<this->pos;i++){
        std::cout<<this->elems[i]<<std::endl;
    }
}
STACK::~STACK()
{
    if (elems == 0){
        return;
    }
    delete [] elems;
    *(int**)(&elems) = 0;
}


QUEUE::QUEUE(int m) : STACK(m), s2(m) {
    return;
}

QUEUE::QUEUE(const QUEUE &s) : STACK(static_cast<STACK>(s)), s2(s.s2) {
    return;
}
 QUEUE::QUEUE(QUEUE &&q)noexcept:s2(std::move(q.s2)), STACK(q.s2.size()){

 }
QUEUE::operator int() const {
    return STACK::operator int() + s2.operator int();
}

int QUEUE::full() const {
    return STACK::operator int() == STACK::size() && !s2.operator int();
}

int QUEUE::operator [](int x) const {
    if (x >= STACK::operator int() + s2.operator int())
        throw std::logic_error("trying to get elem outside of queue");
    if (x >= int(s2))
        return STACK::operator [](x - int(s2));
    else
        return s2[int(s2) - x - 1];
}

QUEUE &QUEUE::operator <<(int e) {
    if (STACK::operator int() == STACK::size()) {
        int temp;
        int origSize = STACK::operator int();
        for (int i = 0; i < origSize; ++i) {
            STACK::operator >>(temp);
            s2 << temp;
        }
    }
    STACK::operator <<(e);
    return *this;
}

QUEUE &QUEUE::operator >>(int &e) {
    if (int(s2)) {
        s2 >> e;
    } else {
        int temp;
        int origSize = STACK::operator int();
        for (int i = 0; i < origSize - 1; ++i) {
            STACK::operator >>(temp);
            s2 << temp;
        }
        STACK::operator >>(e);
    }
    return *this;
}

QUEUE &QUEUE::operator =(const QUEUE &s) {
    STACK::operator=(static_cast<STACK>(s));
    s2 = s.s2;
    return *this;
}

void QUEUE::print() const {
    using namespace std;

    for (int i = 0; i < int(s2); i++) {
        cout << s2[int(s2) - i - 1]<<"  ";
    }
    cout<<"  ";
    for (int i = 0; i < STACK::operator int(); i++) {
        cout << STACK::operator [](i)<<"  ";
    }
    cout << flush;
}
QUEUE::~QUEUE() {
    return;
}

int dance(int m,int f,QUEUE M,QUEUE F){
    int man = M[m];
    int female = F[f];
    int count = 0;
    while (1)
    {
        int temp_man;
        int temp_female;
        count ++;
        M >> temp_man;
        F >> temp_female;
        count ++;
        if(temp_man == man && temp_female ==female ){
            break;
        }
        M << temp_man;
        F << temp_female;
    }
    return count;
}
int main(int argc, char** argv)
{
    if(argc==1){
        int M,F,m,f;
        // input here
        cout<<"input M:";
        cin>>M;
        cout<<"input F:";
        cin>>F;
        cout<<"input m:";
        cin>>m;
        cout<<"input f:";
        cin>>f;

        if(m>M||f>F){
            cout<<"wrong input";
            return 0;
        }

        QUEUE q1(M);
        QUEUE q2(F);

        int count=0;
        int temp1=0,temp2=0;
        while(1){
            //initial here
            if(q1==0){
                for(int i=0;i<M;i++){
                    if(i==m-1)q1<<1;
                    else q1<<0;
                }
            }
            if(q2==0){
                for(int i=0;i<F;i++){
                    if(i==f-1)q2<<1;
                    else q2<<0;
                }
            }

            //pop and calculate here
            count++;
            q1>>temp1;
            q2>>temp2;
            if(temp1 && temp2){
                cout<<"result:"<<count<<"\n";
                break;
            }
        }
        return 0;
    }
    QUEUE *p = (QUEUE*)malloc(sizeof(QUEUE));
    QUEUE *s = (QUEUE*)malloc(sizeof(QUEUE));
    p=0;
    s=0;

    int i,j,pop_temp;
    char flag='#';
    for(i=1;i<argc;i++){

        if(argv[i][0]=='-'){
            if(flag=='#');
            else if(flag=='S'){
                printf("S  %d",p->size());
            }
            else if(flag=='N');
            else if(flag=='G');
            else{
                printf("  %c", flag);
                p->print();
            }

            switch (argv[i][1]) {
                case 'S':
                    flag='S';
                    break;

                case 'I':
                    flag='I';
                    break;

                case 'O':
                    flag='O';
                    break;

                case 'C':
                    s=new QUEUE(*p);
                    flag='C';
                    break;

                case 'A':
                    flag='A';
                    break;

                case 'N':
                    // printf("  N  %d", *p);
                    cout<<"  N  "<<(*p);
                    flag='N';
                    break;

                case 'G':
                    flag='G';
                    break;

                default:
                    //error now
                    break;
            }
        }

        else{
            switch (flag){
                case 'S':
                    p = new QUEUE(atoi(argv[i]));
                    break;

                case 'I':
                    if(p->full()){
                        printf("  I  E\n");
                        return 0;
                    }
                    p=&((*p)<<(atoi(argv[i])));
                    break;

                case 'O':
                    for(j=0;j<atoi(argv[i]);j++){
                        if(*p==0){
                            printf("  O  E\n");
                            return 0;
                        }
                        else
                            p=&((*p)>>pop_temp);
                    }
                    break;

                case 'C':
                    //error
                    return 0;
                    break;

                case 'A':
                    s=new QUEUE(*p);
                    *p=*s;
                    break;

                case 'N':
                    break;

                case 'G':
                    if(atoi(argv[i])>(*p)){
                        printf("  G  E\n");
                        return 0;
                    }
                    printf("  G  %d",(*p)[atoi(argv[i])]);
                    break;

                default:
                    //first input S, error
                    break;
            }
        }

    }

    if(flag=='#');
    else if(flag=='S'){
        printf("S  %d",p->size());
    }
    else if(flag=='N');
    else if(flag=='G');
    else{
        printf("  %c", flag);
        p->print();
    }
    printf("\n");

    delete p;
    delete s;
    return 0;
}
