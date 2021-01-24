#    File: mlRemoveBlanks
#  Author: **************
#    Date: mm/dd/yyyy
# Purpose: Practice rotate & AND to remove spare blanks
#--------------------------------------------------------------
# Write a MIPS assembler program to remove the extra blanks from
# a string: 
# INPUT: "Two  bee ore  knot too  Bea that"
# PATTERN:00011000100011000010001100010000
# ROTATE: 00110001000110000100011000100000
# AND:    00010000000010000000001000000000
# RESULT:"Two bee ore knot too Bea that   "

.data
    .eqv    SYS_PRINT_WORD   1  #word, byte, character
    .eqv    SYS_PRINT_FLOAT  2  #float  
    .eqv    SYS_PRINT_DOUBLE 3  #double
    .eqv    SYS_PRINT_TEXT   4  #text (zero terminated)
    .eqv    SYS_INPUT_WORD   5  #input word
    .eqv    SYS_INPUT_FLOAT  6  #input float
    .eqv    SYS_PRINT_BIN   35  #print binary
    .eqv    SYS_EXIT        10  #terminate

#   declare variables
    .eqv    BLANK       32
                        #12345678901234567890123456789012
    text:       .ascii  "Two  bee ore  knot too  Bea that"
    end_text:   .asciiz "\n"
    result:     .ascii  "                                "
    end_result: .asciiz "\n"
    blank:      .byte   ' '
    endl:       .asciiz "\n"
    endl2:      .asciiz "\n\n"
    
.text
.globl main
main:

# Print starting text
    la  $a0, text
    li  $v0, SYS_PRINT_TEXT
    syscall
# ----------------------------------------------------------------
# Create the bit pattern with a 1 where each blanks exists
# ----------------------------------------------------------------
    la      $s7, end_text   # s7 = ending address for loop
    la      $s1, text       # s1 = text address
    move    $s0, $zero      # s0 = the bit pattern
loop1:
    sll     $s0, $s0, 1     # shift pattern
    lbu     $t2, 0($s1)     # get byte
    li      $t1, BLANK
    bne     $t1, $t2, noBlank   # compare with blank
    ori     $s0, $s0, 1     # set 1 in bit0 for blank
noBlank:
    addiu   $s1, $s1, 1     # move to next character
    bne     $s1, $s7, loop1 # loop if not done
    # print pattern
    move    $a0, $s0
    li      $v0, SYS_PRINT_BIN
    syscall
    la      $a0, endl
    li      $v0, SYS_PRINT_TEXT
    syscall

# ----------------------------------------------------------------
# Duplicate bit pattern, Rotate left, AND the two patterns
#   should be where extra blanks exist
# ----------------------------------------------------------------
    # duplicate s0 pattern into s2
    la 	    $s2, 0($s0)
    # rotate s2 left one bit
    sll     $s2, $s2, 1
    # print s2 rotate
    move    $a0, $s2
    li      $v0, SYS_PRINT_BIN
    syscall
    la      $a0, endl
    li      $v0, SYS_PRINT_TEXT
    syscall
    # AND the two patterns: s2 & s0
    and     $s5, $s2, $s0
    # print the AND pattern
    move    $a0, $s5
    li      $v0, SYS_PRINT_BIN
    syscall
    la      $a0, endl
    li      $v0, SYS_PRINT_TEXT
    syscall
# ----------------------------------------------------------------
# Copy 'text' into 'result' for each zero bit in s3 pattern
# ----------------------------------------------------------------
    # ending s7 'end_text' address
    la      $s7, end_text
    # source address 'text' in s0
    la      $s0, text
    # destination address 'result' in s1
    la      $s1, result
loop2:
    # rotate high bit to bit0
    rol     $s5, $s5, 1     # rotate pattern
    # test bit0
    andi    $t0, $s5, 1
    # skip if bit0 is 1
    bne     $t0, $zero, skip   # compare with blank
    # get character at (s0)
    lbu     $t1, ($s0)
    # save character in (s1)
    sb      $t1, ($s1)
    # advance s1 'result' address
    addi    $s1, $s1, 1
skip:
    # advance s0 'text' address
    addi     $s0, $s0, 1     # shift pattern
    # loop2 if not done (s0 != s7)
    bne     $s0, $s7, loop2     
    # print 'result'
    la  $a0, result
    li  $v0, 4
    syscall
#---- terminate ---
exit:
    li  $v0, SYS_EXIT
    syscall
        
#.end main
