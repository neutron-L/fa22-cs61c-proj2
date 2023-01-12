.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    ebreak
    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)

    # open file
    add a1, x0, x0
    jal x1, fopen
    addi a1, x0, -1
    beq a0, a1, fopen_error
    add s0, a0, x0
    
    # read rows and cols
    lw a1, 4(sp)
    addi a2, x0, 4
    jal x1, fread 
    addi a2, x0, 4
    bne a0, a2, fread_error

    add a0, s0, x0
    lw a1, 8(sp)
    addi a2, x0, 4
    jal x1, fread 
    addi a2, x0, 4
    bne a0, a2, fread_error

    # malloc space
    lw a1, 4(sp)
    lw t3, 0(a1)
    lw a1, 8(sp)
    lw t4, 0(a1)
    mul s1, t3, t4
    slli s1, s1, 2
    add a0, s1, x0
    jal x1, malloc
    beq a0, x0, malloc_error

    add a1, a0, x0    # pointer
    add a0, s0, x0    # a0 is the fp
    add a2, s1, x0    

    # save fp
    addi sp, sp, -4
    sw s0, 0(sp)

    add s0, a1, x0    # s0 is the matrix
    # read matrix
    jal x1, fread
    bne a0, s1, fread_error

    # restore fp
    lw a0, 0(sp)
    addi sp, sp, 4

    # close file
    jal x1, fclose
    bne a0, x0, fclose_error 
    add a0, s0, x0

    # Epilogue
    lw ra, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw s0, 12(sp)
    lw s1, 16(sp)
    addi sp, sp, 20

    jr ra


malloc_error:
    addi a0, x0, 26
    j exit

fopen_error:
    addi a0, x0, 27
    j exit

fclose_error:
    addi a0, x0, 28
    j exit

fread_error:
    addi a0, x0, 29
    j exit
