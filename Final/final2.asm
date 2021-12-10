# final2.asm
# Final Exam: Question 2
# Name: Phillip Mai
# Dec. 10, 2021
# Make MIPS assembly program with Memory Mapped I/O that take the user character and print it in a console until 'q' is typed. Also, make the interrupt handler(Kernel text program)
# OFF Bare Machine, OFF Enable Delayed Branches, ON Enable Mapped IO, OFF Enable Delayed Loads, OFF Load Exception Handler, ON Accept Pseudo Instruction
# I copy from Lab-MMIO2.asm with some changes that make it enter 3 number digits
#

    .data

    .text
    .globl  main
main:

	li	$s0, 100		# ASCII code for 'q' (Meaning if you press 'q' the program end)
	lui	$t0, 0xFFFF

rd_wait:
	lw	$t1, 0($t0)		# load from the input control register 
	andi	$t1, $t1, 0x0001	# reset (clear) all bits except LSB (least significant bit)
	beq	$t1, $zero, rd_wait		# if not ready(0) restart loop, if ready(1) continue
	lw	$v0, 4($t0)		# input device is ready, so read 
	
wr_wait:
	lw	$t1, 8($t0)		# load the output control register 
	andi	$t1, $t1, 0x0001	# reset all bits except (least significant bit)
	beq	$t1, $zero, wr_wait	# if not ready, then loop back
	sw	$v0, 12($t0)		# output device is ready, so write
	
	bne	$v0, $s0, rd_wait	# branch to rd_wait if there more than ASCII code 'q'
	

# loop:


done:
    li  $v0, 10     # Code 10 for exit
    syscall         # End program