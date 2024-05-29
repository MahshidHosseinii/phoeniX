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

## Algorithm Overview

QuickSort works by selecting a pivot element from the array and partitioning the remaining elements into two sub-arrays: one containing elements less than the pivot, and the other containing elements greater than the pivot. It then recursively sorts the two sub-arrays and combines them to obtain the final sorted array.

The partitioning process is crucial to the algorithm's efficiency and is typically implemented using the Hoare or Lomuto partitioning schemes. This implementation employs the Lomuto partitioning scheme, which selects the rightmost element as the pivot and partitions the array by swapping elements around the pivot.

## Implementation Details

### Function Overview

The code consists of two main functions: `QuickSort` and `PrintArr`.

<div align="justify">

The first one for print array before and after sort and another for execution of quick sort on a array.

First Choose a number in array as a pivot, and we need to make all the numbers on the left of the pivot are smaller than the pivot, all the numbers on the right of the pivot are bigger than the pivot.

### `QuickSort` Function

The `QuickSort` function is the core of the implementation and takes three arguments:

- `a0`: The base address of the array to be sorted.
- `a1`: The starting index of the sub-array to be sorted (left bound).
- `a2`: The ending index of the sub-array to be sorted (right bound).

The function performs the following steps:

1. Save the necessary register values on the stack for later restoration.
2. Check if the left bound (`s1`) is greater than or equal to the right bound (`s2`). If so, skip the sorting process and jump to `EndQuickSort`.
3. Calculate the pivot element by selecting the element at the left bound (`s1`).
4. Partition the array around the pivot element using the Lomuto partitioning scheme.
   - The partitioning process rearranges the elements such that all elements smaller than the pivot are to the left of the pivot, and all elements greater than the pivot are to the right of the pivot.
   - After partitioning, swap the pivot element with the element at the final position of the left partition.
5. Recursively call `QuickSort` on the left sub-array by setting `a0` to the base address of the array, `a1` to the left bound, and `a2` to the index of the pivot element minus one.
6. Recursively call `QuickSort` on the right sub-array by setting `a0` to the base address of the array, `a1` to the index of the pivot element plus one, and `a2` to the right bound.
7. Restore the saved register values from the stack.
8. Return to the calling function.


### `PrintArray` Function

The `PrintArray` function is a utility function that prints the elements of the array to the console. It takes two arguments:

- `a1`: The base address of the array to be printed.
- `a2`: The address of the memory location containing the size of the array.

The function iterates over the array elements and prints them separated by spaces, followed by a newline character at the end. It uses the `ecall` instruction to print individual integers and strings.

### Usage

To use this implementation, you need to provide the following:

- The base address of the array to be sorted, stored in register `a0`.
- The starting index of the sub-array to be sorted, stored in register `a1`.
- The ending index of the sub-array to be sorted, stored in register `a2`.

After calling the `QuickSort` function, you can optionally call the `PrintArray` function to print the sorted array.

Note that this implementation assumes the existence of a space-separated string called `space` and a newline string called `newline` in memory, which are used for printing the array elements.

</div>

### Example

To sort an array of integers `[5, 2, 9, 1, 7]` and print the sorted array, you can follow these steps:

1. Load the base address of the array into register `a0`.
2. Set register `a1` to 0 (the starting index).
3. Set register `a2` to 4 (the ending index, assuming 0-based indexing).
4. Call the `QuickSort` function.
5. Load the base address of the array into register `a1`.
6. Load the address of the memory location containing the size of the array into register `a2`.
7. Call the `PrintArray` function.

After executing these steps, the sorted array `[1, 2, 5, 7, 9]` will be printed to the console.

</div>

### Execution

