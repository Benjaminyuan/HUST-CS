EXTERN F2T10:FAR

EXTERN F10T2:FAR
.386
IO MACRO A,B
    LEA DX,A
    MOV AH,B
    INT 21H
    ENDM
WRITE_GOOD_INFO MACRO A;输出商品的数字信息
    MOV AX,A
    MOV DX,16
    CALL F2T10
    ENDM
STACK SEGMENT USE16 STACK
    DB 200 DUP(0)
STACK ENDS

STACKBAK SEGMENT USE16 
      DB 200 DUP(0)
STACKBAK ENDS
DATA SEGMENT USE16 PARA PUBLIC 'DATA'
BUF  DB '*****THE SHOP IS SHOP_ONE*****$'
BUF1 DB 'PLEASE INPUT YOUR NAME $'
BUF2 DB 'PLEASE INPUT YOUR PASSWORD $'
BUF3 DB 'The name is wrong $'
BUF4 DB 'f:Please input the good you want $'
BUF5 DB 'The NAME is right $'
BUF6 DB 'The PWD is wrong$'
BUF7 DB 'Landed successfully$'
BUF8 DB 'Good you want not exist$'
BUF9 DB 'Good is not remain$'
BUF10 DB '0123456789abcdef'
BUF11 DB 'The pwd is right $'
BUF12 DB 'Good found!!!$'
BUF13 DB 'count !!!$'

BUF14 DB 'update success !!!$'
BUF15 DB 'hear!$'

BUF16 DB 'The information of this product is as below$';提示：提示用户以下是查找到的商品的信息
BUF17 DB 'Find_GOOD$';
BUF18 DB 'CHANGE FAILED $';
BUF19 DB 'CHANGE SUCCESS $';
BUF20 DB 'INTERRUPT SERVICE ALREADY LOADED! $';
BUF21 DB 'INTERRUPT SERVICE LOADED! $';

BUF22 DB 'Please enter the number 1 to 9 to select the function',0DH,0AH
	 DB '1. Log in / re log in',0DH,0AH
	 DB '2. Find the specified product and display its information',0DH,0AH
	 DB '3. Placing an order',0DH,0AH
	 DB '4. Calculate commodity recommendation',0DH,0AH
	 DB '5. Ranking', 0DH,0AH
	 DB '6. Change product information', 0DH,0AH
	 DB '7. Change the store operation environment', 0DH,0AH
	 DB '8. Display the current stack segment first address',0DH,0AH
	 DB '9. Exit',0DH,0AH,'$'
BUF_GOOD_EMPTY DB 'GOOD EMPTY $';


AUTH DB ?
CRLF DB 0DH,0AH,'$'
IN_NAME DB 11
	DB ?
	DB 11 DUP(0)
IN_PWD   DB 7
	DB ?
	DB 7 DUP(0)
IN_GOOD DB 11
	DB ?
	DB 11 DUP(0)
BNAME DB 'yjw',3 DUP(0)
COUNT1 = $-BNAME
BPASS DB  5 XOR 'Y';密码长度的加密方法，和老板姓名的首字母异或
	  DB ('j'-30H)*2
	  DB ('o'-30H)*2
	  DB ('k'-30H)*2
	  DB ('e'-30H)*2
	  DB ('r'-30H)*2;密码为JOKER，长度为5位
	  DB 0A1H,5FH,0D3H;随意填充防止被猜出密码的长度
COUNT2 = $-BPASS
N EQU 3000
S1  DB 'SHOP_ONE',0
GA1 DB 'PEN',7 DUP(0),10
    DW 35 XOR 'P',56,8500,25,?
GA2 DB 'BOOK',6 DUP(0),9
    DW 12 XOR 'B',30,8500,5,?
    ; 实际销售价格=销售价*折扣/10
    ; 进货价(字类型)，
    ; 销售价（字类型），
    ; 进货总数（字类型），
    ; 已售数量（字类型）
    ; 推荐度
GA3 DB 'PAD',7 DUP(0),10
    DW 12 XOR 'M',30,8500,5,?
GAN DB N-3 DUP('TEMP-VALUE',8,15,0,20,0,30,0,2,0,?,?)
NUMBER DB 10;用于保存修改商品信息时输入的数字串
	   DB ?
	   DB 10 DUP(0)
GOOD DW 0
M EQU 100
COUNTM DW 5000
P1   DW PASS1
P2   DW PASS2
BREAK_STATE DB 0;记录中断服务程序装载状态，0是没有装载，1是已经装载

OLDINT1 DW  0,0               ;1号中断的原中断矢量（用于中断矢量表反跟踪）
OLDINT3 DW  0,0  
DATA ENDS
CODE SEGMENT USE16
    ASSUME CS:CODE,DS:DATA,SS:STACK
