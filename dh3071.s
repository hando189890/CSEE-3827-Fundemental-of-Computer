        .data


AVCorrect:        .asciiz "\nCorrect Assessment"
AVKeyName:       .asciiz " keyval "
AVFailLead:      .asciiz "Test "
AVFalsePos:        .asciiz ": failed with correct key\n"
AVFalseNeg:      .asciiz ": failed (says correct) with wrong key\n"
AVStartTest:     .asciiz "\nStarting Test "
NewLine:        .asciiz "\n"
AVDone:         .asciiz "\nALL DONE\n"


Found: .asciiz "Result: "
        
EncryptedPhrase: .word 0x5f7fb06, 0xfb06f2f8, 0xc0704fb, 0xf9fbf7f3, 0x6f306fb, 0x700f809, 0xf805f30b, 0xf300f808, 0xf7080706, 0x60700f8, 0x8f3faf3, 0x4f5f2f7, 0xf7fdf5f4, 0x801f2f7, 0x1f5f304, 0xf2f6f7f7, 0x605f7ff, 0xf2f7f9f3, 0xfaf401f7, 0x0

DecryptionSpace: .space 400 # 400 bytes of space, more than enough...


.text
j main 



main:
		
		li $s0,0x01010101
mainLoop:
		bgeu $s0,0xFEFEFEFE,mainLoopEnd
		la $a0,EncryptedPhrase
		la $a1,DecryptionSpace
		move $a2,$s0
		jal AddAndVerify
		bne $v0, 1, continue
foundKey:             
		la $a0, Found     
		li $v0, 4         
		syscall			 
						  
		la $a0, NewLine   
		li $v0, 4         
		syscall			 
						  
		move $a0, $s0     
		li $v0, 1         
		syscall			 
						  
		la $a0, NewLine   
		li $v0, 4         
		syscall			 
		la $a1,DecryptionSpace				  
		move $a0, $a1     
		li $v0, 4         
		syscall			 
						  
						  
		la $a0, NewLine   
		li $v0, 4         
		syscall			 
						  
		la $a0, NewLine   
		li $v0, 4         
		syscall		
continue:
		li $t0, 0x01010101
		addu $s0, $s0, $t0
		b mainLoop
mainLoopEnd:
		
	la $a0, AVDone       
	li $v0, 4         
	syscall			 
	li $v0, 10        
	syscall           
					  
					  
 

        
        ############# Put Code for AddAndVerify, IsCandidate, WordDecrypt Here
WordDecrypt:
	addiu   $sp, $sp, -20
	sw      $ra, 0($sp)
	sw      $s0, 4($sp)
	sw      $s1, 8($sp)
	sw      $s2, 12($sp)
	sw      $s3, 16($sp)
	
	move $s0,$a1
	addu $s1,$a0,$a1
	addu $v0,$s1,$a2
	bltu $v0,$a1,overflow
	li $v1,0
	j WordDecrypt.return
overflow:
	li $v1,1
WordDecrypt.return:
	lw      $s3, 16($sp)
	lw      $s2, 12($sp)
	lw      $s1, 8($sp)
	lw      $s0, 4($sp)
	lw      $ra, 0($sp)
	addiu   $sp, $sp, 20
	jr $ra
	

IsCandidate:
	addiu   $sp, $sp, -20
	sw      $ra, 0($sp)
	sw      $s0, 4($sp)
	sw      $s1, 8($sp)
	sw      $s2, 12($sp)
	sw      $s3, 16($sp)
	
	move $s0,$a0
	li $v0,1
IsCandidateLoop:
	beq $s0,$zero,IsCandidate.return

	andi $s2,$s0,255
	bltu $s2,64,checkFailed
	bgtu $s2,90,checkFailed
	
	srl $s0,$s0,8
	b IsCandidateLoop
checkFailed:
	li $v0,0
IsCandidate.return:
	lw      $s3, 16($sp)
	lw      $s2, 12($sp)
	lw      $s1, 8($sp)
	lw      $s0, 4($sp)
	lw      $ra, 0($sp)
	addiu   $sp, $sp, 20
	jr $ra
	
	
AddAndVerify:
	addiu   $sp, $sp, -20
	sw      $ra, 0($sp)
	sw      $s0, 4($sp)
	sw      $s1, 8($sp)
	sw      $s2, 12($sp)
	sw      $s3, 16($sp)
	
	
	#li $s3,0
	move $s0,$a0
	move $s1,$a1
	move $s2,$a2
#AddAndVerifyLoop:
	#sll $t1,$s3,2
	#add $t1,$t1,$s0
	lw $t1,0($s0) #load a word 
	beq $t1,0,AddAndVerifyLoopDone
	
	addi $a0,$s0,4
	addi $a1,$s1,4
	move $a2,$s2
	jal AddAndVerify
	beq $v0, 0, suffixInvalid
	
	lw $a0,0($s0)
	move $a1, $s2
	move $a2, $v1
	jal WordDecrypt
	move $a0, $v0
	sw $v0, 0($s1)
	jal IsCandidate
	b AddAndVerify.return
	#addi $s3,$s3,1
	#b AddAndVerifyLoop
AddAndVerifyLoopDone:
	#beq $s3,0,nullString
nullString:
	sw $zero,0($s1)
	li $v0, 1
	li $v1, 0
	b AddAndVerify.return
suffixInvalid:
	li $v0, 0
	li $v1, 0

AddAndVerify.return:
	lw      $s3, 16($sp)
	lw      $s2, 12($sp)
	lw      $s1, 8($sp)
	lw      $s0, 4($sp)
	lw      $ra, 0($sp)
	addiu   $sp, $sp, 20
	jr $ra

