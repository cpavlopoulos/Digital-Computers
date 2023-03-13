.data
procTerm: .asciiz "Process was asked to be terminated"
string1: .asciiz "Please enter any key to continue or Q to quit:"
exit_message: .asciiz "This number is outside the allowable range."
prompt: .asciiz "Please enter a number in the range 0-24: "
.align 2
result: .asciiz "The Fibonacci number F"
.align 2
result2: .asciiz " is "
endl: .asciiz "\n\n"
.align 2
finalResult: .space 28   

.text
main:

la $a0, string1  #prints string 1
li $v0, 4
syscall

li $v0, 12       #takes character from user to continue process or to terminate
syscall

move $s1,$v0     #stores the char to $s1

la $a0,endl      #Print '\n'
li $v0,4
syscall

beq  $s1, 81, terminate   #if user's input is Q then it proceeds to terminate

# Prompt user to input non-negative number
la $a0,prompt   
li $v0,4
syscall

li $s2, 24    #loads 24 in $s2 for comparison with user's input

li $v0, 5    #Read the number(n)
syscall

move $t2,$v0    # n to $t2
# Call function to get fibonnacci #n
move $a0,$t2

bgt  $t2,$s2,print_error_message   	#if user's input number is greater than 24 it goes to print_error_message
jal fib     				#call fib (n)
move $t3,$v0    			#result is in $t3

#loads result's,result2's and finalResult's addresses in $t4,$t6,$t9 respectively 
la   $t4, result
la   $t6, result2
la   $t9, finalResult

      addi $t2,$t2,48     		#goes to number's ascii character

    #loops to process every byte
   sCopyResult:
	###############
	#loop to copy every letter of result
	###############
        lb   $t0, 0($t4)  		#set $t0 to first letter of $t4
        beq  $t0, $zero, sCopyNum_part2 #exit loop on null byte
        sb   $t0, 0($t9)		#stores each byte in $t9
        addi $t4, $t4, 1        	#goes to next byte in both $t4
        addi $t9, $t9, 1	 	#and $t9
        b sCopyResult             	#continues the loop
        
   sCopyNum:   
    	  lw   $ra,0($sp)      		#loads return address from stack
    	  addi $sp, $sp, 4     		#stack pointer goes to previous position
               
   sCopyNum_part2:
       #adds number between result and result2      
        bgt  $t2,67,takeNum2 		#if $t2 is greater than 20 goes to takeNum2
        bgt  $t2,57,takeNum		#if $t2 is greater than 10 goes to takeNum
        sb   $t2, 0($t9)		#stores each byte in $t9
        addi $t9, $t9, 1		#goes to next byte in $t9
        subi $sp, $sp, 4		#storing return address on stack
        sw   $ra,0($sp)			 
        jal sCopyResult2		#jumps to sCopyResult2
        
   takeNum:
    	subi $t2,$t2,10			#subtracts 10 from $t2 to take second digit
    	addi $s0,$zero,49		#loads ascii character 1 
        sb   $s0, 0($t9)		#stores each byte in $t9
        addi $t9, $t9, 1		#goes to next byte in $t9
        subi $sp, $sp, 4		#storing return address on stack
        sw   $ra,0($sp)
        jal sCopyNum			#jumps to sCopyNum
        
   takeNum2:
    	subi $t2,$t2,20			#subtracts 20 from $t2 to take second digit
    	addi $s0,$zero,50		#loads ascii character 2 
        sb   $s0, 0($t9)		#stores each byte in $t9
        addi $t9, $t9, 1		#goes to next byte in $t9
        subi $sp, $sp, 4		#storing return address on stack
        sw   $ra,0($sp)
        jal sCopyNum			#jumps to sCopyNum
               
   sCopyResult2:   
    	lw   $ra,0($sp)			#loads return address from stack
        addi $sp, $sp, 4		#stack pointer goes to previous position
                
   sCopyResult2_part2:
      ###############
	#loop to copy every letter of result
	###############
        lb   $t0, 0($t6)  		#set $t0 to first letter of $t6
        beq  $t0, $zero, sDone 	#exit loop on null byte
        sb   $t0, 0($t9)		#stores each byte in $t9
        addi $t6, $t6, 1        	#goes to next byte in both $t6
        addi $t9, $t9, 1	 	#and $t9
        b sCopyResult2_part2        #continues the loop
        
   sDone:
	################
	#subroutine to put together the full string
	################
        sb $zero, 0($t9) 		#null terminate string
        
        la $a0, finalResult     	#syscall to display the final result
        li $v0, 4
        syscall
        
        move $a0,$t3   		 	#Print the answer
	  li   $v0,1
	  syscall
	  
	  la   $a0, endl 		#Print '\n'
	  li   $v0, 4
	  syscall

	  jal main

fib:
	# Compute and return fibonacci number
	beqz $a0,zero   	#if n=0 return 0
	beq $a0,1,one   	#if n=1 return 1

	#Calling fib(n-1)
	subi $sp,$sp,4   	#storing return address on stack
	sw $ra,0($sp)

	subi $a0,$a0,1   	#n-1
	
	subi $sp,$sp,4   	#storing $a0 on stack	
	sw  $a0,0($sp)
	
	jal fib     
				#fib(n-1)
	lw  $a0,0($sp)   	#loads $a0 from stack
	addi $sp,$sp,4
	
	addi $a0,$a0,1 

	lw $ra,0($sp)   	#restoring return address from stack
	addi $sp,$sp,4


	subi $sp,$sp,4   	#Push return value to stack
	sw $v0,0($sp)
	#Calling fib(n-2)
	subi $sp,$sp,4   	#storing return address on stack
	sw $ra,0($sp)

	subi $a0,$a0,2   	#n-2
	
	subi $sp,$sp,4	 	#storing $a0 on stack
	sw  $a0,0($sp)
	
	jal fib     		#fib(n-2)
	
	lw  $a0,0($sp)		#loads $a0 from stack
	addi $sp,$sp,4
	
	addi $a0,$a0,2

	lw $ra,0($sp)   	#restoring return address from stack
	addi $sp,$sp,4
				#---------------
	lw $t5,0($sp)   	#Pop return value from stack
	addi $sp,$sp,4

	add $v0,$v0,$t5 	# f(n-2) + fib(n-1)
	jr $ra 			# decrement/next in stack

zero:
	li $v0,0     		#loads 0
	jr $ra
one:
	li $v0,1	 	#loads 1
	jr $ra

print_error_message: 

	li $v0,4
	la $a0,exit_message    	#prints exit_message
	syscall

	la $a0,endl 		#Print '\n'
	li $v0,4
	syscall

	jal main            	#jumps to main

terminate:
	la $a0,procTerm		#prints procTerm
	li $v0,4
	syscall

	li $v0,10		#syscall to terminate
	syscall