MIN DB ?;分钟
SEC DB ?;秒
OLD_INT DW ?,?;记录原中断程序信息
STATE DB 0;用于记录转移堆栈段的状态
SSEG	   DW    ?,  ?	;用于保存2个堆栈段的段地址


NEWO8H PROC FAR
	PUSHF 
	CALL DWORD PTR CS:OLD_INT;执行原中断程序
	CALL GET_TIME;获取时间
	CMP BYTE PTR CS:SEC,0
	JE	CHANGE_STACK
	IRET 
CHANGE_STACK:
	PUSHA
	CMP BYTE PTR CS:STATE,0;判断目前处于哪一个堆栈
	JE GO_TO_STACKBAK
	JMP GO_TO_STACK
GO_TO_STACKBAK:
	MOV BYTE PTR CS:STATE,1
	MOV DX,STACKBAK
	CALL COPY_STACK
	POPA
	IRET
GO_TO_STACK:
	MOV BYTE PTR CS:STATE,0
	MOV DX,STACK
	CALL COPY_STACK
	POPA
	IRET
NEWO8H ENDP
GET_TIME PROC 
	PUSH AX
	MOV AL,0;秒的偏移
	OUT 70H,AL 
	JMP $+2
	IN AL,71H;读取秒的信息
	MOV BYTE PTR CS:SEC,AL
	POP AX
	RET
GET_TIME ENDP

COPY_STACK PROC 
	PUSH ES
	MOV ES,DX
	MOV BX,199
CSL:
	MOV AL,SS:[BX];循环拷贝堆栈
	MOV ES:[BX],AL
	DEC BX
	CMP BX,0
	JNE CSL
	MOV SS,DX;切换堆栈
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


    LEA DI,GA1
    MOV CX,10
MENU:
    ; 输出商店名称
    IO BUF,9
    ; 输出空格
    IO BUF22,9
    IO CRLF,9
L_INPUT:
    ;输入一个字符
    MOV AH,1
    INT 21H

    IO CRLF,9

    CMP AL,'1'
    JE LOGIN
    CMP AL,'2'
    JNE FUNC3
    CALL FIND_GOOD
    JMP MENU
FUNC3:    
    CMP AL,'3'
    JE ORDER
FUNC4:
    CMP AL,'4'
    JE COUNT_PRODUCE
    CMP AL,'5'
    JE RANK
    CMP AL,'6'
    JNE FUNC7
    CALL CHANGE_GOOD_INFO
    JMP MENU
FUNC7: 
    CMP AL,'7'
	JNE FUNC8
    CALL CHANGE_STORE_RUNTIME
	JMP MENU
FUNC8:   
	CMP AL,'8'
    JNE FUNC9
    CALL SHOW_CURRENT_CS
    JMP MENU
FUNC9:
    CMP AL,'9'
	JNE MENU
    JMP OVER
LOGIN:
    ;请输入姓名
    LEA DX,BUF1
    MOV AH,9
    INT 21H

    ;LEA DX,IN_NAME
    ;MOV AH,10
    ;INT 21H
    IO IN_NAME,10
    LEA DX,CRLF
	MOV AH,9
	INT 21H

    ;判断是否仅输入回车，若是，直接跳到
    CMP IN_NAME+1,0
    JE MENU
   ;长度不一致
L_CHECK_NAME:
    LEA SI,IN_NAME
	LEA DI,BNAME
	MOV CL,1[SI]
	CMP CL,3
	JNE LOGIN_NAME_WRONG
L_LOOP_N: 
    MOV AL,2[SI]
	MOV BL,[DI]
	INC SI
	INC DI
	CMP AL,BL
	JNE LOGIN_NAME_WRONG
	LOOP L_LOOP_N
	LEA DX,BUF5
	MOV AH,9
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
L_IN_PWD:
    LEA DX,BUF2;输入密码
	MOV AH,9
	INT 21H

	LEA DX,IN_PWD
	MOV AH,10
	INT 21H

	LEA DX,CRLF
	MOV AH,9
	INT 21H

    ;比较密码
CHECK_PWd_LENGTH:
    cli
	mov ah,2ch
	int 21h
	push dx;获取时间并保存


	MOV CL,IN_PWD+1
    XOR CL,'Y'
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

PASS1:
	cli;堆栈检查反跟踪
	push P2;PASS2的地址压栈

	LEA DI,BPASS+1
	LEA SI,IN_PWD+2

	pop ax
	mov bx,[esp-2];把栈顶上面的字（PASS2的地址）取到
	sti
	jmp bx;如果被跟踪，将不会转移到PASS2
	db ' come on !'
PASS2:
	MOV CL,BYTE PTR BPASS
	XOR CL,'Y';CL此时存储的是真实密码的长度
    
