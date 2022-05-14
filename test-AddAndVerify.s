        .data
DecryptStringSpace: .space 400 # 400 bytes of space, more than enough...

AVCorrect:        .asciiz "\nCorrect Assessment"
AVKeyName:       .asciiz " keyval "
AVFailLead:      .asciiz "Test "
AVFalsePos:        .asciiz ": failed with correct key\n"
AVFalseNeg:      .asciiz ": failed (says correct) with wrong key\n"
AVStartTest:     .asciiz "\nStarting Test "
NewLine:        .asciiz "\n"
AVDone:         .asciiz "\nALL DONE\n"


        
TestData:
        # format is good key, bad key, encode-phrase-len (in words), encode phrase
        .word 12, 25, 2, 0x433c3d3c, 0x433e3d3e, 0
        .word 17, 20, 6, 0x493e492f, 0x443e482f, 0x3c3e3c41, 0x33333d30, 0x48333330, 0x3041323e, 0
        .word 0, 0, 0


.text

main:
        la $t0, TestData
        li $t1, 0
        li $t4, 1
AddVerifyTestLoop:
        
        add $t2, $t0, $t1
        lw $t3, 0($t2)
        beq $t3, $zero, AddVerifyTestDone
        la $a0, AVStartTest
        li $v0, 4
        syscall
        move $a0, $t4
        li $v0, 1
        syscall
        la $a0, NewLine
        li $v0, 4
        syscall

        move $a2, $t3
        sll $a2, $a2, 8
        or $a2, $a2, $t3
        sll $a2, $a2, 8
        or $a2, $a2, $t3
        sll $a2, $a2, 8
        or $a2, $a2, $t3
        move $a0, $t2
        add $a0, $a0, 12
        la $a1, DecryptStringSpace
        sw $t0, -4($sp)
        sw $t1, -8($sp)
        sw $a0, -12($sp)
        sw $a1, -16($sp)
        sw $a2, -20($sp)
        sw $t2, -24($sp)
        sw $t4, -28($sp)
        
        addi $sp, $sp, -28
        jal AddAndVerify
        addi $sp, $sp, 28
        lw $t0, -4($sp)
        lw $t1, -8($sp)
        lw $a0, -12($sp)
        lw $a1, -16($sp)
        lw $a2, -20($sp)
        lw $t2, -24($sp)
        lw $t4, -28($sp)
        li $t3, 1
        beq $t3, $v0, AddVerifyNextCase

        la $a0, AVFailLead
        li $v0, 4
        syscall
        move $a0, $t4
        li $v0, 1
        syscall
        la $a0, AVKeyName
        li $v0, 4
        syscall
        lw $a0, 0($t2)
        li $v0, 1
        syscall
        la $a0, AVFalsePos
        li $v0, 4
        syscall


        ### Now try with bad key
AddVerifyNextCase:
        lw $t3, 4($t2)
        move $a2, $t3
        sll $a2, $a2, 8
        or $a2, $a2, $t3
        sll $a2, $a2, 8
        or $a2, $a2, $t3
        sll $a2, $a2, 8
        or $a2, $a2, $t3
        move $a0, $t2
        add $a0, $a0, 12
        la $a1, DecryptStringSpace
        sw $t0, -4($sp)
        sw $t1, -8($sp)
        sw $a0, -12($sp)
        sw $a1, -16($sp)
        sw $a2, -20($sp)
        sw $t2, -24($sp)
        sw $t4, -28($sp)
        
        addi $sp, $sp, -28
        jal AddAndVerify
        addi $sp, $sp, 28
        lw $t0, -4($sp)
        lw $t1, -8($sp)
        lw $a0, -12($sp)
        lw $a1, -16($sp)
        lw $a2, -20($sp)
        lw $t2, -24($sp)
        lw $t4, -28($sp)

        beq $zero, $v0, AddVerifyNextIter

        la $a0, AVFailLead
        li $v0, 4
        syscall
        move $a0, $t4
        li $v0, 1
        syscall
        la $a0, AVKeyName
        li $v0, 4
        syscall
        lw $a0, 4($t2)
        li $v0, 1
        syscall
        la $a0, AVFalseNeg
        li $v0, 4
        syscall

AddVerifyNextIter:
        addi $t4, $t4, 1
        lw $t3, 8($t2)
        sll $t3, $t3, 2
        add $t1, $t1, $t3
        addi $t1, $t1, 16
        j AddVerifyTestLoop
        
AddVerifyTestDone:
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
 