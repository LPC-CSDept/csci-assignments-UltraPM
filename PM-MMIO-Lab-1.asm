# PM-MMIO-Lab-1.asm
# Phillip Mai
# 12/2/2021
# Implementation of Memory Mapped I/O
# Lab 1 MMIO: Make a MIPS Assembly Code to take one character from the user and then display it
# OFF Bare Machine, OFF Enable Delayed Branches, ON Enable Mapped IO, OFF Enable Delayed Loads, OFF Load Exception Handler, ON Accept Pseudo Instruction
#

	.text
	.globl	main

main:	lui	$t0, 0xffff

rd_Wait:
	lw	$t1, 0($t0)		# load from the input control register 
	andi	$t1, $t1, 0x0001	# reset (clear) all bits except LSB 
	beq	$t1, $zero, rd_Wait		# if not yet ready, then loop back
	lw	$v0, 4($t0)		# input device is ready, so read 

	lui	$t0, 0xffff

wr_Wait:
	lw	$t1, 8($t0)		# load the output control register 
	andi	$t1, $t1, 0x0001	# reset all bits except LSB 
	beq	$t1, $zero, wr_Wait	# if not ready, then loop back 
	sw	$v0, 12($t0)		# output device is ready, so write

	li	$v0, 10			# exit
	syscall