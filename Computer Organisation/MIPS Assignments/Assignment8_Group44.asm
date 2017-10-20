# Group 44   Assignment 8

################### Very Importat Comment #################

# Please update mdArray3 accordingly to the test case. It contains result of multiplication
# Change it in .data section accordingly, OTHERWISE RESULTS WILL BE WRONG 
# I have initialise it to be 10*10. So, if your test case includes result matrix to be 
# greater than 10*10, please add more 0.00 elements in columns and rows accordingly.

################### Very Important Comment ##################

# mdArray1 is the first matrix, mdArray2 is the second matrix
# mdArray3 contains result of multiplication i.e. mdArray3 = mdArray1*mdArray2 
# Sizes of initial matrices are contained in row_size and col_size

.data
	str1: .asciiz " "
	str2: .asciiz "\n"
	mdArray1: .double 0.00,1.00,20.00				# Change According to Test Case
			  .double 2.00,3.00,40.00
			  .double 4.00,5.00,60.00
			  .double 6.00,7.00,10.00
	row_size1: .word 4								# Change According to Test Case
	col_size1: .word 3								# Change According to Test Case

	mdArray2: .double 0.00,1.00,2.00,2.00			# Change According to Test Case
			  .double 3.00,4.00,6.00,5.00
			  .double 4.00,6.00,7.00,8.00
	row_size2: .word 3								# Change According to Test Case	
	col_size2: .word 4								# Change According to Test Case	

	mdArray3: .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00
			  .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00
			  .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00
			  .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00
			  .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00
			  .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00
			  .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00
			  .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00
			  .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00
			  .double 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00

	doubl1: .double 0.0
	DATASIZE = 8
	

.text
.globl main
.ent main
main:

	la $s0, mdArray1	 #base address of the array1
	lw $s1, row_size1	 #size of the array
	lw $s2, col_size1

	la $a3, mdArray2	 #base address of the array2
	lw $s3, row_size2	 #size of the array
	lw $s4, col_size2

	la $s7, mdArray3	 #base address of the array3
	lw $t8, row_size1	 #size of the array
	lw $t9, col_size2

	jal mulMatrix		 #Call to the multiplication function

	li $t1,0 			 #row-loop index (i)
	li $t2,0			 #col-loop index (j)

while:
	li $t2,0			#col-loop index (j)

while2:
		
	mul $s5, $t1, $t9 	#addr=base+(rowIndex*rowSize + colIndex)*dataSize
	add $s5, $s5, $t2    
	mul $s5, $s5, DATASIZE
	add $s6, $s7, $s5

	l.d $f8,($s6)
	li $v0,3
	mov.d $f12, $f8
	syscall
	
	li $v0,4
	la $a0, str1
	syscall
	add $t2, $t2, 1
	blt $t2, $t9, while2

	li $v0,4
	la $a0, str2
	syscall
	
	add $t1, $t1, 1
	blt $t1, $t8, while

	li $v0,10	#Terminate program
	syscall
.end main

.globl mulMatrix
.ent mulMatrix

mulMatrix:
	
	addi $sp, $sp, -32				# Setting frame size to 32
	sw $ra, 28($sp)					# Saving return address and frame pointer
	sw $fp, 24($sp)
	addu $fp, $sp, 32               # Pointing frame pointer to base of frame

	li $t1,0 	#row-loop index (i)
	li $t2,0	#col-loop index (j)
	li $t3,0	#mul-loop index (k)
	
mulloop3:
	li $t2,0	#col-loop index (j)

mulloop2:
	ldc1 $f6,doubl1  #stores the calculated array3[i][j]
	li $t3,0		 #mul-loop index (k)

mulMatrixloop:

	mul $t4, $t1, $s2 	#addr=base+(rowIndex*rowSize + colIndex)*dataSize
	add $t4, $t4, $t3    
	mul $t4, $t4, DATASIZE
	add $t4, $s0, $t4

	l.d $f2, ($t4)		#get element array1[i][k]

	
	mul $t5, $t3, $s4 	#addr=base+(rowIndex*rowSize + colIndex)*dataSize
	add $t5, $t5, $t2    
	mul $t5, $t5, DATASIZE
	add $t5, $a3, $t5

	l.d $f4, ($t5)			#get element array2[k][j]

	
	mul.d $f12,$f2,$f4 		#Multiplication of array1[i][k] & array2[k][j]
	add.d $f6,$f6,$f12		#Storing sum of k numbers

	add $t3,$t3,1			#k++
	blt $t3, $s2,mulMatrixloop

	
	mul $s5,$t1,$t9		#addr=base+(rowIndex*rowSize + colIndex)*dataSize
	add $s5, $s5, $t2    
	mul $s5, $s5, DATASIZE
	add $s6, $s7, $s5

	s.d $f6,($s6)			#Store the calculated number in array3[i][j]

	add $t2,$t2,1
	blt $t2, $s4, mulloop2

	add $t1, $t1,1
	blt $t1, $s1, mulloop3

	lw $ra, 28($sp)					# Restoring frame and stack pointer, return address
	lw $fp, 24($sp)
	addi $sp, $sp, 32
	jr $ra  			#Return to calling routine
	
.end mulMatrix