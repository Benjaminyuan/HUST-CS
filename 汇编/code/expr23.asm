.386
STACK SEGMENT USE16 STACK
    DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16
BUF  DB 'Found product information$';提示:找到商品信息
BUF1 DB 'PLEASE INPUT YOUR NAME $';提示：输入用户名
BUF2 DB 'PLEASE INPUT YOUR PASSWORD $';提示：输入密码
BUF3 DB 'Login failed $';提示：登录失败
BUF4 DB 'Please input the good you want $';提示：输入商品名称
BUF5 DB 'Product information not found $';提示：没有找到商品的信息
BUF6 DB 'The goods are sold out$';提示：商品已经售完
BUF7 DB 'Login successfully$';提示：输入用户名和密码正确，登陆成功
BUF8 DB 'Please enter the number 1 to 9 to select the function',0DH,0AH
	 DB '1. Log in / re log in',0DH,0AH
	 DB '2. Find the specified product and display its information',0DH,0AH
	 DB '3. Placing an order',0DH,0AH
	 DB '4. Calculate commodity recommendation',0DH,0AH
	 DB '5. Ranking', 0DH,0AH
	 DB '6. Change product information', 0DH,0AH
	 DB '7. Change the store operation environment', 0DH,0AH
	 DB '8. Display the current code segment first address',0DH,0AH
	 DB '9. Exit',0DH,0AH,'$'
BUF9 DB 'Invalid good input$';提示：GOOD为空
BUF10 DB 'Complete the calculation of recommendation$';提示：完成推荐度的计算
BUF11 DB 'The input character does not meet the requirements.Please input again!!$';提示:输入的选择功能的字符不符合要求
BUF12 DB '0123456789ABCDEF'
BUF13 DB 'The information of this product is as below$';提示：提示用户以下是查找到的商品的信息
BUF14 DB 'Return from function 4!$';提示：从功能4返回成功 
AUTH DB 0;当前登录状态，0表示顾客状态
CRLF DB 0DH,0AH,'$';回车键
BNAME DB 'TIANZHAO',0;老板姓名
BPASS DB 'TEST',0,0;密码
FUNCTION DW L_IN_NAME
		 DW L_IN_GOOD
		 DW L_PLACE_ORDER
		 DW L_CALCULATE_RECOMMEND
		 DW L_RANK
		 DW L_CHANGE_GOOD_INFO
		 DW L_CHANGE_ENVIRONMENT
		 DW L_SHOW_CURRENT_CS
		 DW L_END_SYSTEM
N EQU 3000;商品个数
M EQU 20000;循环次数
CONTROL_RETURN DB 0;控制计算推荐度函数返回的位置，0代表直接返回主界面，1代表返回模块3
SNAME  DB 'SHOP',0;网店名称，用0结束
GOOD DW 0;用于储存商品信息段的首地址

GA1 DB 'PEN',7 DUP(0),10;商品名称及折扣
    DW 35,56,M,0,?;推荐度还未计算
GA2 DB 'BOOK',6 DUP(0),9;商品名称及折扣
    DW 12,30,M,0,?;进货价，销售价，进货数量，已售数量，推荐度还未计算
GAN DB N-3 DUP('TEMP-VALUE',8,15,0,20,0,30,0,2,0,?,?);除了两个已经具体定义了的商品信息外，其他商品信息暂时假定为一样的
GANN DB 'BAG',7 DUP(0),10;商品名称及折扣
    DW 35,56,M,0,?;进货数量为M，初始销售数量为0


IN_NAME DB 10;用来存储输入的用户名
	DB 0
	DB 10 DUP(0)
IN_PWD   DB 7;用来存储输入的密码
	DB 0
	DB 7 DUP(0)
IN_GOOD DB 10;用来存储输入的商品的名称
	DB 0
	DB 10 DUP(0)
DATA ENDS
CODE SEGMENT USE16
    ASSUME CS:CODE,DS:DATA,SS:STACK

START:
	MOV AX,DATA
	MOV DS,AX

	CMP IN_NAME+1,0
	JLE PRINT_GOOD
	MOV BL,IN_NAME+1
	MOV BH,0
	MOV IN_NAME+2[BX],'$'

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,IN_NAME+2
	MOV AH,9
	INT 21H;如果存在的话，输出用户名

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车

