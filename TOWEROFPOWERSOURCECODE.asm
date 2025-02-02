org 00h
very_very_start:
	mov 0x3A, #00000000b
	mov 0x19, #0
	mov 0x1b, #0

very_start:
	jnb p3.0, very_start
	mov sp, 0x08
	mov 0x38, #00000001b
	mov 0x39, #00001000b
	acall new_pillar

start:
	mov 0x49, #15
ddd:
	mov 0x31, #7
	mov 0x32, #7

; Downward motion
loop1:
	acall display
	acall inputing
	mov a, 0x38
	rl a
	mov 0x38, a
	djnz 0x31, loop1

; Upward motion
loop2:
	acall display
	acall inputing
	mov a, 0x38
	rr a
	mov 0x38, a
	djnz 0x32, loop2

	djnz 0x49, ddd
	sjmp start


display:
	mov 0x40, #3
disp:
; Display for the right bar (continuously moving)
	mov p1, 0x38
	mov p0, #11110000b
	acall delay
	acall again
; Display for the left bar (randomly spawn)
	mov p1, 0x39
	mov p0, #00001111b
	acall delay
	acall again
; Display for health bars
	mov p2, #10000000b
	mov p0, 0x3A
	acall delay
	acall again2

	acall score
	acall again2

	djnz 0x40, disp

	ret

; For turning off the Led matrix (left side)
again:
	mov p1, #0
	mov p0, #255
	ret
; For turning off the Led matrix (right side)
again2:
	mov p2, #0
	mov p0, #255
	ret
; To check if the player clicked the button
inputing:
	mov 0x3B, p3
	mov a, 0x3B
	cpl a
	jnb p3.0, input
	ret
; If the player clicked the button
input:
	mov a, 0x38
	cjne a, 0x39, bad1	; Check if the left bar aligned with the right bar
	sjmp good

bad1:
	acall bad

; If the player aligns the two bar
good:
	mov 30h, #10
disp1:
; Display the +1 animation
	mov p0, #11011111b
	mov p1, #00011100b
	acall delay
	acall again

	mov p0, #10001111b
	mov p1, #00001000b
	acall delay
	acall again

	mov p0, #11111001b
	mov p1, #00000010b
	acall delay
	acall again

	mov p0, #11111101b
	mov p1, #01111110b
	acall delay
	acall again

	mov p0, #11111000b
	mov p1, #01000000b
	acall delay
	acall again
; Display the Smiley Face animation
	mov p2, #00000100b
	mov p0, #11111000b
	acall delay
	acall again2

	mov p2, #00001000b
	mov p0, #11111010b
	acall delay
	acall again2

	mov p2, #00000100b
	mov p0, #00011111b
	acall delay
	acall again2

	mov p2, #00001000b
	mov p0, #01011111b
	acall delay
	acall again2

	mov p2, #01000000b
	mov p0, #11000011b
	acall delay
	acall again2

	mov p2, #00100000b
	mov p0, #10111101b
	acall delay
	acall again2

	djnz 30h, disp1

; For score
	mov 0x08, #0
	mov 0x0A, #0
	mov 0x0C, #0
	inc 0x19		;incrementing the first digit by 1
	mov a, 0x19
	cjne a, #10, lol	;to check if the first digit has reached 10 or greater than 9
	mov 0x19, #0		;to reset it back to 0
	inc 0x1b		;to increment the second digit by 1
	lol:
	ljmp very_start

; If the players did not align the two bars
bad:
	mov 30h, #25
disp2:
; Display Sad face to Right side LED matrix
	mov p2, #00000100b
	mov p0, #11111000b
	acall delay
	acall again2

	mov p2, #00001000b
	mov p0, #11111010b
	acall delay
	acall again2

	mov p2, #00000100b
	mov p0, #00011111b
	acall delay
	acall again2

	mov p2, #00001000b
	mov p0, #01011111b
	acall delay
	acall again2

	mov p2, #00100000b
	mov p0, #11000011b
	acall delay
	acall again2

	mov p2, #01000000b
	mov p0, #10111101b
	acall delay
	acall again2
