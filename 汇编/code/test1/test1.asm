EXTERN F2T10:FAR
;�ӳ���F2T10
;���ܣ����з��Ŷ�������ת����ʮ����ASCII�������16λ�Σ���
;��ڲ�����
    ;AX/EAX ��Ŵ�ת���Ķ���������
    ;DX ���16λ��32λ��־��(DX)=32��ʾ��ת������EAX�С�����ʱ�ᱻ�޸ģ���ΪҪ�������
;���ڲ������ޡ�

EXTERN F10T2:FAR
;���ܣ��з���ʮ����ת��Ϊ�����͵Ķ���������16λ�Σ���
;��ڲ��������봮��ַ��SI�У�������CX�С�
;���ڲ�����(SI)=-1��ʾ����ת�������AX�С�

.386
STACK SEGMENT USE16 STACK
    DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16
BUF1 DB 'PLEASE INPUT YOUR NAME $';��ʾ�������û���
BUF2 DB 'PLEASE INPUT YOUR PASSWORD $';��ʾ����������
BUF3 DB 'Login failed $';��ʾ����¼ʧ��
BUF4 DB 'Please input the good you want $';��ʾ��������Ʒ����
BUF5 DB 'Product information not found $';��ʾ��û���ҵ���Ʒ����Ϣ
BUF6 DB 'The goods are sold out$';��ʾ����Ʒ�Ѿ�����
BUF7 DB 'Login successfully$';��ʾ�������û�����������ȷ����½�ɹ�
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
BUF9 DB 'Invalid good input$';��ʾ��GOODΪ��
BUF10 DB 'Complete the calculation of recommendation$';��ʾ������Ƽ��ȵļ���
BUF11 DB 'The input character does not meet the requirements.Please input again!!$';��ʾ:�����ѡ���ܵ��ַ�������Ҫ��
BUF12 DB '0123456789ABCDEF'
BUF13 DB 'The information of this product is as below$';��ʾ����ʾ�û������ǲ��ҵ�����Ʒ����Ϣ
BUF14 DB 'Checkout success$';��ʾ���ӹ���4���سɹ� 
BUF15 DB 'Only the boss has authority$';��ʾ��ֻ���ϰ���ܸ�����Ʒ��Ϣ
BUF16 DB 'Complete product information change$';��ʾ�������Ʒ��Ϣ���޸�
AUTH DB 0;��ǰ��¼״̬��0��ʾ�˿�״̬
CRLF DB 0DH,0AH,'$';�س���
BNAME DB 'TIANZHAO',0;�ϰ�����
BPASS DB 'TEST',0,0;����

NUMBER DB 10;���ڱ����޸���Ʒ��Ϣʱ��������ִ�
	   DB ?
	   DB 10 DUP(0)
	
N EQU 30
CONTROL_RETURN DB 0;���Ƽ����Ƽ��Ⱥ������ص�λ�ã�0����ֱ�ӷ��������棬1������ģ��3
SNAME  DB 'SHOP',0;�������ƣ���0����
GOOD DW 0;���ڴ�����Ʒ��Ϣ�ε��׵�ַ
GA1 DB 'PEN',7 DUP(0),10;��Ʒ���Ƽ��ۿ�
    DW 35,56,70,25,?;�Ƽ��Ȼ�δ����
GA2 DB 'BOOK',6 DUP(0),9;��Ʒ���Ƽ��ۿ�
    DW 12,30,25,15,?;�����ۣ����ۼۣ����������������������Ƽ��Ȼ�δ����
GAN DB N-2 DUP('TEMP-VALUE',8,15,0,20,0,30,0,2,0,?,?);���������Ѿ����嶨���˵���Ʒ��Ϣ�⣬������Ʒ��Ϣ��ʱ�ٶ�Ϊһ����
IN_NAME DB 10;�����洢������û���
	DB 0
	DB 10 DUP(0)
IN_PWD   DB 7;�����洢���������
	DB 0
	DB 7 DUP(0)
IN_GOOD DB 10;�����洢�������Ʒ������
	DB 0
	DB 10 DUP(0)
DATA ENDS
CODE SEGMENT USE16
    ASSUME CS:CODE,DS:DATA,SS:STACK

;�궨��
	WRITE MACRO A;����ַ�����
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

	WRITE_GOOD_INFO MACRO A;�����Ʒ��������Ϣ
		MOV AX,A
		MOV DX,16
		CALL F2T10
		ENDM

	PRINT_BLANK MACRO ;����ո�
		MOV DL,' '
		MOV AH,2
		INT 21H
		ENDM

	INPUT_STRING MACRO A;�����ַ���
		LEA DX,A
		MOV AH,10
		INT 21H
		ENDM

;�궨�����
	

