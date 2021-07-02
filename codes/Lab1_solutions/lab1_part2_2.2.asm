;-----------------------------------------------------------------------------;--------------
;TITLE: LAB1-PART2 2: ASCII character representation
;AUTHOR : VIKASH KUMAR (WADHWANI ELECTRONICS LAB)

;Use this subroutine which converts a byte in binary to two ASCII characters representing its Hexadecimal representation.
Org 0h
ljmp main
Org 100h
main:

MOV A, #4AH   ;  For example 4AH is placed in Accumulator

	MOV R0 ,A        ; Store the given bytes in  register R0
	ANL A, #0Fh      ; Accumulator is and with OFH to get lower nibble 
	MOV R1,A         ; Store lower nibble in R1
    acall ASCII_SUB	 ; calling subroutine ASCII_SUB which returns ASCII characters representing its hexadecimal 
	MOV B,A          ; Store ASCII character of lower nibble in Register B
	MOV A, R0        ; Restore the initial bytes
	ANL A, #0F0H     ; Accumulator is and with F0H to get upper nibble 
	SWAP A           ; swap Accumulator
	MOV R1,A         ; Store upper nibble in R1
	acall ASCII_SUB	 ; calling subroutine ASCII_SUB which returns ASCII characters representing its hexadecimal 
	
	HERE:SJMP HERE           ; Keep waiting here once task done
		ASCII_SUB:           ; subroutine which returns ASCII characters representing its hexadecimal
				CLR C        ; clear the carry flag 
				SUBB A, #0AH ; Subtract 0AH from Accumulator
				JC NUM1      ; carry bit is high when A has value between 0-9
				ADD A, #41H  ; ADD 41H to get ASCII value for Alphabet
				ret          ; return
				NUM1:        
					MOV A,R1 ; store R1 to Accumulator
					ADD A, #30H ;ADD 30H to get ASCII value for numeric
				ret          ;return

end
