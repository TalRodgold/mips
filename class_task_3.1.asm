# yair naor- 208983783, tal rodgold- 318162344

.data 
MyWord:
.word 5 -1 0 2 1 3 4
MyLength:
.word  0

.text
.macro swap (%a, %b) # to swap to numbers
sw %a, -4($a0)
sw %b, 0($a0)
.end_macro
.macro MySyscall (%function) # for syscall
li $v0 %function
syscall
.end_macro

la $a0 MyWord # loads the array
la $s0 MyWord # save array in s0
la  $a1 MyLength # loads length
sub $a1 $a1 $a0 #update the curent length
add $t0, $zero, $zero #counter for outLoop
add $t1, $zero, $zero # counter for inerLoop
outerLoop:
add $t0, $t0, 4 # grow counter by 1
add $a0, $s0, $zero # every outer loop we make $a1 point to begging of array
beq $t0, $a1, end # if counter reaches size we exit loop
add $t1, $zero, $zero # restart inerloop counter
inerLoop:
beq $t1, $t0 outerLoop # if t1 equals to t0 go back to outerloop
lw $t2, 0($a0) #receives earlier array value 
lw $t3, 4($a0) #receiver the value after t2
slt $t4 $t3 $t2 # if bigger index value is smaller t4 recives 1 and we swap
addi $t1, $t1, 4 # t1 ++ inercounter
addi $a0, $a0, 4 #myword point on next value
bne $t4, 1 ,inerLoop # if dont need a swap go back to inerloop 
swap($t3, $t2) # if need a swap
j inerLoop # back to inerloop

end:
li $t1 ' ' # space for printing
lw $a0, 0($s0)#receives first array value
add $t0, $zero, $zero # counter for printing
print: 
MySyscall (1) # print num
addi $s0, $s0, 4 # make s0 point to next value
la $a0, ($t1)
MySyscall (11)# print space
add $t0, $t0, 4
lw $a0, 0($s0)  # a0 points to next value
bne $t0 $a1 print
MySyscall(10) # exit



