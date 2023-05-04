; Assignment #1 
; Student Name: Jiayue Wong
; V Number: V00------
;
; Problem 1 - adds 16 bit values
; Please copy your code for Problem 1 here between START and STOP marks
; and do not modify any other lines
; START -----------------------------------------------------------------

.cseg
.org 0 ;begins assembling at address 0

add16:
.def num1L=r16 ; R16 holds X low byte
.def num1H=r17
.def num2L=r18 ; R16 holds Y low byte
.def num2H=r19
.def flow=r20

	ldi flow, 0x00

	movw num1H:num1L, r27:r26 ; copy the contents of r27:r26(x) into r17:r16 
	movw num2H:num2L, r29:r28

	add num1L, num2L ; add the lower bytes together
	adc num1H, num2H ; add the higher bytes and includes carry bit

	brcs overflow ; branch if carry set
	movw r31:r30, num1H:num1L

overflow: 
	ldi flow, 0x01
	mov r0, flow ; copy r20 to r0
	movw r31:r30, num1H:num1L
	rjmp done

done: 
	ret
; STOP ------------------------------------------------------------------
;
;
;
;
;
; Problem 2 - Checks for odd
; Please copy your code for Problem 2 here between START and STOP marks
; and do not modify any other lines
; START -----------------------------------------------------------------

.cseg
.org 0

add_prity:
.def counter=r17
.def num=r18
.def oddCheck=r20
.def makeOdd=r21
.equ loopTimes=0x08 ; only want the loop to occur max 8 times
	
	ldi makeOdd, 0b10000000
	ldi oddCheck, 0b00000001
	ldi r16, loopTimes
	ldi counter, 0x00

	mov num,r26 ; copy r26 to r18

loop:
	dec r16 ; decrement until zero flag set
	cpi r16,0
	breq isItOdd
	lsr num ; logical shift right the number
	brcs increment ; branch if a carry is set '1'
	jmp loop

increment: 
	inc counter ; increment counter for every '1'
	rjmp loop

isItOdd:
	and counter,oddCheck ; if counter is 1 - odd, if counter 0 - even
	cpi counter,1
	breq itIsOdd
	mov r30,r26
	jmp done

itIsOdd:
	or makeOdd,r26 ; changes the 7th bit of our original byte to 1
	mov r30,makeOdd
	jmp done

done: 
	ret
; STOP ------------------------------------------------------------------

