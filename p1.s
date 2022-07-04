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
##	$ spim -file 1.s
##      SPIM Version 6.5 of January 4, 2003
##      Copyright 1990-2003 by James R. Larus (larus@cs.wisc.edu).
##      All Rights Reserved.
##      See the file README for a full copyright notice.
##      Loaded: /opt/spim-6.5/share/spim-6.5/trap.handler
##      Problem 1: 18 625 30
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
##    		 PROBLEM 1: weighted_avg
##
## Compute a weighted average of three 32-bit numbers, A, B, and C
## 	return (.25A + .25B + .5C)
## A,B, and C are in $a0, $a1, and $a2 respectively.  The result
## should be returned in $v0.
##	
## HINT: Do not use mult/div or floating point values.  To keep
## precision for as long as possible, minimize the number of
## division operations.	
##################################################################### 
				    
weighted_avg:
		# YOUR CODE HERE
		
		add $t0, $a0, $a1 # t0 = a0+a1
		add $t1, $a2, $a2 # t1 = a2+a2
		add $t2, $t0, $t1 # t2 = a0+a1 = a0+a1+a2+a2
		sra $v0, $t2, 2 # divide by 4
		
		jr $ra
	      
####################################################################
##            DO NOT MODIFY BELOW THIS LINE                       ##
####################################################################

main:
########################################
##         TEST PROBLEM 1             ##
########################################

	      li    $a0, 1
	      jal   print_problem_header

	      li    $a0, 42
	      li    $a1, 10
	      li    $a2, 10
	      jal   weighted_avg              # weighted_avg = 18
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      li    $a0, 500
	      li    $a1, 1000
	      li    $a2, 500
	      jal   weighted_avg              # weighted_avg = 625
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      li    $a0, 30
	      li    $a1, 31
	      li    $a2, 30
	      jal   weighted_avg              # weighted_avg = 30
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
	