L_CHECK_PWD:
	MOV AL,[DI]
	MOV BL,[SI]
	SUB BL,30H
	ADD BL,BL
	CMP AL,BL
    JNE LOGIN_PWD_WRONG
	INC SI
	INC DI
    DEC CL
    JZ L_AUTH_1
	LOOP L_CHECK_PWD
L_AUTH_0:
    ;auth设置为0
    MOV AUTH,0
    JMP MENU

L_AUTH_1:
    IO BUF11,9
    IO CRLF,9
    ;auth设置为1
    MOV AUTH,1
    JMP MENU
    
LOGIN_NAME_WRONG:
    IO BUF3,9;提示输出错误的信息
    IO CRLF,9
	JMP LOGIN
LOGIN_PWD_WRONG:
	IO BUF6,9
	IO CRLF,9
	JMP L_IN_PWD
	db 'come on !'

ORDER:
    CMP GOOD,0
    JE MENU
    MOV AX,0
    CALL TIMER

LOOP_M:
    MOV DI,GOOD

    ;进货数量
    MOV AX,WORD PTR [DI]+15

    ;销量
    MOV BX,WORD PTR [DI]+17

    CMP AX,BX;比较
    JE GOOD_NO_REMAIN ;进货数量等于已售数量，显示已经售完
    MOV AX, WORD PTR [DI]+17
    ADD AX,1
    MOV WORD PTR [DI]+17,AX

COUNT_PRODUCE:
    MOV EBP,N;
    XOR EDI,EDI
    LEA DI,GA1
; 计算推荐度
COUNT_LOOP:

	MOV AX, WORD PTR [EDI]+11
    ;解密
    MOVZX BX,BYTE PTR [EDI]
    XOR AX,BX
	MOV CX, 10
	IMUL CX

	MOV SI, WORD PTR [EDI]+13
	MOVZX BX, BYTE PTR[EDI]+10
	IMUL SI, BX
	DIV SI ;AX中为商，DX中为余数
	MOVZX ESI,AX ;将商移动到SI中储存
	 ;以上部分为推荐度的左半部分


    MOVZX EAX,WORD PTR [EDI]+17;已售数量
    ;位移
    MOV ECX,64
    IMUL ECX
    ;SHL EAX,6;位移
	XOR EDX,EDX
    MOVZX EBX,WORD PTR [EDI]+15;进货量
    DIV EBX;
	ADD ESI,EAX;SI即为推荐度
	MOV 19[DI],SI;将推荐度储存

	ADD DI,21;将DI指向下一商品信息段
	DEC EBP;查看下一商品段信息，BP加一
    CMP EBP,0;
	JNE COUNT_LOOP

    MOV AX,1        ;计时
    CALL TIMER

    ;LEA DX,BUF13 ;调试
    ;MOV AH,9
    ;INT 21H
    ; 空格
    ;LEA DX,CRLF
	;MOV AH,9
	;INT 21H
    MOV GOOD,0;
    JMP MENU
GOOD_NO_REMAIN:
    LEA DX,BUF9 
    MOV AH,9
    INT 21H
    ; 空格
    LEA DX,CRLF
	MOV AH,9
	INT 21H
    JMP MENU
RANK:
    JMP MENU
MODIFY_GOOD:
    JMP MENU
CHANGE_STORE_RUNTIME PROC
	CMP BYTE PTR BREAK_STATE,0
	JNE ALREADY_LOAD
	PUSH DS;
	PUSH CS 
	POP DS

	MOV AX,3508H
	INT 21H

	MOV WORD PTR OLD_INT,BX;偏移地址
	MOV WORD PTR OLD_INT+2,ES;

	MOV DX,OFFSET NEWO8H
	MOV AX,2508H
	INT 21H;
	POP DS
	MOV BYTE PTR BREAK_STATE,1
	IO BUF21,9
	IO CRLF,9
	RET 
ALREADY_LOAD:
	IO BUF20,9
	IO CRLF,9
	RET 
CHANGE_STORE_RUNTIME ENDP

SHOW_CURRENT_CS PROC 
    PUSH CX
    PUSH AX
    PUSH DX
    PUSH BX

    IO CRLF,9

    MOV AX,SS;改写
    MOV BX,16
    MOV CX,0;
L_LOOP_SHOW_CS:
    MOV DX,0
    DIV BX;商在AX,余数在DX中
    PUSH DX;
    INC CX;
    CMP AX,0
    JE SHOW_CS
    JMP L_LOOP_SHOW_CS
SHOW_CS:
    CMP CX,0
    JE SHOW_END
    POP BX
    MOVZX DX,BUF10[BX];
    MOV AH,2
    INT 21H
    DEC CX
    JMP SHOW_CS
SHOW_END:
    IO CRLF,9

    POP BX
	POP DX
	POP AX
	POP CX
    RET 
