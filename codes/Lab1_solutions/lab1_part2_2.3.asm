;-----------------------------------------------------------------------------
;--------------
;TITLE: LAB1-PART2 2.3:readnibble
;AUTHOR : G V N DINESH KUMAR (WADHWANI ELECTRONICS LAB)

;Write a subroutine readNibble which will read  the  binary  value 
;which  is  set  on  the  port  using  pins  of  port  1(P1.3-P1.0).   The subroutine should display this 
;value on the pins of port 1 (P1.4 to P1.7) for 5 seconds and store the nibble as the last four bits of 
;location 4EH.Once it is displayed, the program should clear the pins P1.7-P1.4 for one second and call readNibble again 
;to read the new value from the pins (P1.0 to P1.3). 
;If the read valueequals to 0FH, the program should display the value stored at 4EH(the previously readnibble),
;otherwise, display the new value.
;-----------------------------------------------------------------------------
;--------------
org 00h
ljmp main
org 100h
;--------------------------------------------------------------------------------------------
;Delay sub routine whcih generates delay,D
delay:
	USING 0			;assembler directive that indicates to assembler register bank0
	PUSH 0E0H
	PUSH AR0 		;pushing the registers which are going to be
	PUSH AR1 		;used by this subroutine
	PUSH AR2
	MOV A, 4FH 		;Move the value of D from 4FH to A
	MOV B, #10 		;Load 10 in B
	MUL AB     		;Multiply 10 with D to get the number of iterations for the 50ms loop
	MOV R0, A  		;Move the result to R0 which is used as the iterator in the loop
	BACK1:
				;the following is a nested loop which generates a
				;delay of 50ms. This delay has been iterated 10D
				;times to get a total delay of 500Dms = D/2 seconds
		MOV R2,#200
		BACK2:
			MOV R1,#0FFH
			BACK3:
				DJNZ R1, BACK3
			DJNZ R2, BACK2
		DJNZ R0, BACK1
	POP AR2 		;popping the register in the exact reverse order before
	POP AR1 		;exiting from the subroutine
	POP AR0
	POP 0E0H
	RET
readNibble :
				; Routine to read a nibble and confirm from user
				; First configure Pins 1.0 to P1.3 as input and P1.4 to P1.7 as Output.
				; To configure port as Output clear it
				; To configure port as input, set it.
				; Logic to read a 4 bit nibble and get confirmation from user
	loop:
				;turn on all 4 leds which tells routine is ready to accept input
		mov p1, #0ffh
				;wait for 5 sec during which user can give input through P1.0 to P1.3
		mov 4fh, #10 	;moving 10 to 4FH to generate a delay of 5 seconds from LCALL
		lcall delay
				;turn off P1.4 to P1.7
		mov p1, #0fh
				;read the input from switches (nibble)
		mov r0, p1 	;P1 is saved in R0
				;wait for one sec
		mov 4fh, #2
		lcall delay
				;show the read value on P1.4 to P1.7
		mov a, r0 	;moving the read value from R0 to ACC
		swap a
		orl a, #0fh
		mov p1, a
				;wait for 5 sec
		mov 4fh, #10
		lcall delay
				;clear P1.4 to P1.7
		mov p1, #0fh
				;read the input from P1.0 to P1.3
		mov a, p1
		cjne a, #0fh, loop
	mov 4eh, r0 		;moving the previously read nibble to lower bits of 4EH
	ret
main:
	lcall readNibble
	
here: sjmp here

end