# final2.asm
# Final Exam: Question 2
# Name: Phillip Mai
# Dec. 10, 2021
# Make MIPS assembly program with Memory Mapped I/O that take the user character and print it in a console until 'q' is typed. Also, make the interrupt handler(Kernel text program)
# OFF Bare Machine, OFF Enable Delayed Branches, ON Enable Mapped IO, OFF Enable Delayed Loads, OFF Load Exception Handler, ON Accept Pseudo Instruction
# I copy from Lab-MMIO2.asm & IntIO-Kernel-Lab2.asm with some changes that make it tpyed characters in a console list until close by q
#

		.kdata                  # kernel data     
s1:		.word   10
s2:		.word   11
new_line:	.asciiz "\n"    # newline

    .text     
    .globl  main
main:

	li	$s0, 113		# ASCII - Binary Character Table for 'q' (Meaning if you press 'q' the program end)

# Example code to Enable all interrupts
    mfc0    $a0, $12      	  # read from the status register     
    ori     $a0, 0xff11  	   # enable all interrupts     
    mtc0    $a0, $12      	  # write back to the status register 

    lui     $t0, 0xFFFF   	  # $t0 = 0xFFFF0000     
    ori     $a0, $0, 2    	  # enable keyboard interrupt     
    sw      $a0, 0($t0)   	  # write back to 0xFFFF0000; store to Receiver Control to enable interrupts

here:
	j	here					# loop forever until 'q' to close program

# KERNEL text ******************
		
	.ktext	0x80000180			# kernel code starts here     
	sw		$v0, s1				# We need to use these registers in KERNEL text
	sw		$a0, s2				# not using the stack because the interrupt in KERNEL text

# code to get the Exception Code
	mfc0	$k0, $13			# Cause register 
	srl		$a0, $k0, 2			# Extract Exception Code Field 
	andi	$a0, $a0, 0x1f		# Get the exception code 
	bne		$a0, $zero, kdone	# Exception Code 0 is I/O. Only processing I/O here 

	lui		$v0, 0xFFFF			# $v0 = 0xFFFF0000 and it memory addresss to start on MMIO
	lw		$a0, 4($v0)			# get the input key
	lw		$t1, 8($t0)			# load the output control register 
	andi	$t1, $t1, 0x0001	# reset all bits except (least significant bit)

	sw		$v0, 12($t0)		# output device is ready, so write

	bne		$a0, $s0, print		# branch to print if there more than ASCII code 'q'

	li	$v0, 10			#   print it 
	syscall 			#   Note: interrupt routine should return very fast, then end code section

print:
	li		$v0, 11				# Code to print it here.      
	syscall						    

	li		$v0, 4
	la		$a0, new_line		# $a0 to newline then print result 
	syscall

kdone:
	lw		$v0, s1				# Restore $v0 register 
	lw     	$a0, s2				# Restore $a0 register 
	mtc0	$0, $13				# Clear Cause register 
	mfc0 	$k0, $12			# Set Status register 
	ori		$k0, 0x11			# Interrupts enabled 
	mtc0	$k0, $12			# write back to status 
	eret						# return to EPC 