; Display Sad face to Left side LED matrix
	mov p1, #00000100b
	mov p0, #11111000b
	acall delay
	acall again

	mov p1, #00001000b
	mov p0, #11111010b
	acall delay
	acall again

	mov p1, #00000100b
	mov p0, #00011111b
	acall delay
	acall again

	mov p1, #00001000b
	mov p0, #01011111b
	acall delay
	acall again

	mov p1, #00100000b
	mov p0, #11000011b
	acall delay
	acall again

	mov p1, #01000000b
	mov p0, #10111101b
	acall delay
	acall again

	djnz 30h, disp2

	mov 0x08, #0
	mov 0x0A, #0
	mov 0x0C, #0
	mov a, 0x3A
	cjne a, #255, minus_life	; Check if there is still health bar left
	jmp end

; if there is still health bar left then it will decrement the health bar by 1
minus_life:
;complementing the col for health bar then rotating it left to the carry and then clearing it to diminish the 1 bit store in clear, resulting in decrementing the health bar by 1
	clr c
	mov a, 0x3A
	cpl a
	rlc a
	clr c
	cpl a
	mov 0x3A, a
	jmp very_start

; To randomly spawn the left bar after each input
new_pillar:
	inc 0x33
	mov a, 0x33
	cjne a, #21, damn
	mov 0x33, #0
damn:
	mov a, 0x33
	mov dptr, #pillar
	movc a, @a+dptr
	mov 0x39, a
	ret

delay:
	mov 50h, #5
	mov 51h, #5
	loop_delay2:
	loop_delay: djnz 50h, loop_delay
	djnz 51h, loop_delay2
	ret

; Displaying the real-time score on the Right side LED Matrix
score:
	mov a, 0x1b		;for second digit

	cjne a, #0, one_1
;for 00-09 range of score
	mov a, 0x19		;for fist digit
	cjne a, #0, one
	acall dispzero
	acall dispzero2	
	ljmp shesh

one:
	cjne a, #1, two
	acall dispone
	acall dispzero2
	ljmp shesh

two:
	cjne a, #2, three
	acall disptwo
	acall dispzero2
	ljmp shesh

three:
	cjne a, #3, four
	acall dispthree
	acall dispzero2
	ljmp shesh

four:
	cjne a, #4, five
	acall dispfour
	acall dispzero2
	ljmp shesh

five:
	cjne a, #5, six
	acall dispfive
	acall dispzero2
	ljmp shesh

six:
	cjne a, #6, seven
	acall dispsix
	acall dispzero2
	ljmp shesh

seven:
	cjne a, #7, eight
	acall dispseven
	acall dispzero2
	ljmp shesh

eight:
	cjne a, #8, nine
	acall dispeight
	acall dispzero2
	ljmp shesh

nine:
	acall dispnine
	acall dispzero2
	ljmp shesh

; for 10-19 range of score
one_1:
	cjne a, #1, two_1
	mov a, 0x19
	cjne a, #0, one1
	acall dispzero
	acall dispone2
	ljmp shesh

one1:
	cjne a, #1, two1
	acall dispone
	acall dispone2
	ljmp shesh

two1:
	cjne a, #2, three1
	acall disptwo
	acall dispone2
	ljmp shesh

three1:
	cjne a, #3, four1
	acall dispthree
	acall dispone2
	ljmp shesh

four1:
	cjne a, #4, five1
	acall dispfour
	acall dispone2
	ljmp shesh

five1:
	cjne a, #5, six1
	acall dispfive
	acall dispone2
	ljmp shesh

six1:
	cjne a, #6, seven1
	acall dispsix
	acall dispone2
	ljmp shesh

seven1:
	cjne a, #7, eight1
	acall dispseven
	acall dispone2
	ljmp shesh

eight1:
	cjne a, #8, nine1
	acall dispeight
	acall dispone2
	ljmp shesh

nine1:
	acall dispnine
	acall dispone2
	ljmp shesh
