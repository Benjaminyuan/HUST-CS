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

STACKBAK SEGMENT USE16 
      DB 200 DUP(0)
STACKBAK ENDS

DATA SEGMENT USE16 PARA PUBLIC 'DATA'
BUF  DB '********THE SHOP IS MY SHOP*********$'
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
	 DB '8. Display the current stack segment first address',0DH,0AH
	 DB '9. Exit',0DH,0AH,'$'
BUF9 DB 'Invalid good input$';提示：GOOD为空
BUF10 DB 'Complete the calculation of recommendation$';提示：完成推荐度的计算
BUF11 DB 'The input character does not meet the requirements.Please input again!!$';提示:输入的选择功能的字符不符合要求
BUF12 DB '0123456789ABCDEF'
BUF13 DB 'The information of this product is as below$';提示：提示用户以下是查找到的商品的信息
BUF14 DB 'Checkout success$';提示：从功能4返回成功 
BUF15 DB 'Only the boss has authority$';提示：只有老板才能更改商品信息
BUF16 DB 'Complete product information change$';提示：完成商品信息的修改
BUF17 DB 'Interrupt service loaded$';提示：已经完成中断处理程序的装载
BUF18 DB 'Finish copy$';提示：已经完成堆栈段的转化
BUF19 DB 'You have used up all the attempts. The system shut down automatically$';提示：已经用完所有尝试次数，系统自动关闭
AUTH DB 0;当前登录状态，0表示顾客状态
CRLF DB 0DH,0AH,'$';回车键
BNAME DB 'TIANZHAO',0;老板姓名
BPASS DB  5 XOR 'T';密码长度的加密方法，和老板姓名的首字母异或
	  DB ('J'-30H)*2
	  DB ('O'-30H)*2
	  DB ('k'-30H)*2
	  DB ('e'-30H)*2
	  DB ('R'-30H)*2;密码为JOKER，长度为5位
	  DB 0A1H,5FH,0D3H;随意填充防止被猜出密码的长度

NUMBER DB 10;用于保存修改商品信息时输入的数字串
	   DB ?
	   DB 10 DUP(0)
	
N EQU 30
GOOD DW 0;用于储存商品信息段的首地址
GA1 DB 'PEN',7 DUP(0),10;商品名称及折扣
    DW 35 XOR 'P',56,70,25,?;推荐度还未计算
GA2 DB 'BOOK',6 DUP(0),9;商品名称及折扣
    DW 12 XOR 'B',30,25,15,?;进货价，销售价，进货数量，已售数量，推荐度还未计算
GA3 DB 'MILK',6 DUP(0),10;商品名称及折扣
	DW 12 XOR 'M',20,30,10,?;进货价，销售价，进货数量，已售数量，推荐度还未计算
GAN DB N-3 DUP('TEMP-VALUE',8,15,0,20,0,30,0,2,0,?,?);除了已经具体定义了的商品信息外，其他商品信息暂时假定为一样的

IN_NAME DB 10;用来存储输入的用户名
	DB 0
	DB 10 DUP(0)
IN_PWD   DB 7;用来存储输入的密码
	DB 0
	DB 7 DUP(0)
IN_GOOD DB 10;用来存储输入的商品的名称
	DB 0
	DB 10 DUP(0)

BREAK_STATE DB 0;记录中断服务程序装载状态。0是没有装载，1是已经装载

OLDINT1 DW  0,0               ;1号中断的原中断矢量（用于中断矢量表反跟踪）
OLDINT3 DW  0,0               ;3号中断的原中断矢量

OVER DW L_OUT_WRONG
P1   DW PASS1
P2   DW PASS2

COUNT_INPUT_TIME DB 5;用于记录输入错误的次数。

DATA ENDS;数据段定义结束




CODE SEGMENT USE16
    ASSUME CS:CODE,DS:DATA,SS:STACK
COUNT DB 18;8号中断发生18次大约为1秒
  MIN    DB ?
  SEC    DB ?
OLD_INT  DW 0, 0
STATE DB 0;用于记录转移堆栈段的状态。
		   ;0代表要转到STACK，1代表要转到STACKBAK
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

NEW08H  PROC  FAR
        PUSHF
        CALL  DWORD  PTR CS:OLD_INT;执行原中断程序的内容
		DEC BYTE PTR CS:COUNT
		CMP BYTE PTR CS:COUNT,0
		JE JUDGE_TIME
		IRET

