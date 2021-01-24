# Program: mlKeyboardDriver.asm
#  Author: Brandon Evans
#    Date: 4/20/20
# Purpose: Practice using XOR, random
#-------------------------------------------------------------------
# The left column is random keys depressed on a keyboard.
# A zero means the key is not pressed, a one means the key is pressed.
# You need to determine the CHANGES from one left-hand row to the next.
#    PREVIOUS ==>  0         1            1               0
#         NEW ==>  0         1            0               1
#     MEANING ==>  No      Key Still     Key            New Key
#                 Change    Pressed     Released        Depressed
# If a New Key is depressed, that bit should apprear on the Right.
#-------------------------------------------------------------------
# SAMPLE OUTPUT:
# 00000000000000000000000001101011  00000000000000000000000001101011
# 00000000000000000000000000100111  00000000000000000000000000000100
# 00000000000000000000000000110001  00000000000000000000000000010000
# 00000000000000000000000011011111  00000000000000000000000011001110
# 00000000000000000000000011001001  00000000000000000000000000000000
# 00000000000000000000000010101100  00000000000000000000000000100100
# 00000000000000000000000010000111  00000000000000000000000000000011
# 00000000000000000000000010001001  00000000000000000000000000001000
# 00000000000000000000000011001011  00000000000000000000000001000010
# 00000000000000000000000010110110  00000000000000000000000000110100
# 00000000000000000000000011100111  00000000000000000000000001000001
# 00000000000000000000000011110110  00000000000000000000000000010000
# 00000000000000000000000001001000  00000000000000000000000000001000
# 00000000000000000000000001101011  00000000000000000000000000100011
# 00000000000000000000000000011010  00000000000000000000000000010000
# 00000000000000000000000011001101  00000000000000000000000011000101

.data
    .eqv    SYS_PRINT_WORD   1  #word, byte, character
    .eqv    SYS_PRINT_FLOAT  2  #float  
    .eqv    SYS_PRINT_DOUBLE 3  #double
    .eqv    SYS_PRINT_TEXT   4  #text (zero terminated)
    .eqv    SYS_EXIT        10  #terminate
    .eqv    SYS_PRINT_CHAR  11  #print char
    .eqv    SYS_READ_CHAR   12  #read char
    .eqv    SYS_TIME        30  #system time to a1,a0
    .eqv    SYS_SLEEP       32  #delay a0 msec
    .eqv    SYS_PRINT_BIN   35  #print binary
    .eqv    SYS_SET_SEED    40  #set random seed
    .eqv    SYS_RAND_INT    42  #get random int
    
wait:       .word       1000     #1 second
max:        .word       16      #max loops
tab:        .asciiz "\t"
endl:       .asciiz "\n"
last:       .word       0       #last random    

.text
.globl  main
main:
    # get system time
    li      $v0, SYS_TIME       #get system time
    syscall
    # use system time lsb for seed a1, a0=0 for id
    move    $a1, $a0            #time lsw will be seed
    li      $a0, 0              #generator id 0
    li      $v0, SYS_SET_SEED
    syscall
    # initialize main loop: s7=max, s6=0 (loop counter) 
    lw      $s7, max	       #loop max
    move    $s6, $zero	       #s6=0 counter
    
    # main loop 
loop:
    # pause 'wait' msec using SYS_SLEEP
    li      $v0, SYS_SLEEP
    lw      $a0, wait
    syscall
    
    # get random integer in a0
    li      $v0, SYS_RAND_INT  #get random in $a-
    li	    $a0, 0             #generator ID
    li      $a1, 0xFFFF	      #max random
    syscall
    
    # load 'last' into s0
    lw      $s0, last
    
    # zero top 24 bits of a0 random
    andi    $a0, $a0, 0xFF
    
    # save a0 new random lsb into 'last' and move a0 into s1
    sw      $a0, last
    move    $s1, $a0
    # print a0 random lsb as binary
    li	    $v0, SYS_PRINT_BIN
    syscall
    
    # print a tab
    la	    $a0, tab
    li      $v0, SYS_PRINT_TEXT
    syscall
    # XOR s0 'last' with s1 new random lsb, save in a register
    xor     $s3, $s1, $s0
    
    # AND the XOR results with s1 new random lsb, print as binary
    and     $s4, $s1, $s3
    move    $a0, $s4
    li      $v0, SYS_PRINT_BIN
    syscall
    # print a new line
    li      $v0, SYS_PRINT_TEXT
    la	    $a0, endl
    syscall

    # end loop: s6++, if s6==s7 then branch to exit:
    #           else branch to loop:
    addi    $s6, $s6, 1
    beq     $s7, $s6, exit
    j       loop

#------------------------
# terminate program.
exit:
    li  $v0, SYS_EXIT   # call code for terminate
    syscall             # system call
#.end main
