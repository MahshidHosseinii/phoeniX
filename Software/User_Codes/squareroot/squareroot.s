# https://leetcode.com/problems/sqrtx/
# Calculate floor(sqrt(x))

.data
magic_const: .word 0x07C4ACDD
lookup_tbl:  .word 0, 9, 1, 10, 13, 21, 2, 29, 11, 14, 16, 18, 22, 25, 3, 30, 8, 12, 20, 28, 15, 17, 24, 7, 19, 27, 23, 6, 26, 5, 4, 31

.text
main:
        # Start calculating square root
        li  a0, 64             # Load the input number
        jal ra, compute_sqrt   # Call compute_sqrt
        
        # Print the result
        mv a1, a0              # Move result to a1 for printing
        li a0, 1               # Print integer syscall
        ecall                  # Make syscall
        
        # Exit the program
        li a0, 10              # Exit syscall
        ecall                  # Make syscall
        ebreak
        
compute_sqrt:
        li   t0, 0             # result = 0;
        li   t1, 1             # bit = 1;
        mv   s0, a0            # Save input number
        mv   s1, ra            # Save return address
        jal  ra, find_bsr      # Call find_bsr to get highest bit
        srli a0, a0, 1         # Divide by 2
        sll  t1, t1, a0        # Shift bit left by divided value
        mv   ra, s1            # Restore return address
        mv   a0, s0            # Restore input number
sqrt_loop:
        beqz t1, sqrt_done     # If bit == 0, exit loop
        add  t2, t0, t1        # temp = result + bit
        mul  t3, t2, t2        # temp_squared = temp * temp
        bltu a0, t3, skip_add  # If input < temp_squared, skip addition
        add  t0, t0, t1        # result = result + bit
        beq  a0, t3, sqrt_done # If result^2 == input, exit loop
skip_add:
        srli t1, t1, 1         # bit = bit >> 1
        j sqrt_loop            # Repeat loop
sqrt_done:  
        mv a0, t0              # Move result to a0
        ret
        
find_bsr:
    srli a1, a0, 1            # Shift right by 1
    or   a0, a0, a1           # OR with shifted value
    srli a1, a0, 2            # Shift right by 2
    or   a0, a0, a1           # OR with shifted value
    srli a1, a0, 4            # Shift right by 4
    or   a0, a0, a1           # OR with shifted value
    srli a1, a0, 8            # Shift right by 8
    or   a0, a0, a1           # OR with shifted value
    srli a1, a0, 16           # Shift right by 16
    or   a0, a0, a1           # OR with shifted value
    
    # Multiply by magic constant
    lw   a1, magic_const      # Load magic constant
    mul  a0, a0, a1           # Multiply by magic constant
    srli a0, a0, 27           # Shift right by 27
    
    # Lookup in table
    la   a1, lookup_tbl       # Load lookup table address
    slli a0, a0, 2            # Multiply index by 4 (word size)
    add  a0, a0, a1           # Calculate table entry address
    lw   a0, 0(a0)            # Load value from table

    ret                       # Return