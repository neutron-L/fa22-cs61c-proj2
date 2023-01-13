.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    add t0, a0, x0   # t0 is the address of current item
    add t1, x0, x0   # t1 is the current index

    # if a1 greater than 1, goto loop_start
    bgt a1, x0, loop_start
    addi a0, x0, 36
    j exit

loop_start:
    beq t1, a1, loop_end

    lw t2, 0(t0)
    bgt t2, x0, loop_continue
    sub t2, t2, t2
loop_continue:
    sw t2, 0(t0)
    addi t1, t1, 1
    addi t0, t0, 4
    j loop_start

loop_end:
    # Epilogue


    jr ra
