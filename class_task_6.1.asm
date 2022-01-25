#yair naor - 208983783 , tal rodgold- 318162344


.data
ERROR: .asciiz "incorrect input, please insert again\n"
print_1: .asciiz "please enter number of rows for first matrix\n"
print_2: .asciiz "please enter number of columns for first matrix\n"
print_3: .asciiz "please enter number of rows for second matrix\n"
print_4: .asciiz "please enter number of columns for second matrix\n"
print_5: .asciiz "please enter numbers for Matrix\n"
print_6: .asciiz "A = \n"
print_7: .asciiz "B = \n"
print_8: .asciiz "C = \n"
print_9: .asciiz "please enter first matrix info\n"
print_10: .asciiz "please enter second matrix info\n"


.align 2
matrix_A: .space 160
matrix_B: .space 160
matrix_C: .space 160

.text
.macro MySyscall (%function) 		# for syscall
	li $v0 %function
	syscall
		.end_macro

recieve_sizes:
	la $a0, print_1
	MySyscall (4)
	MySyscall (5) 			# we ask for 4 numbers, two for first matrix, and other two for second matrix
	add $t0, $v0, $zero 		# row 1

	la $a0, print_2	
	MySyscall (4)
	MySyscall (5)
	add $t1, $v0, $zero		#column 1
	
	la $a0, print_3
	MySyscall (4)
	MySyscall (5)
	add $t2, $v0, $zero 		# row 2
	
	la $a0, print_4
	MySyscall (4)
	MySyscall (5)
	add $t3, $v0, $zero 		#colomun 2
	
	bne $t1, $t2, error
	
	la $a0, print_9
	MySyscall (4)
	mult $t0, $t1
	mflo $a2			#a2 recives amount of numbers in matrix A for reading 
	la $a1, matrix_A		#insert to a1 memory of matrix a for reading
	jal read
	
	la $a0, print_10
	MySyscall (4)
	mult $t2, $t3
	mflo $a2
	la $a1, matrix_B
	jal read
	
	mult $t0, $t3			#recieving size of new result matrix
	mflo $a3			#we insert new size of result matrix
	la $a0, matrix_A
	la $a1, matrix_B
	la $a2, matrix_C
	jal calculate
	
	la $a0, print_6			#we start print from a to c
	MySyscall (4)
	la $a1, matrix_A
	la $a2, ($t0)			#rows of matrix a
	la $a3	($t1)			#columns of matrix a
	jal print

	la $a0, print_7		
	MySyscall (4)
	la $a1, matrix_B
	la $a2, ($t2)			#rows of matrix B
	la $a3	($t3)			#columns of matrix B
	jal print
	
	
	la $a0, print_8		
	MySyscall (4)
	la $a1, matrix_C
	la $a2, ($t0)			#rows of matrix C
	la $a3	($t3)			#columns of matrix C
	jal print

	MySyscall (10)


error:
	la $a0, ERROR 		
	MySyscall (4) 
	j recieve_sizes

read:
	addi $sp, $sp, -12
	sw $a2, 0($sp)			#a0 contains size of matrix
	sw $a1, 4($sp)			#a1 contains matrix adress
	sw $s6, 8($sp)
	addi $t9, $a2, 0		#t9 is counter
	addi $t8, $zero, 0
	add $s6, $a1, $zero		
read_more:
	MySyscall (5)	
	sw $v0, ($s6)
	addi $s6, $s6, 4
	addi $t8, $t8, 1		#increase counter 
	bne $t8, $t9, read_more 
	addi $sp, $sp, 12		#retrieve adress to jump back
	jr $ra
		
calculate:
	addi $sp, $sp, -32
	sw $a0, 0($sp)			# Matrix A
	sw $a1, 4($sp)			# Matrix B
	sw $a2, 8($sp)			# Matric C
	sw $a3, 12($sp)			#size of Matrix C
	sw $s0 16($sp)
	sw $s1 20($sp)
	sw $s2 24($sp)
	sw $s3 28($sp)
	addi $t7, $zero, 0		#t7 counter for outer loop
