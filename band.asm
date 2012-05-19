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

MAIN PROC FAR  ;主程序

START: 
	mov  ax, DATA
	mov  ds, ax

	mov cx,0            ;计数器，开始指向乐谱的某一个音符
	;set screen-------------------------
	MOV	AH,0	;设置300×200彩色图形方式
	MOV	AL,0DH             
	INT	10H
	MOV	AH,0BH	;设置背景颜色
	MOV	BH,0             
	MOV	BL,06h
	INT	10h

	;-----------------------
	;初始化：一开始屏幕上已经有6个音符---------
	call move_tune    ;先乐谱下移
	call lay_egg      ;后在第一行加入新音符
	inc cx	          ;计数器+1
	call move_tune    ;先乐谱下移
	call lay_egg      ;后在第一行加入新音符
	inc cx	          ;计数器+1
	call move_tune    ;先乐谱下移
	call lay_egg      ;后在第一行加入新音符
	inc cx	          ;计数器+1
	call move_tune    ;先乐谱下移
	call lay_egg      ;后在第一行加入新音符
	inc cx	          ;计数器+1
	call move_tune    ;先乐谱下移
	call lay_egg      ;后在第一行加入新音符
	inc cx	          ;计数器+1
	call move_tune    ;先乐谱下移
	call lay_egg      ;后在第一行加入新音符
	inc cx	          ;计数器+1
	;-----------------------------------------
	call refresh  	    ;刷新


main_loop:	
	
	
	;检查键盘有没有键按下？
	;mov ah,0bh
	;int 21h
	;inc al
	;jnz do_nothing      ;如果没有按键，在0.5s后重刷屏幕

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
	call move_tune    ;先乐谱下移
	call lay_egg      ;后在第一行加入新音符
	inc cx	          ;计数器+1
	call refresh      ;刷新屏幕
	cmp cx, song_length         ;如果计数器大于歌曲长度就退出程序
	ja  exit


	
	jmp read_key    ;反复读键

exit:	
	mov ax, 4c00h
	int 21h

MAIN ENDP
;------------------------------------------------------
SOUNDF PROC NEAR ;手动演奏发声程序   IN：DI

       	PUSH AX
      	PUSH BX
       	PUSH CX
       	PUSH DX
       	PUSH DI
 
       	MOV AL,0B6H                                 ;定时器初始化
       	OUT 43H,AL
       	MOV DX,12H
       	MOV AX,348CH
       	DIV DI
       	OUT 42H,AL                                    ;定时器送处值
       	IN AL,61H                                        ;开扬声器
      	MOV AL,AH
       	OUT 42H,AL
       	IN AL,61H
       	MOV AH,AL
       	OR AL,3
       	OUT 61H,AL

WAIT1:  

      	CALL WAITF                                   ;调用延时程序
	IN AL,60H                                 
    	TEST AL,80H                               ;查询键是否放开
    	JZ WAIT1                                         ;未放开继续查询
      	MOV AL,AH                                    ;放开则关扬声器
       	OUT 61H,AL

	mov ah,0ch
	int 21h   ;清除键盘缓冲
	POP DI
	POP DX
	POP CX
       	POP BX
       	POP AX
	RET

SOUNDF ENDP
;------------------------------------------------------
WAITF PROC NEAR ;延时程序

	push cx
	MOV CX,10

WAITF1:
 	
       	LOOP WAITF1
	pop cx
       	RET

WAITF ENDP
;-------------------------------------------------------
refresh proc near;刷新屏幕的子程序

	push 	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	
	call	clear_screen  ;卷屏
;xxxxxx

;------------------------------------------
;key
	mov 	si,0
colum_begin:

	mov	di,0
row_begin:
	
	mov	ax,di
	mov	cl,8
	shl	ax,cl   ;di的低8位给dh
	mov	cx,ax   ;暂时保存一下ax
	mov     ax,si
	mov	bx,2
	mul	bx
	add	ax,cx    ;2*si+old_ax
	mov	dx,ax ;di->dh  si->dl

	mov	ah,2   ;置光标
	int 	10h

	mov	bx,offset key ;key->dx
	mov	ax,si
	mov	dx,6  
	mul	dx  ;si*6
	add	ax,di  ;si*6+di
	push	si
	mov	si,ax
	mov	al,[bx][si] ;考察key中的符号0,1,2
	pop	si	
	cmp	al, 0
	je	draw_white

	cmp     al, 2
	je	draw_long

	mov	ah,09   ;else 短记号	
	mov 	al,22   ;asc=22
	mov	bl,7
	mov	cx,1
	int 	10h
	jmp	draw_entrance

draw_white:
	mov	ah,09   ;写空格	
	mov 	al,' '   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h
	jmp	draw_entrance
	
draw_long:
	mov	ah,09  ;写长记号
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
	jl	colum_begin  ;超过8列，退出循环
	
        ;画出底线---------------------
	
	mov 	di,0
line_loop:
	mov	ah,2   ;置光标
	mov	dx,di   ;dl是index
	mov     dh,6
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,177   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	line_loop

	;画出键位------------------------------
	mov	ah,2   ;置光标
	mov	dl,0
	mov     dh,7
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'1'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,2
	mov     dh,7
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'2'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,4
	mov     dh,7
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'3'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,6
	mov     dh,7
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'4'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,8
	mov     dh,7
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'5'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,10
	mov     dh,7
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'6'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,12
	mov     dh,7
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'7'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,14
	mov     dh,7
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'8'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

        ;画出基座---------------------
	
	mov 	di,0
