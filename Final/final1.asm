# final1.asm
# Final Exam: Question 1
# Name: Phillip Mai
# Dec. 10, 2021
# Make MIPS assembly program with Memory Mapped I/O that print real decimal value for the 3 digit user input through the MM I/O by using the syscall. 
# OFF Bare Machine, OFF Enable Delayed Branches, ON Enable Mapped IO, OFF Enable Delayed Loads, OFF Load Exception Handler, ON Accept Pseudo Instruction
# I copy from Lab-MMIO.asm with some changes that make it enter 3 number digits
# 

    .text
    .globl  main

main:
    li  $t9, 100                # $t9 = Number of digits(3), hundred for 3 digits
    lui $t0, 0xffff             # load upper immediate
wait:
    lw      $t1, 0($t0)         # Load Receiver Control to $t1
    andi    $t1, $t1, 0x0001    # test the Receiver control register has 1 in LSB (ready bit)
    beqz    $t1, wait           # if LSB is 0, reset wait or if LSB is 1, continnes read a character from I/O device
    lw      $s0, 4($t0)         # Read data from Receiver Data to $s0

    sub     $s0, $s0, 48        # s0 = v0 - 48 to convert from ASCII
    mul     $s0, $s0, $t9       # Multiply $s0 by the place value factor in $t9
    div     $t9, $t9, 10        # Divide $t9 to decrease place value factor to the next place
    add     $s1, $s1, $s0       # Add current digits value to $s1
    bnez    $t9, wait           # Polling for next phase

read:
    add     $a0, $s1, $zero     # Copying $t9 to $a0 
    li      $v0, 1              # Syscall code to print input
    syscall 

done:
    li  $v0, 10                 # Code 10 for exit
    syscall                     # End program
