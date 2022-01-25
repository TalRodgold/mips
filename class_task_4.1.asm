# yair naor- 208983783, tal rodgold- 318162344

.data 
JumpTable:
.space 168
.word L0,L1
.space 200
.word L2
.space 644
FAIL:
.asciiz "ERROR :( " 

.text

.macro MySyscall (%function) # for syscall
li $v0 %function
syscall
.end_macro

MySyscall (5) #recieving integer from user
add $t0, $v0, $zero # we save user input in t0

MySyscall (12) # recieveing upcode sign  from user
add $t1, $v0, $zero# we save user upcode in t1

MySyscall (5) #recieving second integer from user
add $t2, $v0, $zero # we save user input in t2

la  $t3, JumpTable    
sll $t4, $t1, 2	# $t4 = 4 * k
add $t4, $t4, $t3 #$t4 = address of JumpTable[k]
lw $t5, 0($t4)	# $t5 = JumpTable[k]
beq $t5, $zero, ERROR
jr	$t5 # unconditional jump to address in register

L0: 	jal multFunc  	
		j	EXIT
L1:	jal plusFunc	
		j	EXIT
L2:	jal powFunc	
		j	EXIT	
multFunc:
add $t6, $ra, $zero # we keep return adress in t6 
beq $t2, $zero, endMult
beq $t0, $zero, endMult
slt $s7, $t2, $zero # if the second number is negative we switch between them before mult
bne $s7, 1, continue #if positive
add $t8, $t0, $zero # else switch
add $t0, $t2, $zero
add $t2, $t8, $zero

continue:
addi $t1, $zero, 0 # counter
add $t3, $t2, $zero # we keep t2 in a help register
add $t2, $t7, $zero
add $t7, $zero, $zero
loop_M:
add $t2, $t7, $zero
jal plusFunc 
addi $t1, $t1, 1 # counter growth
bne $t1, $t3, loop_M
endMult:
addi $ra, $t6, 0 # retrieve jal adress from t6
jr $ra

plusFunc:
add $t7, $t0, $t2
jr $ra

powFunc:
add $s6, $ra, $zero # we keep return adress in t6 
beq $t2, $zero, special # if the second number is 0 the result is 1 no matter what
beq $t2, 1, special_1
addi $s1, $zero, 1 # counter
add $s3, $t2, $zero # we keep t2 in a help register for counting

add $t2, $t0, $zero
loopP:
beq $s1, $s3, endPow #check if to end func
jal multFunc 
addi $s1, $s1, 1 # counter growth
add $t2, $t7, $zero # when doing power we need t2 to behold the next stage
bne $s1, $s3, loopP
beq $s1, $s3, endPow

special:
addi $t7, $zero, 1
beq $t7, 1 , endPow

special_1:
addi $t7, $t0, 0

endPow:
addi $ra, $s6, 0 # retrieve jal adress from t6
jr $ra

ERROR:
la $a0, FAIL
MySyscall (4)# print   
MySyscall (10) #end

EXIT:
la $a0, ($t7) # load resault
MySyscall (1) #print

MySyscall (10) #end 

