#pragma warning(disable:4996)
#pragma warning(disable:6031)
#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<time.h>
#include<algorithm>
using namespace std;

#define TRUE  1
#define FALSE 0
#define OK    2
#define ERROR -1
int* value;//记录变元的值
int* occurtimes;//记录变元出现次数
int* backtrack;//记录是否访问过变元
int* positivetimes;  //记录变元出现的正状态次数
int* negativetimes;//记录变元出现的负状态次数
int linenumbers;//记录子句的行数
int variablenumbers;//记录初始文字的种类数
typedef struct Node {
	int name;
	struct Node* next;
}Node;//邻接表的节点，用于记录文字

typedef struct Line {
	struct Node* firstnode;//指向第一个邻接的节点
	struct Line* nextline;//指向下一行子句
}Line;

typedef struct ShuduLine {
	int v[9][9];
	struct ShuduLine* next;
}ShuduLine;

Line* CreatCNF(char* cnfpath)
{
	Line* cnf = (Line*)malloc(sizeof(Line));
	cnf->firstnode = NULL; cnf->nextline = NULL;//初始化

	FILE* fp;
	fp = fopen(cnfpath, "r");
	if (fp == NULL) {
		printf("打开失败\n");
		return NULL;
	}
	char x;//用于储存读取到的信息
	while ((x = fgetc(fp)) == 'c')
	{
		while ((x = fgetc(fp)) != '\n')
			;  //跳过注释部分
	}

	int i, k;
	for (i = 0; i < 5; i++) {
		x = fgetc(fp);
	}//移动到行数和变元数
	fscanf(fp, "%d", &variablenumbers);
	fscanf(fp, "%d", &linenumbers);
	//对相关信息进行初始化
	value = (int*)calloc(variablenumbers + 1, sizeof(int));
	occurtimes = (int*)calloc(variablenumbers + 1, sizeof(int));
	backtrack = (int*)calloc(variablenumbers + 1, sizeof(int));
	for (i = 0; i < variablenumbers + 1; i++) {
		backtrack[i] = 0;//0代表还未访问,1代表已经访问
	}
	positivetimes = (int*)calloc(variablenumbers + 1, sizeof(int));
	negativetimes = (int*)calloc(variablenumbers + 1, sizeof(int));
	//到此截止
	Node* head1, * tail1, * p;
	Line* tail2, * q;
	tail2 = cnf;
	for (i = 0; i < linenumbers; i++) {
		fscanf(fp, "%d", &k);
		if (k != 0) {
			head1 = (Node*)malloc(sizeof(Node));
			if (head1 == NULL) {
				printf("分配空间错误\n");
				return NULL;
			}
			head1->name = k;
			head1->next = NULL;
			occurtimes[abs(k)]++;
			if (k > 0) positivetimes[abs(k)]++;
			else       negativetimes[abs(k)]++;
			tail1 = head1;
		}//创建第一个结点
		else continue;

		while (fscanf(fp, "%d", &k) && k != 0) {
			p = (Node*)malloc(sizeof(Node));
			if (p == NULL) {
				printf("分配空间错误\n");
				return NULL;
			}
			p->name = k;
			p->next = NULL;
			occurtimes[abs(k)]++;
			if (k > 0) positivetimes[abs(k)]++;
			else       negativetimes[abs(k)]++;
			tail1->next = p;
			tail1 = p;
		}
		//将生成的链表连接到表头节点上
		if (i == 0) {//第一行时特殊处理
			cnf->firstnode = head1;
			cnf->nextline = NULL;
		}
		else {
			q = (Line*)malloc(sizeof(Line));
			if (q == NULL) {
				printf("空间分配错误\n");
				return NULL;
			}
			q->firstnode = head1;
			q->nextline = NULL;
			tail2->nextline = q;
			tail2 = q;
		}
	}
	fclose(fp);
	return cnf;
}

void DesplayFile(Line* s)
/*用于展示所读取CNF文件的数值*/
{
	Line* linep;
	Node* nodep;
	int count = 0;
	if (s == NULL) {
		printf("子句集为空\n");
		return;
	}
	linep = s;
	while (linep) {
		nodep = linep->firstnode;
		printf("%d:", ++count);
		while (nodep) {
			printf("%d ", nodep->name);
			nodep = nodep->next;
		}
		putchar('\n');
		linep = linep->nextline;
	}
	putchar('\n');
}

void AnalyzeFile(Line* s)
/*对文件进行解析*/
{
	Line* linep;
	Node* nodep;
	int count;
	if (s == NULL) {
		printf("子句集为空\n");
		return;
	}
	linep = s;
	while (linep) {
		count = 0;//初始化
		nodep = linep->firstnode;
		while (nodep) {
			if (count == 0) {
				if (nodep->name > 0)
					printf("%d ", nodep->name);
				else
					printf("!%d ", abs(nodep->name));
			}
			else {
				if (nodep->name > 0)
					printf("V %d ", nodep->name);
				else
					printf("V !%d", abs(nodep->name));
			}
			count++;
			nodep = nodep->next;
		}
		putchar('\n');
		linep = linep->nextline;
	}
}

int JudgeSingle(Line* s, int* positivetimes, int* negativetimes)
/*判断子句集中是否存在单子句子,若存在单子句，
则返回出现次数最多的单子句；若不存在单子句，则返回0*/
{
	int max;//用于记录单子句的正负乘积出现次数的最大值
	Line* linep = s;

	typedef struct record {
		int name;
		struct record* next;
	}record;//将子句集中的单子句用链表串联记录

	record* head, * tail, * p, * q;
	head = (record*)malloc(sizeof(record));//为了方便，以有头结点的链表进行储存
	if (head == NULL) {
		printf("分配空间失败\n");
		return ERROR;
	}
	head->next = NULL;
	tail = head;

	if (s == NULL) {//子句集为空，不存在单子句
		return 0;
	}
	while (linep)
	{
		if (linep->firstnode != NULL)
		{//当读取到的子句不是空子句时
			if (linep->firstnode->next == NULL)//说明该子句是单子句
			{
				p = (record*)malloc(sizeof(record));
				if (p == NULL) {
					printf("分配空间错误\n");
					return ERROR;
				}
				p->name = linep->firstnode->name;
				p->next = NULL;
				tail->next = p;
				tail = p;
				//将单子句放到链表中记录
			}
		}
		linep = linep->nextline;
	}
	if (head->next == NULL) {//说明没有单子句
		return 0;
	}
	p = head->next;
	max = -1;
	int recordName = 0;
	while (p)
	{
		if (p->name > 0) {//当为文字为正时
			if (positivetimes[p->name] > max) {
				max = positivetimes[p->name];
				recordName = p->name;
			}

		}
		else {//当文字为负时
			if (negativetimes[abs(p->name)] > max) {
				max = negativetimes[abs(p->name)];
				recordName = p->name;
			}
		}
		p = p->next;
	}//以上进行完后，recordName储存的是出现次数最多的文字

	/*销毁为了记录单子句而建立的链表*/
	if (head->next == NULL)
		free(head);
	else
	{
		p = head->next;
		q = p->next;
		while (p)
		{
			free(p);
			p = q;
			if (p)  q = p->next;
		}
		free(head);
	}
	return recordName;
}

