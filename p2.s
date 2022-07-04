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
##	$ spim -file 2.s
##      SPIM Version 6.5 of January 4, 2003
##      Copyright 1990-2003 by James R. Larus (larus@cs.wisc.edu).
##      All Rights Reserved.
##      See the file README for a full copyright notice.
##      Loaded: /opt/spim-6.5/share/spim-6.5/trap.handler
##      Problem 2: 1 10 0
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
##    		  PROBLEM 2: min4
##
## Return the minimum, assuming unsigned integers, of $a0, $a1, $a2,
## and $a3 in $v0.
##################################################################### 	
	      
min4:
		# YOUR CODE HERE

		sgt $t0 $a1, $a0
		bne $t0 $zero, .L6

		b .L3

.L6:

	    sgt $t1 $a2, $a0
		bne $t1 $zero, .L1

		b .L2

	  

.L1:
		
	    sgt $t2 $a3, $a0
		bne $t2 $zero, .M0

		b .M3

	   
.L2:
		
		sgt $t3 $a3, $a2
		bne $t3 $zero, .M2

		b .M3
	   



.L3:
		sgt $t4 $a2, $a1
		bne $t4 $zero, .L4

		b .L5

	   

.L4:
		sgt $t5 $a3, $a1
		bne $t5 $zero, .M1

		b .M3
	  
	  

.L5:
		sgt $t6 $a3, $a2
		bne $t6 $zero, .M2

		b .M3
	   

.M0:
		move $v0, $a0
		jr   $ra	
.M1:	
		move $v0, $a1
		jr   $ra	
.M2:	
		move $v0, $a2
		jr   $ra	
.M3:	
		move $v0, $a3
		jr   $ra		



####################################################################
##            DO NOT MODIFY BELOW THIS LINE                       ##
####################################################################

main:
########################################
##            TEST PROBLEM 2          ##
########################################

	      li    $a0, 2
	      jal   print_problem_header

	      li    $a0, 1
	      li    $a1, 10
	      li    $a2, 100
	      li    $a3, 1000
	      jal   min4              # min4 = 1
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      li    $a0, 1000
	      li    $a1, 10
	      li    $a2, 100
	      li    $a3, 1000
	      jal   min4              # min4 = 10
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      li    $a0, 10
	      li    $a1, 1
	      li    $a2, 0
	      li    $a3, 8
	      jal   min4              # min4 = 0
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
	