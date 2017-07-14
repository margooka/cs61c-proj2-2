# CS 61C Summer 2016 Project 2-2 
# string.s

#==============================================================================
#                              Project 2-2 Part 1
#                               String README
#==============================================================================
# In this file you will be implementing some utilities for manipulating strings.
# The functions you need to implement are:
#  - strlen()
#  - strncpy()
#  - copy_of_str()
# Test cases are in linker-tests/test_string.s
#==============================================================================

.data
newline:	.asciiz "\n"
tab:	.asciiz "\t"

.text
#------------------------------------------------------------------------------
# function strlen()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string input
#
# Returns: the length of the string
#------------------------------------------------------------------------------
strlen:
	# YOUR CODE HERE
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	addu $t0, $0, $0			#counter = 0
	beq $a0, $0, strlenexit 		#if $a0 null exit
	strlenloop: 
	addiu $a0, $a0, 1			#a0 = pointer to next char
	addiu $t0, $t0, 1			#counter +1
	bne $a0, $0, strlenloop			#loop
	strlenexit:
	addu $v0, $t0, $0			#return $v0 = counter 
	
	jr $ra

#------------------------------------------------------------------------------
# function strncpy()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = pointer to destination array
#  $a1 = source string
#  $a2 = number of characters to copy
#
# Returns: the destination array
#------------------------------------------------------------------------------
strncpy:
	# YOUR CODE HERE
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	move $v0, $a0  			#$v0 = destination array $a0 -> $v0
	beq $a1, $0, strncpyexit 	#if src str null
	strncpyloop:
	lb $t1, 0($a1) 			#t1 = char to copy 
	sb $a0, 0($t1)			#put next src char in dest
	addiu $a0, $a0, 1		#a0 = pointer to next dest char
	addiu $a1, $a1, 1		#a1 = pointer to next src char
	
	addiu $a2, $a2, -1 		#counter -1
	beq $a0, $0 strncpyexit 	#number of characters to copy > str length
	beq $a2, $0 strncpyexit 	#copied  the $a2 number of characters
	
	strncpyexit:
	
	
	jr $ra

#------------------------------------------------------------------------------
# function copy_of_str()
#------------------------------------------------------------------------------
# Creates a copy of a string. You will need to use sbrk (syscall 9) to allocate
# space for the string. strlen() and strncpy() will be helpful for this function.
# In MARS, to malloc memory use the sbrk syscall (syscall 9). See help for details.
#
# Arguments:
#   $a0 = string to copy
#
# Returns: pointer to the copy of the string
#------------------------------------------------------------------------------
copy_of_str:
	# YOUR CODE HERE
	
	jal strlen			#a0 = str input fo strlen
	move $a2, $v0			#a2 = num char to copy for strncpy
	sw $
					#v0 = num bytes for syscall 9 to allocate
					#a0 should = num bytes if syscall 
	syscall 9			#v0 now contains address of allocated mem
	move $a0, $v0			#a0 = dest array for strncpy
					#a1 = source string
					
	jal strncpy
	jr $ra

###############################################################################
#                 DO NOT MODIFY ANYTHING BELOW THIS POINT                       
###############################################################################

#------------------------------------------------------------------------------
# function streq() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string 1
#  $a1 = string 2
#
# Returns: 0 if string 1 and string 2 are equal, -1 if they are not equal
#------------------------------------------------------------------------------
streq:
	beq $a0, $0, streq_false	# Begin streq()
	beq $a1, $0, streq_false
streq_loop:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	bne $t0, $t1, streq_false
	beq $t0, $0, streq_true
	j streq_loop
streq_true:
	li $v0, 0
	jr $ra
streq_false:
	li $v0, -1
	jr $ra			# End streq()

#------------------------------------------------------------------------------
# function dec_to_str() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Convert a number to its unsigned decimal integer string representation, eg.
# 35 => "35", 1024 => "1024". 
#
# Arguments:
#  $a0 = int to write
#  $a1 = character buffer to write into
#
# Returns: the number of digits written
#------------------------------------------------------------------------------
dec_to_str:
	li $t0, 10			# Begin dec_to_str()
	li $v0, 0
dec_to_str_largest_divisor:
	div $a0, $t0
	mflo $t1		# Quotient
	beq $t1, $0, dec_to_str_next
	mul $t0, $t0, 10
	j dec_to_str_largest_divisor
dec_to_str_next:
	mfhi $t2		# Remainder
dec_to_str_write:
	div $t0, $t0, 10	# Largest divisible amount
	div $t2, $t0
	mflo $t3		# extract digit to write
	addiu $t3, $t3, 48	# convert num -> ASCII
	sb $t3, 0($a1)
	addiu $a1, $a1, 1
	addiu $v0, $v0, 1
	mfhi $t2		# setup for next round
	bne $t2, $0, dec_to_str_write
	jr $ra			# End dec_to_str()