START:
	MOV AX,DATA
	MOV DS,AX

	CMP IN_NAME+1,0
	JE PRINT_GOOD
	MOV BL,IN_NAME+1
	MOV BH,0
	MOV IN_NAME+2[BX],'$'

	WRITE IN_NAME+2;������ڵĻ�������û���
PRINT_GOOD:
	CMP IN_GOOD+1,0
	JE PRINT_INFO
	MOV BL,IN_GOOD+1
	MOV BH,0
	MOV IN_GOOD+2[BX],'$'

	WRITE IN_GOOD+2;������ڵĻ��������ǰ�������Ʒ��

PRINT_INFO:
	WRITE BUF8;����˵���ʾ��Ϣ
INPUT_COMMAND:
	MOV AH,1
	INT 21H;����һ���ַ�

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
	WRITE BUF11;�����ʾ���
	JMP INPUT_COMMAND;Ҫ���ٴ����빦��ѡ���ַ�


;����1
L_IN_NAME PROC
	PUSH BX
	PUSH AX
	PUSH DI
	PUSH SI
	PUSH CX
L:	WRITE BUF1;��ʾ�����û�����Ϣ
	INPUT_STRING IN_NAME;��������
	MOV BL,IN_NAME+1
	MOV BH,0
	MOV IN_NAME+2[BX],0;�����ֵ�ĩβ��0��������

	WRITE BUF2;��ʾ��������
	INPUT_STRING IN_PWD;��������
	MOVZX BX,IN_PWD+1
	MOV IN_PWD+2[BX],0;������ĩβ��0��������

	CMP IN_NAME+1,0;�ж��Ƿ��������س�
	JE L_0_AUTH;���ǣ���AUTHΪ0���ص����˵�

L_CHECK_NAME:
	CMP IN_NAME+1,8
	JNE L_OUT_WRONG;�����λ������һ����ֱ����ת����½ʧ����ʾ
	LEA DI,BNAME
	LEA SI,IN_NAME+2;�ֱ𽫱����������������������׵�ַ��ֵ��DI,SI�����ڱȽ�
	MOV CX,1
 L_LOOP_N:
	CMP CX,8
	JG L_CHECK_PWD;������ڼ�����CX����8����˵��������ȷ��Ҫ��ת�������
	MOV AL,[DI]
	MOV BL,[SI];���üĴ������Ѱַ
	CMP AL,BL
	JNE L_OUT_WRONG;�в���ȵ���ĸ����ת����½ʧ����ʾ
	INC DI
	INC SI
	INC CX
	JMP L_LOOP_N;ѭ���ж�

L_CHECK_PWD:
	CMP IN_PWD+1,4
	JNZ L_OUT_WRONG;��������λ����һ����ֱ����ת����¼ʧ����ʾ
	LEA DI,BPASS
	LEA SI,IN_PWD+2
	MOV CX,1
 L_LOOP_P:
	CMP CX,4
	JG L_1_AUTH;���������붼��ȷ����AUTH��ֵΪ1�������¼�ɹ���ʾ��Ϣ����ת��������
	MOV AL,[DI]
	MOV BL,[SI]
	CMP AL,BL
	JNE L_OUT_WRONG;���벻��ȷ����ת����½ʧ����ʾ
	INC DI
	INC SI
	INC CX
	JMP L_LOOP_P;ѭ���ж�

L_OUT_WRONG:
	WRITE BUF3;�����¼ʧ����ʾ
	JMP L;�Ҹ����޸�Ϊ��ת���ٴ���������������

L_0_AUTH:
	MOV AUTH,0
	JMP FINISH_LOAD

L_1_AUTH:
	MOV AUTH,1
	WRITE BUF7;�����¼�ɹ���ʾ
	JMP FINISH_LOAD

FINISH_LOAD:
	POP CX
	POP SI
	POP DI
	POP AX
	POP BX
	RET
L_IN_NAME ENDP


;������Ʒ��Ϣ������2��ʵ�֣�����
L_IN_GOOD PROC
	PUSH BX
	PUSH DI
	PUSH SI
	PUSH CX
	PUSH DX
	WRITE BUF4;��ʾ������Ʒ����
	INPUT_STRING IN_GOOD;������Ʒ����
	MOVZX BX,IN_GOOD+1
	MOV IN_GOOD+2[BX],0;������ĩβ��0��������	
	CMP IN_GOOD+1,0
    JNE L_CHECK_GOOD;�����ȷ��������Ʒ��������ת���Ƚ�ģ��
	JMP NOT_FIND;���ֱ�������˻س��������û���ҵ�����ת�����˵�����

L_CHECK_GOOD:
	LEA DI,GA1
	LEA SI,IN_GOOD+2
	MOVZX CX,IN_GOOD+1;CX����������Ʒ���ʵĸ���
	MOV DX,0;DX������Ʒ��Ϣ����ţ���0-29��

