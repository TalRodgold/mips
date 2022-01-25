# yair naor- 208983783 . tal rodgold- 318162344
.text
loop: li $v0, 5 # read user input
	syscall 
	beq $v0, $zero, end # while user input not 0
	#check if num is between 10 and 100
	slti $t0, $v0, 100 # if num smaller than 100 return 1
	slti $t1, $v0, 9 # if num bigger than 10 return 0
	# check if user input was valid
	bne $t0, 1, negativ # if num was bigger than 100
	bne $t1, 0, negativ # if num was smaller than 9
	add $t7, $t7, $v0 # if user input was valid add sum
	# check if user input was valid
	negativ: slti $t3, $v0, -100 # if num is smaller than -100 return 0
	slti $t4, $v0, -9 # if num is bigger than -9 return 1
	bne $t3, 0, loop # if user input was smaller than -100
	bne $t4, 1, loop # if user input was bigger than 9
	add $t7, $t7, $v0 # if user input was valid add sum
	j loop # return to begining of loop
end: # when user input is 0
add $a0, $t7, $zero #copy
li $v0, 1 #print
syscall
li $v0, 10 #exit
syscall





