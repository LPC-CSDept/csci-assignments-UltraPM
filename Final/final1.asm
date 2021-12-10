# final.asm
# Final Exam: Question 1
# Name: Phillip Mai
# Dec. 10, 2021
# Make MIPS assembly program with Memory Mapped I/O that print real decimal value for the 3 digit user input through the MM I/O by using the syscall. 
# OFF Bare Machine, OFF Enable Delayed Branches, ON Enable Mapped IO, OFF Enable Delayed Loads, OFF Load Exception Handler, ON Accept Pseudo Instruction
# I copy from Lab-MMIO.asm with some changes that make it enter 3 number digits
# 

    .data

    .text
    .globl  main

main:
    lw  $t9, 100                # $t9 = Number of digits(3), hundred for 3 digits
    lui $t0, 0xffff             # load upper immediate
wait:
    lw      $t1, 0($t0)         # Load Receiver Control to $t1
    andi    $t1, $t1, 0x0001    # test the Receiver control register has 1 in LSB (ready bit)
    beq     $t1, $zero, wait    # if LSB is 0, reset wait or if LSB is 1, continnes read a character from I/O device
    lw      $s0, 4($t0)         # Read data from Receiver Data to $s0

    sub     $s0, $s0, 48        # s0 = v0 - 48
    sub		$t9, $t9, 1
    beq 	$t9, $zero, read
    mul     $s1, $s0, 10        # It is the first digit among two digits
    b       wait

read:		
    add     $a0, $s1, $s0       # print 
    li  $v0, 1
    syscall 

done:
    li  $v0, 10     # Code 10 for exit
    syscall         # End program