SHOW_CURRENT_CS ENDP

OVER: 
    cli                           ;还原中断矢量
    mov  ax,OLDINT1
    mov  es:[1*4],ax
    mov  ax,OLDINT1+2
    mov  es:[1*4+2],ax
    mov  ax,OLDINT3
    mov  es:[3*4],ax
    mov  ax,OLDINT3+2
    mov  es:[3*4+2],ax 
    sti
	MOV   AH,4CH
	MOV   AL, 0;退出码 (如0、0FFH等)
    INT   21H
FIND_GOOD PROC

    ;;提示输入商品名称
    IO BUF4,9

    ; 输入商品的名字
    LEA DX,IN_GOOD
	MOV AH,10
	INT 21H
	
    ;比较长度
	CMP IN_GOOD+1,0
    JNE L_CHECK_GOOD_F

    JMP GOOD_NOT_FOUND_F

L_CHECK_GOOD_F:	
	IO CRLF,9
	LEA DI,GA1

	LEA SI,IN_GOOD+2
	MOVZX CX,IN_GOOD+1;CX保存输入商品单词的个数
	MOV DX,0;DX代表商品信息的序号（从0-29）

LL_F:
    MOV BX,0;BX代表商品名字比较位置（从0开始计数）

L_LOOP_G_F: 
	CMP BX,CX
	JGE FURTHER_CHECK;，以防输入的商品名为储存商品名的子集
	MOV AL,[DI+BX]
	MOV AH,[SI+BX]
	CMP AH,AL
	JNE L_NEXT_GOOD_F;如果不相等，判断下一条商品信息
	INC BX;如果相等，判断下一个字母是否相等
	JMP L_LOOP_G_F

L_NEXT_GOOD_F:;进入下个商品的位置
	ADD DI,21;将DI移动到下个商品信息段
	INC DX;商品信息序号相应加一
	CMP DX,30
	JE GOOD_NOT_FOUND_F
	JMP LL_F
FURTHER_CHECK:
	CMP BYTE PTR[DI+BX],0;判断储存字段该处是否为0
	JE MARK_GOOD_F;若是0，则表示输入名字不是储存名字的子集
	JMP L_NEXT_GOOD_F;若不是0，则说明输入名字为储存名字的子集，还需要检查下一条商品信息段

MARK_GOOD_F:

    MOV GOOD,DI;将该商品信息段的首地址储存到GOOD字段中
	MOVZX BX,IN_GOOD+1;将该商品名字单词的长度赋值给BX
    IO BUF16,9;输出提示信息
    IO CRLF,9

	MOV BYTE PTR [DI+BX],'$';在名字的末尾添加$
    IO [DI],9;输出商品的名字
	MOV BYTE PTR [DI+BX],0


    MOVZX AX,BYTE PTR 10[DI]
	MOV DX,16
	CALL F2T10;输出商品折扣
    IO CRLF,9
	
    ;
    MOV AX, WORD PTR 11[DI]
    MOVZX BX,bYTE PTR [DI]
    XOR AX,BX
	WRITE_GOOD_INFO AX;进价
    IO CRLF,9
    

	WRITE_GOOD_INFO 13[DI];售价
    IO CRLF,9


	WRITE_GOOD_INFO 15[DI];进货数
    IO CRLF,9


	WRITE_GOOD_INFO 17[DI];销售数
    IO CRLF,9

	WRITE_GOOD_INFO 19[DI];推荐度
    IO CRLF,9


GOOD_FOUND_F:
    IO BUF12,9
    IO CRLF,9
    RET
GOOD_NOT_FOUND_F:
    ;提示未找到信息
    IO BUF8,9
    IO CRLF,9
    RET
FIND_GOOD ENDP

CHANGE_GOOD_INFO PROC 
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

NEWINT:IRET


CHANGE_INFO:
	CMP BP,6
	JE L1;因为存储折扣的空间只有一个字节，所以要特殊处理
L3: 
    LEA DX,CRLF
	MOV AH,9
	INT 21H

    MOV AX,WORD PTR [BX]
    MOV DX,16
	CALL F2T10;

    MOV DL,'>'
	MOV AH,2
	INT 21H

    IO NUMBER,10;输入要修改成的数字
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

    IO NUMBER,10;输入要修改成的数字
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
	IO BUF18,9;输出错误提示信息
	JMP RETURN

GOOD_EMPTY:
    IO BUF_GOOD_EMPTY,9
    JMP RETURN
FINISH_CHANGE:
	IO BUF19,9;提示完成商品信息的修改
	JMP RETURN
RETURN:
    POP CX
	POP SI
	POP AX
	POP DX
	POP BP
	POP BX
    IO CRLF,9
	RET

CHANGE_GOOD_INFO ENDP



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