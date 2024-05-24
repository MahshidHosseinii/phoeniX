# https://leetcode.com/problems/sqrtx/
# Calculate floor(sqrt(x))

.data
magic:    .word 0x07C4ACDD
table:    .word 0, 9, 1, 10, 13, 21, 2, 29, 11, 14, 16, 18, 22, 25, 3, 30, 8, 12, 20, 28, 15, 17, 24, 7, 19, 27, 23, 6, 26, 5, 4 ,31

.text
main:
        # call floor(squrt(x))
        li  a0, 1024             
        jal ra, floor_sqrt    # call floor_sqrt(x)
        
        # print result
        mv a1, a0             # integer to print
        li a0, 1              # print int environment call (1)
        ecall                 # print int environment call
        
        # exit
        li a0, 10             # exit environment call id (10)
        ecall                 # exit environment call
        
        
        
floor_sqrt:
        li   t0, 0            # unsigned int s = 0;
        li   t1, 1            # unsigned int i = 1;
        mv   s0, a0           # s0 = a0, save before call routine
        mv   s1, ra
        jal  ra, bit_scan_reverse
        srli a0, a0, 1        # a0 = a0 / 2
        sll  t1, t1, a0       # i = i << (a0/2)
        mv   ra, s1
        mv   a0, s0
for_next_bit:
        beqz t1, next_bit_end # if i == 0 goto next_bit_end
        add  t2, t0, t1       # t2 = s + i
        mul  t3, t2, t2       # t3 = (t2)^2 = (s+i)^2
        bltu a0, t3, if_x_is_less_than_t3 # if a0 < t3 then don't add
        add  t0, t0, t1       # s = s + i
        beq  a0, t3, next_bit_end  # if s^2 == x, then t0 is the answer and we exit this loop earlier
if_x_is_less_than_t3:
        srli t1, t1, 1        # i = i >> 1
        j for_next_bit        # goto for_next_bit
next_bit_end:  
        mv a0, t0
        ret
        
        
        
bit_scan_reverse:
    srli a1, a0, 1   #
    or   a0, a0, a1  # a0 = a0 | (a0 >> 1)
    srli a1, a0, 2   #
    or   a0, a0, a1  # a0 = a0 | (a0 >> 2)
    srli a1, a0, 4   #
    or   a0, a0, a1  # a0 = a0 | (a0 >> 4)
    srli a1, a0, 8   #
    or   a0, a0, a1  # a0 = a0 | (a0 >> 8)
    srli a1, a0, 16  #
    or   a0, a0, a1  # a0 = a0 | (a0 >> 16)
    
    # multiply by magic
    lw   a1, magic   # a1 = &magic
    mul  a0, a0, a1  # a0 = a0 * magic
    srli a0, a0, 27  # a0 = (a0 * magic) >> 27
    
    # table lookup
    la   a1, table   # a1 = &table
    slli a0, a0, 2   # a0 = a0 * 4
    add  a0, a0, a1  # a0 = &table[a0*4]
    lw   a0, 0(a0)   # a0 = *table[a0*4]

    ret