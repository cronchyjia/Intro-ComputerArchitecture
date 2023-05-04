; a2-signalling.asm
; University of Victoria
; CSC 230: Spring 2023
; Instructor: Ahmad Abdullah
;
; Student name: Jiayue Wong
; Student ID: V00------
; Date of completed work: 3/2/2023
;
; *******************************
; Code provided for Assignment #2 
;
; Author: Mike Zastre (2022-Oct-15)
;
 
; This skeleton of an assembly-language program is provided to help you
; begin with the programming tasks for A#2. As with A#1, there are "DO
; NOT TOUCH" sections. You are *not* to modify the lines within these
; sections. The only exceptions are for specific changes changes
; announced on Brightspace or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****

.include "m2560def.inc"
.cseg
.org 0

; ***************************************************
; **** BEGINNING OF FIRST "STUDENT CODE" SECTION ****
; ***************************************************

	; initializion code will need to appear in this
    ; section
	.def loop_counter = r18

	sts DDRL, r16
	out DDRB, r16

	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r16, HIGH(RAMEND)
	out SPH, r16


; ***************************************************
; **** END OF FIRST "STUDENT CODE" SECTION **********
; ***************************************************

; ---------------------------------------------------
; ---- TESTING SECTIONS OF THE CODE -----------------
; ---- TO BE USED AS FUNCTIONS ARE COMPLETED. -------
; ---------------------------------------------------
; ---- YOU CAN SELECT WHICH TEST IS INVOKED ---------
; ---- BY MODIFY THE rjmp INSTRUCTION BELOW. --------
; -----------------------------------------------------

	rjmp test_part_a
	; Test code


test_part_a:
	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00111000
	rcall set_leds
	rcall delay_short

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds

	rjmp end


test_part_b:
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds

	rcall delay_long
	rcall delay_long

	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds

	rjmp end

test_part_c:
	ldi r16, 0b11111000
	push r16
	rcall leds_with_speed
	pop r16

	ldi r16, 0b11011100
	push r16
	rcall leds_with_speed
	pop r16

	ldi r20, 0b00100000
test_part_c_loop:
	push r20
	rcall leds_with_speed
	pop r20
	lsr r20
	brne test_part_c_loop

	rjmp end


test_part_d:
	ldi r21, 'E'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'A'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long


	ldi r21, 'M'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'H'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	rjmp end


test_part_e:
	ldi r25, HIGH(WORD02 << 1)
	ldi r24, LOW(WORD02 << 1)
	rcall display_message
	rjmp end

end:
    rjmp end






; ****************************************************
; **** BEGINNING OF SECOND "STUDENT CODE" SECTION ****
; ****************************************************

set_leds:
	sts DDRL, r16
	out DDRB, r16

	ldi r18, 0b00000000
	ldi r19, 0b00000000

test_led6:
	mov r17,r16
	andi r17, 0b00000001
	cpi r17, 0b00000001
	breq turn_on_led6

test_led5:
	mov r17,r16
	andi r17, 0b00000010
	cpi r17, 0b00000010
	breq turn_on_led5

test_led4:
	mov r17,r16
	andi r17, 0b00000100
	cpi r17, 0b00000100
	breq turn_on_led4

test_led3:
	mov r17,r16
	andi r17, 0b00001000
	cpi r17, 0b00001000
	breq turn_on_led3

test_led2:
	mov r17,r16
	andi r17, 0b00010000
	cpi r17, 0b00010000
	breq turn_on_led2

test_led1:
	mov r17,r16
	andi r17, 0b00100000
	cpi r17, 0b00100000
	breq turn_on_led1

turn_on:
	sts PORTL, r18
	out PORTB, r19

	ret

turn_on_led6:
	ldi r20, 0b10000000
	add r18, r20
	rjmp test_led5

turn_on_led5:
	ldi r20, 0b00100000
	add r18, r20
	rjmp test_led4

turn_on_led4:
	ldi r20, 0b00001000
	add r18, r20
	rjmp test_led3

turn_on_led3:
	ldi r20, 0b00000010
	add r18, r20
	rjmp test_led2
		
turn_on_led2:
	ldi r20, 0b00001000
	add r19, r20
	rjmp test_led1

turn_on_led1:
	ldi r20, 0b00000010
	add r19, r20
	rjmp turn_on



slow_leds:
	mov r16,r17 ;copy contents of r17 into r16
	rcall set_leds
	rcall delay_long
	ldi r16, 0b00000000 ;turn off all the lights
	rcall set_leds
	ret



fast_leds:
	mov r16,r17
	rcall set_leds
	rcall delay_short
	ldi r16, 0b00000000
	rcall set_leds
	ret



leds_with_speed:
	push ZL
	push ZH ;protects z registers

	in ZL, SPL
	in ZH, SPH
	ldd r17, Z+6 ;loads parameter from the stack

	mov r18, r17
	andi r18, 0b11000000
	cpi r18, 0b11000000
	breq leds_with_speed_slow
	rcall fast_leds
	rjmp finish_speed

