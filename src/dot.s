.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================


dot:
    # Prologue
    add t0, x0, x0 # t0 store the sum
    add t1, x0, x0 # current index of arr1
    add t2, x0, x0 # current index of arr2
    add t6, x0, x0 # current used items number

    # check length
    bgt a2, x0, check_stride1
    addi a0, x0, 36
    j error 
check_stride1:
    # check arr1 stride  
    bgt a3, x0, check_stride2
    j set_code
check_stride2:
    # check arr2 stride   
    bgt a4, x0, loop_start
    
set_code:
    addi a0, x0, 37
error:
    j exit

loop_start:
    # load arr1[t1]
    slli t3, t1, 2
    add t3, t3, a0
    lw t4, 0(t3)

    # load arr2[t2]
    slli t3, t2, 2
    add t3, t3, a1
    lw t5, 0(t3)

    # sum += t4 * t5
    mul t4, t4, t5
    add t0, t0, t4

loop_continue:
    add t1, t1, a3
    add t2, t2, a4
    addi t6, t6, 1
    bge t6, a2, loop_end
    j loop_start

loop_end:


    # Epilogue

    add a0, t0, x0
    jr ra


# =======================================================
# FUNCTION: check if arg is less than 1
# Arguments:
#   a0 (int) is a number
#   a1 (int) is the error exit code if a0 <= 0
# =======================================================
