# InClass/ ArrayAccess.asm: Print Word, Half, Byte
# void main()
# {
#	int[]   word = {0,1,2,3,4,5,6,7};
#	short[] half = {0,1,2,3,4,5,6,7,0,0,0,0,0,0,0,0};
#	byte[]  tiny = {0,1,2,3,4,5,6,7};
#	cout << word[5] << endl;
#	cout << half[5] << endl;
#	cout << tiny[5] << endl;
# } //end main
.data
word:	.word	0,1,2,3,4,5,6,7
half:	.half	0,1,2,3,4,5,6,7,0,0,0,0,0,0,0,0
tiny:	.byte	0,1,2,3,4,5,6,7,8
endl:	.asciiz "\n"
.text
.globl main
main:
	li	$t0, 5		#index   base_addr + index * element_size
	# WORD[5] *(4)
	la	$s0, word	# &word[0]
	sll	$t1, $t0, 2	# *4
	add 	$t7, $s0, $t1 	# &word[5]
	lw	$a0, ($t7)
	li	$v0, 1
	syscall
        la	$a0, endl
        li	$v0, 4		# SYS_PRINT_TEXT
        syscall
        
	# HALF[5]
	la	$s0, half	# &word[0]
	sll	$t1, $t0, 1	# *2
	add 	$t7, $s0, $t1 	# &word[5]
	lh	$a0, ($t7)
	li	$v0, 1
	syscall
        la	$a0, endl
        li	$v0, 4		# SYS_PRINT_TEXT
        syscall

	# TINY[5]
	la	$s0, tiny	# &word[0]
	sll	$t1, $t0, 0	# *1
	add 	$t7, $s0, $t1 	# &word[5]
	lb	$a0, ($t7)
	li	$v0, 1
	syscall
        la	$a0, endl
        li	$v0, 4		# SYS_PRINT_TEXT
        syscall

#--- exit ---
	li	$v0, 10
	syscall
