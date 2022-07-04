#############################################################################
## 
##       		     HOMEWORK 3
##
## - Fill in the functions described below.
## - Modify only the function bodies.  Do not modify any of the function
##   names or other parts of this file.
## - All of your implementations should adhere to MIPS calling conventions.
## - When working correctly, your file should print out the following (one
##   line of output for each question):	
##
##	$ spim -file 3.s
##      SPIM Version 6.5 of January 4, 2003
##      Copyright 1990-2003 by James R. Larus (larus@cs.wisc.edu).
##      All Rights Reserved.
##      See the file README for a full copyright notice.
##      Loaded: /opt/spim-6.5/share/spim-6.5/trap.handler
##      Problem 3: 2 -1 -1 0
##	
##                Administrative Instructions
##	
## - We will be testing your programs using QtSPIM
## - For download, from http://spimsimulator.sourceforge.net/
## - Documentation can be found here:
##         http://spimsimulator.sourceforge.net/further.html
##
##   NB: The entire file is a single namespace, meaning your label names
##   need to be globally unique.
##	
##################################################################### 

	      .data
newline:      .asciiz "\n"
problem:      .asciiz "Problem"
somechars:    .asciiz "ABC?.3"
hello:	      .asciiz "hello"
world:	      .asciiz "world"
help:	      .asciiz "help"
vec1:	      .word 40, 100, 0
vec2:	      .word 40, 35, 47, 200, 43, 37, 31, 90, 62
vec3:	      .word -5, 0
vec4:	      .word 0
	      
	      .text
	      .globl main
	      
##################################################################### 
##    		PROBLEM 3: length
##
## Given a zero-terminated list of 4 byte integers ranging from 1-100
## (inclusive), count the number of elements in the list.
##  - The terminating zero should not be included in the count.
##  - If a value outside of legal range (1 >= x <= 100) is found
##    indicate an error by returning -1.
##  - Function takes one argument, a pointer to the start of the list
##################################################################### 
	
length:
		# YOUR CODE HERE
		move $t1, $a0
		move $t0, $zero
		li $t2, 1
		li $t4, 100

LOOP:

		lw $t3, 0($t1)
		beq $t3, $0, Exit

		blt $t3, $t2, Error
		blt $t4, $t2, Error

		addi $t0, $t0, 1
		addi $t1, $t1, 4 

        j LOOP

Exit:
		move $v0, $t0
		jr $ra

Error:
		addi $v0, $zero, -1
		jr $ra


####################################################################
##            DO NOT MODIFY BELOW THIS LINE                       ##
####################################################################

main:
########################################
##            TEST PROBLEM 3          ##
########################################

	      li    $a0, 3
	      jal   print_problem_header

	      la    $a0, vec1
	      jal   length            # length = 2
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      la    $a0, vec2
	      jal   length            # length = -1
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      la    $a0, vec3
	      jal   length            # length = -1
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      la    $a0, vec4
	      jal   length            # length = 0
	      move  $a0, $v0
	      jal   print_int
	      jal   print_newline

########################################
##            EXIT                    ##
########################################

	      li    $v0, 10
	      syscall


####################################################################
##                      HELPER FUNCTIONS                          ##
####################################################################

print_problem_header:
	      addi  $sp, $sp -8
	      sw    $s0, 0($sp)
	      sw    $ra, 4($sp)
	      move  $s0, $a0
	      la    $a0, problem
	      jal   print_string
	      jal   print_space
	      move  $a0, $s0
	      jal   print_int
	      li    $a0, 58
	      jal   print_char
	      jal   print_space
	      lw    $s0, 0($sp)
	      lw    $ra, 4($sp)
	      addi  $sp, $sp, 8
	      jr    $ra

print_string:
	      li    $v0, 4
	      syscall
	      jr    $ra

print_char:   li    $v0, 11
	      syscall
	      jr    $ra
	      
print_int:    li    $v0, 1 
	      syscall
	      jr    $ra

print_space:
	li    $a0, 32
	li    $v0, 11
	syscall
	jr    $ra
	
print_newline:
	      la    $a0, newline
	      li    $v0, 4
	      syscall
	      jr    $ra

####################################################################
##                       END OF FILE                              ##
####################################################################
	
