        .data
WordDecryptTestPhrase1: .asciiz "\nCurrent test case: "
WordDecryptTestPhrase2: .asciiz "\nResults are: "
SumNoGood:      .asciiz "  SUM result is WRONG"
CarryNoGood:    .asciiz "  CARRY result is WRONG"
AllGood:        .asciiz "  PASSES TEST"

WordDecryptTestData: .word 100, 200, 1, 301, 0
        .word 60000, 30000, 1, 90001, 0
        .word 600000, 300000, 1, 900001, 0
        .word 2147483640, 2147483640, 0, -16, 0
        .word -100, 5000, 0, 4900, 1
        .word 50468, -1248128, 1, -1197659, 0
        .word 50468, -30303, 0, 20165, 1
        .word 0x0, 0x0, 0x0

.text
        
main:   
        la $t0, WordDecryptTestData
WordDecryptTestLoop:
        la $a0, WordDecryptTestPhrase1
        li $v0,4
        syscall
        lw $a0, 0($t0)
        li $v0,1
        syscall
        li $a0 '+'
        li $v0,11
        syscall
        lw $a0, 4($t0)
        li $v0,1
        syscall
        li $a0 '+'
        li $v0,11
        syscall
        lw $a0, 8($t0)
        li $v0,1
        syscall
                
        lw $a0, 0($t0)
        lw $a1, 4($t0)
        lw $a2, 8($t0)
        sw $t0, -4($sp)
        addi $sp, $sp, -4
        jal WordDecrypt
        
        lw $t0, 0($sp)
        addi $sp, $sp, 4
        move $t1, $v0  # store v0 in t1
        move $t2, $v1   # store v1 in t2
        
        li $a0,'='
        li $v0,11
        syscall
        move $a0, $t1
        li $v0,1
        syscall
        li $a0,','
        li $v0,11
        syscall
        move $a0,$t2
        li $v0,1
        syscall

        li $t5, 1
        lw $t3, 12($t0)
        lw $t4, 16($t0)
        beq $t1, $t3, SUMGOOD
        li $t5, 0
        la $a0, SumNoGood
        li $v0, 4
        syscall
SUMGOOD:
        beq $t2, $t4, CARRYGOOD
        li $t5, 0
        la $a0, CarryNoGood
        li $v0, 4
        syscall
CARRYGOOD:
        beq $t5, $zero, SKIPPEDPASS

        la $a0, AllGood
        li $v0, 4
        syscall
SKIPPEDPASS:    
        addi $t0, $t0, 20
        lw $t1, 0($t0)
        bne $t1, $zero, WordDecryptTestLoop

EndWordDecryptTest:     

        
        li $v0, 10
        syscall


############ Insert your WordDecrypt Here

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
        
        


    
