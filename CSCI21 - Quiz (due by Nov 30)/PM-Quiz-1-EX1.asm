## PM-Quiz-1-EX1.asm
## Phillip Mai
## Novermber 26, 2021
## [Quiz] MIPS Floating Point - Program Quiz  (DUE Nov. 30, 2021)
## [1] Make an assembly program for converting single-precision temperatures from Fahrenheit to Celsius.(20 pts)
## Celsius = ((Fahrenheit - 32)*5)⁄9
## Show the assembly code and the printed result(screenshot). Make comments with the pseudo-high-level code. 
## 1. Ask to user for Fahrenheit value (take the integer value)
## 2. Convert it to the floating-point value
## 3. Calculate the Celsius degree
## 4. Print the result as a floating value
## OFF Bare Machine, OFF Enable Delayed Branches, OFF Enable Mapped IO, OFF Enable Delayed Loads, ON Load Exception Handler, ON Accept Pseudo Instruction
##
	.data
input:	.asciiz "\nEnter the Temperature in Fahrenheit: "
repeat:	.asciiz "\nThe Temperature in Fahrenheit is: "
output:	.asciiz "\nThe Temperature in Celsius is: "

	.text
	.globl	main
main:	li	$v0, 4		# print input on terminal
	la	$a0, input	# store input in $a0
	syscall

	li	$v0, 6		# 6 used to read the single precision integer
	syscall

	mtc1	$v0, $f4	# Puts integers into floating point register, $v0 = $f4
	cvt.s.w	$f5, $f4	# Convert to floating point single value

	li.s	$f1, 32.0	# $f1 = 32.0
	li.s	$f2, 5.0	# $f2 = 5.0
	li.s	$f3, 9.0	# $f3 = 9.0

	mov.s	$f4, $f0	# $f4 = $f0 = Fahrenheit

	sub.s	$f0, $f0, $f1	# To convert, farenheit subtract 32; (Farenheit -32)
	mul.s	$f0, $f0, $f2	# Then, muiltity by 5; (Farenheit -32)*5.0
	div.s	$f0, $f0, $f3	# Finally, divide by 9; (Farenheit -32)*5.0)/9.0

	la	$a0, repeat	# Print repeat string result
	li	$v0, 4		# System call to print
	syscall

	mov.s	$f12, $f4	# Put floating point number in $f12 then copy repeat value to print
	li	$v0, 2		# Print a floating point code
	syscall			# Print repeat code result

	li	$v0, 4		# system call to print
	la	$a0, output	# Print output string result
	syscall

	mov.s	$f12, $f0	# Put floating point number in $f12, then copy output value to print
	li	$v0, 2		# print floating point code
	syscall			# Print output code result

	li	$v0, 10		# Use 10 to end code
	syscall			# Exit to System

## end of file