; for 20-29 range of score
two_1:
	cjne a, #2, three_1
	mov a, 0x19
	cjne a, #0, one2
	acall dispzero
	acall disptwo2
	ljmp shesh

one2:
	cjne a, #1, two2
	acall dispone
	acall disptwo2
	ljmp shesh

two2:
	cjne a, #2, three2
	acall disptwo
	acall disptwo2
	ljmp shesh

three2:
	cjne a, #3, four2
	acall dispthree
	acall disptwo2
	ljmp shesh

four2:
	cjne a, #4, five2
	acall dispfour
	acall disptwo2
	ljmp shesh

five2:
	cjne a, #5, six2
	acall dispfive
	acall disptwo2
	ljmp shesh

six2:
	cjne a, #6, seven2
	acall dispsix
	acall disptwo2
	ljmp shesh

seven2:
	cjne a, #7, eight2
	acall dispseven
	acall disptwo2
	ljmp shesh

eight2:
	cjne a, #8, nine2
	acall dispeight
	acall disptwo2
	ljmp shesh

nine2:
	acall dispnine
	acall disptwo2
	ljmp shesh
; for 30-39 range of score
three_1:
	cjne a, #3, four_1
	mov a, 0x19
	cjne a, #0, one3
	acall dispzero
	acall dispthree2
	ljmp shesh

one3:
	cjne a, #1, two3
	acall dispone
	acall dispthree2
	ljmp shesh

two3:
	cjne a, #2, three3
	acall disptwo
	acall dispthree2
	ljmp shesh

three3:
	cjne a, #3, four3
	acall dispthree
	acall dispthree2
	ljmp shesh

four3:
	cjne a, #4, five3
	acall dispfour
	acall dispthree2
	ljmp shesh

five3:
	cjne a, #5, six3
	acall dispfive
	acall dispthree2
	ljmp shesh

six3:
	cjne a, #6, seven3
	acall dispsix
	acall dispthree2
	ljmp shesh

seven3:
	cjne a, #7, eight3
	acall dispseven
	acall dispthree2
	ljmp shesh

eight3:
	cjne a, #8, nine3
	acall dispeight
	acall dispthree2
	ljmp shesh

nine3:
	acall dispnine
	acall dispthree2
	ljmp shesh
; for 40-49 range of score
four_1:
	cjne a, #4, five_1
	mov a, 0x19
	cjne a, #0, one4
	acall dispzero
	acall dispfour2
	ljmp shesh

one4:
	cjne a, #1, two4
	acall dispone
	acall dispfour2
	ljmp shesh

two4:
	cjne a, #2, three4
	acall disptwo
	acall dispfour2
	ljmp shesh

three4:
	cjne a, #3, four4
	acall dispthree
	acall dispfour2
	ljmp shesh

four4:
	cjne a, #4, five4
	acall dispfour
	acall dispfour2
	ljmp shesh

five4:
	cjne a, #5, six4
	acall dispfive
	acall dispfour2
	ljmp shesh

six4:
	cjne a, #6, seven4
	acall dispsix
	acall dispfour2
	ljmp shesh

seven4:
	cjne a, #7, eight4
	acall dispseven
	acall dispfour2
	ljmp shesh

eight4:
	cjne a, #8, nine4
	acall dispeight
	acall dispfour2
	ljmp shesh

nine4:
	acall dispnine
	acall dispfour2
	ljmp shesh
; for 50-59 range of score
five_1:
	cjne a, #5, six_1
	mov a, 0x19
	cjne a, #0, one5
	acall dispzero
	acall dispfive2
	ljmp shesh

one5:
	cjne a, #1, two5
	acall dispone
	acall dispfive2
	ljmp shesh

two5:
	cjne a, #2, three5
	acall disptwo
	acall dispfive2
	ljmp shesh

three5:
	cjne a, #3, four5
	acall dispthree
	acall dispfive2
	ljmp shesh

four5:
	cjne a, #4, five5
	acall dispfour
	acall dispfive2
	ljmp shesh

five5:
	cjne a, #5, six5
	acall dispfive
	acall dispfive2
	ljmp shesh

