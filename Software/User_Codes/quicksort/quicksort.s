.data
array_size: .word 10
array_data: .word 32432, 5, 7, 120, -5, -231, 65, -80, 23, 32
before_msg: .string "Array before sorting: "
after_msg:  .string "Array after sorting: "
space:      .string " "
newline:    .string "\n"

.text
main:
    # Print before_msg
    la   a1, before_msg   # Load address of before_msg
    addi a0, x0, 4        # Syscall for printing string
    ecall
    
    # Print array
    la   a1, array_data   # Load array address
    la   a2, array_size   # Load array size address
    jal  ra, PrintArray   # Call PrintArray function
    
    # Quick sort
    la   a0, array_data   # Load array address
    addi a1, x0, 0        # Set left bound to 0
    la   a2, array_size   # Load array size address
    lw   a2, 0(a2)        # Load array size
    addi a2, a2, -1       # Set right bound to array size - 1
    jal  ra, QuickSort    # Call QuickSort function
    
    # Print after_msg
    la   a1, after_msg    # Load address of after_msg
    addi a0, x0, 4        # Syscall for printing string
    ecall
    
    # Print array
    la   a1, array_data   # Load array address
    la   a2, array_size   # Load array size address
    jal  ra, PrintArray   # Call PrintArray function
    
    li  a0, 10            # Syscall for exiting program
    ecall
    ebreak
    
QuickSort:
    # Save registers on stack
    addi sp, sp, -28      # Allocate stack space for saving registers
    sw   ra, 0(sp)        # Save return address
    sw   s0, 4(sp)        # Save s0
    sw   s1, 8(sp)        # Save s1
    sw   s2, 12(sp)       # Save s2
    sw   s3, 16(sp)       # Save s3
    sw   s4, 20(sp)       # Save s4
    sw   s5, 24(sp)       # Save s5
    
    # Initialize local variables
    mv   s0, a0           # s0 = array base address
    mv   s1, a1           # s1 = left bound
    mv   s2, a2           # s2 = right bound
    mv   s4, a1           # s4 = l = left bound
    mv   s5, a2           # s5 = r = right bound
    bge  s1, s2, EndQuickSort # If left bound >= right bound, end quicksort
    
    # Calculate pivot
    mv   t0, s0           # t0 = array base address
    mv   t1, s1           # t1 = left bound
    slli t1, t1, 2        # t1 = left bound * 4 (each element is 4 bytes)
    add  t0, t0, t1       # t0 = address of array[left bound]
    lw   s3, 0(t0)        # s3 = pivot = array[left bound]
    
PartitionLoop: 
    beq  s4, s5, DonePartition  # If l == r, partition is done
    
    mv   t0, s0           # t0 = array base address
    mv   t1, s5           # t1 = r
    mv   t2, s4           # t2 = l
    slli t1, t1, 2        # t1 = r * 4
    slli t2, t2, 2        # t2 = l * 4
    add  t1, t0, t1       # t1 = address of array[r]
    lw   t1, 0(t1)        # t1 = array[r]
    add  t2, t0, t2       # t2 = address of array[l]
    lw   t2, 0(t2)        # t2 = array[l]
    
    # Move right index
    bge  s3, t1, MoveLeft # If pivot >= array[r], move left index
    bge  s4, s5, MoveLeft # If l >= r, move left index
    addi s5, s5, -1       # r--
    j PartitionLoop       # Jump to PartitionLoop
    
MoveLeft:
    blt  s3, t2, Swap     # If pivot < array[l], swap elements
    bge  s4, s5, Swap     # If l >= r, swap elements
    addi s4, s4, 1        # l++
    j PartitionLoop       # Jump to PartitionLoop
    
Swap:
    bge  s4, s5, PartitionLoop # If l >= r, jump to PartitionLoop
    mv   t0, s0           # t0 = array base address
    mv   t1, s5           # t1 = r
    mv   t2, s4           # t2 = l
    slli t1, t1, 2        # t1 = r * 4
    slli t2, t2, 2        # t2 = l * 4
    add  t1, t0, t1       # t1 = address of array[r]
    lw   t3, 0(t1)        # t3 = array[r]
    add  t2, t0, t2       # t2 = address of array[l]
    lw   t0, 0(t2)        # t0 = array[l]
    sw   t3, 0(t2)        # array[l] = array[r]
    sw   t0, 0(t1)        # array[r] = array[l]
    j PartitionLoop       # Jump to PartitionLoop
    
DonePartition:
    mv   t0, s0           # t0 = array base address
    mv   t1, s1           # t1 = left bound
    mv   t2, s4           # t2 = l
    slli t1, t1, 2        # t1 = left bound * 4
    slli t2, t2, 2        # t2 = l * 4
    add  t1, t0, t1       # t1 = address of array[left bound]
    add  t2, t0, t2       # t2 = address of array[l]
    lw   t3, 0(t2)        # t3 = array[l]
    sw   t3, 0(t1)        # array[left bound] = array[l]
    sw   s3, 0(t2)        # array[l] = pivot
    
    # Recursive calls for left and right partitions
    mv   a0, s0           # a0 = array base address
    mv   a1, s1           # a1 = left bound
    addi a2, s4, -1       # a2 = l - 1
    jal  ra, QuickSort    # Recursive call for left partition
    
    mv   a0, s0           # a0 = array base address
    addi a1, s4, 1        # a1 = l + 1
    mv   a2, s2           # a2 = right bound
    jal  ra, QuickSort    # Recursive call for right partition
    
EndQuickSort:
    # Restore registers from stack
    lw   ra, 0(sp)        # Restore return address
    lw   s0, 4(sp)        # Restore s0
    lw   s1, 8(sp)        # Restore s1
    lw   s2, 12(sp)       # Restore s2
    lw   s3, 16(sp)       # Restore s3
    lw   s4, 20(sp)       # Restore s4
    lw   s5, 24(sp)       # Restore s5
    addi sp, sp, 28       # Deallocate stack space
    jr   ra               # Return from function
    
PrintArray:
    mv t0, a1             # Load array base address
    lw t1, 0(a2)          # Load array size
PrintLoop:
    lw a1, 0(t0)          # Load array element
    addi a0, x0, 1        # Syscall to print integer
    ecall
    la a1, space          # Load address of space string
    addi a0, x0, 4        # Syscall to print string
    ecall
    addi t0, t0, 4        # Move to next element
    addi t1, t1, -1       # Decrement array size
    bne t1, x0, PrintLoop # Loop until all elements are printed


    
    la a1, newline        # Load address of newline string
    addi a0, x0, 4        # Syscall to print string
    ecall
    jr ra                 # Return from function