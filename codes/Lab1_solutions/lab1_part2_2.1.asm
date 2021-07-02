;-----------------------------------------------------------------------------;--------------
;TITLE: LAB1-PART2 1:Software Delay for 1 second
;AUTHOR : G V N DINESH KUMAR (WADHWANI ELECTRONICS LAB)

;Use the subroutine developed as homework to make a 1 second timer.  
;The program shouldset the pins P1.4 to P1.7 of Port-1 for about 1 second
;and then clear these off
;-----------------------------------------------------------------------------;--------------
org 0000H	    ;Complier Directive to start storing code from 00H
ljmp main	    ;Jump to main program
org 100H            ;Complier Directive to start storing code from 100H
	
main: 
		setb p1.4;set the pins P1.4 to P1.7
		setb P1.5
		setb p1.6
		setb p1.7
		Acall delay_1_s; Call the delay subroutine of 1 sec
		
		acall main ;jump to the starting of the program to repeat
;-------------------------------------------------------------------------------------------
;Delay subroutine to get 50 millisec delay
;--------------------------------------------------------------------------------------------
;-- the following is a nested loop which generates a delay of 50ms
DELAY_OF_50_MS:
	MOV R2,#200
	BACK1:
	MOV R1,#0FFH
	BACK :
	DJNZ R1, BACK
	DJNZ R2, BACK1
RET
;-------------------------------------------------------------------------------------------
;Delay subroutine to get 1 sec delay
;-------------------------------------------------------------------------------------------
;following is a nested loop which generates 1 sec using 50ms delay subroutine
DELAY_1_S:
	MOV R3,#20  
	LOOP123:
	ACALL DELAY_OF_50_MS
	DJNZ R3,LOOP123
	clr p1.4   ;clearing the pins P1.4 to P1.7
	clr p1.5
	clr p1.6
	clr p1.7
	
RET
;-------------------------------------------------------------------------------------------
END