six5:
	cjne a, #6, seven5
	acall dispsix
	acall dispfive2
	ljmp shesh

seven5:
	cjne a, #7, eight5
	acall dispseven
	acall dispfive2
	ljmp shesh

eight5:
	cjne a, #8, nine5
	acall dispeight
	acall dispfive2
	ljmp shesh

nine5:
	acall dispnine
	acall dispfive2
	ljmp shesh

six_1:
	ret
shesh:
	ret
;-----------------------------------------------
;manual code for number 0 to 9 (right side/first digit)
scorezero:
	mov 30h, #1
dispzero:
	mov p0, #11110110b
	mov p2, #00111100b
;	acall delay
	acall again2

	mov p0, #11111001b
	mov p2, #01000010b
;	acall delay
	acall again2

	djnz 30h, dispzero
	ret

scoreone:
	mov 30h, #1
dispone:
	mov p0, #11111001b
	mov p2, #00000010b
;	acall delay
	acall again2

	mov p0, #11111101b
	mov p2, #01111110b
;	acall delay
	acall again2
	
	mov p0, #11111000b
	mov p2, #01000000b
;	acall delay
	acall again2

	djnz 30h, dispone
	ret
	
scoretwo:
	mov 30h, #1
disptwo:
	mov p0, #11110000b
	mov p2, #01001010b
;	acall delay
	acall again2
	
	mov p0, #11111110b
	mov p2, #00001110b
;	acall delay
	acall again2
	
	mov p0, #11110111b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, disptwo
	ret

scorethree:
	mov 30h, #1
dispthree:
	mov p0, #11110000b
	mov p2, #01001010b
;	acall delay
	acall again2

	mov p0, #11111110b
	mov p2, #01111110b
;	acall delay
	acall again2

	djnz 30h, dispthree
	ret

scorefour:
	mov 30h, #1
dispfour:
	mov p0, #11110110b
	mov p2, #00001110b
;	acall delay
	acall again2
	
	mov p0, #11110000b
	mov p2, #00001000b
;	acall delay
	acall again2

	mov p0, #11111110b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, dispfour
	ret

scorefive:
	mov 30h, #1
dispfive:
	mov p0, #11110000b
	mov p2, #01001010b
;	acall delay
	acall again2
	
	mov p0, #11110111b
	mov p2, #00001110b
;	acall delay
	acall again2
	
	mov p0, #11111110b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, dispfive
	ret

scoresix:
	mov 30h, #1
dispsix:
	mov p0, #11110000b
	mov p2, #01001010b
;	acall delay
	acall again2
	
	mov p0, #11110111b
	mov p2, #00001110b
;	acall delay
	acall again2

	mov p0, #11110110b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, dispsix
	ret

scoreseven:
	mov 30h, #1
dispseven:
	mov p0, #11110000b
	mov p2, #00000010b
;	acall delay
	acall again2
	
	mov p0, #11111110b
	mov p2, #01111110b
;	acall delay
	acall again2

	djnz 30h, dispseven
	ret

scoreeight:
	mov 30h, #1
dispeight:
	mov p0, #11110000b
	mov p2, #01001010b
;	acall delay
	acall again2
	
	mov p0, #11110110b
	mov p2, #01111110b
;	acall delay
	acall again2

	djnz 30h, dispeight
	ret

scorenine:
	mov 30h, #1
dispnine:
	mov p0, #11110110b
	mov p2, #00001110b
;	acall delay
	acall again2
	
	mov p0, #11110000b
	mov p2, #00001010b
;	acall delay
	acall again2

	mov p0, #11111110b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, dispnine
	ret

;-----------------------------------------------
;manual code for number 0 to 9 (left side/second digit)
scorezero2:
	mov 30h, #1
dispzero2:
	mov p0, #01101111b
	mov p2, #00111100b
;	acall delay
	acall again2
	
	mov p0, #10011111b
	mov p2, #01000010b
;	acall delay
	acall again2

	djnz 30h, dispzero2
	ret

scoreone2:
	mov 30h, #1
dispone2:
	mov p0, #10011111b
	mov p2, #00000010b