bool JudgeEmptyGather(Line* s)
/*判断子句集是否为空*/
{
	if (s == NULL)
		return 1;
	else return 0;
}

bool JudgeEmptyWords(Line* s)
/*判断是否存在空子句*/
{
	Line* p;
	if (s == NULL) {//子句集为空，没有空子句
		return 0;
	}
	p = s;
	while (p)
	{
		if (p->firstnode == NULL)
			return 1;
		p = p->nextline;
	}
	return 0;
}


int InsertVariable(Line*& s, int xname, int* positivetimes, int* negativetimes, int* occurtimes)
/*向子句集中插入单个变元*/
{
	//将该变元插入子句集中
	Line* linep;
	Node* nodep;
	nodep = (Node*)malloc(sizeof(Node));
	if (nodep == NULL) {
		printf("分配空间失败\n");
		return ERROR;
	}
	nodep->name = xname; nodep->next = NULL;
	linep = (Line*)malloc(sizeof(Line));
	if (linep == NULL) {
		printf("分配空间失败\n");
		return ERROR;
	}
	linep->firstnode = nodep;
	linep->nextline = s;
	s = linep;
	//插入操作到此为止，下面需要更改记录子句集信息的数组的值
	//根据DPLL算法的具体情况，插入的文字只能是子句集中已有的文字
	//因此省略插入新文字的情况

	occurtimes[abs(xname)]++;
	if (xname > 0)
	{
		positivetimes[xname]++;
	}
	else {
		negativetimes[abs(xname)]++;
	}
	linenumbers++;
	return OK;
}





void DelLine(Line*& s, Line* p, int* positivetimes, int* negativetimes, int* occurtimes)
/*从子句集s中删除指定的子句p*/
{
	Node* nodep1 = NULL, * nodep2 = NULL;
	Line* linep;
	if (s == NULL) {
		printf("子句集为空\n");
		return;
	}
	if (s == p)
	{//说明要删除的是第一条子句，需要特殊处理
		nodep1 = p->firstnode;
		if (nodep1 != NULL)
			nodep2 = nodep1->next;
		while (nodep1)
		{//删除表结点
			occurtimes[abs(nodep1->name)]--;//总的出现次数
			if (nodep1->name > 0) {//正值或者负值出现次数
				positivetimes[nodep1->name]--;
			}
			else {
				negativetimes[abs(nodep1->name)]--;
			}
			free(nodep1);
			nodep1 = nodep2;
			if (nodep1 != NULL)
				nodep2 = nodep1->next;
			else
				break;
		}
		s = p->nextline;
		free(p);//删除头结点
		linenumbers--;
	}
	else
	{//要删除的不是第一条子句
		nodep1 = p->firstnode;
		if (nodep1 != NULL)
			nodep2 = nodep1->next;
		while (nodep1) {//删除表结点
			occurtimes[abs(nodep1->name)]--;//总的出现次数
			if (nodep1->name > 0)
			{//正值或者负值出现次数
				positivetimes[nodep1->name]--;
			}
			else
			{
				negativetimes[abs(nodep1->name)]--;
			}
			free(nodep1);
			nodep1 = nodep2;
			if (nodep1 != NULL)
				nodep2 = nodep1->next;
			else
				break;
		}//end of while

		linep = s;
		while (linep->nextline != p)
			linep = linep->nextline;//将linep移动到p之前
		linep->nextline = p->nextline;
		free(p);//删除头结点
		linenumbers--;
	}//end of else

}


void DelWords(Line*& s, int xname, int* positivetimes, int* negativetimes, int* occurtimes)
/*删除子句集中所有包含单子句xname的子句（包括其本身）*/
{
	if (s == NULL) {
		printf("S为空集\n");
		return;
	}
	Line* linep1, * linep2;//linep1指向正在检查的行，
						 //为了保证删除一行后还能找到下一行，需要用line2暂时保存下一行的地址
	Node* nodep1;
	linep1 = s; linep2 = linep1->nextline;
	while (linep1)
	{

		nodep1 = linep1->firstnode;

		while (nodep1)
		{
			if (nodep1->name == xname)
			{
				DelLine(s, linep1, positivetimes, negativetimes, occurtimes);//该行子句包含文字xname，需要将该行子句删除
				break;
			}
			else
				nodep1 = nodep1->next;
		}

		//列指针linep1移动到下一行
		linep1 = linep2;
		if (linep1 != NULL)
		{
			linep2 = linep1->nextline;
		}//end of if
	}//end of while
}

void DelWord(Line* s, int xname, int* positivetimes, int* negativetimes, int* occurtimes)
/*删除语句集中包含文字xname的部分（并非是将整个语句都删除，只删除语句中的xname），
与DelWords有区别！！！此操作可能产生空语句！！*/
{
	Line* linep; Node* p, * q;

	if (s == NULL) {
		printf("语句集为空\n");
		return;
	}
	linep = s;
	while (linep)
	{
		q = linep->firstnode;
		p = NULL;

		while (q)
		{
			while (q != NULL && q->name != xname)
			{
				p = q;
				q = q->next;
			}
			if (q && linep->firstnode == q)
			{//说明要删除的是首节点
				linep->firstnode = q->next;
				free(q);
				occurtimes[abs(xname)]--;
				if (xname > 0)	positivetimes[abs(xname)]--;
				else			negativetimes[abs(xname)]--;
				q = linep->firstnode;
			}
			else
			{//要删除的点不是首节点
				if (q)
				{
					p->next = q->next;
					free(q);
					occurtimes[abs(xname)]--;
					if (xname > 0)	positivetimes[abs(xname)]--;
					else			negativetimes[abs(xname)]--;
					q = p->next;
				}
			}
		}
		linep = linep->nextline;
	}
}

void SingleWords(Line*& s, int xname, int* positivetimes, int* negativetimes, int* occurtimes)
/*利用单子句xname进行化简*/
{
	value[abs(xname)] = xname > 0 ? 1 : 0;
	DelWords(s, xname, positivetimes, negativetimes, occurtimes);/*从S中删除所有包含L的子句，包括单子句本身得到子句集S1.*/
	if (JudgeEmptyGather(s) != 1) {//如果子句集S不为空，则对每个子句去掉-xname。
		DelWord(s, -xname, positivetimes, negativetimes, occurtimes);
	}
}