JUDGE_TIME:
		MOV BYTE PTR CS:COUNT,18
		CALL GET_TIME
		CMP BYTE PTR CS:SEC,0
		JE CHANGE_STACK
		IRET

CHANGE_STACK:
		PUSHA
		CMP BYTE PTR CS:STATE,0
		JE GO_TO_STACKBAK
		JMP GO_TO_STACK
GO_TO_STACKBAK:
		MOV BYTE PTR CS:STATE,1
		MOV DX,STACKBAK
		CALL COPY_STACK
		MOV SS,DX
		POPA
		IRET
GO_TO_STACK:
		MOV BYTE PTR CS:STATE,0
		MOV DX,STACK
		CALL COPY_STACK
		MOV SS,DX
		POPA
		IRET
NEW08H  ENDP

GET_TIME PROC
		PUSH AX
		MOV AL,0
		OUT 70H,AL
		JMP $+2
		IN AL,71H
		MOV BYTE PTR CS:SEC,AL
		POP AX
		RET
GET_TIME ENDP

COPY_STACK PROC 
;输入参数为DX，DX存储新堆栈段的SS
;该函数功能为将当前堆栈段切换到新堆栈段，并且将旧堆栈段的内容复制到新堆栈段中
	PUSH ES
	MOV ES,DX
	MOV BX,199
CSL:
	MOV AL,SS:[BX]
	MOV ES:[BX],AL
	DEC BX
	CMP BX,0
	JNE CSL
	MOV SS,DX
	POP ES
	RET
COPY_STACK ENDP


	

START:
	MOV AX,DATA
	MOV DS,AX

	xor  ax,ax                  ;接管调试用中断，中断矢量表反跟踪
    mov  es,ax
    mov  ax,es:[1*4]            ;保存原1号和3号中断矢量
    mov  OLDINT1,ax
    mov  ax,es:[1*4+2]
    mov  OLDINT1+2,ax
    mov  ax,es:[3*4]
    mov  OLDINT3,ax
    mov  ax,es:[3*4+2]
    mov  OLDINT3+2,ax
    cli                           ;设置新的中断矢量
    mov  ax,OFFSET NEWINT
    mov  es:[1*4],ax
    mov  es:[1*4+2],cs
    mov  es:[3*4],ax
    mov  es:[3*4+2],cs
    sti

	mov bx,es:[1*4];检查中断矢量表是否被改变
	inc bx		   ;如果被改变则跳转到PASS4，
				   ;如果没有被改变就不知道跳转到哪里了
	jmp bx

PASS4:
	WRITE BUF;输出商店名
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
	INT 21H

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
	JNE ERROR2;输入的位数都不一样，直接跳转到登陆失败提示
	LEA DI,BNAME
	LEA SI,IN_NAME+2;分别将保存姓名和输入姓名串的首地址赋值给DI,SI，便于比较
	MOV CX,1
 L_LOOP_N:
	CMP CX,8
	JG L_CHECK_PWD;如果用于计数的CX大于8，则说明姓名正确，要跳转检查密码
	MOV AL,[DI]
	MOV BL,[SI];采用寄存器间接寻址
	CMP AL,BL
	JNE ERROR2;有不相等的字母，跳转到登陆失败提示
	INC DI
	INC SI
	INC CX
	JMP L_LOOP_N;循环判断

L_CHECK_PWD:
	cli
	mov ah,2ch
	int 21h
	push dx;获取时间并保存

	MOV CL,IN_PWD+1
	XOR CL,'T'
	SUB CL,BYTE  PTR BPASS
	MOVSX BX,CL
	ADD BX,OFFSET P1;如果串长相同，BX中存储的是P1的偏移地址

	mov ah,2ch
	int 21h
	sti
	cmp dx,[esp]
	pop dx
	jz OK1;通过时间的检验
	mov bx,[bx];BX可能是PASS1也可能不是PASS1
	add bx,10h;BX一定不是PASS1
	jmp bx;如果时间不同，则说明程序正在被调试，那么就选择跳出程序的正常运行

OK1:
	mov bx,[bx];如果时间符合要求，串长相同的话，BX中存储的是PASS1
			   ;如果时间不符合要求，串长不容，BX中存储的不是PASS1
	cmp bx,PASS1;判断BX中存储的是否为PASS1，其实也就是判断是否时间相符并且字符串相同
	je	OK2
	jmp OVER

