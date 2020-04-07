EXTERN F2T10:FAR
;子程序F2T10
;功能：将有符号二进制数转换成十进制ASCII码输出（16位段）。
;入口参数：
    ;AX/EAX 存放待转换的二进制数。
    ;DX 存放16位或32位标志，(DX)=32表示待转换数在EAX中。返回时会被修改（因为要输出）。
;出口参数：无。

EXTERN F10T2:FAR
;功能：有符号十进制转换为字类型的二进制数（16位段）。
;入口参数：输入串首址在SI中，串长在CX中。
;出口参数：(SI)=-1表示出错，转换结果在AX中。

.386
STACK SEGMENT USE16 STACK
    DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16
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
BUF14 DB 'Checkout success$';提示：从功能4返回成功 
BUF15 DB 'Only the boss has authority$';提示：只有老板才能更改商品信息
BUF16 DB 'Complete product information change$';提示：完成商品信息的修改
AUTH DB 0;当前登录状态，0表示顾客状态
CRLF DB 0DH,0AH,'$';回车键
BNAME DB 'TIANZHAO',0;老板姓名
BPASS DB 'TEST',0,0;密码

NUMBER DB 10;用于保存修改商品信息时输入的数字串
	   DB ?
	   DB 10 DUP(0)
	
N EQU 30
CONTROL_RETURN DB 0;控制计算推荐度函数返回的位置，0代表直接返回主界面，1代表返回模块3
SNAME  DB 'SHOP',0;网店名称，用0结束
GOOD DW 0;用于储存商品信息段的首地址
GA1 DB 'PEN',7 DUP(0),10;商品名称及折扣
    DW 35,56,70,25,?;推荐度还未计算
GA2 DB 'BOOK',6 DUP(0),9;商品名称及折扣
    DW 12,30,25,15,?;进货价，销售价，进货数量，已售数量，推荐度还未计算
GAN DB N-2 DUP('TEMP-VALUE',8,15,0,20,0,30,0,2,0,?,?);除了两个已经具体定义了的商品信息外，其他商品信息暂时假定为一样的
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

;宏定义
	WRITE MACRO A;输出字符串，
		LEA DX ,CRLF
		MOV AH,9
		INT 21H

		LEA DX,A
		MOV AH,9
		INT 21H

		LEA DX ,CRLF
		MOV AH,9
		INT 21H
		ENDM

	WRITE_GOOD_INFO MACRO A;输出商品的数字信息
		MOV AX,A
		MOV DX,16
		CALL F2T10
		ENDM

	PRINT_BLANK MACRO ;输出空格
		MOV DL,' '
		MOV AH,2
		INT 21H
		ENDM

	INPUT_STRING MACRO A;输入字符串
		LEA DX,A
		MOV AH,10
		INT 21H
		ENDM

;宏定义结束
	

START:
	MOV AX,DATA
	MOV DS,AX

	CMP IN_NAME+1,0
	JE PRINT_GOOD
	MOV BL,IN_NAME+1
	MOV BH,0
	MOV IN_NAME+2[BX],'$'

	WRITE IN_NAME+2;如果存在的话，输出用户名
PRINT_GOOD:
	CMP IN_GOOD+1,0
	JE PRINT_INFO
	MOV BL,IN_GOOD+1
	MOV BH,0
	MOV IN_GOOD+2[BX],'$'

	WRITE IN_GOOD+2;如果存在的话，输出当前浏览的商品名

PRINT_INFO:
	WRITE BUF8;输出菜单提示信息
INPUT_COMMAND:
	MOV AH,1
	INT 21H;输入一个字符

	CMP AL,'1'
	JL INPUT_COMMAND_WRONG
	CMP AL,'9'
	JG INPUT_COMMAND_WRONG
	SUB AL,'0'
	MOVZX BX,AL
	CMP BX,1
	JE FUN1
	CMP BX,2
	JE FUN2
	CMP BX,3
	JE FUN3
	CMP BX,4
	JE FUN4
	CMP BX,5
	JE FUN5
	CMP BX,6
	JE FUN6
	CMP BX,7
	JE FUN7
	CMP BX,8
	JE FUN8
	CMP BX,9
	JE L_END_SYSTEM
FUN1:
	CALL L_IN_NAME
	JMP START
FUN2:
	CALL L_IN_GOOD
	JMP START
FUN3:
	CALL L_PLACE_ORDER
	JMP START
FUN4:
	CALL L_CALCULATE_RECOMMEND
	JMP START
FUN5:
	CALL L_RANK
	JMP START
FUN6:
	CALL L_CHANGE_GOOD_INFO
	JMP START
FUN7:
	CALL L_CHANGE_ENVIRONMENT
	JMP START
FUN8:
	CALL L_SHOW_CURRENT_CS
	JMP START