int SelectVariable(int* backtrack, int* positivetimes, int* negativetimes)
/*基于某种策略选取变元v，策略就是选取剩余文字中出现次数最多的那个,
若返回0，说明不存在文字*/
{
	int i, max = -1, c = 0;//max用于记录出现最多的次数，c用于记录相应的文字值
	for (i = 1; i < variablenumbers + 1; i++)
	{
		if (backtrack[i] == 0)
		{//说明还未被选中
			if (positivetimes[i] > negativetimes[i])
			{
				if (positivetimes[i] > max) {
					max = positivetimes[i];
					c = i;
				}
			}
			else
			{
				if (negativetimes[i] > max) {
					max = negativetimes[i];
					c = -i;
				}
			}
		}
	}
	return c;
}

Line* CopyGather(Line* s)
/*比照集合s复制一个集合，返回重新复制集合的头指针*/
{
	if (s == NULL)   return NULL;
	Line* t, * linep1, * linep2, * q;
	Node* nodep, * head, * tail, * p;
	int i;
	t = (Line*)malloc(sizeof(Line));
	if (t == NULL) {
		printf("分配空间错误\n");
		return NULL;
	}
	t->firstnode = NULL; t->nextline = NULL;
	linep2 = t;
	linep1 = s;
	for (i = 0; linep1 != NULL; i++)
	{
		head = tail = NULL;
		nodep = linep1->firstnode;
		//生成第一个表结点需要特殊处理。
		if (nodep != NULL)
		{//不为空时，生成第一个表结点
			head = (Node*)malloc(sizeof(Node));
			if (head == NULL) {
				printf("分配空间错误\n");
				return NULL;
			}
			head->name = nodep->name;
			head->next = NULL;
			tail = head;
			nodep = nodep->next;
		}

		while (nodep != NULL)
		{//生成完该行的其余表结点
			p = (Node*)malloc(sizeof(Node));
			if (p == NULL) {
				printf("分配空间错误\n");
				return NULL;
			}
			p->name = nodep->name;
			p->next = NULL;
			tail->next = p;
			tail = p;
			nodep = nodep->next;
		}
		//将生成的表结点连接到相应的头结点上
		if (i == 0)
		{//第一行子句特殊处理
			t->firstnode = head;
			t->nextline = NULL;
		}
		else
		{
			q = (Line*)malloc(sizeof(Line));
			if (q == NULL) {
				printf("分配空间错误\n");
				return NULL;
			}
			q->firstnode = head;
			if (q == NULL) {
				printf("分配空间错误\n");
				return NULL;
			}
			q->nextline = NULL;
			linep2->nextline = q;
			linep2 = q;
		}
		linep1 = linep1->nextline;
	}
	return t;
}

int* CopyShuzu(int* old_shuzu)
/*复制数组，如果复制成功则返回新数组的首地址，否则返回空指针*/
{
	int* new_shuzu;
	int i;
	new_shuzu = (int*)malloc((variablenumbers + 1) * sizeof(int));
	if (new_shuzu == NULL)
	{
		printf("分配空间失败\n");
		return NULL;
	}
	for (i = 1; i < variablenumbers + 1; i++)
	{
		new_shuzu[i] = old_shuzu[i];
	}
	return new_shuzu;

}

void PrintValue()
{
	int i;
	for (i = 1; i < variablenumbers + 1; i++)
	{
		printf("%2d =%2d ", i, value[i]);
		if (i % 5 == 0)
		{
			putchar('\n');
		}
	}

}

int Seekchunwenzi(Line* S)//找到纯文字
{
	int* literal = (int*)calloc(variablenumbers + 1, sizeof(int));
	if (literal == NULL)
	{
		return  -2;
	}
	Line* L = S;
	while (L != NULL)
	{
		Node* c = L->firstnode;
		while (c != NULL)
		{
			int f = literal[abs(c->name)];
			if (f == 0)
			{
				literal[abs(c->name)] = c->name > 0 ? 1 : -1;
			}
			else if (f == -1 && (c->name) > 0)//此时有多个文字且正负不一致
			{
				literal[abs(c->name)] = 2;
			}
			else if (f == 1 && (c->name) < 0)
			{
				literal[abs(c->name)] = 2;
			}
			c = c->next;
		}
		L = L->nextline;
	}
	int i;
	for (i = 1; i < variablenumbers + 1; i++) //遍历找到第一个纯文字
	{
		if (literal[i] == -1 || literal[i] == 1)
		{
			int j = literal[i];
			free(literal);
			return i * j;
		}
	}
	return 0;
}


void DestroyGather(Line* s)
/*清除邻接表内存*/
{
	Line* linep1, * linep2;
	Node* nodep1, * nodep2;
	if (s == NULL)
		return;
	linep1 = s;
	linep2 = linep1->nextline;
	while (linep1)
	{
		nodep1 = linep1->firstnode;
		nodep2 = NULL;
		if (nodep1 != NULL)
			nodep2 = nodep1->next;
		while (nodep1)
		{
			free(nodep1);
			nodep1 = nodep2;
			if (nodep1)
				nodep2 = nodep1->next;
		}//删除该行的表结点
		linep1 = linep2;
		if (linep1)
			linep2 = linep1->nextline;
	}
}

