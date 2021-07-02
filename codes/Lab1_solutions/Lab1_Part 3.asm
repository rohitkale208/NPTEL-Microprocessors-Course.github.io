;-----------------------------------------------------------------------------
;--------------
;TITLE: LAB1-PART3 :Array Manipulation
;AUTHOR : G V N DINESH KUMAR (WADHWANI ELECTRONICS LAB)

;Store 10 elements of an array by reading the port.  
;If the original array is A[0], A[1], . . . A[9],
;Generate the array B, such that it contains
;A[0] XOR A[1], A[1] XOR A[2], . . . A[8] XOR A[9], A[9] XOR A[0]
;Now  display  the elements of  this  new array  by  reading  the  index  from the  port-1 as  inthe previous part, 
;stopping when the given index is>9.  Location of first element of array A starts from 60H 
;and Location of first element of array B starts from 70H.
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
	push ar0 	;pushing the registers being used in this program
	push ar1
	mov r0, #10 	;R0 = number of bytes to be read
	mov r1, #60h 	;R1 = starting address from where the read bytes need to be stored
	loop_readValues:
		lcall packNibble ;packnibble will read and store 1 byte in 4FH
		mov @r1, 4fh 	 ;moving the read byte from 4FH to the required address
		inc r1 		 ;R1 = R1 + 1
		djnz r0, loop_readValues
	pop ar1 		;popping the registers before returning
	pop ar0
	ret

array_manipulate:
	using 0
	push ar0 		;pushing the registers being used in this program
	push ar1
	push ar2
	mov r2, #10 		;R2 = the number of elements in the array
	mov r0, #60h		;R0 = pointer to the first array starting
	mov r1, #70h 		;R1 = pointer to the second array starting
	dec r2 			;the loop runs 10 times
	loop_back:
		mov a, @r0 	;ACC = @R0
		inc r0 		;R0 = R0 + 1
		xrl a, @r0 	;ACC = ACC^@R0
		mov @r1, a 	;@R1 = ACC
		inc r1 		;R1 = R1 + 1
		djnz r2, loop_back
	mov a, @r0 		;
	mov r0, 51h 		;R0 = the starting address of the array A
	xrl a, @r0 		;ACC = ACC^A[0]
	mov @r1, a 		;moving ACC to the specified location
	pop ar2 		;popping the registers before returning
	pop ar1
	pop ar0
	ret

displayValues:
	push ar0 		;pushing the registers being used in this program
	push ar1
	push ar2
	push ar3
	next:
		mov a, #10	;ACC = the number of elements of Array B
		mov r1, #70h 	;r1 = address of the first location of array B
		mov p1, #0fh 	;set the internal latches of the lower nibble high to read P1
		mov r0, p1 	;reading P1 and storing in R0
		mov r2, p1 	;r2 = the value read from port
		clr c 		;clear carry as the next instruction is subtract
		subb a, r0 	;subtract R0 from ACC
		jc next 	;if carry is set then jump to displayValues
		mov a, r2 	;else move the address of the first byte to ACC
		add a, r1 	;add the value read from the port
		mov r1, a 	;move the result of addition to R1
		dec r1 		;decrement R1 to get to the actual location of the required byte
		mov a, @r1 	;move the byte to be displayed to ACC
		mov p1, a 	;move the value from ACC to P1
		swap a 		;swap ACC to get the lower nibble from A4 to A7
		mov r3, a 	;move ACC to R3 since ACC might get modified in the delay subroutine
		mov 4fh, #4 	;moving #4 in 4fh as delay of 2 seconds is needed
		lcall delay 	;delay of 2 seconds
		mov p1, r3 	;display the lower nibble
		lcall delay
		jmp next 	;jump back to the start of the subroutine to display continuously
	pop ar3 		;popping the registers before returning
	pop ar2
	pop ar1
	pop ar0
	ret

MAIN:
	LCALL readValues	;call subroutine to input array A elements	
	LCALL array_manipulate	;call subroutine to do xor of adjacent elements
	
	LCALL displayValues	;Display of elements of array B
	
here:SJMP here
END