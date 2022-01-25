#yair naor - 208983783 , tal rodgold- 318162344
.data 
result:
.asciiz "RESULT = "

input:
.asciiz "INPUT = "

ERROR: 
.asciiz "ERROR\n" 

.align 2
number:
.space 10 # The number in ASCII


.text
.macro MySyscall (%function) # for syscall
li $v0 %function
syscall
.end_macro
start:
jal read_hex_number

beq $v1, $zero, bye
srl $s2, $v1, 24 # we insert into s2 the right bits of number
addi $t0, $zero, 0X31 #we insert into integers t0 -t3 op-codes
addi $t1, $zero, 0X30
addi $t2, $zero, 0X48
addi $t3, $zero, 0X74

beq $s2, $t0, opcode_0 # we check what opcode we need to jump to
beq $s2, $t1, opcode_1
beq $s2, $t2, opcode_2
beq $s2, $t3, opcode_3

j error #if no code fitted we print error and ask for new number

opcode_0:
addi $t4, $zero , 0XC3
or $s0, $t4, $v1 # we insert into so the result
j result_print

opcode_1:
addi $t4, $zero, 0XFFFFFF3C
and $s0, $t4, $v1
j result_print

opcode_2:
addi $t4, $zero, 0XFF00
xor $s0, $t4, $v1
j result_print

opcode_3:
sll $t2, $v1, 7 #first we delete 8 left bits
srl $t2, $t2, 27 #we move 27 bits right so the 20-24 bits will now be in t2 and will be used is counter
addi $t4, $zero, 0 # t4 the counter
addi $s0, $v1, 0 # we give s0 the number from the user for the sll
loop:
beq $t4, $t2, result_print # if we shifted as much we need we jump to print
sll $s0, $s0, 1 #each loop we shift left by one
addi $t4, $t4, 1 # move counter ++
j loop
error:
la $a0, ERROR
MySyscall (4)# print error
j start

result_print:
	la $a0 input
	MySyscall (4)
	la $a0 ($v1)
	MySyscall (34)

	li $a0 ' '
	MySyscall (11)# print

	la $a0 result
	MySyscall (4)
	la $a0, ($s0)
	MySyscall (34)
	li $a0 '\n'
	MySyscall (11)# print
	j start

bye:
MySyscall (10) #end 



# This function reads a number in hex A to F must be BIG LETTERS
read_hex_number:
addi $sp,$sp,-20 # Save room for 5 registers
sw $t0,0($sp) # Save $t0
sw $t1,4($sp) # Save $t1
sw $t2,8($sp) # Save $t2
sw $t3,12($sp) # Save $t3
sw $t4,16($sp) # Save $t4
li $v0,8
la $a0,number
li $a1,10
syscall # Read number as string
li $t0,0 # $t0 = The result
la $t1,number # $t1 = pointer to number
next: lb $t2,0($t1) # $t2 = next digit
li $t4,10
beq $t2,$t4,end # if $t2 = enter --> finish
sll $t0,$t0,4 # $t0 *= 16
slti $t3,$t2,0x3a # check if tav <= '9'
bne $t3,$zero,digit
addi $t2,$t2,-55 # $t2 = $t2 -'A' + 10
j cont
digit: addi $t2,$t2,-48 # $t2 = $t2 - '0'
cont: add $t0,$t0,$t2 # add to sum
addi $t1,$t1,1 # increment pointer
j next
end: addi $v1,$t0,0 # return value in $v1
lw $t0,0($sp) # Restore $t0
lw $t1,4($sp) # Restore $t1
lw $t2,8($sp) # Restore $t2
lw $t3,12($sp) # Restore $t3
lw $t4,16($sp) # Restore $t4
addi $sp,$sp,20 # Restore $sp
jr $ra # return



#**** user input : 74300011
#INPUT = 0x74300011 RESULT = 0xa1800088
#**** user input : 307777FE
#INPUT = 0x307777fe RESULT = 0x3077773c
#**** user input : 48AAEEBB
#INPUT = 0x48aaeebb RESULT = 0x48aa11bb
#**** user input : 0
#
#- program is finished running --