int xcount = 0;
int DPLL(Line*& s, int* backtrack, int* positivetimes, int* negativetimes, int* occurtimes)
/*DPLL核心算法,s为公式对应的子句集。若其满足，返回TRUE（1）；否则返回FALSE（0）。
如果求解过程出现状况，没能最终求解，则返回-1*/
{
	int v;
	Line* t;
	int i;
	/*单子句化简规则*/
	printf("%-8d\b\b\b\b\b\b\b\b", ++xcount);
	while (v = JudgeSingle(s, positivetimes, negativetimes))//若S中存在单子句,则将出现次数最多的单子句赋值给v。
	{
		SingleWords(s, v, positivetimes, negativetimes, occurtimes);//执行化简
		for (i = 1; i < variablenumbers + 1; i++)
		{//说明这些变元已经被删除掉了
			if (occurtimes[i] == 0)
				backtrack[i] = 1;
		}
		if (JudgeEmptyGather(s))//S为空集，则返回TRUE
		{
			return TRUE;
		}
		else if (JudgeEmptyWords(s))//S中有空子句，说明不可满足，返回FALSE
		{
			return FALSE;
		}
	}
	/*纯文字消除规则*/
	while (v = Seekchunwenzi(s))
	{
		value[abs(v)] = v > 0 ? 1 : 0;
		DelWords(s, v, positivetimes, negativetimes, occurtimes);
		for (i = 1; i < variablenumbers + 1; i++)
		{
			if (occurtimes[i] == 0)
				backtrack[i] = 1;//代表该变元已经被完全删除
		}
		if (JudgeEmptyGather(s))//S为空集，则返回TRUE
		{
			return TRUE;
		}
	}
	//printf("%d\n", ++dpll_count);
	//DesplayFile(s);

	t = CopyGather(s);
	int* newbacktrack, * newpositive, * newnegative, * newoccur;
	newbacktrack = CopyShuzu(backtrack);
	newpositive = CopyShuzu(positivetimes);
	newnegative = CopyShuzu(negativetimes);
	newoccur = CopyShuzu(occurtimes);
	/*下面是分裂策略*/
	v = SelectVariable(backtrack, positivetimes, negativetimes);//选取出现次数最多的变元
	if (v == 0)//正常情况下V肯定不会等于0
		return -1;
	if (InsertVariable(s, v, positivetimes, negativetimes, occurtimes) == ERROR)
	{
		printf("插入v时出现异常\n");
		return -1;
	}
	//DesplayFile(s);
	if (DPLL(s, backtrack, positivetimes, negativetimes, occurtimes) == TRUE)
	{
		free(newbacktrack);
		free(newpositive);
		free(newnegative);
		free(newoccur);
		return TRUE;
	}

	DestroyGather(s);//清空内存
	s = t;
	if (InsertVariable(s, -v, newpositive, newnegative, newoccur) == ERROR)
	{
		printf("插入v时出现异常\n");
		return -1;
	}
	if (DPLL(s, newbacktrack, newpositive, newnegative, newoccur) == TRUE)
	{
		free(newbacktrack);
		free(newpositive);
		free(newnegative);
		free(newoccur);
		return TRUE;
	}
	return -1;
}

int TestCorrect(Line* s)
/*根据已生成的value表测试语句集是否已经满足*/
{
	Line* linep = s;
	Node* nodep;
	int count1, count2;
	count1 = count2 = 0;
	if (s == NULL)
	{
		printf("子句集为空\n");
		return ERROR;
	}
	while (linep)
	{
		nodep = linep->firstnode;
		while (nodep)
		{
			if (nodep->name > 0)
			{
				if (value[nodep->name] == 1)
				{
					count1++; break;//如果发现该行有一个文字为正则说明该行成立
				}					//count1用来计数成立的行数
			}
			else
			{
				if (value[abs(nodep->name)] == 0)
				{
					count1++; break;
				}
			}
			nodep = nodep->next;
		}
		count2++;//count2用来记录总行数
		linep = linep->nextline;
	}
	if (count2 == count1) {
		printf("\n经检验，value表可以使得子句集成立\n");
		return OK;
	}
	else {
		printf("value表错误\n");
		return ERROR;
	}

}

void ChangeName(char* filename)
/*改变文件名字的后缀*/
{
	int i;
	for (i = 0; filename[i] != '.'; i++)
		;

	filename[++i] = 'r';
	filename[++i] = 'e';
	filename[++i] = 's';
}

int StoreToFile(char* filename, int status, double time)
{
	FILE* fp;
	int i;
	fp = fopen(filename, "w");
	if (fp == NULL)
	{
		printf("文件创建失败\n");
		return ERROR;
	}
	if (status == FALSE)
	{
		fprintf(fp, "s 0\n");
		fprintf(fp, "t %lf", time * 1000);
	}
	else if (status == TRUE)
	{
		fprintf(fp, "s 1\n");
		fprintf(fp, "v ");
		for (i = 1; i < variablenumbers + 1; i++)
		{
			if (value[i] > 0)
			{
				fprintf(fp, "%d ", i);
			}
			else
			{
				fprintf(fp, "%d ", -i);
			}
		}
		fprintf(fp, "\nt %lf", time * 1000);
	}
	else
	{
		fprintf(fp, "s -1\nt %lf", time * 1000);
	}
	fclose(fp);
	return OK;

}



/*以下为数独部分*/

int transtoVariable(int i, int j)
/*将棋盘的不同位置转换为变量(仅适用于6*6棋盘，后续有待进一步改进)*/
{
	return  (i - 1) * 8 + j;
}




void HangAppendWords3(Line*& tail, int i, int j, int& appendv)//调用时appendv初始值为64
/*限制条件3，第i行和第j行不能完全一样，用来给子句集添加附加语句*/
{
	int x;
	Node* nhead, * ntail, * np;
	for (x = 1; x <= 8; x++)
	{
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		appendv++;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - transtoVariable(i, x);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = -appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - transtoVariable(j, x);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = -appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = transtoVariable(i, x);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = transtoVariable(j, x);
		nhead->next->next = (Node*)malloc(sizeof(Node));
		nhead->next->next->name = appendv;
		nhead->next->next->next = NULL;
		tail->firstnode = nhead;//添加完结尾为0的子句
								//例：15710= ?51∧?71

		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		appendv++;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = transtoVariable(i, x);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = -appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = transtoVariable(j, x);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = -appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - transtoVariable(i, x);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = 0 - transtoVariable(j, x);
		nhead->next->next = (Node*)malloc(sizeof(Node));
		nhead->next->next->name = appendv;
		nhead->next->next->next = NULL;//添加完结尾为1的子句
										//例：15711= 51∧71
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		appendv++;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - (appendv - 2);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - (appendv - 1);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = (appendv - 2);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = (appendv - 1);
		nhead->next->next = (Node*)malloc(sizeof(Node));
		nhead->next->next->name = 0 - appendv;
		nhead->next->next->next = NULL;
		tail->firstnode = nhead;
		//添加完更高一级的子句
		//例：1571= 15711∨15710
	}

	//以下添加最高级别的子句
	//例：157= ?[1571∧1572∧…∧1578]
	tail->nextline = (Line*)malloc(sizeof(Line));
	tail = tail->nextline;
	appendv++;
	int v[9];
	for (i = 1; i <= 8; i++)
		v[i] = appendv - 1 - (i - 1) * 3;//v[i]中储存的都是低一级别的附加变元

	nhead = (Node*)malloc(sizeof(Node));
	ntail = nhead;
	nhead->name = -appendv;
	for (i = 1; i <= 8; i++)
	{
		np = (Node*)malloc(sizeof(Node));
		np->name = -v[i];
		np->next = NULL;
		ntail->next = np;
		ntail = ntail->next;
	}
	tail->firstnode = nhead;
	for (i = 1; i <= 8; i++)
	{
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = appendv;
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = v[i];
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = NULL;
	}//添加完成
}

