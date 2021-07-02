;-----------------------------------------------------------------------------;--------------
;TITLE: LAB1-PART2 2: ASCII character representation
;AUTHOR : VIKASH KUMAR (WADHWANI ELECTRONICS LAB)
;Write an assembly language program to generate programmable software delay which is

multiple of 0.25 milli seconds. It should accept a 8 bit value as a count

Org 0h
ljmp main
Org 100h
main: 
	MOV R2,41h  ;load the count value from memory location 41H.
 	lcall delay
here :sjmp here

delay:  ;subroutein for delay of 0.25 milli seconds
	BACK1:
		MOV R1,#0FFH
		BACK :
			DJNZ R1, BACK
		DJNZ R2, BACK1
	ret