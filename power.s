		AREA power, CODE, READWRITE

x		EQU 4							;integer constant x - base used to compute x^n
n		EQU 4							;non-negative integer constant 'n' - exponent used to compute x^n
zero	EQU 0							;constant integer 0
one		EQU 1							;constant integer 1
		ENTRY
;--------------------------------------------------------------------------------------------	
MAIN	ADR sp, stack					;define the stack
		
		MOV r0, #n						;prepare the parameter n
		MOV r1, #x						;prepare the parameter x
		STR r0, [sp, #-4]!				;push the exponent parameter n on the stack
		STR r1, [sp, #-4]!				;push the base parameter x on the stack
		
		SUB sp, sp, #4					;reserve a place in the stack for the return value
		
		BL POWER						;call the power subroutine to calculate x^n
		
		LDR	r0, [sp], #4				;load the result in r0 and pop it from the stack
		ADD sp, sp, #8					;remove the parameters from the stack

		ADR r10, result					;get the addres of the result variable
		STR r0, [r10]					;store the final result in the result variable
		
Loop 	B Loop							;infinte loop
;--------------------------------------------------------------------------------------------		
		AREA power, CODE, READWRITE

POWER	STMFD sp!, {r0, r1, r2, fp, lr}	;push general registers, as well as fp and lr onto stack
		MOV fp, sp						;set the fp for this call
		LDR r0, [fp, #28]				;get the parameter n from the stack
		LDR r1, [fp, #24]				;get the parameter x from the stack

BASE	CMP r0, #zero					;if (n=0), Base Case
		MOVEQ r0, #one					;{prepare the value to be returned
		STREQ r0, [fp, #20]				;store the returned value in the stack
		BEQ RETURN						;branch to the return section
										;}
		
Test	TST r0, #one					;test if the last bit is 1 (i.e. is n an odd number)
		BNE ODD							;if n is odd jump to ODD
		BEQ EVEN						;if n is even jump to EVEN
		
ODD		SUB r0, r0, #one				;decrease the exponent n by 1 (i.e. n-1)
		STR r0, [sp, #-4]!				;push the new exponent n onto the stack
		STR r1, [sp, #-4]!				;push the parameter x onto the stack
		SUB sp, sp, #4					;reserve space for local variable y (i.e. return value)
		BL POWER						;call the POWER subroutine i.e. power(x, n-1)
		LDR r0, [sp], #4				;load the result in r0 and pop it from the stack
		ADD sp, sp, #8					;remove the parameters from the stack
		MUL r1, r0, r1					;prepare the value to be returned - multiply the result by x i.e. x * power(x, n-1)
		STR r1, [fp, #20]				;store the returned value in the stack
		BL RETURN						;jump to RETURN
		
EVEN	LSR r0, r0, #one				;shift n right by 1 (i.e. divide n by 2)
		STR r0, [sp, #-4]!				;push the new exponent n onto the stack
		STR r1, [sp, #-4]!				;push the parameter x onto the stack
		SUB sp, sp, #4					;reserve space for local variable y (i.e. return value)
		BL POWER						;call the POWER subroutine i.e. power(x, n-1)
		LDR r0, [sp], #4				;load the result in r0 and pop it from the stack
		ADD sp, sp, #8					;remove the parameters from the stack
		
		MUL r2, r0, r0					;Square the result to get the new return value i.e. y*y
		STR r2, [fp, #20]				;store the returned value in the stack
	
RETURN 	MOV sp,fp						;collapse all working spaces for this function call
		LDMFD sp!,{r0, r1, r2, fp, pc}	;load all registers and return to the caller
;--------------------------------------------------------------------------------------------
		AREA power, DATA, READWRITE
result	DCD	0x00						;final result
		SPACE 300						;declare the space for the stack
stack	DCD 0x00						;initial stack position (Full Descending model)
;--------------------------------------------------------------------------------------------	
		END
