# yair naor- 208983783, tal rodgold- 318162344

.data

my_byte:
.byte 5 10 15 25
MyLength:
.byte 0
Failed:
.asciiz "FAILED, NOT SERIES" 
Ar:
.asciiz "succes, arithmetic progression: "
Ge:
.asciiz "succes, geometric series: "
first:
.asciiz "first element is: "
is_equal:
.asciiz " = "

.text

.macro MySyscall (%function) # for syscall
li $v0 %function
syscall
.end_macro

la $a0 my_byte # loads the array
la $a1 MyLength # loads length
sub $a1 $a1 $a0 #update the curent length                 
lb $t0, 0($a0) #receives index a1
lb $t1, 1($a0) #receiver index a2
sub $s0, $t1, $t0 # caluclate if d
div $s1, $t1, $t0 # calculate if q
la $s2, 1($a0) # recieves second index 
addi $t6, $zero, 2 #counter for loop checking
aritmetic:
beq $t6, $a1, end_ar # if we finished the series
lb $t2, 1($s2) # insert n+1
sub $t7, $t2, $t1 # sub between two linked numbers
bne $t7, $s0, reset # if not a aritmetic then check if geometric
addi $t6, $t6, 1 # grow counter by 1
la $s2, 1($s2) # load n+1
add $t1, $t2, $zero # every loop we compare t1 and t2, so we make t1 point on n and t2 on n+1
j aritmetic

reset:
addi $t6, $zero, 2# reset  counter and array pointer
la $s2, 1($a0)

geometric:
beq $t6, $a1, end_ge # if we finished the series
lb $t2, 1($s2) # insert n+1
div $t7, $t2, $t1 # div between two linked numbers
bne $t7, $s1, failed # if not a geonetric then not a series
addi $t6, $t6, 1 # grow counter by 1
la $s2, 1($s2) # load n+1
add $t1, $t2, $zero
j geometric

end_ar:
la $a0, Ar
MySyscall (4)# print 
la $a0, first # print
MySyscall (4)# print
la $s2, my_byte
lb $a0, ($s2)
MySyscall (1)# print
li $a0 '.'
MySyscall (11)# print
li $a0 ' ' #space print
MySyscall (11)# print
li $a0 'd' # d equals
MySyscall (11)# print
la $a0, is_equal
MySyscall (4)# print
la $a0, ($s0)
MySyscall (1)# print
j terminate

end_ge:
la $a0, Ge
MySyscall (4)# print
la $a0, first # print
MySyscall (4)# print 
la $s2, my_byte # loads the array
lb $a0, ($s2)
MySyscall (1)# print first index
li $a0 '.'
MySyscall (11)# print
li $a0 ' ' #space print
MySyscall (11)# print
li $a0 'q' # q equals
MySyscall (11)# print
la $a0, is_equal
MySyscall (4)# print
la $a0, ($s1)
MySyscall (1)# print
j terminate

failed:
la $a0, Failed
MySyscall (4)# print 
j terminate

terminate:
MySyscall(10) # exit




