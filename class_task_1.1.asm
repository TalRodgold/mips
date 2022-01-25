# yair naor- 208983783 . tal rodgold- 318162344
.data
MyWords :
.word 7 7 7 0 # first array to hold words
MyEmptyArray1:
.space 20 #empty array to recieve words
.text
la $a0, MyWords # adress of both arrays into registar a1 and a0
la $a1, MyEmptyArray1
loop: 
	lw $t1, 0($a0) #insert word from array into t1
	sw $t1, 0($a1) #store word from t1 to new array
	beq $zero, $t1, end # check if the word is "0", if so we jump to end
	addi $a0, $a0, 4 #if the word isnt "0" we make both pointers point on next word in array
	addi $a1, $a1, 4
	addi $t0, $t0, 1# each loop we add 1 to a register to count the amount of words in array
	j loop
end: 
addi $a0, $t0, 0 # load into a0 the value we want to print
li $v0, 1 #print order
syscall
li $v0, 10 #exit
syscall