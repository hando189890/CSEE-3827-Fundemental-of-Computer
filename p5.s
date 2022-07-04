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
##	$ spim -file 5.s
##      SPIM Version 6.5 of January 4, 2003
##      Copyright 1990-2003 by James R. Larus (larus@cs.wisc.edu).
##      All Rights Reserved.
##      See the file README for a full copyright notice.
##      Loaded: /opt/spim-6.5/share/spim-6.5/trap.handler
##      Problem 5: 0 2 2 4
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
##	        PROBLEM 5: hamming
##
##  Compute the hamming distance (i.e., number of different characters)
##  between two strings.
##  - The two arguments are pointers to two null-terminated strings
##    of characters.
##  - If one string is shorter than the other, the mismatches all
##    count as 1, e.g., hello
##                      help
##                      00011 = hamming distance of 2        
##  - You should use your diffchar function from problem 4.
#####################################################################

diffchar:     
		# YOUR CODE HERE

    	beq $t1, $t2, Correct
        b Exit
       

Correct: 
		addi $v1, $zero, 0
		j Next
	
		

Exit:
        
  		addi $v1, $zero, 1
  		j Next




hamming:      
		# YOUR CODE HERE
		move $t0, $zero 
		j loop


loop:

		lb $t1, 0($a0) 
		lb $t2, 0($a1) 
		
		beq $t1, $zero, h1
		beq $t2, $zero, h2

		li $v1, -1

		j diffchar

		

Next:
		addu $t0, $t0, $v1
		addi $a0, $a0, 1 
		addi $a1, $a1, 1 

		j loop 

h1:     
        lb $t2, 0($a1)
        beq $t2, $zero, End

        addu $t0, $t0, 1
        addi $a1, $a1, 1 

        j h1

h2:     
	lb $t1, 0($a0)
        beq $t1, $zero, End

        addu $t0, $t0, 1
        addi $a0, $a0, 1 

        j h2


End:
        move $v0, $t0
		jr $ra



####################################################################
##            DO NOT MODIFY BELOW THIS LINE                       ##
####################################################################


main:
########################################
##            TEST PROBLEM 5          ##
########################################

	      li    $a0, 5
	      jal   print_problem_header

	      la    $a0, hello
	      la    $a1, hello
	      jal   hamming         # hamming = 0
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      la    $a0, hello
	      la    $a1, help
	      jal   hamming         # hamming = 2
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      la    $a0, help
	      la    $a1, hello
	      jal   hamming         # hamming = 2
	      move  $a0, $v0
	      jal   print_int
	      jal   print_space

	      la    $a0, hello
	      la    $a1, world
	      jal   hamming         # hamming = 4
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
	