;	acall delay
	acall again2

	mov p0, #11011111b
	mov p2, #01111110b
;	acall delay
	acall again2
	
	mov p0, #10001111b
	mov p2, #01000000b
;	acall delay
	acall again2

	djnz 30h, dispone2
	ret

scoretwo2:
	mov 30h, #1
disptwo2:
	mov p0, #00001111b
	mov p2, #01001010b
;	acall delay
	acall again2
	
	mov p0, #11101111b
	mov p2, #00001110b
;	acall delay
	acall again2
	
	mov p0, #01111111b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, disptwo2
	ret

scorethree2:
	mov 30h, #1
dispthree2:
	mov p0, #00001111b
	mov p2, #01001010b
;	acall delay
	acall again2

	mov p0, #11101111b
	mov p2, #01111110b
;	acall delay
	acall again2

	djnz 30h, dispthree2
	ret

scorefour2:
	mov 30h, #1
dispfour2:
	mov p0, #01101111b
	mov p2, #00001110b
;	acall delay
	acall again2
	
	mov p0, #00001111b
	mov p2, #00001000b
;	acall delay
	acall again2

	mov p0, #11101111b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, dispfour2
	ret

scorefive2:
	mov 30h, #1
dispfive2:
	mov p0, #00001111b
	mov p2, #01001010b
;	acall delay
	acall again2
	
	mov p0, #01111111b
	mov p2, #00001110b
;	acall delay
	acall again2
	
	mov p0, #11101111b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, dispfive2
	ret

scoresix2:
	mov 30h, #1
dispsix2:
	mov p0, #00001111b
	mov p2, #01001010b
;	acall delay
	acall again2
	
	mov p0, #01111111b
	mov p2, #00001110b
;	acall delay
	acall again2

	mov p0, #01101111b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, dispsix2
	ret

scoreseven2:
	mov 30h, #1
dispseven2:
	mov p0, #00001111b
	mov p2, #00000010b
;	acall delay
	acall again2
	
	mov p0, #11101111b
	mov p2, #01111110b
;	acall delay
	acall again2

	djnz 30h, dispseven2
	ret

scoreeight2:
	mov 30h, #1
dispeight2:
	mov p0, #00001111b
	mov p2, #01001010b
;	acall delay
	acall again2
	
	mov p0, #01101111b
	mov p2, #01111110b
;	acall delay
	acall again2

	djnz 30h, dispeight2
	ret

scorenine2:
	mov 30h, #1
dispnine2:
	mov p0, #01101111b
	mov p2, #00001110b
;	acall delay
	acall again2
	
	mov p0, #00001111b
	mov p2, #00001010b
;	acall delay
	acall again2

	mov p0, #11101111b
	mov p2, #01110000b
;	acall delay
	acall again2

	djnz 30h, dispnine2
	ret

; For left bar randomizer
org 700h
	pillar: db 16, 8, 128, 64, 4, 1, 32, 2, 128, 1, 32, 2, 128, 4, 1, 32, 2, 128, 16, 8, 64, 4

;"GG" and score display after four chances or Game Over
end:
gameover:
	mov b, #1
disp389:
	mov p0, #11110000b
	mov p1, #10001000b
	acall delay
	acall again

	mov p0, #11110111b
	mov p1, #11111000b
	acall delay
	acall again

	mov p0, #11111110b
	mov p1, #11100000b
	acall delay
	acall again
	mov p0, #11111100b
	mov p1, #00100000b
	acall delay
	acall again

;------------------------

	mov p0, #00001111b
	mov p1, #00010001b
	acall delay
	acall again

	mov p0, #01111111b
	mov p1, #00011111b
	acall delay
	acall again

	mov p0, #11101111b
	mov p1, #00011100b
	acall delay
	acall again

	mov p0, #11001111b
	mov p1, #00000100b
	acall delay
	acall again

	acall score

	djnz b, disp389

;For resetting/restarting the game when player clicks the button
	jnb p3.0, restart
	sjmp gameover

restart:
	ljmp very_very_start

END