![alt text](https://github.com/setarekhosravi/phoeniX_CompOrgPr/blob/main/Software/images/pr_execution.png)
![alt text](https://github.com/setarekhosravi/phoeniX_CompOrgPr/blob/main/Software/images/quicksort.png)

## Integer Square Root

This code is a RISC-V assembly implementation for the Square Root Calculation problem. The goal is to calculate the square root of a given integer `x`.

## Problem Description

Given a non-negative integer `x`, compute and return the square root of `x` rounded down to the nearest integer.

## Algorithm Overview

Basically this problem asks us to find  𝑦 of  𝑦=√⌊𝑥⌋  with given variable 𝑥.
where 𝑥 is a non-negative integer that ranges between [0,2^31−1].

The solution exploits the fact that we are looking for an integer, and the relationship between 𝑥 and √𝑦
 follows a strict order. So we can just enumerate each bit to find the integer that is closest to 𝑥.

First Attempts to retrieve the MSB of that given number 𝑥.
Multiply the number by 0x07C4ACDD. Shift it by 27 bits.
Lookup the table. Now you got the index of the MSB of 𝑥 (0-based index).

The algorithm employed in this implementation works as follows:

1. Find the position of the most significant set bit in the input number `x`. This position determines the approximate range of the square root.
2. Initialize the result to 0 and a bit variable to 1.
3. In a loop, check if adding the current bit value to the result would lead to a value greater than the square root. If not, add the bit value to the result, and then shift the bit value right by one position.
4. Repeat step 3 until the bit value becomes 0.

The key components of this algorithm are:
<
- **Bit Scan Reverse (BSR)**: A technique to find the position of the most significant set bit in a number.
- **Magic Constant and Lookup Table**: A constant and a precomputed lookup table are used to efficiently perform the BSR operation.
- **Iterative Square Root Calculation**: The square root is computed iteratively by adding or skipping bit values based on the comparison with the input number.

## Implementation Details


### `compute_sqrt` Function

The `compute_sqrt` function takes a single argument:

- `a0`: The input number for which the square root needs to be computed.

The function performs the following steps:

1. Initialize the result (`t0`) to 0 and the bit value (`t1`) to 1.
2. Save the input number (`s0`) and the return address (`s1`) in saved registers.
3. Call the `find_bsr` function to find the position of the most significant set bit in the input number.
4. Shift the bit value (`t1`) left by half the position of the most significant bit.
5. Enter a loop (`sqrt_loop`):
   - Check if the bit value is 0. If so, exit the loop.
   - Calculate a temporary value (`t2`) by adding the current result and bit value.
   - Square the temporary value (`t3`).
   - Compare the input number (`a0`) with the squared temporary value (`t3`). If the input number is less than the squared value, skip the addition step.
   - If the input number is greater than or equal to the squared value, add the bit value to the result.
   - If the squared result is equal to the input number, exit the loop.
   - Shift the bit value right by one position.
   - Repeat the loop.
6. Move the final result (`t0`) to `a0`.
7. Return to the calling function.

### `find_bsr` Function

The `find_bsr` function takes a single argument:

- `a0`: The input number for which the position of the most significant set bit needs to be found.

The function performs the following steps:

1. Initialize `a0` with the input number.
2. Perform a series of bitwise OR operations to propagate the set bits to the right.
3. Multiply `a0` by a magic constant (`0x07C4ACDD`).
4. Right-shift `a0` by 27 bits.
5. Use the result as an index into a precomputed lookup table (`lookup_tbl`) to get the position of the most significant set bit.
6. Return the position of the most significant set bit in `a0`.

### Usage

To use this implementation, follow these steps:

1. Load the input number for which the square root needs to be computed into register `a0`.
2. Call the `compute_sqrt` function by executing `jal ra, compute_sqrt`.
3. The result will be stored in register `a0`.

Note that this implementation assumes the existence of a precomputed lookup table (`lookup_tbl`) and a magic constant (`magic_const`) in memory.

### Example

In the provided code, the `main` function demonstrates how to use the `compute_sqrt` function:

1. Load the value `64` into register `a0`.
2. Call the `compute_sqrt` function by executing `jal ra, compute_sqrt`.
3. Print the result (stored in `a0`) using the `ecall` system call.

After executing this code, the output will be `8`, which is the floor of the square root of `64`.

   
   
### Execution
![alt text](https://github.com/setarekhosravi/phoeniX_CompOrgPr/blob/main/Software/images/sqrt(64).png)
![alt text](https://github.com/setarekhosravi/phoeniX_CompOrgPr/blob/main/Software/images/squareroot.png)

**In images directory** there is another output for the ```squareroot``` code.

## Contributers
* [Setare Khosravi](https://github.com/setarekhosravi)
* [Mahshid Hosseini](https://github.com/MahshidHosseinii)