PRINT_GOOD:
	CMP IN_GOOD+1,0
	JLE PRINT_INFO
	MOV BL,IN_GOOD+1
	MOV BH,0
	MOV IN_GOOD+2[BX],'$'

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,IN_GOOD+2
	MOV AH,9
	INT 21H;如果存在的话，输出当前浏览的商品名

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车

PRINT_INFO:

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF8
	MOV AH,9
	INT 21H;输出菜单提示信息

	LEA DX,CRLF
	MOV AH,9
	INT 21H

INPUT_COMMAND:
	MOV AH,1
	INT 21H;输入一个字符

	CMP AL,'1'
	JL INPUT_COMMAND_WRONG
	CMP AL,'9'
	JG INPUT_COMMAND_WRONG
	SUB AL,'0'
	MOVZX BX,AL
	DEC BX
	IMUL BX,2
	JMP FUNCTION[BX];跳转到相应的功能模块

INPUT_COMMAND_WRONG:
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF11
	MOV AH,9
	INT 21H;输出提示语句

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车键

	JMP INPUT_COMMAND;要求再次输入功能选择字符

L_IN_NAME:
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF1
	MOV AH,9
	INT 21H;提示输入用户名信息

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车键

	LEA DX,IN_NAME
	MOV AH,10
	INT 21H;输入姓名
	MOV BL,IN_NAME+1
	MOV BH,0
	MOV IN_NAME+2[BX],0;对名字的末尾加0进行修正

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF2
	MOV AH,9
	INT 21H;提示输入密码

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车键

	LEA DX,IN_PWD
	MOV AH,10
	INT 21H;输入密码
	MOVZX BX,IN_PWD+1
	MOV IN_PWD+2[BX],0;对密码末尾加0进行修正

	CMP IN_NAME+1,0;判断是否仅仅输入回车
	JE L_0_AUTH;若是，赋AUTH为0，回到主菜单

L_CHECK_NAME:
	CMP IN_NAME+1,8
	JNE L_OUT_WRONG;输入的位数都不一样，直接跳转到登陆失败提示
	LEA DI,BNAME
	LEA SI,IN_NAME+2;分别将保存姓名和输入姓名串的首地址赋值给DI,SI，便于比较
	MOV CX,1
 L_LOOP_N:
	CMP CX,8
	JG L_CHECK_PWD;如果用于计数的CX大于8，则说明姓名正确，要跳转检查密码
	MOV AL,[DI]
	MOV BL,[SI];采用寄存器间接寻址
	CMP AL,BL
	JNE L_OUT_WRONG;有不相等的字母，跳转到登陆失败提示
	INC DI
	INC SI
	INC CX
	JMP L_LOOP_N;循环判断

L_CHECK_PWD:
	CMP IN_PWD+1,4
	JNZ L_OUT_WRONG;密码输入位数不一样，直接跳转到登录失败提示
	LEA DI,BPASS
	LEA SI,IN_PWD+2
	MOV CX,1
 L_LOOP_P:
	CMP CX,4
	JG L_1_AUTH;姓名和密码都正确，将AUTH赋值为1，输出登录成功提示信息，跳转到主界面
	MOV AL,[DI]
	MOV BL,[SI]
	CMP AL,BL
	JNE L_OUT_WRONG;密码不正确，跳转到登陆失败提示
	INC DI
	INC SI
	INC CX
	JMP L_LOOP_P;循环判断

L_OUT_WRONG:
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF3
	MOV AH,9
	INT 21H;输出登录失败提示

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车

	JMP L_IN_NAME;我个人修改为跳转到再次输入姓名和密码

L_0_AUTH:
	MOV AUTH,0
	JMP START

L_1_AUTH:
	MOV AUTH,1

	LEA DX,BUF7
	MOV AH,9
	INT 21H;输出登录成功提示

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车键

	JMP START

;查找商品信息，功能2的实现！！！
L_IN_GOOD:
	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车键

	LEA DX,BUF4
	MOV AH,9
	INT 21H;提示输入商品名称

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车键
	
	LEA DX,IN_GOOD
	MOV AH,10
	INT 21H;输入商品名称
	MOVZX BX,IN_GOOD+1
	MOV IN_GOOD+2[BX],0;对名称末尾加0进行修正	
	CMP IN_GOOD+1,0
    JNE L_CHECK_GOOD;如果的确输入了商品名，则跳转到比较模块
	JMP NOT_FIND;如果直接输入了回车，则输出没有找到，跳转到主菜单界面

