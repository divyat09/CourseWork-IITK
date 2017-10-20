# Write a MIPS program to add two rational numbers and print the result in normalized
# scientific format with two digits after the decimal point ((+/-)X.YYe(+/-)ZZ). The numerators and
# denominators of the two numbers are given as inputs by a user.

#Registers Used
# $t0 for storing x's numerator
# $t1 for storing x's denominator
# $t2 for storing y's numerator
# $t3 for storing y's denominator
# $t4 for stroing exponent
# $t5 for storing sign of Number


#data segment

.data
zero:    .float 0.0
one:     .float 1.0
ten:     .float 10.0
hundred: .float 100.0
round:   .float 0.5
Hundred: .word 100

inputxn: .asciiz "Please enter value for x's numerator\n "
inputxd: .asciiz "Plese enter value for x's denominator\n"
inputyn: .asciiz "Please enter value for y's numerator\n"
inputyd: .asciiz "Please enter value for y's denominator\n"
output: .asciiz "Result in Scientific Notation is  "
dot: .asciiz "."
exp: .asciiz "e"
minus: .asciiz "-"
newline: .asciiz "\n"


.text
.globl main

main:
	
	l.s $f6, zero
    l.s $f7, one
    l.s $f8, ten
	l.s $f9, hundred
    
    #Taking input for x's numerator
	la $a0, inputxn
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t0, $v0

	#Taking input for x's denominator
	la $a0, inputxd
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t1, $v0

	#Taking input for y's numerator
	la $a0, inputyn
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t2, $v0

	#Taking input for y's denominator
	la $a0, inputyd
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t3, $v0	

	# Adding the rational numbers
	mul $t4, $t0, $t3
	mul $t5, $t1, $t2
	add $t6, $t4, $t5

	mul $t7, $t1, $t3

	# Converting to float for division
	mtc1 $t6, $f1
	cvt.s.w $f3, $f1

	mtc1 $t7, $f2
	cvt.s.w $f4, $f2

	div.s $f5, $f3, $f4	


	# Scientific Notation
	li $t4, 0

	
	cvt.w.s $f10, $f5
	mfc1 $t0, $f10

	li $t1, 1
	beq $t0, $t1, Base1
	li $t1, -1
	beq $t0, $t1, Base2
	
	c.le.s $f5, $f6     		# $f6 stores 0.0
	bc1t Loop2 
	bc1f Loop1


Base1:
	
	li $t1, 1
	li $t7, 0

	move $a0, $t1
	li $v0, 1
	syscall	 

	la $a0, dot
	li $v0, 4
	syscall

	move $a0, $t7 
	li $v0, 1
	syscall	
	
	move $a0, $t7 
	li $v0, 1
	syscall	

	la $a0, exp
	li $v0, 4
	syscall

	move $a0, $t4
	li $v0, 1
	syscall

    #Terminating
	li $v0, 10
	syscall		

Base2:
	
	la $a0, minus
	li $v0, 4
	syscall
	
	li $t1, 1
	li $t7, 0

	move $a0, $t1
	li $v0, 1
	syscall	 

	la $a0, dot
	li $v0, 4
	syscall

	move $a0, $t7 
	li $v0, 1
	syscall	
	
	move $a0, $t7 
	li $v0, 1
	syscall	

	la $a0, exp
	li $v0, 4
	syscall

	move $a0, $t4
	li $v0, 1
	syscall

    #Terminating
	li $v0, 10
	syscall		
	

Loop1:							# Loop for positive case	

	li $t5, 0	         		# t5==0  means number is positive
	
	c.le.s $f5, $f7				# $f7 stores 1.0
	bc1t Negative_Exponent
	bc1f Positive_Exponent

Loop2:							# Loop for negative case
	
	abs.s $f5, $f5
	
	li $t5, 1	         		# t5==1  means number is negative

	c.le.s $f5, $f7 			# This checks if number is less than 1.0
	bc1t Negative_Exponent
	bc1f Positive_Exponent


Positive_Exponent:

	li $t6, 0	         		# t6==0  means exponent is positive
	
	c.le.s $f5, $f8				# $f8 stores 10.0
	bc1t Round_Off		# This loop keeps dividing by 10 till mantissa is in range 1 to 10

	div.s $f5, $f5, $f8
	addi $t4, $t4, 1
	
	j Positive_Exponent

Negative_Exponent:

	li $t6, 1	         		# t6==1  means exponent is positive

	mul.s $f5, $f5, $f8		
	addi $t4, $t4, 1
	
	c.le.s $f5, $f7     # This loop keeps multiply by 10 till mantissa is in range 1 to 10
	bc1f Round_Off
	bc1t Negative_Exponent


Round_Off:
	
	# Rounding off: Multiplying by 100 and then rounding off 
	mul.s $f5, $f5, $f9
	round.w.s  $f11, $f5
	mfc1 $t0, $f11						# t0 contains the rounded off integer
 
	lw $t7, Hundred
	div $t0, $t0, $t7       
	mflo $t1              				# Quotient 
	mfhi $t7							# Remainder			
	
	bne $t5, $zero, Negative   			# Printing for negative case

	# Printing the Number for Positive case
	move $a0, $t1
	li $v0, 1
	syscall	 

	la $a0, dot
	li $v0, 4
	syscall

	move $a0, $t7 
	li $v0, 1
	syscall	

	bne $t6, $zero, Neg_Exponent   			# Printing for negative case

	la $a0, exp
	li $v0, 4
	syscall

	move $a0, $t4
	li $v0, 1
	syscall

    #Terminating
	li $v0, 10
	syscall		

Negative:
	
	# Printing the Number for Negative case

	la $a0, minus
	li $v0, 4
	syscall

	move $a0, $t1
	li $v0, 1
	syscall	 

	la $a0, dot
	li $v0, 4
	syscall

	move $a0, $t7 
	li $v0, 1
	syscall	
	
	bne $t6, $zero, Neg_Exponent   			# Printing for negative case

	la $a0, exp
	li $v0, 4
	syscall

	move $a0, $t4
	li $v0, 1
	syscall

    #Terminating
	li $v0, 10
	syscall		

Neg_Exponent:

	mul $t4, $t4, -1

	la $a0, exp
	li $v0, 4
	syscall

	move $a0, $t4
	li $v0, 1
	syscall

    #Terminating
	li $v0, 10
	syscall		

.end main
