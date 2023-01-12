.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)
    sw ra, 20(sp)

    # open file
    addi a1, x0, 1
    jal x1, fopen
    addi a1, x0, -1
    beq a0, a1, fopen_error
    add s0, a0, x0

    # write rows and cols
    add a0, s0, x0
    addi a1, sp, 4
    addi a2, x0, 1
    addi a3, x0, 4
    jal x1, fwrite
    addi a2, x0, 1
    bne a0, a2, fwrite_error

    add a0, s0, x0
    addi a1, sp, 8
    addi a2, x0, 1
    addi a3, x0, 4
    jal x1, fwrite
    addi a2, x0, 1
    bne a0, a2, fwrite_error

    # write matrix
    add a0, s0, x0
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    mul s1, a2, a3
    add a2, s1, x0
    addi a3, x0, 4
    jal x1, fwrite
    bne a0, s1, fwrite_error


    # close file
    add a0, s0, x0
    jal x1, fclose
    bne a0, x0, fclose_error

    # Epilogue
    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw s0, 12(sp)
    lw s1, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    jr ra

fopen_error:
    addi a0, x0, 27
    j exit

fwrite_error:
    addi a0, x0, 30
    j exit

fclose_error:
    addi a0, x0, 28
    j exit