INPUT_COMMAND_WRONG:
	WRITE BUF11;输出提示语句
	JMP INPUT_COMMAND;要求再次输入功能选择字符


;功能1
L_IN_NAME PROC
	PUSH BX
	PUSH AX
	PUSH DI
	PUSH SI
	PUSH CX
L:	WRITE BUF1;提示输入用户名信息
	INPUT_STRING IN_NAME;输入姓名
	MOV BL,IN_NAME+1
	MOV BH,0
	MOV IN_NAME+2[BX],0;对名字的末尾加0进行修正

	WRITE BUF2;提示输入密码
	INPUT_STRING IN_PWD;输入密码
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
	WRITE BUF3;输出登录失败提示
	JMP L;我个人修改为跳转到再次输入姓名和密码

L_0_AUTH:
	MOV AUTH,0
	JMP FINISH_LOAD

L_1_AUTH:
	MOV AUTH,1
	WRITE BUF7;输出登录成功提示
	JMP FINISH_LOAD

FINISH_LOAD:
	POP CX
	POP SI
	POP DI
	POP AX
	POP BX
	RET
L_IN_NAME ENDP


;查找商品信息，功能2的实现！！！
L_IN_GOOD PROC
	PUSH BX
	PUSH DI
	PUSH SI
	PUSH CX
	PUSH DX
	WRITE BUF4;提示输入商品名称
	INPUT_STRING IN_GOOD;输入商品名称
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
	CMP DX,30
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

	WRITE BUF13;输出提示信息
	WRITE [DI];输出商品的名字
	MOV BYTE PTR [DI+BX],0

	MOVZX AX,BYTE PTR 10[DI]
	MOV DX,16
	CALL F2T10;输出商品折扣

	PRINT_BLANK
	WRITE_GOOD_INFO 11[DI];进价
	PRINT_BLANK
	WRITE_GOOD_INFO 13[DI];售价
	PRINT_BLANK
	WRITE_GOOD_INFO 15[DI];进货数
	PRINT_BLANK
	WRITE_GOOD_INFO 17[DI];销售数
	PRINT_BLANK
	WRITE_GOOD_INFO 19[DI];推荐度
	JMP FINISH_SEARCH

NOT_FIND:
	WRITE BUF5;输出没有找到商品信息的提示信息
	MOV IN_GOOD+1,0;由于没有该信息，所以IN_GOOD中存入的值也就无效
	JMP FINISH_SEARCH
FINISH_SEARCH:
	POP DX
	POP CX
	POP SI
	POP DI
	POP BX
	RET
L_IN_GOOD ENDP



;功能3的实现：下订单
L_PLACE_ORDER PROC
	PUSH ESI
	PUSH BX
	CMP GOOD,0;判断GOOD是否为空
	JNE JUDGE_NUMBER;若不为空，则进一步判断商品数量是否为0
	JMP SHOW_GOOD_EMPTY;若为空，则跳转到主菜单界面

JUDGE_NUMBER:

	MOVZX ESI,GOOD
	MOV BX,15[ESI]
	CMP BX,17[ESI];第一个为进货总量，第二个为已售数量
	JLE SHOW_SOLD_OUT;如果进货数量小于等于已售数量，显示已经售完，并跳转到主界面
	ADD WORD PTR 17[ESI],1;如果进货数量大于已售数量，则将存储的已售数量加一

	CALL L_CALCULATE_RECOMMEND;进入计算推荐度的模块
	WRITE BUF14;输出提示信息
	MOV GOOD,0;下单完成后，需要还原GOOD字段
	MOV BYTE PTR IN_GOOD+1,0;还原商品字段
	JMP PLACE_END
SHOW_GOOD_EMPTY:
	WRITE BUF9;输出当前GOOD为空的提示信息
	JMP PLACE_END
SHOW_SOLD_OUT:
	WRITE BUF6;输出商品售完提示信息
	JMP PLACE_END
PLACE_END:
	POP ESI
	POP BX
	RET
L_PLACE_ORDER ENDP


;对功能4的实现，计算所有商品的推荐度
L_CALCULATE_RECOMMEND PROC
	PUSH EBP
	PUSH EDI
	PUSH EAX
	PUSH ECX
	PUSH EDX
	PUSH ESI
	PUSH EBX
    MOV EBP,N;EBP用于计数
	XOR EDI,EDI
	LEA DI,GA1;将商品段的首地址存储到EDI中

