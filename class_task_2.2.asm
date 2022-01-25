# yair naor- 208983783, tal rodgold- 318162344
.data
print1:
.asciiz "ENTER VALUE:"
print2:
.asciiz "ENTER OP CODE:"
print3:
.asciiz "the result is:"
err:
.asciiz "ERROR"
.text
la $a0 print1 # we print "enter value"
li $v0, 4
syscall
li $v0, 5 # recieving number from user
syscall
add $t0,$v0, $zero # t0 hold the number the user wrote
la $a0 print2 #print next order
li $v0, 4
syscall

loop: 
li $v0, 12 # format to recieve char from user
syscall
addi $t7 $v0, 0 # variable revieves char from user
li $t1 '@' # t1 recives @
li $t2 '-' # t2 recieves -
li $t3 '+' # t3 recieves +
li $t4 '*' # recieves times "*"

beq $t1, $t7, end
la $a0 print1 # we print "enter value"
li $v0, 4
syscall
li $v0, 5 # recieving number from user
syscall
add $t5,$v0, $zero # t5 hold the number the user wrote
beq $t7 $t2 minus
beq $t7 $t3 plus
beq $t7 $t4 times
j loop # if the char didn't match any wanted signs we jump back to recieve new sign
minus:
sub $t6, $t0, $t5 # t6 recieves the sub calculation
add $t0, $t6, $zero
j loop

plus:
add $t6, $t0, $t5 # t6 recieves the add of the 2 numbers
add $t0, $t6, $zero
j loop

times:
mult $t0 $t5 # multiply 2 numbers
mfhi $s0 #insert into s0 s1 two parts of multiply
mflo $s1
slt $t1, $t0, $zero
slt $t2, $t5, $zero # we check if the numbers are the same sign or not
beq $t1, $t2 positive # if the numbers have the same sign we get a positive result

#if they have different signs we proseed here.
bne $s0, -1, error # if hi of mult isnt -1 we have an overflow
add $s2, $s1, $zero # we want to check msb of lo without erasing its value so we tranfer it to s2.
sra $s1, $s1, 31 # we check msb of low to see if there is an overflow
bne $s1, -1, error
add $t0, $s2, $zero
j loop

positive:
bne $s0, $zero error # if hi of mult isnt zero we have an overflow
add $s2, $s1, $zero # we want to check msb of lo without erasing its value so we tranfer it to s2.
sra $s2, $s2, 31# we check msb of low to see if there is an overflow
bne $s2, $zero, error
add $t0, $s1, $zero
j loop

error:
la $a0 err # we print "ERROR"
li $v0, 4
syscall
j exit

end:
la $a0 print3 # we print "the result is"
li $v0, 4
syscall
# we print the result
la $a0, ($t0)
li $v0, 1
syscall

exit:
li $v0 10 # exit
syscall
