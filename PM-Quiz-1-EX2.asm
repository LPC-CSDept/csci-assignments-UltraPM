## PM-Quiz-1-EX2.asm
## Phillip Mai
## Novermber 26, 2021
## [Quiz] MIPS Floating Point - Program Quiz (DUE Nov. 30, 2021)
## [2] Make an assembly program (20pts)
## Calculate AX^2 + BX + C, ask the user for X, A, B, C coefficients 
## Show the assembly code and the printed result(screenshot). Make comments with the pseudo-high-level code. 
## OFF Bare Machine, OFF Enable Delayed Branches, OFF Enable Mapped IO, OFF Enable Delayed Loads, ON Load Exception Handler, ON Accept Pseudo Instruction
##

	.data
valX:	.asciiz	"Enter a value for x: "		# prompt for x coefficient
valA:	.asciiz	"Enter a value for a: "		# prompt for A coefficient
valB:	.asciiz	"Enter a value for b: "		# prompt for B coefficient
valC:	.asciiz	"Enter a value for c: "		# prompt for C coefficient
result:	.asciiz "The sum of ax^2 + bx + c is: "

	.text
	.globl	main

main:	la	$a0, valX	# Enter X value
	li	$v0, 4		# print string
	syscall
	li	$v0, 6		# read single precision
	syscall			# $f0 <= x
	move	$t0, $v0	# store input X value that taken user into any register

	la	$a0, valA	# Enter A value
	li	$v0, 4		# print string
	syscall
	li	$v0, 6		# read single precision float
	syscall			# $f1 <= A
	mov.s	$f1, $f0	# Move A to saved register

	la	$a0, valB	# Enter B value
	li	$v0, 4		# print string
	syscall
	li	$v0, 6		# read single precision float
	syscall			# $f2 <= B
	mov.s	$f2, $f0	# Move B to saved register

	la	$a0, valC	# Enter C value
	li	$v0, 4		# print string
	syscall
	li	$v0, 6		# read single precision float
	syscall			# $f3 <= C
	mov.s	$f3, $f0	# Move C to saved register

# evaluate the quadratic equcation
	mul.s	$f4, $f0, $f0	# $f4 = x^2
	mul.s	$f4, $f4, $f1	# $f4 = ax^2
	mul.s	$f2, $f2, $f0	# $f2 = bx
  	add.s	$f4, $f2, $f4	# $f4 = ax^2 + bx
  	add.s	$f4, $f4, $f3	# $f4 = ax^2 + bx + c

	addi	$v0, $zero, 4	# Print output result string
	la	$a0, result	# Load result prompt for sum = ax^2 + bx + c
	syscall

	mov.s	$f12,$f4	# Put Floating Point number in $f12 = argument
	li	$v0, 2		# print a float
	syscall

	li	$v0, 10 	# code 10 to exit program
	syscall			# Return to OS

# end