OK2:jmp bx;跳转到PASS1，对密码进行更进一步的判断
DB '12340139129481';混淆视听

	
PASS1:
	cli;堆栈检查反跟踪
	push P2;PASS2的地址压栈

	LEA DI,BPASS+1
	LEA SI,IN_PWD+2

	pop ax
	mov bx,[esp-2];把栈顶上面的字（PASS2的地址）取到
	sti
	jmp bx;如果被跟踪，将不会转移到PASS2
	db 'hao ge ge jia you o!'
PASS2:
	MOV CL,BYTE PTR BPASS
	XOR CL,'T';CL此时存储的是真实密码的长度
 L_LOOP_P:
	MOV AL,[DI]
	MOV BL,[SI]
	SUB BL,30H
	ADD BL,BL
	CMP AL,BL
	JNE ERROR2;密码不正确，跳转到登陆失败提示
	INC DI
	INC SI
	DEC CL
	JZ L_1_AUTH;姓名和密码都正确，将AUTH赋值为1，输出登录成功提示信息，跳转到主界面
	JMP L_LOOP_P;循环判断

ERROR2:
	mov ebx,offset P1
	mov edx,2
	sub ebx,edx
	jmp word ptr [ebx];跳转到L_OUT_WRONG
	db '666 hao ge ge jia you o!'

L_OUT_WRONG:
	WRITE BUF3;输出登录失败提示
	mov bx,offset COUNT_INPUT_TIME;DX中存储的是该变量的偏移地址
	dec byte ptr [bx];输入错误一次就该该变量-1
	CMP byte ptr [bx],0
	je END_THE_SYSTEM
	JMP L;我个人修改为跳转到再次输入姓名和密码

END_THE_SYSTEM:
	mov byte ptr [bx],5;将COUNT_INPUT_TIME还原
	WRITE BUF19;输出提示语句
	jmp END_SYSTEM

L_0_AUTH:
	MOV AUTH,0
	MOV BYTE PTR COUNT_INPUT_TIME,5
	JMP FINISH_LOAD

L_1_AUTH:
	MOV AUTH,1
	WRITE BUF7;输出登录成功提示
	MOV BYTE PTR COUNT_INPUT_TIME,5
	JMP FINISH_LOAD

FINISH_LOAD:
	POP CX
	POP SI
	POP DI
	POP AX
	POP BX
	RET
L_IN_NAME ENDP

NEWINT:IRET
TESTINT: jmp pass4


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
L2:	CMP BP,0
	JNE CHANGE_INFO
	JMP FINISH_CHANGE

CHANGE_INFO:
	CMP BP,6
	JE L1;因为存储折扣的空间只有一个字节，所以要特殊处理

L3:	LEA DX,CRLF
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

L1:	LEA DX,CRLF
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
	CMP BYTE PTR BREAK_STATE,0
	JNE ALREADY_LOAD;已经装载
	PUSH DS
	PUSH CS
	POP DS
	MOV   AX, 3508H
    INT   21H
    MOV   WORD PTR OLD_INT,  BX ;偏移地址
    MOV   WORD PTR OLD_INT+2, ES;段地址
    MOV   DX, OFFSET NEW08H
    MOV   AX, 2508H
    INT   21H;装载中断服务程序
	POP DS
	MOV BYTE PTR BREAK_STATE,1
ALREADY_LOAD:
	WRITE BUF17
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
	INT 21H

	MOV AX,SS
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
	INT 21H
	DEC CX
	JMP SHOW_CS

SHOW_END:
	LEA DX,CRLF
	MOV AH,9
	INT 21H

	POP BX
	POP DX
	POP AX
	POP CX

	RET;返回
L_SHOW_CURRENT_CS ENDP

;功能9
L_END_SYSTEM:
	CMP DWORD PTR CS:OLD_INT,0
	JE END_SYSTEM
	PUSH DS
	PUSH DX
	MOV DS,WORD PTR OLD_INT+2
	MOV DX,WORD PTR OLD_INT
	MOV AX,2508H;装载回原来的8号中断
	INT 21H
	POP DX
	POP DS
END_SYSTEM:
	MOV AH,4CH
	INT 21H
CODE ENDS
	END START