L_CHECK_GOOD:
	LEA DI,GA1
	LEA SI,IN_GOOD+2
	MOVZX CX,IN_GOOD+1;CX保存输入商品单词的个数
	MOV DX,0;DX代表商品信息的序号（从0-29）

LL:
	MOV BX,0;BX代表商品名字单词的序号（从0开始计数）

L_LOOP_G:
	CMP BX,CX
	JGE FURTHER_CHECK;进行更进一步的判断，以防输入的商品名为储存商品名的子集
	MOV AL,[DI+BX]
	MOV AH,[SI+BX]
	CMP AH,AL
	JNE NEXT_GOOD;如果不相等，判断下一条商品信息
	INC BX;如果相等，判断下一个字母是否相等
	JMP L_LOOP_G

NEXT_GOOD:
	ADD DI,21;将DI移动到下个商品信息段
	INC DX;商品信息序号相应加一
	CMP DX,N
	JE NOT_FIND
	JMP LL
FURTHER_CHECK:
	CMP BYTE PTR[DI+BX],0;判断储存字段该处是否为0
	JE STORE_SHOW_INFO;若是0，则表示输入名字不是储存名字的子集
	JMP NEXT_GOOD;若不是0，则说明输入名字为储存名字的子集，还需要检查下一条商品信息段

STORE_SHOW_INFO:
	MOV GOOD,DI;将该商品信息段的首地址储存到GOOD字段中
	MOVZX BX,IN_GOOD+1;将该商品名字单词的个数赋值给BX
	MOV BYTE PTR [DI+BX],'$';在名字的末尾添加$号

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF13
	MOV AH,9
	INT 21H;输出提示信息

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	MOV DX,DI
	MOV AH,9
	INT 21H;输出商品的名字

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	MOV BYTE PTR [DI+BX],0

	;;;;;;;;;;;;;;;;;;;;展示商品信息先不写
	JMP FIND;提示成功找到商品，跳转到主菜单

NOT_FIND:
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF5
	MOV AH,9
	INT 21H;输出没有找到商品信息的提示信息

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	MOV IN_GOOD+1,0;由于没有该信息，所以IN_GOOD中存入的值也就无效
	JMP START

FIND:
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF
	MOV AH,9
	INT 21H

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	JMP START

;功能3的实现：下订单
L_PLACE_ORDER:
	MOV  AX, 0	;表示开始计时
	CALL TIMER
	MOV CX,0

TEST_START:

	CMP GOOD,0;判断GOOD是否为空
	JNE JUDGE_NUMBER;若不为空，则进一步判断商品数量是否为0
	JMP SHOW_GOOD_EMPTY;若为空，则跳转到主菜单界面

JUDGE_NUMBER:
	MOV SI,GOOD;将储存的商品段的首地址赋值给SI
	ADD SI,15;将SI指向进货总数
	MOV AX,[SI];AX为进货总数，字类型
	ADD SI,2;指向已售数量
	MOV BX,[SI];BX为已售数量，字类型
	CMP AX,BX;比较进货数量和已售数量
	JLE SHOW_SOLD_OUT;如果进货数量等于已售数量，显示已经售完，并跳转到主界面
	ADD WORD PTR [SI],1;如果进货数量大于已售数量，则将存储的已售数量加一

	PUSH CX;保存目前CX的值
	PUSH FINISH_BACK;将计算完推荐度后要跳转回来的标号入栈
	MOV CONTROL_RETURN,1;改变状态
	JMP L_CALCULATE_RECOMMEND;进入计算推荐度的模块
FINISH_BACK:             ;计算完推荐度后要回到的位置
	POP CX;
	INC CX;
	CMP CX,M
	JL TEST_START;如果小于M，则继续执行测试循环
	MOV  AX, 1
	CALL TIMER	;终止计时并显示计时结果(ms)

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF14
	MOV AH,9
	INT 21H;输出提示信息

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	;MOV GOOD,0;下单完成后，需要还原GOOD字段 ;为了能够连续进行M次循环，所以先把这句注释掉
	JMP START


	SHOW_GOOD_EMPTY:
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF9
	MOV AH,9
	INT 21H;输出当前GOOD为空的提示信息

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车键

	JMP START;跳转到主菜单界面

SHOW_SOLD_OUT:
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF6
	MOV AH,9
	INT 21H;输出商品售完提示信息

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车键

	JMP START;跳转到主菜单界面



;对功能4的实现，计算所有商品的推荐度
L_CALCULATE_RECOMMEND:
    MOV BP,0;BP用于计数，代表当前商品信息端的序数（从0开始）
	LEA DI,GA1
