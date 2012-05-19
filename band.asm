;-----------------------------------------------
DATA SEGMENT

	msg 	db '>>>>>','$'

	table	dw 262
		dw 294
		dw 330
		dw 349
		dw 392
		dw 440
		dw 466
		dw 523


	song_length	dw	30  ;25-1+6=30


	song	db	0  ;0
		db	0  ;1
		db	1  ;2
		db	0  ;3
		db	3  ;4
		db	2  ;5
		db	0  ;6
		db	0  ;7
		db	1  ;8
		db	0  ;9
		db	4  ;10
		db	3  ;11
		db	0  ;12
		db	0  ;13
		db	7  ;14
		db	5  ;15
		db	3  ;16
		db	2  ;17
		db	1  ;18
		db	6  ;19
		db	6  ;20
		db	5  ;21
		db	3  ;22
		db	4  ;23	
		db	3  ;24

tune_length	db	0  ;0
		db	0  ;1
		db	1  ;2
		db	1  ;3
		db	1  ;4
		db	2  ;5
		db	0  ;6
		db	0  ;7
		db	1  ;8
		db	1  ;9
		db	1  ;10
		db	2  ;11
		db	0  ;12
		db	0  ;13
		db	1  ;14
		db	1  ;15
		db	1  ;16
		db	1  ;17
		db	1  ;18
		db	0  ;19
		db	0  ;20
		db	1  ;21
		db	1  ;22
		db	1  ;23
		db	2  ;24


	key     db 0  ;0-5
		db 0
		db 0
		db 0
		db 0
		db 1

		db 0  ;6-11
		db 0
		db 0
		db 0
		db 0
		db 1
		
	 	db 0  ;12-17
		db 0
		db 0
		db 0
		db 0
		db 1

	 	db 0 ;18-23
		db 0
		db 0
		db 0
		db 0
		db 1

		db 0  ;24-29
		db 0
		db 0
		db 0
		db 0
		db 1

		db 0  ;30-35
		db 0
		db 0
		db 0
		db 0
		db 1

		db 0  ;36-41
		db 0
		db 0
		db 0
		db 0
		db 1

		db 0  ;42-47
		db 0
		db 0
		db 0
		db 0
		db 1



DATA ENDS
;------------------------------------------------------

CODE SEGMENT

	ASSUME DS:DATA,CS:CODE

MAIN PROC FAR  ;������

START: 
	mov  ax, DATA
	mov  ds, ax

	mov cx,0            ;����������ʼָ�����׵�ĳһ������
	;set screen-------------------------
	MOV	AH,0	;����300��200��ɫͼ�η�ʽ
	MOV	AL,0DH             
	INT	10H
	MOV	AH,0BH	;���ñ�����ɫ
	MOV	BH,0             
	MOV	BL,06h
	INT	10h

	;-----------------------
	;��ʼ����һ��ʼ��Ļ���Ѿ���6������---------
	call move_tune    ;����������
	call lay_egg      ;���ڵ�һ�м���������
	inc cx	          ;������+1
	call move_tune    ;����������
	call lay_egg      ;���ڵ�һ�м���������
	inc cx	          ;������+1
	call move_tune    ;����������
	call lay_egg      ;���ڵ�һ�м���������
	inc cx	          ;������+1
	call move_tune    ;����������
	call lay_egg      ;���ڵ�һ�м���������
	inc cx	          ;������+1
	call move_tune    ;����������
	call lay_egg      ;���ڵ�һ�м���������
	inc cx	          ;������+1
	call move_tune    ;����������
	call lay_egg      ;���ڵ�һ�м���������
	inc cx	          ;������+1
	;-----------------------------------------
	call refresh  	    ;ˢ��


main_loop:	
	
	
	;��������û�м����£�
	;mov ah,0bh
	;int 21h
	;inc al
	;jnz do_nothing      ;���û�а�������0.5s����ˢ��Ļ

read_key:
	;mov ah,6
	;mov dl,0ffh
	;int 21h
	mov ah,0
	int 16h
	cmp al, 0dh
	je  exit
	mov bx, offset table
	cmp al,'1'
	jb  read_key
	cmp al, '8'
	ja  read_key
	and ax, 0fh
	shl ax, 1
	sub ax, 2
 	mov si, ax
	mov di, [bx][si]
	call soundf
	call move_tune    ;����������
	call lay_egg      ;���ڵ�һ�м���������
	inc cx	          ;������+1
	call refresh      ;ˢ����Ļ
	cmp cx, song_length         ;������������ڸ������Ⱦ��˳�����
	ja  exit


	
	jmp read_key    ;��������

exit:	
	mov ax, 4c00h
	int 21h