LL:
	MOV BX,0;BX������Ʒ���ֵ��ʵ���ţ���0��ʼ������

L_LOOP_G:
	CMP BX,CX
	JGE FURTHER_CHECK;���и���һ�����жϣ��Է��������Ʒ��Ϊ������Ʒ�����Ӽ�
	MOV AL,[DI+BX]
	MOV AH,[SI+BX]
	CMP AH,AL
	JNE NEXT_GOOD;�������ȣ��ж���һ����Ʒ��Ϣ
	INC BX;�����ȣ��ж���һ����ĸ�Ƿ����
	JMP L_LOOP_G

NEXT_GOOD:
	ADD DI,21;��DI�ƶ����¸���Ʒ��Ϣ��
	INC DX;��Ʒ��Ϣ�����Ӧ��һ
	CMP DX,30
	JE NOT_FIND
	JMP LL
FURTHER_CHECK:
	CMP BYTE PTR[DI+BX],0;�жϴ����ֶθô��Ƿ�Ϊ0
	JE STORE_SHOW_INFO;����0�����ʾ�������ֲ��Ǵ������ֵ��Ӽ�
	JMP NEXT_GOOD;������0����˵����������Ϊ�������ֵ��Ӽ�������Ҫ�����һ����Ʒ��Ϣ��

STORE_SHOW_INFO:
	MOV GOOD,DI;������Ʒ��Ϣ�ε��׵�ַ���浽GOOD�ֶ���
	MOVZX BX,IN_GOOD+1;������Ʒ���ֵ��ʵĸ�����ֵ��BX
	MOV BYTE PTR [DI+BX],'$';�����ֵ�ĩβ���$��

	WRITE BUF13;�����ʾ��Ϣ
	WRITE [DI];�����Ʒ������
	MOV BYTE PTR [DI+BX],0

	MOVZX AX,BYTE PTR 10[DI]
	MOV DX,16
	CALL F2T10;�����Ʒ�ۿ�

	PRINT_BLANK
	WRITE_GOOD_INFO 11[DI];����
	PRINT_BLANK
	WRITE_GOOD_INFO 13[DI];�ۼ�
	PRINT_BLANK
	WRITE_GOOD_INFO 15[DI];������
	PRINT_BLANK
	WRITE_GOOD_INFO 17[DI];������
	PRINT_BLANK
	WRITE_GOOD_INFO 19[DI];�Ƽ���
	JMP FINISH_SEARCH

NOT_FIND:
	WRITE BUF5;���û���ҵ���Ʒ��Ϣ����ʾ��Ϣ
	MOV IN_GOOD+1,0;����û�и���Ϣ������IN_GOOD�д����ֵҲ����Ч
	JMP FINISH_SEARCH
FINISH_SEARCH:
	POP DX
	POP CX
	POP SI
	POP DI
	POP BX
	RET
L_IN_GOOD ENDP



;����3��ʵ�֣��¶���
L_PLACE_ORDER PROC
	PUSH ESI
	PUSH BX
	CMP GOOD,0;�ж�GOOD�Ƿ�Ϊ��
	JNE JUDGE_NUMBER;����Ϊ�գ����һ���ж���Ʒ�����Ƿ�Ϊ0
	JMP SHOW_GOOD_EMPTY;��Ϊ�գ�����ת�����˵�����

JUDGE_NUMBER:

	MOVZX ESI,GOOD
	MOV BX,15[ESI]
	CMP BX,17[ESI];��һ��Ϊ�����������ڶ���Ϊ��������
	JLE SHOW_SOLD_OUT;�����������С�ڵ���������������ʾ�Ѿ����꣬����ת��������
	ADD WORD PTR 17[ESI],1;��������������������������򽫴洢������������һ

	CALL L_CALCULATE_RECOMMEND;��������Ƽ��ȵ�ģ��
	WRITE BUF14;�����ʾ��Ϣ
	MOV GOOD,0;�µ���ɺ���Ҫ��ԭGOOD�ֶ�
	MOV BYTE PTR IN_GOOD+1,0;��ԭ��Ʒ�ֶ�
	JMP PLACE_END
SHOW_GOOD_EMPTY:
	WRITE BUF9;�����ǰGOODΪ�յ���ʾ��Ϣ
	JMP PLACE_END
SHOW_SOLD_OUT:
	WRITE BUF6;�����Ʒ������ʾ��Ϣ
	JMP PLACE_END
PLACE_END:
	POP ESI
	POP BX
	RET
L_PLACE_ORDER ENDP


