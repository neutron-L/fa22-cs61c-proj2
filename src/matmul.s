.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
ebreak
    # Error checks
    bne a2, a4, error
    bge x0, a1, error
    bge x0, a2, error
    bge x0, a4, error
    bge x0, a5, error

    # Prologue
    add t1, x0, x0  # t1 is i
    add t2, x0, x0  # t2 is j

outer_loop_start:
    # if i >= a1 goto outer_loop_end
    bge t1, a1, outer_loop_end
    add t0, a3, x0  # t0 point to the m1, call it pb
    sub t2, t2, t2  # j = 0


inner_loop_start:
    # if j >= a5 goto inner_loop_end
    bge t2, a5, inner_loop_end

    # save param and temporal register
    addi sp, sp, -44
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw t0, 28(sp)
    sw t1, 32(sp)
    sw t2, 36(sp)
    sw ra, 40(sp)

    # set param
    add a0, a0, x0
    add a1, t0, x0
    add a2, a2, x0
    addi a3, x0, 1 
    add a4, a5, x0

    # call dot
    jal x1, dot
    lw a6, 24(sp)
    sw a0, 0(a6)          # *pc = a6

    # restore param and temporal register
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw t0, 28(sp)
    lw t1, 32(sp)
    lw t2, 36(sp)
    lw ra, 40(sp)

    addi sp, sp, 44

    addi t2, t2, 1        # ++j, ++pc, ++pb 
    addi a6, a6, 4
    addi t0, t0, 4

    j inner_loop_start

inner_loop_end:
    slli a2, a2, 2
    add a0, a0, a2
    srai a2, a2, 2
    addi t1, t1, 1
    j outer_loop_start

outer_loop_end:
    # Epilogue

    jr ra

error:
    addi a0, x0, 38
    j exit