LOOP_CALCULATE:
	CMP BP,N;
	JGE FINISH_CALCULATE

	MOV AX, WORD PTR [DI]+11
	MOV CX, 10
	IMUL CX
	MOV SI, WORD PTR [DI]+13
	
	MOV BX,0
	MOV BL, BYTE PTR[DI]+10
	IMUL SI, BX
	DIV SI;AX中为商，DX中为余数
	MOV SI,AX;将商移动到SI中储存
	;以上部分为推荐度的左半部分

	MOV AX, WORD PTR [DI]+17
	MOV CX, 64
	IMUL CX
	DIV WORD PTR [DI]+15;商储存在AX中
	ADD SI,AX;SI即为推荐度
	MOV 19[DI],SI;将推荐度储存
	INC BP;查看下一商品段信息，BP加一
	ADD DI,21;将DI指向下一商品信息段
	JMP LOOP_CALCULATE



	FINISH_CALCULATE:

	LEA DX,CRLF
	MOV AH,9
	INT 21H

	LEA DX,BUF10
	MOV AH,9
	INT 21H

	LEA DX,CRLF
	MOV AH,9
	INT 21H
	CMP CONTROL_RETURN,0
	JE START;如果为0，则说明要求直接跳转到主界面
	POP BX;如果为1，则说明要求跳转到模块3中
	MOV CONTROL_RETURN,0;将该变量还原
	JMP BX





L_RANK:
	JMP START

L_CHANGE_GOOD_INFO:
	JMP START

L_CHANGE_ENVIRONMENT:
	JMP START


L_SHOW_CURRENT_CS:

	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车

	MOV AX,CS
	MOV BX,16
	MOV CX,0;用于计数

LOOP_SHOW_CS:
	MOV DX,0
	DIV BX;商在AX中，余数在DX中
	PUSH DX;将DX压栈，以便反向输出
	INC CX;计数加一
	CMP AX,0
	JE SHOW_CS;说明分解完毕，转到输出模块
	JMP LOOP_SHOW_CS


SHOW_CS:
	CMP CX,0
	JE SHOW_END
	POP SI
	MOVZX DX,BUF12[SI];把ACSII码输入到DX中
	MOV AH,2
	INT 21H;
	DEC CX
	JMP SHOW_CS

SHOW_END:
	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车

	JMP START;回到主界面

L_END_SYSTEM:
	MOV AH,4CH
	INT 21H

;时间计数器(ms),在屏幕上显示程序的执行时间(ms)
;使用方法:
;	   MOV  AX, 0	;表示开始计时
;	   CALL TIMER
;	   ... ...	;需要计时的程序
;	   MOV  AX, 1	
;	   CALL TIMER	;终止计时并显示计时结果(ms)
;输出: 改变了AX和状态寄存器
TIMER	PROC
	PUSH  DX
	PUSH  CX
	PUSH  BX
	MOV   BX, AX
	MOV   AH, 2CH
	INT   21H	     ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
	MOV   AL, DH
	MOV   AH, 0
	IMUL  AX,AX,1000
	MOV   DH, 0
	IMUL  DX,DX,10
	ADD   AX, DX
	CMP   BX, 0
	JNZ   _T1
	MOV   CS:_TS, AX
_T0:	POP   BX
	POP   CX
	POP   DX
	RET
_T1:	SUB   AX, CS:_TS
	JNC   _T2
	ADD   AX, 60000
_T2:	MOV   CX, 0
	MOV   BX, 10
_T3:	MOV   DX, 0
	DIV   BX
	PUSH  DX
	INC   CX
	CMP   AX, 0
	JNZ   _T3
	MOV   BX, 0
_T4:	POP   AX
	ADD   AL, '0'
	MOV   CS:_TMSG[BX], AL
	INC   BX
	LOOP  _T4
	PUSH  DS
	MOV   CS:_TMSG[BX+0], 0AH
	MOV   CS:_TMSG[BX+1], 0DH
	MOV   CS:_TMSG[BX+2], '$'
	LEA   DX, _TS+2
	PUSH  CS
	POP   DS
	MOV   AH, 9
	INT   21H
	POP   DS
	JMP   _T0
_TS	DW    ?
 	DB    'Time elapsed in ms is '
_TMSG	DB    12 DUP(0)
TIMER   ENDP
	





CODE ENDS
	END START
	
	


