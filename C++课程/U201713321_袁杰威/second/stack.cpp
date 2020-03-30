#include<iostream>
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

int main(int argc, char** argv)
{
    using namespace std ;
	STACK* p = (STACK*)malloc(sizeof(STACK));
	STACK* s = (STACK*)malloc(sizeof(STACK));
	p = 0;
	s = 0;

	int i, j, pop_temp;
	char flag = '#';
	for (i = 1; i < argc; i++) {

		if (argv[i][0] == '-') {
			if (flag == '#');
			else if (flag == 'S') {
				printf("S  %d", p->size());
			}
			else if (flag == 'N');
			else if (flag == 'G');
			else {
				printf("  %c", flag);
				p->print();
			}

			switch (argv[i][1]) {
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
				s = new STACK(*p);
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

		else {
			switch (flag) {
			case 'S':
				p = new STACK(atoi(argv[i]));
				break;

			case 'I':
				if (*p == p->size()) {
					printf("  I  E\n");
					return 0;
				}
				p = &((*p) << (atoi(argv[i])));
				break;

			case 'O':
				for (j = 0; j < atoi(argv[i]); j++) {
					if (*p == 0) {
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
				s = new STACK(*p);
				*p = *s;
				break;

			case 'N':
				break;

			case 'G':
				if (atoi(argv[i]) > (*p)) {
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

	if (flag == '#');
	else if (flag == 'S') {
		printf("S  %d", p->size());
	}
	else if (flag == 'N');
	else if (flag == 'G');
	else {
		printf("  %c", flag);
		p->print();
	}
	printf("\n");

	delete p;
	delete s;
	return 0;
}