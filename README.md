# CG2028 Computer Organisation Project

This group project was completed as part of the CG2028 Computer Organisation course taught at the National University of Singapore (NUS). For this project, we are required to code out an assembly function to solve a carpark assignment problem. We are required to use the STM32L475 ARM Cortex-M4 board to run the code. The main C program calls the assembly function, which then returns the result in the array specified by the pointer. For more details, view the full report [here](Documents/Assignment1_51_A0286550Y_A0266842W_Report.pdf).

## Table of Contents
1. [Project Overview](#project-overview)
1. [Assignment Questions](#assignment-questions)
1. [Machine Code](#machine-code)
1. [Microarchitecture Design](#microarchitecture-design)
1. [Discussion of Improvements Made to Enhance Efficiency](#discussion-of-improvements-made-to-enhance-efficiency)

## Project Overview

A smart parking system is implemented in a multi-story car park. The car park has F floors and S parking sections on each floor. The system tracks the cars parked in the parking sections in real-time. At the start of each day, the system records the number of cars parked on each floor. Throughout the day, cars enter the car park from time to time. The cars only exit the car park at the end of a day. The objective of this assignment is to develop a system that updates the cars parked at the end of the day, considering the initial state, cars entering, and cars exiting.

![image](https://github.com/user-attachments/assets/7caa31c7-2ac2-4231-bc7e-7c35b6d5483f)

The above figure demonstrates an example with a car park having 3 floors and 2 parking sections per floor. The initial state of the car park is represented by a 2D array `{{8, 8}, {8, 8}, {8, 8}}`, where each element represents the number of cars parked in a section. The number of cars entering the car park throughout the day is given as a 1D array `{1, 2, 3, 4, 5}` representing the number of cars entering at different times of the day. The number of cars exiting in each section at the end of the day is represented by `{{1, 2}, {2, 3}, {3, 4}}`.

To update the cars parked, two rules need to be followed:

1. The maximum number of cars that can park in each section is 12.

1. Cars entering the car park are assigned to sections floor by floor, starting from the first section on the first floor (building[0][0]). When a section reaches its maximum capacity of 12, incoming cars are directed to the next section on the same floor.

Therefore, with the given numbers for this example and `SECTION_MAX = 12`, the expected number of cars parked at the end of the day will be `{{11, 10}, {10, 8}, {5, 4}}`.

The objective of this project is to develop an ARMv7-M assembly language function asm_fun() that updates the cars parked in each section at the end of the day, considering the initial state, cars entering, and cars exiting.

## Assignment Questions

### 1. Memory Address Calculation

- **Question:**  
  How to calculate the memory address of element `building[A][B]` (with floor index `A` and section index `B`, where indices start at 0)?

- **Answer:**  
  The memory address is given by the equation: memory address of building[A][B] = address of building + 4 * (A * S + B), where `S` is the number of sections.

### 2. Function Return Observations

- **Question:**  
  Describe what you observe in (i) and (ii) and explain why there is a difference. (i) is when the `PUSH {R14}` and `POP {R14}` lines are commented and (ii) is when they are uncommented.

- **Observation (i):**  
The function does not return correctly to `main()`, possibly leading to a segmentation fault or unexpected results.

- **Explanation:**  
  The Link Register (`R14`) stores the return address when calling functions. Without saving `R14` (via `PUSH {R14}`) before a branch with link (BL) and restoring it (via `POP {R14}`) afterward, the function cannot return correctly.

- **Observation (ii):**  
The program executes correctly, returning to `main()` as expected.

- **Explanation:**  
  Saving and restoring `R14` ensures that the correct return address is preserved, so `BX LR` correctly transfers control back to `main()`.

### 3. Handling Exhaustion of General Purpose Registers

- **Question:**  
  What can you do if you have used up all the general purpose registers and you need to store some more values during processing?

- **Solutions:**
- **Use the Stack (PUSH & POP):**  
  Temporarily store data on the stack when registers are full.
- **Use Memory (RAM):**  
  Store additional values in global/static variables or dynamically allocated memory.
- **Reuse Registers:**  
  Identify registers that are no longer needed and overwrite them. Utilise shifting or rotating techniques to manage temporary values instead of allocating new registers.

## Machine Code

The report provides machine codes corresponding to selected assembly language instructions from the project. Below are five examples:

| **Instruction**                | **Type**           | **Machine Code (Hex)**         |
|--------------------------------|--------------------|--------------------------------|
| `ADD R6, R4`                   | Data Processing    | `0x00864004`                   |
| `LDR R4, [R1], #4`             | Memory Access      | `0x05941004`                   |
| `BNE SUM_ENTRIES`              | Branching          | `0x1A000020`                   |
| `MOV R5, #0`                   | Data Processing    | `0x3D050000`                   |
| `STR R9, [R8], #4`             | Memory Access      | `0x05498004`                   |

## Microarchitecture Design

This section details the modifications made to the single-cycle processor design to support **MUL (Multiply)** and **MLA (Multiply-Accumulate)** instructions. Key modifications include:

- **Hardware Multiplier Unit:**  
A dedicated combinational multiplier that accepts two 32-bit inputs (`Mult_In_A` and `Mult_In_B`) and produces a 32-bit product (`Mult_Out_Product`) in a single cycle.

- **Control Logic Enhancements:**  
The Decoder is updated to recognise `MUL` and `MLA` opcodes and generate appropriate control signals (e.g., `MULControl`) to enable the multiplier unit.

- **Data Path Adjustments:**  
A multiplexer (MUX) is added before the Write Back stage to select either the ALU result or the multiplier output. For MLA instructions, the multiplier output is added to an additional operand (`Rn`) using the ALU before write-back.

- **Register File Considerations:**  
The Register File provides operands to both the ALU and the multiplier. For MLA operations, the necessary operand (`Rn`) is also read to facilitate accumulation.

![image](https://github.com/user-attachments/assets/41b2b35d-70f1-4edd-94c9-17d7f8fb0232)

## Discussion of Improvements Made to Enhance Efficiency

Several strategies have been implemented to optimise the code:

- **Reusing Registers:**  
Registers such as R4, R5, and R6 are reused throughout the code when they are no longer needed, reducing the overhead of extra register allocation.

- **Storing Intermediate Values:**  
Temporary values are stored in registers to avoid redundant computations, which enhances performance.

- **Optimised Pointer Usage:**  
Instead of creating multiple pointers for array traversal, existing pointers are efficiently reused to iterate through arrays, minimising additional register usage.
