.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    add t0, a0, x0   #t0 is the address of current item
    add t1, x0, x0   # t1 is the current index

    # if a1 greater than 1, goto loop_start
    bgt a1, x0, loop_start
    addi a0, x0, 36
    j exit

loop_start:
    beq t1, a1, loop_end

    lw t2, 0(t0)
    beq t1, x0, update
    bge t3, t2, loop_continue  # if now_biggest >= cur value goto continue
update:
    add t3, t2, x0
    add a0, t1, x0
loop_continue:
    addi t1, t1, 1
    addi t0, t0, 4

    j loop_start

loop_end:
    # Epilogue


    jr ra
