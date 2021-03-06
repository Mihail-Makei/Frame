;==========================================================================
;==============================WARNING=====================================
;===============THIS PROGRAM CONTAINS AN INTELLECTUAL JOKE=================
;==========================================================================

.model tiny
.data
Storage dw 0, 0
MsgOne db 'Would you like a joke?', 0
MsgTwo db 'I believe you would', 0
MsgThree db 'So let me generate it', 0
MsgFour db 'Kim Jong Un is so fat that the recursive function', 0
MsgFive db 'computing his mass causes stack overflow', 0
.code

		COLOR equ 0Ah
		WHITE equ 0Fh

org 100h

Start:
		call ClrScr

		mov ax, 0B800h
		mov es, ax

;======================Introduction=======================================

		mov di, 80*8*2+28*2
		mov bx, offset MsgOne
		call PrintLine

		call LongDelay

		mov di, 80*12*2+28*2
		mov bx, offset MsgTwo
		call PrintLine

		call LongDelay

;=====================Generator=launch====================================

		call ClrScr

		mov di, 80*8*2+28*2
		mov bx, offset MsgThree
		call PrintLine

		call LongDelay

;=====================Print=a=frame========================================

		mov di, 80*12*2+8*2
		mov cx, 60
		mov bx, 7
		call PrintFrame

		call LongDelay

;======================Print=a=joke=========================================

		mov di, 80*14*2+13*2
		mov bx, offset MsgFour
		call PrintLine

		mov di, 80*16*2+18*2
		mov bx, offset MsgFive
		call PrintLine

		call LongDelay

		ret

;=======================PROCEDURES=========================================

;=======================LONG DELAY=========================================
;==========================================================================
; Expects: none
;
; Returns: none
;
; Destroys: ax, cx, dx
;==========================================================================
LongDelay proc
		mov ax, 8600h
		mov cx, 000Ah
		mov dx, 0000h
		int 15h

		ret
endp LongDelay

;===================================================
; Expects: none
;
; Returns: none
;
; Destroys: ax
;===================================================
Delay proc
		mov ax, 8600h

		mov word ptr [Storage], cx
		mov word ptr [Storage+2], dx
		mov cx, 0000h
		mov dx, 8000h
		int 15h

		mov cx, word ptr [Storage]
		mov dx, word ptr [Storage+2]
		
		ret
endp Delay

;===================================================
; Expects: bx - offset to string
;
; Returns: none
;
; Destroys: ax
;===================================================

PrintLine proc
		mov al, [bx]
		mov ah, COLOR

		cld

Symbol:
		cmp al, 0
		je FinalPrt
		
		stosw

		inc bx
		
		call Delay

		mov al, [bx]
		mov ah, COLOR

		jmp Symbol

FinalPrt:
		ret
PrintLine endp

;===================================================
; Expects: none
;
; Returns: none
;
; Destroys: ax
;===================================================
ClrScr proc
		mov ax, 0003h
		int 10h

		ret
ClrScr endp

;===================================================
; Expects: es:[di] - offset to write
;
; Returns: none
;
; Destroys: ax, di
;===================================================
PrintHorizontal proc 
		mov al, 205d
		mov ah, WHITE
		
		cld
HR:
		stosw 
		call Delay
		mov al, 205d
		mov ah, WHITE
		loop HR
		

		ret
endp PrintHorizontal

;===================================================
; Expects: es:[di] - offset to write
;
; Returns: none
;
; Destroys: ax, di
;===================================================
PrintVertical proc
		mov al, 186d
		
		cld
Print:
		stosw
		add di, 79*2
		
		call Delay
		mov al, 186d
		mov ah, WHITE
		loop Print

		ret
endp PrintVertical
;==================================================================
; Expects: es:[di] - offset to print
;
; Returns: none
;
; Destroys: ax, cx
;==================================================================

PrintFrame proc
		mov al, 201d
		mov ah, WHITE
		stosw

		mov dx, cx
		shl dx, 1
		
		call PrintHorizontal	

		mov al, 187d
		stosw
		
		add di, 79*2
		mov cx, bx

		call PrintVertical
		
		mov al, 188d
		stosw

		sub di, 2*2
		std
	
		mov cx, dx
		shr cx, 1

		call PrintHorizontal

		mov al, 200d
		stosw

		std
		sub di, 79*2

		mov cx, bx
Left:
		mov al, 186d
		mov ah, WHITE

		stosw

		sub di, 79*2
		call Delay

		loop Left

		ret
endp PrintFrame

end Start