LOOP_CALCULATE:
	MOV AX, WORD PTR [EDI]+11;AX为进货价
	MOV CX, 10
	IMUL CX;结果储存在（DX,AX中）

	MOV SI, WORD PTR [EDI]+13;SI为销售价
	MOVZX BX, BYTE PTR[EDI]+10;BX为折扣
	IMUL SI, BX
	DIV SI;AX中为商，DX中为余数
	MOVZX ESI,AX;将商移动到ESI中储存
	;以上部分为推荐度的左半部分

	MOVZX EAX, WORD PTR [EDI]+17;已售数量
	SHL EAX,6;EAX乘以64
	XOR EDX,EDX
	MOVZX EBX,WORD PTR [EDI]+15;进货量
	DIV EBX;商储存在EAX中
	ADD ESI,EAX;ESI即为推荐度
	MOV 19[DI],SI
;将推荐度储存，推荐度本身就不大，所以这里不存在截断数据的问题
	DEC EBP
	JZ FINISH_CALCULATE
	ADD EDI,21;将DI指向下一商品信息段
	JMP LOOP_CALCULATE

	FINISH_CALCULATE:
	WRITE BUF10
	POP EBX
	POP ESI
	POP EDX
	POP ECX
	POP EAX
	POP EDI
	POP EBP
	RET 
L_CALCULATE_RECOMMEND ENDP


;功能5，排序
L_RANK PROC
	RET
L_RANK ENDP

;功能6，改变商品信息
L_CHANGE_GOOD_INFO PROC
	PUSH BX
	PUSH BP
	PUSH DX
	PUSH AX
	PUSH SI
	PUSH CX
	CMP AUTH,1
	JNE CHANGE_ERROR
	CMP GOOD,0
	JE  GOOD_EMPTY
	MOV BX,GOOD
	ADD BX,10
	MOV BP,6;用于计数
L2:	
	CMP BP,0
	JNE CHANGE_INFO
	JMP FINISH_CHANGE

CHANGE_INFO:
	CMP BP,6
	JE L1;因为存储折扣的空间只有一个字节，所以要特殊处理

L3:	
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	MOV AX,WORD PTR [BX]
	MOV DX,16
	CALL F2T10

	MOV DL,'>'
	MOV AH,2
	INT 21H

	INPUT_STRING NUMBER;输入要修改成的数字
	CMP BYTE PTR NUMBER+1,0
	JE NEXT_INFO2;如果直接输入了回车键，则继续修改下一个商品信息
	LEA SI,NUMBER+2
	MOVZX CX,BYTE PTR NUMBER+1
	CALL F10T2
	CMP SI,-1
	JE L3
	MOV WORD PTR [BX],AX
	ADD BX,2
	DEC BP
	JMP L2

L1:	
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	MOVZX AX,BYTE PTR [BX]
	MOV DX,16
	CALL F2T10

	MOV DL,'>'
	MOV AH,2
	INT 21H

	INPUT_STRING NUMBER;输入要修改成的数字
	CMP BYTE PTR NUMBER+1,0
	JE NEXT_INFO1;如果直接输入了回车键，则继续修改下一个商品信息
	LEA SI,NUMBER+2;SI为数字串的首地址
	MOVZX CX,BYTE PTR NUMBER+1;CX为数字串的数量
	CALL F10T2;调用函数，将数字串转化为二进制数字，结果存在AX中
	CMP SI,-1
	JE L1;如果输入的数字串不合法，则会要求重新输入
	MOV BYTE PTR [BX],AL;数字串合法，改变折扣的值
	ADD BX,1
	DEC BP
	JMP L2

NEXT_INFO1:
	ADD BX,1
	DEC BP
	JMP L2
	
NEXT_INFO2:
	ADD BX,2
	DEC BP
	JMP L2

CHANGE_ERROR:
	WRITE BUF15;输出错误提示信息
	JMP RETURN

GOOD_EMPTY:
	WRITE BUF9;提示当前操作商品无效
	JMP RETURN

FINISH_CHANGE:
	WRITE BUF16;提示完成商品信息的修改
	JMP RETURN
RETURN:
	POP CX
	POP SI
	POP AX
	POP DX
	POP BP
	POP BX
	RET
L_CHANGE_GOOD_INFO ENDP

;功能7
L_CHANGE_ENVIRONMENT PROC
	RET
L_CHANGE_ENVIRONMENT ENDP


;功能8
L_SHOW_CURRENT_CS PROC
	PUSH CX
	PUSH AX
	PUSH DX
	PUSH BX

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
	POP BX
	MOVZX DX,BUF12[BX];把ACSII码输入到DX中
	MOV AH,2
	INT 21H;
	DEC CX
	JMP SHOW_CS

SHOW_END:
	LEA DX,CRLF
	MOV AH,9
	INT 21H;输出回车

	POP BX
	POP DX
	POP AX
	POP CX

	RET;返回
L_SHOW_CURRENT_CS ENDP

;功能9
L_END_SYSTEM:
	MOV AH,4CH
	INT 21H
CODE ENDS
	END START