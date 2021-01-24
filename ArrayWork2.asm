# InClass/ ArrayWork2.asm: Practice for Final
# void main() {  // SUM
#     const int SIZE = 7;
#     int[] values = {3, 5, 1, 9, -2, 3, 8};
#     int sum = 0;
#     for(int x = 0; x < SIZE; x++)
#		sum += values[x]
#	cout << sum << endl;
# } //end main

.data
    .eqv    SYS_PRINT_WORD   1  #word, byte, character
    .eqv    SYS_PRINT_TEXT   4  #text (zero terminated)
    .eqv    SYS_EXIT        10  #terminate
    
    .eqv	SIZE		7
values:		.word		3, 5, 1, 9, -2, 3, 8 #added one
endl:		.asciiz 	"\n"

.text
.globl main
main:
# Compute a sum for the integers in values[]
# Use a subroutine
	la	$a0, values	#1st input: word array address
	la	$a1, endl	#2nd input: array ending address
	jal	doSum		#call doSum subroutine: result in $v0
	move	$a0, $v0	#move $v0 into $a0 for printing
	li	$v0, SYS_PRINT_WORD
	syscall
	la	$a0, endl
	li	$v0, SYS_PRINT_TEXT
	syscall
exit:
	li	$v0, SYS_EXIT
	syscall

#------------------------------------------------------
# doSum: sum up values in an array of words
#	Input: $a0 - address of the array, element [0]
#	Input: $a1 - ending address
#      Output: $v0 - the sum
#------------------------------------------------------
doSum:	#TODO - write the subroutine
	li	$v0, 0		#starting sum is zero
loop:	bge	$a0, $a1, retSum
	lw	$t0, ($a0)
	add	$v0, $v0, $t0
	add	$a0, $a0, 4	#x++
	j	loop

retSum:
	jr	$ra