void LieAppendWords3(Line*& tail, int i, int j, int& appendv)\
/*限制条件3，第i列和第j列不能完全一样，用来给子句集添加附加语句*/
{
	int x;
	Node* nhead, * ntail, * np;
	for (x = 1; x <= 8; x++)
	{
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		appendv++;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - transtoVariable(x, i);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = -appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - transtoVariable(x, j);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = -appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = transtoVariable(x, i);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = transtoVariable(x, j);
		nhead->next->next = (Node*)malloc(sizeof(Node));
		nhead->next->next->name = appendv;
		nhead->next->next->next = NULL;
		tail->firstnode = nhead;//添加完结尾为0的子句
								//例：15710= ?51∧?71

		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		appendv++;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = transtoVariable(x, i);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = -appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = transtoVariable(x, j);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = -appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - transtoVariable(x, i);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = 0 - transtoVariable(x, j);
		nhead->next->next = (Node*)malloc(sizeof(Node));
		nhead->next->next->name = appendv;
		nhead->next->next->next = NULL;//添加完结尾为1的子句
		tail->firstnode = nhead;		//例：15711= 51∧71

		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		appendv++;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - (appendv - 2);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = 0 - (appendv - 1);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = appendv;
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = (appendv - 2);
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = (appendv - 1);
		nhead->next->next = (Node*)malloc(sizeof(Node));
		nhead->next->next->name = 0 - appendv;
		nhead->next->next->next = NULL;
		tail->firstnode = nhead;
		//添加完更高一级的子句
		//例：1571= 15711∨15710
	}


	//以下添加最高级别的子句
	//例：157= ?[1571∧1572∧…∧1578]
	tail->nextline = (Line*)malloc(sizeof(Line));
	tail = tail->nextline;
	appendv++;
	int v[9];
	for (i = 1; i <= 8; i++)
		v[i] = appendv - 1 - (i - 1) * 3;//v[i]中储存的都是低一级别的附加变元

	nhead = (Node*)malloc(sizeof(Node));
	ntail = nhead;
	nhead->name = -appendv;
	for (i = 1; i <= 8; i++)
	{
		np = (Node*)malloc(sizeof(Node));
		np->name = -v[i];
		np->next = NULL;
		ntail->next = np;
		ntail = ntail->next;
	}
	tail->firstnode = nhead;
	for (i = 1; i <= 8; i++)
	{
		tail->nextline = (Line*)malloc(sizeof(Line));
		tail = tail->nextline;
		nhead = (Node*)malloc(sizeof(Node));
		nhead->name = appendv;
		nhead->next = (Node*)malloc(sizeof(Node));
		nhead->next->name = v[i];
		nhead->next->next = NULL;
		tail->firstnode = nhead;
		tail->nextline = NULL;
	}//添加完成
}

void AppendWords1(Line*& tail)
/*根据约束1来增加子句（同时增加行约束和列约束）*/
{
	int i, j;
	Node* nhead;
	for (i = 1; i <= 8; i++)//先处理行约束
	{//i代表行
		for (j = 1; j <= 6; j++)
		{//j代表列
			tail->nextline = (Line*)malloc(sizeof(Line));
			tail = tail->nextline;
			nhead = (Node*)malloc(sizeof(Node));
			nhead->name = transtoVariable(i, j);
			nhead->next = (Node*)malloc(sizeof(Node));
			nhead->next->name = transtoVariable(i, j + 1);
			nhead->next->next = (Node*)malloc(sizeof(Node));
			nhead->next->next->name = transtoVariable(i, j + 2);
			nhead->next->next->next = NULL;
			tail->firstnode = nhead;

			tail->nextline = (Line*)malloc(sizeof(Line));
			tail = tail->nextline;
			nhead = (Node*)malloc(sizeof(Node));
			nhead->name = 0 - transtoVariable(i, j);
			nhead->next = (Node*)malloc(sizeof(Node));
			nhead->next->name = 0 - transtoVariable(i, j + 1);
			nhead->next->next = (Node*)malloc(sizeof(Node));
			nhead->next->next->name = 0 - transtoVariable(i, j + 2);
			nhead->next->next->next = NULL;
			tail->firstnode = nhead;
		}

	}
	for (j = 1; j <= 8; j++)//再处理列约束
	{//j代表列数
		for (i = 1; i <= 6; i++)
		{//i代表行数
			tail->nextline = (Line*)malloc(sizeof(Line));
			tail = tail->nextline;
			nhead = (Node*)malloc(sizeof(Node));
			nhead->name = transtoVariable(i, j);
			nhead->next = (Node*)malloc(sizeof(Node));
			nhead->next->name = transtoVariable(i + 1, j);
			nhead->next->next = (Node*)malloc(sizeof(Node));
			nhead->next->next->name = transtoVariable(i + 2, j);
			nhead->next->next->next = NULL;
			tail->firstnode = nhead;

			tail->nextline = (Line*)malloc(sizeof(Line));
			tail = tail->nextline;
			nhead = (Node*)malloc(sizeof(Node));
			nhead->name = 0 - transtoVariable(i, j);
			nhead->next = (Node*)malloc(sizeof(Node));
			nhead->next->name = 0 - transtoVariable(i + 1, j);
			nhead->next->next = (Node*)malloc(sizeof(Node));
			nhead->next->next->name = 0 - transtoVariable(i + 2, j);
			nhead->next->next->next = NULL;
			tail->firstnode = nhead;
		}
	}
	tail->nextline = NULL;
}

void helpAppendWords2(Line*& tail, int* v)
/*辅助完成约束2的生成
tail仍然是尾指针，
v是指向储存该行可以取的5个变元的数组的指针*/
{
	int i;
	Node* nhead, * ntail, * p;
	tail->nextline = (Line*)malloc(sizeof(Node));
	tail = tail->nextline;
	nhead = (Node*)malloc(sizeof(Node));
	nhead->name = v[1];
	ntail = nhead;
	for (i = 2; i <= 5; i++)
	{
		p = (Node*)malloc(sizeof(Node));
		p->name = v[i];
		p->next = NULL;
		ntail->next = p;
		ntail = ntail->next;
	}
	tail->firstnode = nhead;

	tail->nextline = (Line*)malloc(sizeof(Node));
	tail = tail->nextline;
	nhead = (Node*)malloc(sizeof(Node));
	nhead->name = 0 - v[1];
	ntail = nhead;
	for (i = 2; i <= 5; i++)
	{
		p = (Node*)malloc(sizeof(Node));
		p->name = 0 - v[i];
		p->next = NULL;
		ntail->next = p;
		ntail = ntail->next;
	}
	tail->firstnode = nhead;
}