;�Թ���4��ʵ�֣�����������Ʒ���Ƽ���
L_CALCULATE_RECOMMEND PROC
	PUSH EBP
	PUSH EDI
	PUSH EAX
	PUSH ECX
	PUSH EDX
	PUSH ESI
	PUSH EBX
    MOV EBP,N;EBP���ڼ���
	XOR EDI,EDI
	LEA DI,GA1;����Ʒ�ε��׵�ַ�洢��EDI��

LOOP_CALCULATE:
	MOV AX, WORD PTR [EDI]+11;AXΪ������
	MOV CX, 10
	IMUL CX;��������ڣ�DX,AX�У�

	MOV SI, WORD PTR [EDI]+13;SIΪ���ۼ�
	MOVZX BX, BYTE PTR[EDI]+10;BXΪ�ۿ�
	IMUL SI, BX
	DIV SI;AX��Ϊ�̣�DX��Ϊ����
	MOVZX ESI,AX;�����ƶ���ESI�д���
	;���ϲ���Ϊ�Ƽ��ȵ���벿��

	MOVZX EAX, WORD PTR [EDI]+17;��������
	SHL EAX,6;EAX����64
	XOR EDX,EDX
	MOVZX EBX,WORD PTR [EDI]+15;������
	DIV EBX;�̴�����EAX��
	ADD ESI,EAX;ESI��Ϊ�Ƽ���
	MOV 19[DI],SI
;���Ƽ��ȴ��棬�Ƽ��ȱ���Ͳ����������ﲻ���ڽض����ݵ�����
	DEC EBP
	JZ FINISH_CALCULATE
	ADD EDI,21;��DIָ����һ��Ʒ��Ϣ��
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


;����5������
L_RANK PROC
	RET
L_RANK ENDP

;����6���ı���Ʒ��Ϣ
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
	MOV BP,6;���ڼ���
L2:	
	CMP BP,0
	JNE CHANGE_INFO
	JMP FINISH_CHANGE

CHANGE_INFO:
	CMP BP,6
	JE L1;��Ϊ�洢�ۿ۵Ŀռ�ֻ��һ���ֽڣ�����Ҫ���⴦��

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

	INPUT_STRING NUMBER;����Ҫ�޸ĳɵ�����
	CMP BYTE PTR NUMBER+1,0
	JE NEXT_INFO2;���ֱ�������˻س�����������޸���һ����Ʒ��Ϣ
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

	INPUT_STRING NUMBER;����Ҫ�޸ĳɵ�����
	CMP BYTE PTR NUMBER+1,0
	JE NEXT_INFO1;���ֱ�������˻س�����������޸���һ����Ʒ��Ϣ
	LEA SI,NUMBER+2;SIΪ���ִ����׵�ַ
	MOVZX CX,BYTE PTR NUMBER+1;CXΪ���ִ�������
	CALL F10T2;���ú����������ִ�ת��Ϊ���������֣��������AX��
	CMP SI,-1
	JE L1;�����������ִ����Ϸ������Ҫ����������
	MOV BYTE PTR [BX],AL;���ִ��Ϸ����ı��ۿ۵�ֵ
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
	WRITE BUF15;���������ʾ��Ϣ
	JMP RETURN

GOOD_EMPTY:
	WRITE BUF9;��ʾ��ǰ������Ʒ��Ч
	JMP RETURN

FINISH_CHANGE:
	WRITE BUF16;��ʾ�����Ʒ��Ϣ���޸�
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

;����7
L_CHANGE_ENVIRONMENT PROC
	RET
L_CHANGE_ENVIRONMENT ENDP


;����8
L_SHOW_CURRENT_CS PROC
	PUSH CX
	PUSH AX
	PUSH DX
	PUSH BX

	LEA DX,CRLF
	MOV AH,9
	INT 21H;����س�

	MOV AX,CS
	MOV BX,16
	MOV CX,0;���ڼ���

LOOP_SHOW_CS:
	MOV DX,0
	DIV BX;����AX�У�������DX��
	PUSH DX;��DXѹջ���Ա㷴�����
	INC CX;������һ
	CMP AX,0
	JE SHOW_CS;˵���ֽ���ϣ�ת�����ģ��
	JMP LOOP_SHOW_CS


SHOW_CS:
	CMP CX,0
	JE SHOW_END
	POP BX
	MOVZX DX,BUF12[BX];��ACSII�����뵽DX��
	MOV AH,2
	INT 21H;
	DEC CX
	JMP SHOW_CS

SHOW_END:
	LEA DX,CRLF
	MOV AH,9
	INT 21H;����س�

	POP BX
	POP DX
	POP AX
	POP CX

	RET;����
L_SHOW_CURRENT_CS ENDP

;����9
L_END_SYSTEM:
	MOV AH,4CH
	INT 21H
CODE ENDS
	END START