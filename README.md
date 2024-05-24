Quick Sort & Integer Square Root
====================
<div align="justify">

This directory contains source files of user codes which will be executed on the phoeniX processor. In this directory, there are two subdirectories included:
- `quicksort`
- `rootsquare`

</div>

## QuickSort Implementation in RISC-V Assembly

This code implements the QuickSort algorithm in RISC-V assembly language. The algorithm works by partitioning an array into two sub-arrays around a pivot element, then recursively sorting the sub-arrays.
<div align="justify">

### Function Overview

The code consists of two main functions: `QuickSort` and `PrintArr`.

<div align="justify">

The first one for print array before and after sort and another for execution of quick sort on a array.

First Choose a number in array as a pivot, and we need to make all the numbers on the left of the pivot are smaller than the pivot, all the numbers on the right of the pivot are bigger than the pivot.

this is the line that we realize that we can't go further.

```
beq  s4, s5, EndSortLoop
```

Next, look upon all numbers on the left of the pivot as new array, and do the same in numbers on the right side.
Repeat the step 1 and 2, until you can't divide more small array.

In the  two below part `Recursion1` and `Recursion1` we repeat quick sort algorithm recursively for sub array that generated in left and right of the pivot:

```
Recursion1:
    mv   a0, s0
    mv   a1, s1
    addi a2, s4, -1
    jal  ra, QuickSort
```

```
Recursion2:
    mv   a0, s0
    addi a1, s4, 1
    mv   a2, s2
    jal  ra, QuickSort
```

### More Information

#### `QuickSort`

The `QuickSort` function takes three arguments:

- `a0`: The base address of the array to be sorted.
- `a1`: The starting index of the sub-array to be sorted.
- `a2`: The ending index of the sub-array to be sorted.

The function performs the following steps:

1. Save the necessary register values on the stack for later restoration.
2. Recursively call `QuickSort` on the left sub-array by setting `a0` to the base address of the array, `a1` to the starting index, and `a2` to the pivot index minus one.
3. Recursively call `QuickSort` on the right sub-array by setting `a0` to the base address of the array, `a1` to the pivot index plus one, and `a2` to the ending index.
4. Restore the saved register values from the stack.
5. Return to the calling function using the `jr ra` instruction.
<div align="justify">

#### `PrintArr`

The `PrintArr` function takes two arguments:

- `a1`: The base address of the array to be printed.
- `a2`: The size of the array.

The function prints the elements of the array separated by spaces and a newline character at the end. It uses the `ecall` instruction to print individual integers and strings.

#### Usage

To use this implementation, you need to provide the following:

- The base address of the array to be sorted, stored in register `a0`.
- The starting index of the sub-array to be sorted, stored in register `a1`.
- The ending index of the sub-array to be sorted, stored in register `a2`.

After calling the `QuickSort` function, you can optionally call the `PrintArr` function to print the sorted array.

Note that this implementation assumes the existence of a space-separated string called `space` and a newline string called `nextline` in memory, which are used for printing the array elements.

#### Example

To sort an array of integers `[5, 2, 9, 1, 7]` and print the sorted array, you can follow these steps:

1. Load the base address of the array into register `a0`.
2. Set register `a1` to 0 (the starting index).
3. Set register `a2` to 4 (the ending index, assuming 0-based indexing).
4. Call the `QuickSort` function.
5. Load the base address of the array into register `a1`.
6. Load the size of the array (5 in this case) into register `a2`.
7. Call the `PrintArr` function.

After executing these steps, the sorted array `[1, 2, 5, 7, 9]` will be printed to the console.

</div>

#### Execution

![alt text](https://github.com/setarekhosravi/phoeniX_CompOrgPr/blob/main/Software/images/pr_execution.png)
![alt text](https://github.com/setarekhosravi/phoeniX_CompOrgPr/blob/main/Software/images/quicksort.png)

## Integer Square Root

This code is a RISC-V assembly implementation for the Square Root Calculation problem. The goal is to calculate the square root of a given integer `x`.

### Problem Description

Given a non-negative integer `x`, compute and return the square root of `x` rounded down to the nearest integer.

### Implementation

The code consists of two main functions: `floor_sqrt` and `bit_scan_reverse`.

### explanation of codes
<div align="justify">
Basically this problem asks us to find  𝑦 of  𝑦=√⌊𝑥⌋  with given variable 𝑥.
where 𝑥 is a non-negative integer that ranges between [0,2^31−1].

The solution exploits the fact that we are looking for an integer, and the relationship between 𝑥 and √𝑦
 follows a strict order. So we can just enumerate each bit to find the integer that is closest to 𝑥.

First Attempts to retrieve the MSB of that given number 𝑥.
Multiply the number by 0x07C4ACDD. Shift it by 27 bits.
Lookup the table. Now you got the index of the MSB of 𝑥 (0-based index).

 Here is where we call ```floor_sqrt``` function for example number 1024 :

```
  li  a0, 1024
  jal ra, floor_sqrt
```

and here we print the result:

```
  mv a1, a0             # integer to print
  li a0, 1              # print int environment call (1)
  ecall
```

### More Information

#### `floor_sqrt`

The `floor_sqrt` function takes an integer `x` (stored in `a0`) and returns the floor of its square root (stored in `a0`). It uses an iterative approach to find the square root by repeatedly adding the largest possible value to a running sum `s` (stored in `t0`) such that `s^2 <= x`. The algorithm works as follows:

1. Initialize `s` to 0 and `i` to 1.
2. Compute the approximate position of the most significant bit of `x` using `bit_scan_reverse`.
3. Right-shift `i` by half the position of the most significant bit of `x`.
4. In a loop:
   - Check if adding `i` to `s` would make `(s + i)^2 > x`. If so, right-shift `i` by 1.
   - Otherwise, add `i` to `s`.
   - If `s^2 == x`, break out of the loop.
5. Return `s` as the floor of the square root of `x`.

#### `bit_scan_reverse`

The `bit_scan_reverse` function takes an integer `x` (stored in `a0`) and returns the position of the most significant set bit in `x` (stored in `a0`). It uses a series of bitwise operations to achieve this:

1. Initialize a variable `a0` with the input `x`.
2. Perform a series of bitwise OR operations to propagate the set bits to the right.
3. Multiply `a0` by a magic constant `0x07C4ACDD`.
4. Right-shift `a0` by 27 bits.
5. Use the result as an index into a precomputed lookup table to get the position of the most significant set bit.

#### Usage

To use this implementation, follow these steps:

1. Load the integer `x` for which you want to calculate the square root into register `a0`.
2. Call the `floor_sqrt` function by executing `jal ra, floor_sqrt`.
3. The result will be stored in register `a0`.

Note that this implementation assumes the existence of a precomputed lookup table (`table`) and a magic constant (`magic`) in memory.

### Example

In the provided code, the `main` function demonstrates how to use the `floor_sqrt` function:

1. Load the value `64` into register `a0`.
2. Call the `floor_sqrt` function by executing `jal ra, floor_sqrt`.
3. Print the result (stored in `a0`) using the `ecall` system call.

After executing this code, the output will be `8`, which is the floor of the square root of `64`.


### Execution
![alt text](https://github.com/setarekhosravi/phoeniX_CompOrgPr/blob/main/Software/images/1024.png)
![alt text](https://github.com/setarekhosravi/phoeniX_CompOrgPr/blob/main/Software/images/squareroot.png)

**In images directory** there is another output for the ```squareroot``` code.

## Contributers
* [Setare Khosravi](https://github.com/setarekhosravi)
* [Mahshid Hosseini](https://github.com/MahshidHosseinii)