MAIN ENDP
;------------------------------------------------------
SOUNDF PROC NEAR ;�ֶ����෢������   IN��DI

       	PUSH AX
      	PUSH BX
       	PUSH CX
       	PUSH DX
       	PUSH DI
 
       	MOV AL,0B6H                                 ;��ʱ����ʼ��
       	OUT 43H,AL
       	MOV DX,12H
       	MOV AX,348CH
       	DIV DI
       	OUT 42H,AL                                    ;��ʱ���ʹ�ֵ
       	IN AL,61H                                        ;��������
      	MOV AL,AH
       	OUT 42H,AL
       	IN AL,61H
       	MOV AH,AL
       	OR AL,3
       	OUT 61H,AL

WAIT1:  

      	CALL WAITF                                   ;������ʱ����
	IN AL,60H                                 
    	TEST AL,80H                               ;��ѯ���Ƿ�ſ�
    	JZ WAIT1                                         ;δ�ſ�������ѯ
      	MOV AL,AH                                    ;�ſ����������
       	OUT 61H,AL

	mov ah,0ch
	int 21h   ;������̻���
	POP DI
	POP DX
	POP CX
       	POP BX
       	POP AX
	RET

SOUNDF ENDP
;------------------------------------------------------
WAITF PROC NEAR ;��ʱ����

	push cx
	MOV CX,10

WAITF1:
 	
       	LOOP WAITF1
	pop cx
       	RET

WAITF ENDP
;-------------------------------------------------------
refresh proc near;ˢ����Ļ���ӳ���

	push 	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	
	call	clear_screen  ;����
;xxxxxx

;------------------------------------------
;key
	mov 	si,0
colum_begin:

	mov	di,0
row_begin:
	
	mov	ax,di
	mov	cl,8
	shl	ax,cl   ;di�ĵ�8λ��dh
	mov	cx,ax   ;��ʱ����һ��ax
	mov     ax,si
	mov	bx,2
	mul	bx
	add	ax,cx    ;2*si+old_ax
	mov	dx,ax ;di->dh  si->dl

	mov	ah,2   ;�ù��
	int 	10h

	mov	bx,offset key ;key->dx
	mov	ax,si
	mov	dx,6  
	mul	dx  ;si*6
	add	ax,di  ;si*6+di
	push	si
	mov	si,ax
	mov	al,[bx][si] ;����key�еķ���0,1,2
	pop	si	
	cmp	al, 0
	je	draw_white

	cmp     al, 2
	je	draw_long

	mov	ah,09   ;else �̼Ǻ�	
	mov 	al,22   ;asc=22
	mov	bl,7
	mov	cx,1
	int 	10h
	jmp	draw_entrance

draw_white:
	mov	ah,09   ;д�ո�	
	mov 	al,' '   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h
	jmp	draw_entrance
	
draw_long:
	mov	ah,09  ;д���Ǻ�
	mov	al,179
	mov	bl, 7
	mov	cx, 1
	int 	10h

draw_entrance:		

	inc 	di      ;row+1
	cmp	di,6
	jl	row_begin
	
	inc 	si
	cmp 	si,8
	jl	colum_begin  ;����8�У��˳�ѭ��
	
        ;��������---------------------
	
	mov 	di,0
line_loop:
	mov	ah,2   ;�ù��
	mov	dx,di   ;dl��index
	mov     dh,6
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,177   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	line_loop

	;������λ------------------------------
	mov	ah,2   ;�ù��
	mov	dl,0
	mov     dh,7
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'1'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,2
	mov     dh,7
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'2'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,4
	mov     dh,7
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'3'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,6
	mov     dh,7
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'4'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,8
	mov     dh,7
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'5'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,10
	mov     dh,7
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'6'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,12
	mov     dh,7
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'7'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,14
	mov     dh,7
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'8'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

        ;��������---------------------
	
	mov 	di,0
base_loop:
	mov	ah,2   ;�ù��
	mov	dx,di   ;dl��index
	mov     dh,8
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,178   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	base_loop	


        ;��������4---------------------------------
	
	mov 	di,0
base_loop4:
	mov	ah,2   ;�ù��
	mov	dx,di   ;dl��index
	mov     dh,9
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,178   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	base_loop4


	;����2---------------------------------------
	mov 	di,0
base_loop2:
	mov	ah,2   ;�ù��
	mov	dx,di   ;dl��index
	mov     dh,10
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,4   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	base_loop2

	;logo----------------------------------------
	mov	ah,2   ;�ù��
	mov	dl,0
	mov     dh,11
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'G'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,2
	mov     dh,11
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'E'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,4
	mov     dh,11
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'E'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,6
	mov     dh,11
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'K'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,8
	mov     dh,11
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'M'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,10
	mov     dh,11
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'U'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,12
	mov     dh,11
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'S'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;�ù��
	mov	dl,14
	mov     dh,11
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,'I'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h
	;����3---------------------------------------
	mov 	di,0
