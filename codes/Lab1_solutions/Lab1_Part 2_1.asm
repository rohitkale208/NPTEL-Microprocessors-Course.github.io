;-----------------------------------------------------------------------------
;--------------
;TITLE: LAB1-PART2 2.1
;AUTHOR : G V N DINESH KUMAR (WADHWANI ELECTRONICS LAB)

;Write  an  assembly  program  to  toggle  port  pin  P1.7  at  specific  intervals.   
;At  location 4FH a user specified integer Dis stored. 
;You should write a subroutine called delay.
;When it is called it should read the value of D and insert a delay ofD/2 seconds.  
;Then write a main program which will call delayin a loop and toggle port pin P1.7 by setting it ON for D/2 seconds 
;and clearing it OFF forD/2 seconds.D will satisfy the following constraint:  1≤D≤10.
;-----------------------------------------------------------------------------
;--------------
ORG 00H	 		;Complier Directive to start storing code from 00H
LJMP MAIN		;Jump to main program

ORG 100H		;Complier Directive to start storing code from 100H



MAIN:
				SETB P1.7
			   	MOV R3,4FH	;READING D
				MOV R5,4FH
				BACK3:
						LCALL DELAY		;for generating delay of D/2 
						DJNZ R3, BACK3
				CLR P1.7	
				BACK5:
						LCALL DELAY		;for generating delay of D/2 
						DJNZ R5, BACK5
				SJMP MAIN
--------------------------------------------------------------------------------------------

;following is a nested loop which generates 0.5 second
--------------------------------------------------------------------------------------------
DELAY: ; 0.5 second delay

		MOV R0, #10
		BACK2: ; 0.05 second delay 
				MOV R2,#200
				BACK1:
						MOV R1,#0FFH
						BACK :
								DJNZ R1, BACK
				DJNZ R2, BACK1
				
		DJNZ R0, BACK2
RET

END