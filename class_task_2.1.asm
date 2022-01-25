# yair naor- 208983783 & tal rodgold- 318162344
.data
my_bytes: # our array
.byte 1 3 2 4 -1
length: # array to assist calculate length
.byte 0

.text
la $a0 my_bytes # load my bytes into a0
la $a1 length # load assist array into a1
sub $t0, $a1, $a0 # this function gives t0 the lenght of my bytes 
add $t1, $t1, $zero # t1 is our counter how many times we check the array numbers
add $t2, $t2, $zero # t2 is a temp variable to recieve max number
loop: beq $t0,$t1 ,end # if array finished jump to end
	lb $t4, 0($a0) 
	slt $t3, $t2, $t4
	bne $t3, 1, notMax # only if next number is biggest we dont jump 
	sub $t2, $t2, $t2 # reset t2 to zero
	addi $t2, $t4, 0 # we insurt the new max number into t2
	notMax: # if not max
	addi $t1, $t1, 1 # grow counter by 1
	addi $a0, $a0, 1 # move index by 1
	j loop # return to loop
end: la $a0, ($t2)
li $v0, 1 #print
syscall
li $v0, 10 #exit
syscall