base_loop3:
	mov	ah,2   ;�ù��
	mov	dx,di   ;dl��index
	mov     dh,12
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,4   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	base_loop3

	
        ;��������6---------------------------------
	
	mov 	di,0
base_loop6:
	mov	ah,2   ;�ù��
	mov	dx,di   ;dl��index
	mov     dh,13
	int 	10h

	mov	ah,09   ;д�ַ�	
	mov 	al,178   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	base_loop6
	;----------------------------------------

	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax

	ret
refresh endp
;---------------------------------------------------------
CLEAR_SCREEN PROC NEAR  ;����
	PUSH	AX	;�����Ĵ���
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	AH,6	;��Ļ�Ͼ���
	MOV	AL,0
	MOV	CH,0	;���Ͻ��к�
        MOV	CL,0	;���Ͻ��к�
	MOV	DH,5	;���½��к�
	MOV	DL,14	;���½��к�
	MOV	BH,7	;����������
	INT	10H	;������ʾ����

	POP	DX	;�ָ��Ĵ���
	POP	CX
	POP	BX
	POP	AX
	RET		;����������
CLEAR_SCREEN  ENDP
;--------------------------------------------------------
move_tune proc near      ;�ӳ��򣺰�key�����Ԫ�ض�����һ��
	push ax
	push bx
	push cx
	push dx
	push di
	push si

	mov si,0 	    ;��ѭ��si from 0 to 7
out_loop:
	mov di,5            ;��ѭ��di from 5 to 1
inside_loop:
	
	;mov [bx][si*6+di],[bx][si*6+di-1];����һ��
	;------------------------
	mov ax,si
	mov bx,6
	mul bx     ;si*6-->ax
	add ax,di  ;si*6+di-->ax
	dec ax     ;�õ�si*6+di-1���ƫ����
	
	push si    ;����si
	mov si,ax     ;si=si*6+di-1     
	mov bx, offset key
	mov dl,[bx][si] ;��key[si*6+di-1]һ���ֽڵ����ݼĴ浽dl
	
	
	inc si        ;si=si*6+di
	
	mov bx, offset key
	mov [bx][si],dl  ;key[si*6+di-1]-->key[si*6+di]
	pop si       ;si�ָ�����
	;----------------------
	dec di

  	cmp di, 0
	jg inside_loop     


	inc si
	cmp si, 8
	jl out_loop        ;siС��8��ѭ����si����8���˳�ѭ��

	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret

move_tune endp
;-------------------------------------------------------
lay_egg proc near;�µ��ӳ��򣬴�������ȡ��һ�������ŵ���Ӧ��������;������cx
	push ax
	push bx
	push dx
	push di
	push si
	
	;��һ��ѭ�������۵�һ������
	
	mov di,0

lay_egg_loop:
	
	mov ax,di
	mov bl,6
	mul bl   ;ax=6*di
	mov si,ax ;si=6*di   si=0,6,12..42
	mov bx, offset key
	mov dl,0
	mov [bx][si],dl ;��һ��ȫ������
	
	inc di
	cmp di,8
	jl  lay_egg_loop

	mov si, cx
	mov bx, offset song
	mov dl, [bx][si]    ;���������ó�һ�������ŵ�dl��������0-7��һ����
	
 	mov ah,0            ;��ah���һ�£�alֱ��װdl�ĵ�8λ��key�۵�index
	mov al, dl          ;al<--dl
	mov bx, 6
	mul bx              ;index*6�ҵ�ÿ�����۵�һ��

	mov si,ax           ;index*6-->si
	mov bx, offset key
	push si
	push bx  ;ȡ��key�Ķ�Ӧλ�ã��ȴ�����

	;��tune_length�������������ȣ�����������䲻ͬ������1��2
	mov si, cx
	mov bx, offset tune_length
	mov dl, [bx][si]
	cmp dl, 2
	je  lay_big_egg      ;�������������2���¸��󵰣������¸�С��

lay_short_egg:
	pop bx
	pop si
	mov dl,1  	
	mov [bx][si],dl     ;�ڵ�һ���µ�
	jmp egg_entrance

lay_big_egg:
	pop  bx
	pop  si
	mov dl,2
	mov [bx][si],dl

egg_entrance:

	pop si
	pop di
	pop dx
	pop bx
	pop ax
	ret
lay_egg endp
;--------------------------------------------------------
CODE ENDS
	END START
