/*
 * asm_func.s
 *
 *  Created on: 7/2/2025
 *      Author: Hou Linxin
 */
   .syntax unified
	.cpu cortex-m4
	.fpu softvfp
	.thumb

		.global asm_func

@ Start of executable code
.section .text

@ CG/[T]EE2028 Assignment 1, Sem 2, AY 2024/25
@ (c) ECE NUS, 2025

@ Write Student 1’s Name here: Roderick Kong Zhang
@ Write Student 2’s Name here: Gandhi Kishen

@ Look-up table for registers:

@ R0: building[][] (Initial state of the car park)
@ R1: exit[][] (Number of cars exiting each section)
@ R2: entry[] (Number of cars entering the car park. You can assume the size of this array is always 5.)
@ R3: result[][] (Array to store the final cars parked, also containing F, S)
@ R4: F, entry value, section cars
@ R5: S, entry counter, building counter
@ R6: Total cars entered, section cars exiting
@ R8: Pointer to R3
@ R9: Temporary value to store SECTION_MAX
@ R10: Store F*S (length of building[][])
@ R11: Vacancy value

@ Constants
.equ ENTRY_LEN, 5            @ Length of entry array
.equ SECTION_MAX, 12         @ Maximum size of section

asm_func:
    PUSH {LR}                @ Save return address

    @ Get F*S
    LDR R4, [R3]             @ Load F value from [R3] to R4
    LDR R5, [R3, #4]         @ Load S value from [R3] to R5
    MUL R10, R4, R5          @ Store F*S in R10

	@ Get total cars entered
	MOV R5, #0               @ Initialise loop counter to 0
	MOV R6, #0               @ Initialise total cars entered to 0
    SUM_ENTRIES:
	    LDR R4, [R1], #4     @ Load value from R1 into R4 and increment R1 by 4 (pointing to entries[])
	    ADD R6, R4           @ Add R4 to total cars entered
	    ADD R5, #1           @ Increment loop counter
	    CMP R5, ENTRY_LEN    @ Repeat until all 5 entries are summed
	    BNE SUM_ENTRIES

	@ Continue adding cars entered until no cars left
	MOV R5, #0               @ Initialise loop counter to 0
	MOV R8, R0               @ Set R8 as a pointer to building[][]
	ADD_ENTRIES:
		LDR R4, [R8]         @ Load value from R8 into R4
		SUBS R11, R4, #12    @ Get vacancy for section
		NEG R11, R11

	    CMP R6, R11          @ Compare R6 with R11
    	BGT THEN_BLOCK       @ If R6 > R11, branch to THEN_BLOCK (Remaining cars left)
    	B ELSE_BLOCK         @ If R6 <= R11, branch to ELSE_BLOCK (No remaining cars)

	    THEN_BLOCK:
	    	MOV R9, SECTION_MAX
	        STR R9, [R8], #4 @ Store section cars in building[][] and move pointer R8 to next section
	    	SUB R6, R11      @ Cars left -= vacancy
	    	ADD R5, #1       @ Increment loop counter
	    	CMP R5, R10      @ Check if there are any sections left
	    	BNE ADD_ENTRIES
	    ELSE_BLOCK:
	    	ADD R4, R6       @ Add remaining cars to section
	    	STR R4, [R8], #4 @ Store section cars in building[][]
	    	MOV R6, #0       @ Set cars left to 0

	@ Remove exited cars from each section
	MOV R5, #0               @ Initialise loop counter to 0
	MOV R8, R0               @ Set R8 as a pointer to building[][]
	REMOVE_EXITS:
		LDR R4, [R8], #4     @ Get section cars and move pointer R8 to next section
		LDR R6, [R2], #4     @ Get exited cars and move pointer R2 to next section
		SUB R4, R6           @ Cars left -= exited cars
		STR R4, [R3], #4     @ Store cars left in result[][]
		ADD R5, #1           @ Increment loop counter
		CMP R5, R10          @ Continue for all sections
		BNE REMOVE_EXITS

    POP {LR}                 @ Restore return address
    BX LR                    @ Return
