;-----------------------------------------------------------------------------
;--------------
;TITLE: LAB1-PART2 2.5:read 10 bytes
;AUTHOR : G V N DINESH KUMAR (WADHWANI ELECTRONICS LAB)

;The  program  should  read  in  10  bytes  this  way,  storing  them  in  an  array  in  memory starting from 60H. 
;After doing this, the program should read another 4 bit value fromthe port pins P1.0 to P1.3.  
;If this value is greater than 09, the program should clearsthe pins P1.4 to P1.7 and stop.  
;Otherwise, this value should be used as an index in the stored array.  
;The corresponding byte value should be displayed on Pins P1.4 to P1.7 
;with higher nibble first followed by lower nibble with a delay of 2 seconds.
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
		PUSH AR0 		;pushing the registers which are going to be
		PUSH AR1 		;used by this subroutine
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
		POP AR1			;popping the register in the exact reverse order before
		POP AR0 		;exiting from the subroutine
	
	ret

packNibble:
	push ar0 		;push the registers being used in this program
	lcall readnibble 	;call readNibble to read the 4 bits and store it in lower 4 bits of 4EH
	mov a, 4eh 		;move the read value from 4EH to ACC
	swap a 			;swapping ACC as the 4 bits read are the higher 4 bits of the byte to be read
	anl a, #0f0h 		;ensuring that the value in the ACC has lower 4 bits as zeroes
	mov r0, a 		;moving ACC to R0 as the next call to readNibble might alter ACC
	lcall readnibble 	;call readNibble to read the 4 bits and store it in lower 4 bits of 4EH
	mov a, 4eh 		;move the read value from 4EH to ACC
	anl a, #0fh 		;ensuring that the value in the ACC has higher 4 bits as zeroes
	orl  a,r0	;R0 = R0|ACC, since R0 had upper 4 bits only and ACC had lower 4 bits
	mov 4fh, a 		;finally moving the whole byte read from R0 to 4FH
	pop ar0 		;popping the registers before returning
	ret
readValues:
	push ar0 		;pushing the registers being used in this program
	push ar1
	mov r0,#10 		;R0 = number of bytes to be read
	mov r1,#60h 		;R1 = starting address from where the read bytes need to be stored
	loop_readValues:
		lcall packNibble ;packnibble will read and store 1 byte in 4FH
		mov @r1, 4fh	 ;moving the read byte from 4FH to the required address
		inc r1 		 ;R1 = R1 + 1
		djnz r0, loop_readValues
	pop ar1 		 ;popping the registers before returning
	pop ar0
	ret

main:
	
	lcall readValues
	mov 4fh,#2		;to read last value
	lcall delay
	mov p1, #0fh 		;set the internal latches of the lower nibble high to read P1
	mov r0, p1 		;reading P1 and storing in R0
	mov r2, p1 		;r2 = the value read from port
	clr c			;clear carry as the next instruction is subtract
	mov a,#10 		;10 bytes
	subb a, r0 		;subtract R0 from ACC
	jc return 		;if carry is set then, input from port > K, jump to displayValues
	mov a, r2 		;else move the address of the first byte to ACC
	add a, #60 		;add the value read from the port
	mov r1, a		;move the result of addition to R1
	dec r1 			;decrement R1 to get to the actual location of the required byte
	mov a, @r1		;move the byte to be displayed to ACC
	mov p1, a 		;move the value from ACC to P1
	swap a 			;swap ACC to get the lower nibble from A4 to A7
	mov r3, a 		;move ACC to R3 since ACC might get modified in the delay subroutine
	mov 4fh, #4 		;moving #4 in 4fh as delay of 2 seconds is needed
	lcall delay 		;delay of 2 seconds
	mov p1, r3 		;display the lower nibble
	lcall delay
return:
here: sjmp here

end