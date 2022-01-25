# yair naor- 208983783, tal rodgold- 318162344
.data 

arr:
.byte 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32

user_input:
.space 24

nott:
.asciiz "SERIES NOT FOUND IN BLOCK \n"

is:
.asciiz "SERIES FOUND IN BLOCK \n"

.text

.macro MySyscall (%function) # for syscall
li $v0 %function
syscall
.end_macro

addi $t1, $zero, 6
la $t3, user_input

loop_1:
MySyscall (5)
sw $v0, ($t3)# we save user input into data
addi $t2, $t2, 1 # grow counter by 1
addi $t3, $t3, 4 # grow index bt 4
bne $t1, $t2 loop_1 # if loop not ended jump 

jal findSeries # call func
j end # jump to end

findSeries:
add $t0, $ra, $zero # we keep return adress in t0 
la $t3, user_input # load user input
lw $a1, ($t3)  # load user input
la $a0, arr # load array
addi $s0, $zero, 31 # limit for counter

loop:
beq $s0, $s1 not_series # if we finished array without finding the series
lb $v0, ($a0)  # load block
beq $v0, $a1 check # if number is in block go to check 
addi $a0, $a0, 1 # move to next item in block
addi $s1, $s1, 1 # grow counter by 1
j loop
jr $ra

check: # check if user input is in block
la $a3, ($a0) # load last location used  of arr to a3
addi $a3, $a3, 1 # point to next value in arr
la $a2, 4($t3) # a2 pointer to seconed value from user input
add $t7, $zero, $zero # set counter
addi $t8, $zero, 6  # set limit
check_loop: # loop to check that all of users input is in block
addi $t7, $t7, 1 # grow counter by 1
beq $t7, $t8 is_series # reach end
lb $s7, ($a3)
lb $s6, ($a2)
addi $a3, $a3, 1
addi $a2, $a2, 4
beq $s7, $s6 check_loop # check if equal
la $a0, ($a3) # load last location used  of arr to a3
j loop

not_series:
la $a0, nott
MySyscall (4)# print  
j end
is_series:
la $a0, is
MySyscall (4)# print  
j end
end:
# print
la $t3, user_input
add $t2, $zero, $zero
loop_2:
lw $a0, ($t3)
MySyscall (1)
addi $t2, $t2, 1
addi $t3, $t3, 4
bne $t1, $t2 loop_2

MySyscall (10) #end 

#**** user input : 3
#**** user input : 4
#**** user input : 5
#**** user input : 8
#**** user input : 9
#**** user input : 7
#SERIES NOT FOUND IN BLOCK 
#345897
#-- program is finished running --

#**** user input : 9
#**** user input : 10
#**** user input : 11
#**** user input : 12
#**** user input : 13
#**** user input : 14
#SERIES FOUND IN BLOCK 
#91011121314
#-- program is finished running --




