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

@ Write Student 1’s Name here:
@ Write Student 2’s Name here:

@ Look-up table for registers:

@ R0 ...
@ R1 ...
@ ...

@ write your program from here:

asm_func:
    PUSH {LR}          @ Save return address

    MOV R0, #8         @ Zero value to store

	STR R0, [R3]
    STR R0, [R3, #4]   @ Store 0 at array[0][1]
    STR R0, [R3, #8]   @ Store 0 at array[1][0]
    STR R0, [R3, #12]  @ Store 0 at array[1][1]
    STR R0, [R3, #16]  @ Store 0 at array[2][0]
    STR R0, [R3, #20]  @ Store 0 at array[2][1]

    BL SUBROUTINE      @ Call subroutine

    POP {LR}           @ Restore return address
    BX LR              @ Return

SUBROUTINE:
    BX LR              @ Simply return

/*
.equ FLOORS, 3
.equ SECTIONS, 2
.equ SECTION_MAX, 12
.equ ENTRY_SIZE, 5  @ Maximum size of entry array

@ Function: asm_func(int* building, int* entry, int* exit, int* result)
asm_func:
    PUSH {R4-R12, LR}        @ Save registers

    MOV R4, R0               @ R4 = building (source)
    MOV R5, R1               @ R5 = entry (source)
    MOV R6, R2               @ R6 = exit (source)
    MOV R7, R3               @ R7 = result (destination)

    @ Step 1: Copy building to result (Deep Copy)
    MOV R8, #0               @ Floor index i
    MOV R9, #0               @ Section index j

copy_building:
    LDR R10, [R4], #4        @ Load building[i][j]
    STR R10, [R7], #4        @ Store in result[i][j]

    ADD R9, R9, #1           @ j++
    CMP R9, #SECTIONS
    BLT copy_building
    MOV R9, #0               @ Reset section index
    ADD R8, R8, #1           @ i++
    CMP R8, #FLOORS
    BLT copy_building

    @ Step 2: Calculate total entry cars (Sum of entry[])
    MOV R8, #0               @ Index
    MOV R10, #0              @ entry_total = 0

sum_entry:
    LDR R11, [R5, R8, LSL #2] @ Load entry[i]
    ADD R10, R10, R11        @ entry_total += entry[i]
    ADD R8, R8, #1
    CMP R8, #ENTRY_SIZE
    BLT sum_entry

    @ Step 3: Distribute Entry Cars into Parking Sections
    MOV R8, #0               @ Floor index
    MOV R9, #0               @ Section index
    MOV R11, R10             @ R11 = Remaining entry_total

process_entry:
    LDR R12, [R7, R9, LSL #2] @ Load result[i][j]
    MOV R10, #SECTION_MAX
    SUB R10, R10, R12         @ vacancy = SECTION_MAX - result[i][j]
    CMP R10, R11              @ Compare vacancy with remaining cars
    BGT partial_fill

    MOV R12, #SECTION_MAX     @ Set section to max capacity
    SUB R11, R11, R10         @ Subtract cars from entry_total
    STR R12, [R7, R9, LSL #2] @ Store SECTION_MAX
    B continue_entry

partial_fill:
    ADD R12, R12, R11         @ Add remaining cars
    MOV R11, #0               @ All cars placed
    STR R12, [R7, R9, LSL #2] @ Store updated count

continue_entry:
    ADD R9, R9, #1            @ Increment section index
    CMP R9, #SECTIONS
    BLT process_entry
    MOV R9, #0                @ Reset section index
    ADD R8, R8, #1            @ Increment floor index
    CMP R8, #FLOORS
    BLT process_entry

    @ Step 4: Process Exiting Cars
    MOV R8, #0               @ Floor index
    MOV R9, #0               @ Section index

process_exit:
    LDR R10, [R6, R8, LSL #2] @ Load exit[i][j]
    LDR R11, [R7, R9, LSL #2] @ Load result[i][j]
    SUB R11, R11, R10         @ Subtract exit[i][j]
    STR R11, [R7, R9, LSL #2] @ Store updated result[i][j]

    ADD R9, R9, #1            @ Increment section index
    CMP R9, #SECTIONS
    BLT process_exit
    MOV R9, #0                @ Reset section index
    ADD R8, R8, #1            @ Increment floor index
    CMP R8, #FLOORS
    BLT process_exit

    @ Final Step: Store the updated result back
    POP {R4-R12, LR}          @ Restore registers
    BX LR                     @ Return

@ Optional subroutine (not used in this example)
SUBROUTINE:
    BX LR                     @ Return from subroutine
*/
