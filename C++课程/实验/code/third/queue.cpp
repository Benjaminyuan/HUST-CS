#include"./stack.h"
STACK::STACK(int m): elems(new int[m]),pos(0),max(m){
}
STACK::STACK( const STACK &s):elems(new int[s.max]),max(s.max){
    pos=0;
    for(int i=0;i<s.pos;i++){
        elems[pos++]= s.elems[i];
    }
};
STACK::STACK(STACK &&s):elems(std::move(s.elems)),max(std::move(s.max)),pos(std::move(s.pos)){
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
    int *tmp = new int[s.max];
    for(int i=0;i<s.pos;i++){
        tmp[i]= s.elems[i];
    }
    delete [] this->elems;
    *(int**)(&this->elems) = tmp;
    *(int*)(&this->max) = s.max;
    this->pos = s.pos;  
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
    delete [] elems;
}
QUEUE::QUEUE(int m) : s1(m), s2(m)
{
}
QUEUE::QUEUE(const QUEUE &q) : s1(q.s1), s2(q.s2)
{
} //用队列q拷贝初始化队列
QUEUE::QUEUE(QUEUE &&q) : s1(std::move(q.s1)), s2(std::move(q.s2))
{
}
QUEUE::operator int() const
{
    return int(s1) + int(s2);
}
int QUEUE::size() const
{
    return int(s1) + int(s2);
}
int QUEUE::full() const
{
    return (int(s1) == s1.size()) && !int(s2);
}
int QUEUE::operator[](int x) const
{
    if (x >= int(s1) + int(s2))
    {
        throw std::logic_error("index out of range");
    }
    if (x >= int(s2))
    {
        return s1[x - int(s2)];
    }
    else
    {
        return s2[int(s2) - x - 1];
    }
}
QUEUE &QUEUE::operator<<(int e)
{
    if (int(s1) == s1.size())
    {
        if (s2.size() != 0)
        {
            throw std::logic_error("queue is full");
        }
        int temp;
        int size = int(s1);
        for (int i = 0; i < size; i++)
        {
            s1 >> temp;
            s2 << temp;
        }
    }
    s1 << e;
    return *this;
}
QUEUE &QUEUE::operator>>(int &e)
{
    if (int(s2))
    {
        s2 >> e;
        return *this;
    }
    int temp;
    int size = int(s1);
    for (int i = 0; i < size; i++)
    {
        s1 >> temp;
        s2 << temp;
    }
    s2 >> e;
    return *this;
}
QUEUE &QUEUE::operator=(QUEUE &&q)
{
    s1 = std::move(q.s1);
    s2 = std::move(q.s2);
    return *this;
}
QUEUE &QUEUE::operator=(const QUEUE &s)
{
    s1 = s.s1;
    s2 = s.s2;
    return *this;
}
void QUEUE::print() const
{
    for (int i = 0; i < int(s2); ++i)
    {
        cout << s2[int(s2) - i - 1];
    }
    for (int i = 0; i < int(s1); ++i)
    {
        cout << s1[i];
    }
    cout << flush;
}
QUEUE::~QUEUE()
{
    return;
}
int main(int argc, char **argv)
{
    if (argc == 1)
    {
        int M, F, m, f;
        // input here
        cout << "input M:";
        cin >> M;
        cout << "input F:";
        cin >> F;
        cout << "input m:";
        cin >> m;
        cout << "input f:";
        cin >> f;

        if (m > M || f > F)
        {
            cout << "wrong input";
            return 0;
        }

        QUEUE q1(M);
        QUEUE q2(F);

        int count = 0;
        int temp1 = 0, temp2 = 0;
        while (1)
        {
            //initial here
            if (q1 == 0)
            {
                for (int i = 0; i < M; i++)
                {
                    if (i == m - 1)
                        q1 << 1;
                    else
                        q1 << 0;
                }
            }
            if (q2 == 0)
            {
                for (int i = 0; i < F; i++)
                {
                    if (i == f - 1)
                        q2 << 1;
                    else
                        q2 << 0;
                }
            }

            //pop and calculate here
            count++;
            q1 >> temp1;
            q2 >> temp2;
            if (temp1 && temp2)
            {
                cout << "result:" << count << "\n";
                break;
            }
        }
        return 0;
    }
    QUEUE *p = (QUEUE *)malloc(sizeof(QUEUE));
    QUEUE *s = (QUEUE *)malloc(sizeof(QUEUE));
    p = 0;
    s = 0;

    int i, j, pop_temp;
    char flag = '#';
    for (i = 1; i < argc; i++)
    {

        if (argv[i][0] == '-')
        {
            if (flag == '#')
                ;
            else if (flag == 'S')
            {
                printf("S  %d", p->size());
            }
            else if (flag == 'N')
                ;
            else if (flag == 'G')
                ;
            else
            {
                printf("  %c", flag);
                p->print();
            }

            switch (argv[i][1])
            {
            case 'S':
                flag = 'S';
                break;

            case 'I':
                flag = 'I';
                break;

            case 'O':
                flag = 'O';
                break;

            case 'C':
                s = new QUEUE(*p);
                flag = 'C';
                break;

            case 'A':
                flag = 'A';
                break;

            case 'N':
                // printf("  N  %d", *p);
                cout << "  N  " << (*p);
                flag = 'N';
                break;

            case 'G':
                flag = 'G';
                break;

            default:
                //error now
                break;
            }
        }

        else
        {
            switch (flag)
            {
            case 'S':
                p = new QUEUE(atoi(argv[i]));
                break;

            case 'I':
                if (p->full())
                {
                    printf("  I  E\n");
                    return 0;
                }
                p = &((*p) << (atoi(argv[i])));
                break;

            case 'O':
                for (j = 0; j < atoi(argv[i]); j++)
                {
                    if (*p == 0)
                    {
                        printf("  O  E\n");
                        return 0;
                    }
                    else
                        p = &((*p) >> pop_temp);
                }
                break;

            case 'C':
                //error
                return 0;
                break;

            case 'A':
                s = new QUEUE(*p);
                *p = *s;
                break;

            case 'N':
                break;

            case 'G':
                if (atoi(argv[i]) > (*p))
                {
                    printf("  G  E\n");
                    return 0;
                }
                printf("  G  %d", (*p)[atoi(argv[i])]);
                break;

            default:
                //first input S, error
                break;
            }
        }
    }

    if (flag == '#')
        ;
    else if (flag == 'S')
    {
        printf("S  %d", p->size());
    }
    else if (flag == 'N')
        ;
    else if (flag == 'G')
        ;
    else
    {
        printf("  %c", flag);
        p->print();
    }
    printf("\n");

    delete p;
    delete s;
    return 0;
}