leds_with_speed_slow:
	rcall slow_leds

finish_speed:
	pop ZH
	pop ZL
	ret


; Note -- this function will only ever be tested
; with upper-case letters, but it is a good idea
; to anticipate some errors when programming (i.e. by
; accidentally putting in lower-case letters). Therefore
; the loop does explicitly check if the hyphen/dash occurs,
; in which case it terminates with a code not found
; for any legal letter.

encode_letter:
	ldi loop_counter, 0b00000000
	push ZL
	push ZH

	ldi r25, 0b00000000

	in ZL, SPL
	in ZH, SPH
	ldd r21, Z+6

	ldi ZL, LOW(PATTERNS)
	ldi ZH, HIGH(PATTERNS)

letter_checker:
	lpm r20, Z
	adiw ZH:ZL, 8 ;skips 8 bits to compare the letters
	cp r21, r20
	breq reset_pointer
	rjmp letter_checker

reset_pointer:
	sbiw ZH:ZL, 7

morse_decoder:
	lpm r20, Z+
	inc loop_counter
	cpi r20, 0x6F ;0x6f is the hexadecimal for o
	breq add_one

shift_left:
	cpi loop_counter, 6
	breq long_or_slow
	lsl r25
	rjmp morse_decoder

continue_to_next:
	cpi loop_counter, 6
	brne shift_left
	breq long_or_slow
	rjmp morse_decoder

add_one:
	inc r25
	rjmp continue_to_next

long_or_slow:
	lpm r20, Z+
	cpi r20, 0x01
	breq is_long
	pop ZH
	pop ZL
	ret

is_long:
	ori r25, 0b11000000
	pop ZH
	pop ZL
	ret



display_message:
	mov ZL, r24
	mov ZH, r25

next_lett:
	lpm r21, Z+
	cpi r21, 0b00000000 ;if character is null end the code
	breq done

	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25
	rcall delay_short
	rjmp next_lett
	
done:
	ret

; ****************************************************
; **** END OF SECOND "STUDENT CODE" SECTION **********
; ****************************************************




; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

; about one second
delay_long:
	push r16

	ldi r16, 14
delay_long_loop:
	rcall delay
	dec r16
	brne delay_long_loop

	pop r16
	ret


; about 0.25 of a second
delay_short:
	push r16

	ldi r16, 4
delay_short_loop:
	rcall delay
	dec r16
	brne delay_short_loop

	pop r16
	ret

; When wanting about a 1/5th of a second delay, all other
; code must call this function
;
delay:
	rcall delay_busywait
	ret


; This function is ONLY called from "delay", and
; never directly from other code. Really this is
; nothing other than a specially-tuned triply-nested
; loop. It provides the delay it does by virtue of
; running on a mega2560 processor.
;
delay_busywait:
	push r16
	push r17
	push r18

	ldi r16, 0x08
delay_busywait_loop1:
	dec r16
	breq delay_busywait_exit

	ldi r17, 0xff
delay_busywait_loop2:
	dec r17
	breq delay_busywait_loop1

	ldi r18, 0xff
delay_busywait_loop3:
	dec r18
	breq delay_busywait_loop2
	rjmp delay_busywait_loop3

delay_busywait_exit:
	pop r18
	pop r17
	pop r16
	ret


; Some tables
.cseg
.org 0x600

PATTERNS:
	; LED pattern shown from left to right: "." means off, "o" means
    ; on, 1 means long/slow, while 2 means short/fast.
	.db "A", "..oo..", 1
	.db "B", ".o..o.", 2
	.db "C", "o.o...", 1
	.db "D", ".....o", 1
	.db "E", "oooooo", 1
	.db "F", ".oooo.", 2
	.db "G", "oo..oo", 2
	.db "H", "..oo..", 2
	.db "I", ".o..o.", 1
	.db "J", ".....o", 2
	.db "K", "....oo", 2
	.db "L", "o.o.o.", 1
	.db "M", "oooooo", 2
	.db "N", "oo....", 1
	.db "O", ".oooo.", 1
	.db "P", "o.oo.o", 1
	.db "Q", "o.oo.o", 2
	.db "R", "oo..oo", 1
	.db "S", "....oo", 1
	.db "T", "..oo..", 1
	.db "U", "o.....", 1
	.db "V", "o.o.o.", 2
	.db "W", "o.o...", 2
	.db "W", "oo....", 2
	.db "Y", "..oo..", 2
	.db "Z", "o.....", 2
	.db "-", "o...oo", 1   ; Just in case!

WORD00: .db "HELLOWORLD", 0, 0
WORD01: .db "THE", 0
WORD02: .db "QUICK", 0
WORD03: .db "BROWN", 0
WORD04: .db "FOX", 0
WORD05: .db "JUMPED", 0, 0
WORD06: .db "OVER", 0, 0
WORD07: .db "THE", 0
WORD08: .db "LAZY", 0, 0
WORD09: .db "DOG", 0

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================

