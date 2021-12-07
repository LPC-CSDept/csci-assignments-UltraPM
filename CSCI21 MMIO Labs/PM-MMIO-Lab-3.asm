# PM-MMIO-Lab-3.asm
# Phillip Mai
# 12/3/21
# Ouput int value to console using MMIO
# Lab 3: Print the decimal value through the Memory-Mapped I/O
# value = 42, $v1 = 40 / 10, $v0 = $v1 + 48  # ASCII code, Display $v0 through MMIO, $v1 = 40 % 10, $v0 = $v1 + 48, Display $v0 through MMIO
# OFF Bare Machine, OFF Enable Delayed Branches, ON Enable Mapped IO, OFF Enable Delayed Loads, OFF Load Exception Handler, ON Accept Pseudo Instruction
#
	.text
	.globl	main
main:	li	$t0, 42			# Value = 42
	or	$t1, $t0, $zero		# $t2 = $t0

DigitCount:
	add	$t2, $t2, 1		# increment DigitCount as $t1
	div	$t1, $t1, 10		# Divide by 10
	bnez	$t1, DigitCount		# reiterate DigitCount if $t2 doesn't equal 0
	
reset:
	or	$t1, $t0, $zero		# Reset $t1 to $t0
	or	$t3, $t2, $zero		# Reset $t3 to $t2
GetDigit:
	sub	$t3, $t3, 1		# decrement digit count
	beqz	$t3, Convert		# branch to convert if least significant digit
	div	$t1, $t1, 10		# Divide by 10
	bgt	$t3, 1, GetDigit	# reiterate GetDigit if no least significant digit
	
Convert:
	rem	$v0, $t1, 10		# $v1 = 40 % 10
	add	$v0, $v0, 48		# $v0 = $v1 + 48
	
	lui	$t9, 0xFFFF		# Display $v0 through MMIO

wr_wait:
	lw	$t4, 8($t9)		# load the output control register
	andi	$t4, $t4, 0x0001	# reset all bits except (least significant bit)
	beqz	$t4, wr_wait		# if not ready, then loop back
	sw	$v0, 12($t9)		# output device is ready, so write
	
	sub	$t2, $t2, 1		# decrement digit count 
	bnez	$t2, reset		# if not the last digit branch to handle the next digit
	
	li	$v0, 10			# Code 10 for exit
	syscall				# End program