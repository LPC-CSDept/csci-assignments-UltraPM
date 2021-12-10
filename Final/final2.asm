# final2.asm
# Final Exam: Question 2
# Name: Phillip Mai
# Dec. 10, 2021
# Make MIPS assembly program with Memory Mapped I/O that take the user character and print it in a console until 'q' is typed. Also, make the interrupt handler(Kernel text program)
# OFF Bare Machine, OFF Enable Delayed Branches, ON Enable Mapped IO, OFF Enable Delayed Loads, OFF Load Exception Handler, ON Accept Pseudo Instruction
# I copy from Lab-MMIO2.asm & IntIO-Kernel-Lab2.asm with some changes that make it tpyed characters in a console list until close by q
#

		.kdata     #   kernel data     
s1:     .word 10     
s2:     .word 11    
new_line: .asciiz     "\n"     
		

		.text     
		.globl     main     
main:     
		mfc0 	$a0, $12     #   read from the status register     
		ori     $a0,   0xff11     # enable all interrupts     
		mtc0 	$a0, $12     # write back to the status register     
		lui     $t0, 0xFFFF     #   $t0 =   0xFFFF0000     
		ori     $a0, $0, 2     #   enable keyboard interrupt     
		sw     	$a0, 0($t0)     # write back to 0xFFFF0000;     Receiver Control 

here:   j here     #   stay here forever     
		
		li 	$v0, 10     #   exit,if     it ever comes here     
		syscall     
		

		# KERNEL text ******************
		
		.ktext  0x80000180     # kernel code starts here     
		sw     	$v0, s1     #   We need to use these registers     
		sw     	$a0, s2     #   not using the stack because the interrupt      
							# might be triggered by a memory reference      
							# using a bad value of the stack pointer  

		mfc0 	$k0, $13     	#   Cause register     
		srl     $a0, $k0, 2     #   Extract   ExcCode     Field     
		andi    $a0, $a0, 0x1f  #   Get the exception code     
		bne     $a0, $zero,   kdone     # Exception Code 0 is I/O. Only processing I/O here     

		lui     $v0, 0xFFFF    	#   $v0 =   0xFFFF0000     
		lw     	$a0, 4($v0)   # 	get the input key     
		li 		$v0,1     		#   print it here.      
		syscall     			#   Note: interrupt routine should return very fast,     
								#   doing something like print is NOT a good practice!     
		li $v0,4     			#   print the new line     
		la $a0,   new_line
		syscall   

kdone:     
		lw     	$v0, s1     		# Restore other registers     
		lw     	$a0, s2     
		mtc0 	$0, $13     	#   Clear Cause register     
		mfc0 	$k0, $12     	# Set Status register     
		#andi    $k0, 0xfffd  	# clear EXL bit d = 1101   
		ori     $k0, 0x11     	#   Interrupts enabled     
		mtc0 	$k0, $12     	#   write back to status     
		eret    			 	# return to EPC    


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
	

# Example code to Enable all interrupts
mfc0 	$a0, $12     	#   read from the status register     
		ori     $a0,   0xff11    	# enable all interrupts     
		mtc0 	$a0, $12     	# write back to the status register 

# Example code to get the Exception Code
mfc0 	$k0, $13     	#   Cause register     
srl     	$a0, $k0, 2     	#   Extract   Exception Code Field     
andi    	$a0, $a0, 0x1f 	#   Get the exception code  

# loop:


done:
    li  $v0, 10     # Code 10 for exit
    syscall         # End program