base_loop:
	mov	ah,2   ;置光标
	mov	dx,di   ;dl是index
	mov     dh,8
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,178   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	base_loop	


        ;画出基座4---------------------------------
	
	mov 	di,0
base_loop4:
	mov	ah,2   ;置光标
	mov	dx,di   ;dl是index
	mov     dh,9
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,178   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	base_loop4


	;基线2---------------------------------------
	mov 	di,0
base_loop2:
	mov	ah,2   ;置光标
	mov	dx,di   ;dl是index
	mov     dh,10
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,4   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	base_loop2

	;logo----------------------------------------
	mov	ah,2   ;置光标
	mov	dl,0
	mov     dh,11
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'G'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,2
	mov     dh,11
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'E'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,4
	mov     dh,11
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'E'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,6
	mov     dh,11
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'K'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,8
	mov     dh,11
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'M'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,10
	mov     dh,11
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'U'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,12
	mov     dh,11
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'S'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	mov	ah,2   ;置光标
	mov	dl,14
	mov     dh,11
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,'I'   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h
	;基线3---------------------------------------
	mov 	di,0
base_loop3:
	mov	ah,2   ;置光标
	mov	dx,di   ;dl是index
	mov     dh,12
	int 	10h

	mov	ah,09   ;写字符	
	mov 	al,4   ;asc
	mov	bl,7
	mov	cx,1
	int 	10h

	inc 	di
	cmp 	di,15
	jl	base_loop3

	
        ;画出基座6---------------------------------
	
	mov 	di,0
base_loop6:
	mov	ah,2   ;置光标
	mov	dx,di   ;dl是index
	mov     dh,13
	int 	10h

	mov	ah,09   ;写字符	
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
CLEAR_SCREEN PROC NEAR  ;卷屏
	PUSH	AX	;保护寄存器
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	AH,6	;屏幕上卷功能
	MOV	AL,0
	MOV	CH,0	;左上角行号
        MOV	CL,0	;左上角列号
	MOV	DH,5	;右下角行号
	MOV	DL,14	;右下角列号
	MOV	BH,7	;卷入行属性
	INT	10H	;调用显示属性

	POP	DX	;恢复寄存器
	POP	CX
	POP	BX
	POP	AX
	RET		;返回主程序
CLEAR_SCREEN  ENDP
;--------------------------------------------------------
move_tune proc near      ;子程序：把key数组的元素都下移一格
	push ax
	push bx
	push cx
	push dx
	push di
	push si

	mov si,0 	    ;外循环si from 0 to 7
out_loop:
	mov di,5            ;内循环di from 5 to 1
inside_loop:
	
	;mov [bx][si*6+di],[bx][si*6+di-1];下移一格
	;------------------------
	mov ax,si
	mov bx,6
	mul bx     ;si*6-->ax
	add ax,di  ;si*6+di-->ax
	dec ax     ;得到si*6+di-1这个偏移量
	
	push si    ;保护si
	mov si,ax     ;si=si*6+di-1     
	mov bx, offset key
	mov dl,[bx][si] ;把key[si*6+di-1]一个字节的内容寄存到dl
	
	
	inc si        ;si=si*6+di
	
	mov bx, offset key
	mov [bx][si],dl  ;key[si*6+di-1]-->key[si*6+di]
	pop si       ;si恢复出来
	;----------------------
	dec di

  	cmp di, 0
	jg inside_loop     


	inc si
	cmp si, 8
	jl out_loop        ;si小于8做循环，si等于8就退出循环

	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	ret

move_tune endp
;-------------------------------------------------------
lay_egg proc near;下蛋子程序，从乐谱中取出一个音，放到对应的音槽中;参数是cx
	push ax
	push bx
	push dx
	push di
	push si
	
	;用一个循环把音槽第一行清零
	
	mov di,0

lay_egg_loop:
	
	mov ax,di
	mov bl,6
	mul bl   ;ax=6*di
	mov si,ax ;si=6*di   si=0,6,12..42
	mov bx, offset key
	mov dl,0
	mov [bx][si],dl ;第一行全部清零
	
	inc di
	cmp di,8
	jl  lay_egg_loop

	mov si, cx
	mov bx, offset song
	mov dl, [bx][si]    ;从乐谱中拿出一个音符放到dl，音符是0-7的一个数
	
 	mov ah,0            ;把ah清空一下，al直接装dl的低8位，key槽的index
	mov al, dl          ;al<--dl
	mov bx, 6
	mul bx              ;index*6找到每个音槽第一行

	mov si,ax           ;index*6-->si
	mov bx, offset key
	push si
	push bx  ;取得key的对应位置，先存起来

	;查tune_length表，根据音符长度，在音槽中填充不同的数字1或2
	mov si, cx
	mov bx, offset tune_length
	mov dl, [bx][si]
	cmp dl, 2
	je  lay_big_egg      ;如果音符长度是2，下个大蛋，否则下个小蛋

lay_short_egg:
	pop bx
	pop si
	mov dl,1  	
	mov [bx][si],dl     ;在第一行下蛋
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