first_loop:
	beq $t0, $t7, end_first_loop
	addi $t6, $zero, 0		#t6 counter for inner loop
second_loop:
	beq $t6, $t3, end_second_loop	#t3 contains column of matrix B
	addi $t4, $zero, 0		# t4 = sum == 0
	addi $t5, $zero, 0		# t5 counter for most inner loop
third_loop:
	beq $t5, $t2, end_third_loop
	mult $t7,$t1			#sum = sum + a[i* colmn1 + k] *b[k*colm2 + j]
	mflo $s0		
	add $s0, $s0, $t5		#we add counter to know correct index
	sll $s0,$s0,2			#multiply by 2
	add $s1 ,$a0, $zero		#use s1 each itteration for spacifec spot on matrix A
	add $s0, $s0, $s1		#we go to adress of matrix + index 
	lw $s0, ($s0)			#we reacieve the the value in current adress
	mult $t3, $t5			#we do the same thing with matrix_B
	mflo $s2
	add $s2, $s2, $t6
	sll $s2, $s2, 2
	add $s1, $a1, $zero
	add $s1, $s1, $s2
	lw $s1, ($s1)
	mult $s0, $s1
	mflo $s0			#after doing the calculation we add it to sum
	add $t4, $t4, $s0		#sum is in t4!
	addi $t5, $t5, 1
	j third_loop
end_third_loop:
	mult $t7, $t3			#matrix_C[i *colm2 +j] = sum
	mflo $s0 		
	add $s0, $s0, $t6
	sll $s0, $s0, 2
	add $s3,$a2, $zero
	add $s3, $s3, $s0		#s3 points at writing matrix destiny
	sw $t4, ($s3)
	addi $t6, $t6, 1
	j second_loop
end_second_loop:
	addi $t7, $t7, 1
	j first_loop
end_first_loop:
	addi $sp,$sp, 32
	jr $ra	
			
				
								
print:
	addi $sp, $sp, -20
	sw $a1, 0($sp)			#a1 contains pointer to matrix
	sw $a2, 4($sp)			#a2 contain rows of matrix
	sw $a3, 8($sp)			#a3 contains columns of matrix
	sw $s0, 12($sp)
	sw $s2, 16($sp)
	addi $t7, $zero, 0		#outer counter for rows
	addi $t6, $zero, 0		#inner counter for columns
	add $s2, $zero, $a3		#save colmb size for correcting counter
outer_loop:
	beq $t7, $a2, end_outer_loop
	
inner_loop:
	beq $t6, $a3, end_inner_loop
	add $t5, $zero, $t6
	sll $t5, $t5, 2
	add $s0, $a1, $t5
	lw $a0, ($s0)
	MySyscall (1)
	li $a0, ' '
	MySyscall (11)
				
	addi $t6, $t6, 1	#inner counter for columns
	j inner_loop
				
					
end_inner_loop:
	li $a0 '\n'
	MySyscall (11)
	add $a3, $a3, $s2	# correct counter
	addi $t7, $t7, 1
	j outer_loop
				
end_outer_loop:
	addi $sp , $sp, 20
	jr $ra
				

#please enter number of rows for first matrix
#**** user input : 2
#please enter number of columns for first matrix
#**** user input : 3
#please enter number of rows for second matrix
#**** user input : 3
#please enter number of columns for second matrix
#**** user input : 2
#please enter first matrix info
#**** user input : 4
#**** user input : 2
#**** user input : 0
#**** user input : 0
#**** user input : 5
#**** user input : 6
#please enter second matrix info
#**** user input : 8
#**** user input : 6
#**** user input : 0
#**** user input : 3
#**** user input : 8
#**** user input : 4
#A = 
#4 2 0 
#0 5 6 
#B = 
#8 6 
#0 3 
#8 4 
#C = 
#32 30 
#48 39 

#-- program is finished running --