void AppendWords2(Line*& tail)
/*约束2，需要保证每行（每列）任取出5个元素，
至少有一个1和一个0*/
{
	int i, j, a, b, c, count, k;
	int v[6];
	for (i = 1; i <= 8; i++)//先考虑行约束
	{//i代表行数
		for (a = 1; a <= 6; a++)
		{//a,b代表在第i行中不取的那两个列坐标
			for (b = a + 1; b <= 7; b++)
			{
				for (c = b + 1; c <= 8; c++)
				{
					count = 1;
					for (j = 1; j <= 8; j++)
					{//j代表列数
						if (j != a && j != b && j != c)
							v[count++] = transtoVariable(i, j);
					}//进行完此次for循环后，数组v中储存有该行可以取的5个变元
					helpAppendWords2(tail, v);
				}

			}
		}
	}

	for (j = 1; j <= 8; j++)//再考虑列约束
	{//j代表列数
		for (a = 1; a <= 6; a++)
		{
			for (b = a + 1; b <= 7; b++)
			{
				for (c = b + 1; c <= 8; c++)
				{
					count = 1;
					for (i = 1; i <= 8; i++)
					{//i代表行数
						if (i != a && i != b && i != c)
							v[count++] = transtoVariable(i, j);
					}//进行完此次for循环后，数组v中储存有该行可以取的5个变元
					helpAppendWords2(tail, v);
				}

			}
		}

	}
	tail->nextline = NULL;
}


void AppendWords(Line*& tail)
{
	int i, j, appendv;
	AppendWords1(tail);
	AppendWords2(tail);
	appendv = 64;
	for (i = 1; i <= 7; i++)
		for (j = i + 1; j <= 8; j++)
		{
			HangAppendWords3(tail, i, j, appendv);
		}
	for (i = 1; i <= 7; i++)
		for (j = i + 1; j <= 8; j++)
		{
			LieAppendWords3(tail, i, j, appendv);
		}
	tail->nextline = NULL;
}

int ReadShudu(Line*& s, int v[][9])
/*读取数独矩阵，建立邻接表,返回值为邻接表的行数*/
{
	Line* head, * tail;
	Node* nhead;
	int i, j, linenumber = 0;
	head = (Line*)malloc(sizeof(Line));
	tail = head;//为了生成方便，暂时保留头结点
	for (i = 1; i <= 8; i++)
		for (j = 1; j <= 8; j++)
		{
			if (v[i][j] == 1)
			{
				tail->nextline = (Line*)malloc(sizeof(Line));
				tail = tail->nextline;
				tail->nextline = NULL;
				tail->firstnode = (Node*)malloc(sizeof(Node));
				tail->firstnode->name = transtoVariable(i, j);
				tail->firstnode->next = NULL;
			}
			else if (v[i][j] == 0)
			{
				tail->nextline = (Line*)malloc(sizeof(Line));
				tail = tail->nextline;
				tail->nextline = NULL;
				tail->firstnode = (Node*)malloc(sizeof(Node));
				tail->firstnode->name = 0 - transtoVariable(i, j);
				tail->firstnode->next = NULL;
			}
			else//此时v[i][j]==-1
				;//不进行任何操作
		}
	AppendWords(tail);
	tail->nextline = NULL;
	tail = head->nextline;
	while (tail)
	{
		linenumber++;
		tail = tail->nextline;
	}
	s = head->nextline;
	free(head);
	return linenumber;
}

int TransferToFile(Line* s, int linenumbers)
{
	FILE* fp;
	Line* linep;
	Node* nodep;
	char filepath[20];
	printf("请输入要存入的文件名\n");
	scanf("%s", filepath);
	fp = fopen(filepath, "w");
	if (fp == NULL)
	{
		printf("文件打开失败\n");
		return ERROR;
	}
	fprintf(fp, "c\n");
	fprintf(fp, "p cnf %d %d\n", 1464, linenumbers);
	linep = s;
	while (linep)
	{
		nodep = linep->firstnode;
		while (nodep)
		{
			fprintf(fp, "%d ", nodep->name);
			nodep = nodep->next;
		}
		fprintf(fp, "0\n");
		linep = linep->nextline;
	}
	fclose(fp);
	return OK;
}



void WriteShudu(int v[][9])
/**根据value表填写8*8的数独**/
{
	int variable, i, j;
	for (variable = 1; variable <= 64; variable++)
	{
		j = variable % 8;
		if (j == 0)  j = 8;
		i = (variable - j) / 8 + 1;
		if (value[variable] == 1)
			v[i][j] = 1;
		else if (value[variable] == 0)
			v[i][j] = 0;
	}
}

