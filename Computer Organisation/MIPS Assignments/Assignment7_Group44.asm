# Group 44   Assignment 7

#######################IMPORTANT################################

# Indexing in output is done as 1 to size. So, index 1 is the first(also smallest) element # of the array and so on.... till index n is the last element of array.

# Please change both the myArray and size according to the test case.

#######################IMPORTANT################################

# myArray contains the stored array in which element is to be searched. 
# size contains the length of the stored array in which element to be searched
# Indexing in output is done as 1 to size. So, index 1 is the first(also smallest) element # of the array and so on.... till index n is the last element of array.

.data

# Change array here as per test case. Please maintain array as Non Decreasing.
# Change size of array as per test case.

myArray: .word 1,1,2,3,3,3,4,5,6,6  
size: .word 10								   	


num: .word 0
input1: .asciiz " Enter a positive integer to be searched in array: "
input2: .asciiz " Stored Sorted array is: "
output_f: .asciiz " No such Number Exists: "
output_t: .asciiz "Index Found: "
output: .asciiz "\n Output is: "
error: .asciiz "Error: Please enter a positive integer \n"
newline: .asciiz "\n"
space: .asciiz "  "
colon: .asciiz ":"

# $t0 stores the value of positive integer to be searched
# $t1 stores the leftmost index of an interval
# $t2 stores the rightmost index of an interval
# $t3 stores the ineger at the mid point index of current interval
# $t4 stores the size of the stored sorted array

.text
.globl main

main:

	la $a0, input1			# Printing input message
	li $v0, 4
	syscall

	li $v0, 5				# Taking N as input
	syscall
		
	sw $v0, num   		    # Stroing the number given as input 
	blt $v0, $zero, Error	
	
    move $t0, $v0			# Initialsing 
    li $t1, 0 					
    lw $t2, size
    addi $t2, $t2, -1
    li $t3, 0
    lw $t4, size			

    mul $t4, $t4, 4
	la $a0, input2
	li $v0, 4
	syscall

Loop:								# Printing the stored sorted array 
	
	lw $a0, myArray($t3)
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall

	addi $t3, $t3, 4
	blt $t3, $t4, Loop


	# Providing  left and right end points as arguments to function Binary Search 	
    move $a0, $t1	  	
    move $a1, $t2
    jal Binary_Search

    j EXIT

Error:
	
	la $a0, error			# Printing error message
	li $v0, 4
	syscall
	j EXIT	

.globl Binary_Search

Binary_Search:
	
	addi $sp, $sp, -32				# Setting frame size to 32
	sw $ra, 28($sp)					# Saving return address and frame pointer and s1,s2,s3
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	addi $fp, $sp, 32               # Pointing frame pointer to base of frame
	
	move $s0, $a0                   # s0 is the left endpoint of interval 
	move $s1, $a1					# s1 is the right endpoint of interval

	add $s2, $s0, $s1				# Calculating the mid point of interval			
	li $s3,2
	div $s2, $s3
	mflo $s2						# Storing mid point in $s2
  
	mul $t3, $s2, 4
	lw $s3, myArray($t3)            # Element of array at index= midpoint of interval 

	beq $t0, $s3, Return_True       # When N= A(mid_point of interval): Element Found
	beq $s0, $s1, Return_None		# When N!=A(mid point) and Left_End= Right_End: 0 Case

    bgt $t0, $s3, Right_Interval	# When N > A(mid_point of interval): Choose right half
    blt $t0, $s3, Left_Interval		# When N < A(mid_point of interval): Choose left half 

Return_None:

	la $a0, output				   # Printing output message
	li $v0, 4
	syscall

    li $a0, -1 					   # Printing 0 to show element does not exist		
    li $v0, 1
    syscall

    la $a0, newline
    li $v0,4
    syscall

	lw $ra, 28($sp)					# Restoring frame and stack pointer, return address
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)  
	addi $sp, $sp, 32
	jr $ra

Return_True:

	# Loading the word just previous to current index of input integer.
	# If they match i.e. same element occurs previously as well, then 
	# Decrease the index till same element is not found just previous to it. This way we
	# get to leftmost index.

	mul $t3, $s2, 4 				# $s2 contains current index of input element in array
	beq $t3, $zero, Print 			# If there is no previous element.
	
	addi $t3, $t3, -4				
	lw $s3, myArray($t3) 			# $s3 is index of element just previous to s2 in array
	beq $t0, $s3, Left_Index		# If same element previously, then go to Left_Index
	j Print        			# If not same, then print index as it is the leftmost index

Left_Index:
	
	addi $s2, $s2, -1			# Decrease index for input element since it is not leftmost

	addi $t3, $t3, -4
	lw $s3, myArray($t3)            
	bne $t0, $s3, Print 			# Print the index as we have found the leftmost index
	j Left_Index					# Continue same till we get to leftmost index

Print:

	la $a0, output					# Printing output message
	li $v0, 4
	syscall

	addi $s2, $s2, 1
    move $a0, $s2
    li $v0, 1						# Printing leftmost index of element in array
    syscall

    la $a0, newline
    li $v0,4
    syscall

	lw $ra, 28($sp)					# Restoring frame and stack pointer, return address
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)  
	addi $sp, $sp, 32
	jr $ra

Right_Interval:			
		
	addi $s2, $s2, 1			# Updating so new interval is right half side of orignial
	move $s0, $s2			

	move $a0, $s0
	move $a1, $s1
	li $t3,0
	jal Binary_Search				# Calling function with new interval		


	lw $ra, 28($sp)					# Restoring frame and stack pointer, return address
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)  
	addi $sp, $sp, 32
	jr $ra

Left_Interval:	
	
	move $s1, $s2				# Updating so new interval is left half side of orignial

	move $a0, $s0
	move $a1, $s1
	li $t3,0
	jal Binary_Search				# Calling function with new interval


	lw $ra, 28($sp)					# Restoring frame and stack pointer, return address
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)  
	addi $sp, $sp, 32
	jr $ra

EXIT:
	
	li $v0, 10
	syscall	