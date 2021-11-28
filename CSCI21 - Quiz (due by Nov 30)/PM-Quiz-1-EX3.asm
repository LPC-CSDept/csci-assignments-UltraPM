## PM-Quiz-1-EX3.asm
## Phillip Mai
## Novermber 26, 2021
## [Quiz] MIPS Floating Point - Program Quiz (DUE Nov. 30, 2021)
## [3] Make an assembly program to calculate Newton’s method(20pts)
## Show the assembly code and the printed result(screenshot). Make comments with the pseudo-high-level code. 
## 1. Ask to user to n
## 2. Start with x = 1
## 3. Stop when |x’ - x |< 0.00001
## OFF Bare Machine, OFF Enable Delayed Branches, OFF Enable Mapped IO, OFF Enable Delayed Loads, ON Load Exception Handler, ON Accept Pseudo Instruction
##

	.data
ValN:	.asciiz	"Enter float value of n: "	# prompt for n 
nval:	.asciiz	"n = "				# repeat for n value 
nroot:	.asciiz "\nsquare root of n = "		# prompt for quare root of n 

	.text
	.globl main

main:	la	$a0, ValN	# Enter n value
	li	$v0, 4		# print string code
	syscall
	li	$v0, 6		# read single precision code
	syscall	

	li.s	$f3, 1.0	# constant 1.0
	li.s	$f4, 2.0	# constant 2.0
	li.s	$f5, 1.0	# x = first approx.
	li.s	$f10, 1.0e-5	# accuracy limit

loop:	mov.s	$f6, $f0	# copy n to another register
	div.s	$f6, $f6, $f5	# n/x
	add.s	$f6, $f5, $f6	# x' = x + n/x
	nop
	div.s	$f6, $f6, $f4	# x' = (x + n/x)/2
	sub.s	$f7, $f6, $f5	# x' - x to check if next approx is accurate enough
	abs.s	$f7, $f7	# absolute value of x' - x
	c.lt.s	$f7, $f10	# if x' - x <= .00001 then it is accurate enough
	bc1t	end		# end the loop if approx is accurate enough
	nop
	mov.s	$f5, $f6	# x = x'
	j	loop		# go back to loop
	nop

end:	la	$a0, nval	# address of "n = "
	li	$v0, 4		# print string code
	syscall
	mov.s	$f12, $f0	# copy n as print float arg
	li	$v0, 2		# print float code
	syscall
	la	$a0, nroot	# print "square root of n = "
	li	$v0, 4		# print string code
	syscall
	mov.s	$f12, $f6	# copy x' as print float arg
	li	$v0, 2		# print float code
	syscall
	li	$v0, 10		# end program code
	syscall
	
## end of file