int CheckKeyWord(int v[][9], int x, int y)
/*检查在数独中新填入数据的正确性,x,y分别为新填入数据的行坐标和列坐标*/
{
	int count1 = 0, count0 = 0;
	int i, j;

	for (i = x, j = 1; j <= 8; j++)
	{//检查该行1，0的数量是否超标
		if (v[i][j] == 1)
			count1++;
		else if (v[i][j] == 0)
			count0++;
	}
	if (count1 > 4 || count0 > 4)
		return FALSE;

	count1 = count0 = 0;
	for (i = 1, j = y; i <= 8; i++)
	{//检查该列1，0的数量是否超标
		if (v[i][j] == 1)
			count1++;
		else if (v[i][j] == 0)
			count0++;
	}
	if (count1 > 4 || count0 > 4)
		return FALSE;

	//检查该行填入的数字是否造成了连续三个数字相同
	switch (y)
	{
	case 1:
		if (v[x][y] == v[x][y + 1] && v[x][y] == v[x][y + 2])
			return FALSE;
		break;
	case 8:
		if (v[x][y] == v[x][y - 1] && v[x][y] == v[x][y - 2])
			return FALSE;
		break;
	case 3:
	case 4:
	case 5:
	case 6:
		if (v[x][y] == v[x][y + 1] && v[x][y] == v[x][y - 1])
			return FALSE;
		if (v[x][y] == v[x][y + 1] && v[x][y] == v[x][y + 2])
			return FALSE;
		if (v[x][y] == v[x][y - 1] && v[x][y] == v[x][y - 2])
			return FALSE;
		break;
	case 2:
		if (v[x][y] == v[x][y + 1] && v[x][y] == v[x][y - 1])
			return FALSE;
		if (v[x][y] == v[x][y + 1] && v[x][y] == v[x][y + 2])
			return FALSE;
		break;
	case 7:
		if (v[x][y] == v[x][y + 1] && v[x][y] == v[x][y - 1])
			return FALSE;
		if (v[x][y] == v[x][y - 1] && v[x][y] == v[x][y - 2])
			return FALSE;
		break;
	}
	//检查该列填入的数字是否造成了连续三个数字相同
	switch (x)
	{
	case 1:
		if (v[x][y] == v[x + 1][y] && v[x][y] == v[x + 2][y])
			return FALSE;
		break;
	case 8:
		if (v[x][y] == v[x - 1][y] && v[x][y] == v[x - 2][y])
			return FALSE;
		break;
	case 3:
	case 4:
	case 5:
	case 6:
		if (v[x][y] == v[x + 1][y] && v[x][y] == v[x - 1][y])
			return FALSE;
		if (v[x][y] == v[x + 1][y] && v[x][y] == v[x + 2][y])
			return FALSE;
		if (v[x][y] == v[x - 1][y] && v[x][y] == v[x - 2][y])
			return FALSE;
		break;
	case 2:
		if (v[x][y] == v[x + 1][y] && v[x][y] == v[x - 1][y])
			return FALSE;
		if (v[x][y] == v[x + 1][y] && v[x][y] == v[x + 2][y])
			return FALSE;
		break;
	case 7:
		if (v[x][y] == v[x + 1][y] && v[x][y] == v[x - 1][y])
			return FALSE;
		if (v[x][y] == v[x - 1][y] && v[x][y] == v[x - 2][y])
			return FALSE;
		break;
	}
	int countx;
	if (x >= 2 && y == 8)//判断该填入的数字有没有造成两个行的内容完全一样
	{
		for (i = 1; i < x; i++)
		{
			countx = 0;
			for (j = 1; j <= 8; j++)
			{
				if (v[i][j] == v[x][j])
					countx++;
			}
			if (countx == 8)
				return FALSE;

		}
	}
	if (x == 8 && y >= 2)//判断填入的数字有没有造成两个列内容完全一样
	{
		for (j = 1; j < y; j++)
		{
			countx = 0;
			for (i = 1; i <= 8; i++)
			{
				if (v[i][j] == v[i][y])
					countx++;
			}
			if (countx == 8)
				return FALSE;
		}
	}
	return TRUE;
}



int  SolveShudu(ShuduLine* s, int x, int y, int& count)
{
	int i, j, check, a, b;
	ShuduLine* shudup;
	while (x <= 8 && s->v[x][y] != -1)//从上往下找找到第一个为-1的空
	{
		y++;
		if (y == 9) //搜索完一行
		{
			x++;
			y = 1;
		}
	}
	if (x > 8)
	{//说明没有空缺的位置
		shudup = (ShuduLine*)malloc(sizeof(ShuduLine));
		if (shudup == NULL)
		{
			printf("数独空间分配失败\n");
			return ERROR;
		}
		for (a = 1; a <= 8; a++)
			for (b = 1; b <= 8; b++)
				shudup->v[a][b] = s->v[a][b];

		shudup->next = s->next;
		s->next = shudup;
		count++;
		return TRUE;
	}
	for (i = 0; i <= 1; i++)
	{
		s->v[x][y] = i;
		if ((check = CheckKeyWord(s->v, x, y)) == TRUE)
		{
			if (x == 8 && y == 8)
			{
				shudup = (ShuduLine*)malloc(sizeof(ShuduLine));
				if (shudup == NULL)
				{
					printf("数独空间分配失败\n");
					return ERROR;
				}
				for (a = 1; a <= 8; a++)
					for (b = 1; b <= 8; b++)
						shudup->v[a][b] = s->v[a][b];
				shudup->next = s->next;
				s->next = shudup;

				s->v[x][y] = -1;
				count++;
				return TRUE;
			}
			else
			{
				if (y == 8)
					SolveShudu(s, x + 1, 1, count);
				else
					SolveShudu(s, x, y + 1, count);
			}

		}
	}
	s->v[x][y] = -1;
	return FALSE;
}

void CountResult(ShuduLine* s, int& count)
{
	count = 0;
	SolveShudu(s, 1, 1, count);
	ShuduLine* p, * q;
	p = s->next; q = NULL;
	if (p)
	{
		q = p->next;
	}
	while (p)
	{//清除掉多余的数独链
		free(p);
		p = q;
		if (p)
		{
			q = p->next;
		}
	}
	s->next = NULL;
}

void RandomCreat(int(*a)[9])
/*随机生成一个6*6的数独*/
{
	ShuduLine* s, * p, * q;
	int i, j, variable, count1, count0, count_result;
	s = (ShuduLine*)malloc(sizeof(ShuduLine));
	if (s == NULL)
	{
		printf("空间分配失败\n");
		return;
	}
	s->next = NULL;

	srand(unsigned(time(NULL)));  /* 产生random_shuffle的随机数种子 */

	for (int i = 1; i <= 8; ++i)
		for (int j = 1; j <= 8; ++j)
			s->v[i][j] = -1;
	count1 = count0 = count_result = 0;
	for (i = 1; i <= 2; i++)
	{
		s->v[1][i] = rand() % 2;
		if (s->v[1][i] == 1)
			count1++;
		else
			count0++;
	}
	for (i = 3; i <= 8; i++)
	{
		variable = rand() % 2;
		if (variable == s->v[1][i - 1] && variable == s->v[1][i - 2])
		{
			if (variable == 1)
			{
				s->v[1][i] = 0;
				count0++;
			}

			else
			{
				s->v[1][i] = 1;
				count1++;
			}
		}
		else if (count1 == 4)

		{
			s->v[1][i] = 0;
			count0++;
		}
		else if (count0 == 4)
		{
			s->v[1][i] = 1;
			count1++;
		}

		else
		{
			s->v[1][i] = variable;
			if (variable) count1++;
			else          count0++;
		}
	}
	SolveShudu(s, 2, 1, count_result);
	int rank;
	if (count_result == 0)
		rank = 1;
	else
		rank = rand() % count_result + 1;

	p = s;
	for (i = 1; i <= rank; i++)
		p = p->next;//p指向的是随机生成的完整的棋盘

	for (i = 1; i <= 8; i++)//给数独棋盘赋值
		for (j = 1; j <= 8; j++)
			a[i][j] = p->v[i][j];

	p = s; q = p->next;
	while (p)
	{//清理生成的数独链
		free(p);
		p = q;
		if (p)
			q = p->next;
	}
}

