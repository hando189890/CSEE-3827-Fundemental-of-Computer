        .data

## HERE IS WHERE YOU PUT THE TEST DATA: a 4-character string, followed by a 1 if it is a candidate string, or a 0 if not.          
IsCandidateTestData:
        .asciiz "HIHO"
        .word 1
        .asciiz "Bo^3"
        .word 0
        .asciiz "ABCD"
        .word 1
        .asciiz "@@@@"
        .word 1
        .asciiz "abcd"
        .word 0
        .asciiz " %AB"
        .word 0
        .asciiz " BCD"
        .word 0
        .asciiz "A CD"
        .word 0
        .asciiz "AB D"
        .word 0
        .asciiz "ABC "
        .word 0
        .asciiz "@ZAP"
        .word 1
        .asciiz "HOW?"
        .word 0
        .asciiz "NOP["
        .word 0


       ### Leave this last .word in place: it terminates the testing        
        .word 0

IsCandidateTestSuccess: .asciiz "Test Successful\n"
IsCandidateTestFail: .asciiz "Test FAILED\n"
IsCandidateSayTesting:  .asciiz "\nTesting "

        .text


main:
        la $t0, IsCandidateTestData
IsCandidateTestLoop:
        la $a0, IsCandidateSayTesting
        li $v0, 4
        syscall
        move $a0, $t0
        li $v0, 4
        syscall
        li $a0, ':'
        li $v0, 11
        syscall
        
        lw $a0, 0($t0)
        
        sw $t0, -4($sp)
        addi $sp, $sp, -4
        jal IsCandidate
        
        lw $t0, 0($sp)
        addi $sp, $sp, 4
        lw $t1, 8($t0)
        beq $t1, $v0, CandidateTestSuccess

        lw $t6, 0($t0)
        andi $t2, $t6, 255
        srl $t6, $t6, 8
        andi $t3, $t6, 255
        srl $t6, $t6, 8
        andi $t4, $t6, 255
        srl $t6, $t6, 8
        andi $t5, $t6, 255
        move $a0, $t2
        li $v0, 1
        syscall
        li $a0, ','
        li $v0, 11
        syscall
        move $a0, $t3
        li $v0, 1
        syscall
        li $a0, ','
        li $v0, 11
        syscall
        move $a0, $t4
        li $v0, 1
        syscall
        li $a0, ','
        li $v0, 11
        syscall
        move $a0, $t5
        li $v0, 1
        syscall
        li $a0, ':'
        li $v0, 11
        syscall
        la $a0, IsCandidateTestFail
        li $v0, 4
        syscall
        j IsCandidateTestContinue
CandidateTestSuccess:
        la $a0, IsCandidateTestSuccess
        li $v0, 4
        syscall
IsCandidateTestContinue:        
        addi $t0, $t0, 12
        lw $t1, 0($t0)
        bne $t1, $zero, IsCandidateTestLoop

        li $v0, 10
        syscall


        ##########  Insert your IsCandidate and WordDecrypt Here

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

        