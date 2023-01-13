.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    ebreak

    # check argc
    addi a0, a0, -5
    bne a0, x0, argc_error

    # save args
    addi sp, sp, -60
    sw ra, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)
    sw s2, 20(sp)
    sw s3, 24(sp)
    sw s4, 28(sp)

    # Read pretrained m0, s0 point to m0
    lw a1, 4(sp)
    lw a0, 4(a1)
    addi a1, sp, 32        # address of rows
    addi a2, sp, 36        # address of cols
    jal x1, read_matrix
    add s0, a0, x0

    # Read pretrained m1, s1 point to m1
    lw a1, 4(sp)
    lw a0, 8(a1)
    addi a1, sp, 40        # address of rows
    addi a2, sp, 44        # address of cols
    jal x1, read_matrix
    add s1, a0, x0

    # Read input matrix, s2 point to input
    lw a1, 4(sp)
    lw a0, 12(a1)
    addi a1, sp, 48        # address of rows
    addi a2, sp, 52        # address of cols
    jal x1, read_matrix
    add s2, a0, x0

    # Compute h = matmul(m0, input)
    # allocate matrix h, s3 point to it
    lw a0, 32(sp)
    lw a1, 52(sp)
    mul a0, a0, a1
    slli a0, a0, 2
    jal x1, malloc
    beq a0, x0, malloc_error
    add s3, a0, x0

    add a0, s0, x0
    lw a1, 32(sp)
    lw a2, 36(sp)
    add a3, s2, x0
    lw a4, 48(sp)
    lw a5, 52(sp)
    add a6, s3, x0
    jal x1, matmul

    # Compute h = relu(h)
    lw a0, 32(sp)
    lw a1, 52(sp)
    mul a1, a1, a0
    add a0, s3, x0
    jal x1, relu

    # Compute o = matmul(m1, h)
    # allocate matrix o, s4 point to it
    lw a0, 40(sp)
    lw a1, 52(sp)
    mul a0, a0, a1
    slli a0, a0, 2
    jal x1, malloc
    beq a0, x0, malloc_error
    add s4, a0, x0

    add a0, s1, x0
    lw a1, 40(sp)
    lw a2, 44(sp)
    add a3, s3, x0
    lw a4, 32(sp)
    lw a5, 52(sp)
    add a6, s4, x0
    jal x1, matmul

    # Write output matrix o
    lw a1, 4(sp)
    lw a0, 16(a1)
    add a1, s4, x0
    lw a2, 40(sp)
    lw a3, 52(sp)
    jal x1, write_matrix

    # Compute and return argmax(o)
    add a0, s4, x0
    lw a1, 40(sp)
    lw a2, 52(sp)
    mul a1, a1, a2
    jal x1, argmax
    # save the a0 
    sw a0, 56(sp)

    # If enabled, print argmax(o) and newline
    lw a2, 8(sp)
    addi a2, a2, -1
    beq a2, x0, end
    jal x1, print_int
    li a0, '\n'
    jal x1, print_char

end:
    # free spaces
    add a0, s0, x0
    jal x1, free
    add a0, s1, x0
    jal x1, free
    add a0, s2, x0
    jal x1, free
    add a0, s3, x0
    jal x1, free
    add a0, s4, x0
    jal x1, free

    lw a0, 56(sp)


    lw ra, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw s0, 12(sp)
    lw s1, 16(sp)
    lw s2, 20(sp)
    lw s3, 24(sp)
    lw s4, 28(sp)
    addi sp, sp, 60

    jr ra


argc_error:
    addi a0, x0, 31
    j exit

malloc_error:
    addi a0, x0, 26 
    j exit