void WaDong(int(*a)[9])
{
	ShuduLine* s;
	int i, j, x, y, flag = 0, k, result;
	s = (ShuduLine*)malloc(sizeof(ShuduLine));
	if (s == NULL) {
		printf("空间生成失败\n");
		return;
	}
	for (i = 1; i <= 8; i++)
		for (j = 1; j <= 8; j++)
			s->v[i][j] = a[i][j];
	s->next = NULL;
	srand(unsigned(time(NULL)));  // 产生random_shuffle的随机数种子 
	x = rand() % 8 + 1;
	y = rand() % 8 + 1;
	s->v[x][y] = -1;//先试探性的挖一个孔
	while (1)
	{
		CountResult(s, result);
		if (result > 1)
		{
			s->v[x][y] = k;
			flag++;
			if (flag > 5)
			{
				break;
			}
		}
		else
		{
			do {
				x = rand() % 8 + 1;
				y = rand() % 8 + 1;
			} while (s->v[x][y] == -1);

			k = s->v[x][y]; //此时(x,y)不为0，记录下这个值,为了预防挖掉该空后导致结果不唯一，还需要把该空填上
			s->v[x][y] = -1;
		}
	}
	for (i = 1; i <= 8; i++)
		for (j = 1; j <= 8; j++)
			a[i][j] = s->v[i][j];
}



int main(void)
{
	int op = 1;
	int a = 0;
	while (op)
	{
		system("cls");
		printf("\n\n");
		printf("------------------请输入你要进行的操作------------\n");
		printf("                      1.使用DPLL求解SAT问题\n");
		printf("                      2.基于SAT求解的求解01数独问题\n");
		printf("    	              0. Exit\n");
		printf("-------------------------------------------------\n");
		printf("请选择你的操作:");
		scanf("%d", &op);
		switch (op)
		{
		case 1:
			int status;
			Line* cnf1, * cnf2;
			char filename[20];
			double t;
			printf("请输入要读取的文件\n");
			scanf("%s", filename);
			getchar();
			cnf1 = CreatCNF(filename);
			printf("\n是否要展示所读取文件的内容？\n");
			printf("1：是\n0：否\n");
			scanf("%d", &a);
			if (a == 1)
			{
				DesplayFile(cnf1);
			}
			printf("\n是否要解析读取的文件？\n");
			printf("1：是\n0:否\n");
			scanf("%d", &a);
			if (a == 1)
			{
				AnalyzeFile(cnf1);
			}
			cnf2 = CopyGather(cnf1);
			clock_t start, finish;
			start = clock();
			status = DPLL(cnf1, backtrack, positivetimes, negativetimes, occurtimes);
			finish = clock();
			t = (double)(finish - start) / CLOCKS_PER_SEC;
			if (status == TRUE)
			{
				printf("求解成功\n");
			}
			else if (status == FALSE)
			{
				printf("该语句集无解\n");
			}
			else if (status == -1)
			{
				printf("结果不确定\n");
			}
			printf("求解用时%f s\n", t);
			if (status == TRUE)
			{
				printf("\n是否需要打印各个变元的取值？\n");
				printf("1：是\n0:否\n");
				scanf("%d", &a);
				if (a == 1)
					PrintValue();
				putchar('\n');
				printf("\n是否需要检验结果的正确性？\n");
				printf("1：是\n0:否\n");
				scanf("%d", &a);
				getchar();
				if (a == 1)
					TestCorrect(cnf2);
			}
			printf("\n是否要对结果进行保存？\n");
			printf("1：是\n0:否\n");
			scanf("%d", &a);
			getchar();
			if (a == 1)
			{
				ChangeName(filename);
				if (StoreToFile(filename, status, t) == OK)
					printf("存入成功\n");
				else
					printf("存入失败\n");
			}
			free(positivetimes);
			free(negativetimes);
			free(occurtimes);
			free(backtrack);
			DestroyGather(cnf1);
			DestroyGather(cnf2);
			system("pause");
			break;
		case 2:
			Line * s1, * s2;
			int v[9][9];
			int b,linenumber;
			RandomCreat(v);
			WaDong(v);
			int i, j;
			for(i=1;i<=8;i++)
				for (j = 1; j <= 8; j++)
				{
					if (v[i][j] != -1)
						printf("%2d", v[i][j]);
					else printf(" *");
					if (j % 8 == 0)
						putchar('\n');
				}
			linenumber=ReadShudu(s1, v);
			printf("\n生成的棋盘已经被转化为SAT问题。是否需要展示转化的邻接表的内容？\n");
			printf("1：是\n0：否\n");
			scanf("%d", &b);
			if (b == 1)
			{
				DesplayFile(s1);
			}
			printf("\n是否需要解析邻接表？\n");
			printf("1：是\n0：否\n");
			scanf("%d", &b);
			if (b == 1)
			{
				AnalyzeFile(s1);
			}
			printf("\n要保存生成的邻接表还是数独求解？\n");
			printf("1：保存邻接表\n0:数独求解\n");
			scanf("%d", &b);
			if (b == 1)
			{
				if (TransferToFile(s1, linenumber) == OK)
				{
					printf("存入成功\n");
				}
				else
				{
					printf("存入失败\n");
				}
			}
			else if (b == 0)
			{
				Line* linep; Node* nodep;
				variablenumbers = 1464;
				value = (int*)calloc(variablenumbers + 1, sizeof(int));
				occurtimes = (int*)calloc(variablenumbers + 1, sizeof(int));
				backtrack = (int*)calloc(variablenumbers + 1, sizeof(int));
				for (i = 0; i < variablenumbers + 1; i++) {
					backtrack[i] = 0;//0代表还未访问,1代表已经访问
				}
				positivetimes = (int*)calloc(variablenumbers + 1, sizeof(int));
				negativetimes = (int*)calloc(variablenumbers + 1, sizeof(int));
				linep = s1;
				while (linep)
				{
					nodep = linep->firstnode;
					while (nodep)
					{
						occurtimes[abs(nodep->name)]++;
						if (nodep->name > 0)
							positivetimes[nodep->name]++;
						else
							negativetimes[abs(nodep->name)]++;
						nodep = nodep->next;
					}
					linep = linep->nextline;
				}
				if (DPLL(s1, backtrack, positivetimes, negativetimes, occurtimes) == TRUE)
				{
					printf("求解完毕,结果如下\n");
					WriteShudu(v);
					for (i = 1; i <= 8; i++)
						for (j = 1; j <= 8; j++)
						{
							printf("%2d", v[i][j]);
							if (j % 8 == 0)
								putchar('\n');
						}
				}
				else
				{
					printf("求解失败\n");
				}
				free(backtrack);
				free(positivetimes);
				free(negativetimes);
				free(occurtimes);
				DestroyGather(s1);
			}
			else
			{
				printf("请输入合法的数字\n");
			}
			getchar(); getchar();
			break;
		case 0:
			break;
		default:
			printf("请输入合法的数字\n");
			getchar(); getchar();
			break;
		}//end of switch
	}
}


