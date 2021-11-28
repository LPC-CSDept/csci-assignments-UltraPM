.data
Msg1: .asciiz "Convert Int to Single Precision: \n"
Num1: .word 10 #Declare Single integer number

.text
.globl main
main:	lw $s0, Num1	#Load word into storage
	mtc1 	$v0, $f4	#Puts integer into Floating Point Register
	cvt.s.w $f1, $f1  # Converted to Floating Point Single

  li $v0, 4
  la $a0, Msg1
  syscall
	li  $v0, 2 	# Print a float
	mov.s $f12, $f1  	# Put Floating Point number in $12
	syscall
# Revert?
	cvt.s.w $f1, $f1  # Converts Single Float to Int

	mtct 	$s0, $f1 # Takes int from FP Register & put it into a integer register

	jr	$ra
	li $v0, 10 # end of program
	sysclall




