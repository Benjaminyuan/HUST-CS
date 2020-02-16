
#include"queue.h"
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
        std::cout<<"  "<<this->elems[i]<<std::endl;
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
        cout <<"  "<< s2[int(s2) - i - 1];
    }
    cout<<"  ";
    for (int i = 0; i < STACK::operator int(); i++) {
        cout <<"  "<< STACK::operator [](i);
    }
    cout << flush;
}
QUEUE::~QUEUE() {
    return;
}
int main(int argc, char** argv)
{

	QUEUE* current = NULL, * temp = NULL;//current:当前操作的栈,temp:临时栈
	int pop;//出栈位置

	char flag = '?';//flag记录上一次操作
	for (int i = 1; i < argc; i++) {
		if (argv[i][0] == '-') {//扫描到-记录对应操作
			switch (argv[i][1]) {
			case 'S':
				flag = 'S';
				break;

			case 'I':
				flag = 'I';
				cout << "  I";//由于一个I后面可以跟多个数字，比较特殊，故单独输出
				break;

			case 'O':
				flag = 'O';
				break;

			case 'C':
				temp = new QUEUE(*current);
				delete current;//删除原内存
				current = temp;
				temp = NULL;//指向空指针
				cout << "  C";
				current->print();
				break;

			case 'A':
				flag = 'A';//深拷贝赋值
				break;

			case 'N':
				flag = 'N';//剩余元素个数
				cout << "  N  " << int(*current);
				break;

			case 'G':
				flag = 'G';//取元素
				break;

			default:
				return 0;
			}
		}
		else {//如果当前符号不是-而是数字的话
			switch (flag) {
			case 'S':
				current = new QUEUE(atoi(argv[i]));//字符串需要转化为整形
				cout << "S  " << atoi(argv[i]);//输出构造队列的大小
				break;

			case 'I':
			{
				while (1)
				{
					if (argv[i][0] == '-')
					{
						i--;//使下一个扫描到-
						break;
					}

					if (!(current->full()))//当前队列没有满
					{
						(*current) << atoi(argv[i]);//入队列
						i++;
					}
					else
					{
						cout << "  E";
						return 0;
					}//队列满了输出错误
					if (i == argc)  break;//防止argv[i][0]越界
				}
				current->print();//打印队列
				break;
			}

			case 'O':
				if (int(*current) < atoi(argv[i]))//队列中元素个数不足够出栈
				{
					cout << "  O  E";
					return 0;
				}
				for (int j = 0; j < atoi(argv[i]); j++)//重号问题*
					(*current) >> pop;//元素出队列
				cout << "  O";
				current->print();//打印元素
				break;

			case 'C':

				break;

			case 'A':
				temp = new QUEUE(atoi(argv[i]));
				*temp = *current;//赋值给新队列
				delete current;
				current = temp;
				temp = NULL;
				cout << "  A";
				current->print();
				break;

			case 'N':
				break;

			case 'G':
				if (atoi(argv[i]) < 0 || atoi(argv[i]) >= int(*current))//访问越界
				{
					cout << "  G  E";
					return 0;
				}
				cout << "  G  " << (*current)[atoi(argv[i])];
				break;


			default:
				return 0;
			}
		}

	}
	delete current;//删除current内存
	current = NULL;

}