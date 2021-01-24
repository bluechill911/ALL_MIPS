#  Final Exam with subroutine, to sum some numbers
#  Author: Kurt Marley, 26-Nov-2019
# -------------------------------------------------#  Data Declarations
#========================================================
# FINAL INCLASS
#========================================================
#  Program to sum numbers in an 
#  array of 16-bit integers (short or .half)
#  and an array of 32-bit integers (.word) 
#  (You may use indexed or pointer array access)
#  -------------------------- C++ code ------------------
#  #include <iostream>
#  #include <string>
#  using namespace std;
#  void main()
#  {
#     const int SIZE = 8;
#     short[] halfs = { 6, 5, -1, 9, 2, 3, -8, 2, 4 };
#     int[]   words = { 6, 5,  1, 9, 2, 3,  8, 2 };
#     int sum = doSum(halfs, words, SIZE);
#     cout << sum << endl;
#  }
#  int doSum(short& h, int& w, int n)
#  {
#     int sum = 0;
#     for(int x = 0; x < n; x++)
#       if ( h[x] < 0 )
#           sum = sum + ( h[x+1] - w[x] );
#	else
#	    sum = sum + ( h[x+1] + w[x] );
#     return sum;
#  }

# -------------------------------------------------------
#  Data Declarations
.data
    .eqv    SYS_PRINT_WORD   1  #word, byte, character
    .eqv    SYS_PRINT_TEXT   4  #text (zero terminated)
    .eqv    SYS_EXIT        10  #terminate

            .eqv        SIZE        8
halfs:      .half       6, 5, -1, 9, 2, 3, -8, 2, 4
words:      .word       6, 5,  1, 9, 2, 3,  8, 2 
endl:       .asciiz     "\n"

# -------------------------------------------------#  text/code section
.text
.globl  main 
main:
# ------
    #TODO: call doSum(values, SIZE)
    la      $a0, halfs  #Inputs
    la      $a1, words
    li	    $a2, SIZE
    jal	    doSum       #get special sum
    move    $a0, $v0
    # Print the sum results
    li      $v0, SYS_PRINT_WORD
    syscall
    la      $a0, endl
    li      $v0, SYS_PRINT_TEXT
    syscall
# ------
#  Done, terminate program. 
    li      $v0, SYS_EXIT   # call code for terminate
    syscall 
#.end main
#--------------------------------------------------------------
# Subroutine: doSum()
# Inputs:     $a0 - address of halfs[] array of .half
#             $a1 - address of words[] array of .word
#             $a2 - number of elements in the array
# Outputs:    $v0 - special sum
#--------------------------------------------------------------
#     for(int x = 0; x < n; x++)
#       if ( h[x] < 0 )
#           sum = sum + ( h[x+1] - w[x] );
#	else
#	    sum = sum + ( h[x+1] + w[x] );
#     return sum;
doSum:  
	#TODO: write the subroutine
	li	$v0, 0		#total
loopSum:
	lh	$t0, 0($a0) 	#half[x]
	bgez	$t0, elseAdd	#half[x] >= 0 else
	lh	$t2, 2($a0)     #half[x+1]
	lw	$t1, 0($a1)	#word[x]
	sub	$t3, $t2, $t1   #h[x+1] - w[x]
	add	$v0, $v0, $t3   #sum = sum + t3
	addi	$a0, $a0, 2     #increment
	addi 	$a1, $a1, 4	#increment
	blt	$t1, $a2, loopSum
	
elseAdd:
	lh	$t0, 2($a0)	#h[x+1]
	lw	$t1, 0($a1)	#w[x]
	add	$t3, $t0, $t1   #h[x+1] + w[x]
	add	$v0, $v0, $t3   #sum = sum + t3
	addi	$a0, $a0, 2	#increment
	addi 	$a1, $a1, 4	#increment
	blt	$t1, $a2, loopSum	
	
retSum:	jr	$ra
	
	
