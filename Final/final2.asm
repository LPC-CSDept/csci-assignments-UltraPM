# final2.asm
# Final Exam: Question 2
# Name: Phillip Mai
# Dec. 10, 2021
# Make MIPS assembly program with Memory Mapped I/O that take the user character and print it in a console until 'q' is typed. Also, make the interrupt handler(Kernel text program)
# OFF Bare Machine, OFF Enable Delayed Branches, ON Enable Mapped IO, OFF Enable Delayed Loads, OFF Load Exception Handler, ON Accept Pseudo Instruction
# I copy from Lab-MMIO.asm with some changes that make it enter 3 number digits
#

    .data

    .text
    .globl  main
main:


loop:


done:
    li  $v0, 10     # Code 10 for exit
    syscall         # End program