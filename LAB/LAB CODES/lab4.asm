.data
optionPrompt: .asciiz "\nPlease determine operation, entry (E), inquiry (I) or quit (Q):\n "
lastNamePrompt: .asciiz "\nPlease enter last name:\n"
firstNamePrompt: .asciiz "\nPlease enter first name:\n"
phoneNumberPrompt: .asciiz "\nPlease enter phone number:\n "
fullEntry: .asciiz "\nThank you, the new entry is the following:\n"
entryNumberPrompt: .asciiz "\nPlease enter the entry number you wish to retrieve: \n"
noEntry: .asciiz "There is no such entry in the phonebook\n"
number: .asciiz "The number is:\n "
entryNumber: .asciiz "\n  . "     #a string that gets modified(based on the number of the entry)
                                    # and printed every time an entry needs to be printed
    
printSpace: .asciiz " "           # a string to seperate different fields of an entry
.align 2
phonebook: .space 600
  
.text
  # Registers used:
  ###################################################
  #
  # $a0 and $a1 are used to pass arguments to subroutines
  # $s0 pointer to the start of each new entry
  # $s1 number of entries +1
  # $s2 used to store temporary values for branching
  # $v0 return value(user input character) from Prompt_User subroutine
  #
  ###################################################
main:
  	la $s0,phonebook                    #loading initial address of phonebook to $s0
        li $s1,1                            #initializing $s1

while1:                                 #loops over the basic operations until user presses Q(exit) 
      jal Prompt_User                   #calls subroutine Prompt_User
      
      move $a1,$s1                      #Get_Entry and Print_Entry use $s1 as argument 

                                        #checks if user input=='E'(ascii value of character 'E' is 69)
      li $s2, 69                        #loads 69 in $s2
      beq $v0, $s2, EntryBranch         #if $v0==$s2 gets to label EntryBranch

                                        #checks if user input=='I'(ascii value of character 'I' is 73)
      li $s2, 73                        #loads 73 in $s2
      beq $v0, $s2, InquiryBranch       #if $v0==$s2 gets to label InquiryBranch

                                        #checks if user input=='Q'(ascii value of character 'Q' is 81)
      li $s2, 81                        #loads 81 in $s2
      beq $v0, $s2, exit                #if $v0==$s2 gets to label exit
    
      j while1                          # if anything else is given as user input, the program repeats the while1 process(jumps to while1 label)


		                        #Branch to pass arguments and call subroutine Get_Entry 
                                        # retrieves the returning value of Get_Entry
EntryBranch:                        # increments $s1 by 1

      move $a0,$s0                      #moves the values of $s0 to $a0 in order to pass $a0 as an argument to Get_Entry
      jal Get_Entry                     #calls Get_Entry subroutine
      move $s0,$v0                      #moves the value of $v0 to $s0
      addi $s1,$s1,1                    # Adds 1 to $s1
      
      j while1                          # jumps back to while1 label


InquiryBranch:                      #Branch to pass arguments and call subroutine Print_Entry

      la $a0,phonebook                  #loads address of phonebook to $a0
      jal Print_Entry                   #calls Print_Entry subroutine

      j while1                          # jumps back to while1 label
          
exit:                               #Branch to exit the program
	li $v0,10
    	syscall                           #exit syscall



  ################ Print_Syscall ############
  ###########################################
  # $v0 is used by the syscall, to print the string from the adress that $a0 is pointing to
  # $ra is used to store the return address of the subroutine
  ###########################################
Print_Syscall:                          #Subroutine to print everything we need
                                        # Uses $a0 as an argument
    li $v0,4                            # Since the syscall prints a string from the adress that $a0 is pointing to        
    syscall                             # there is no need to move tha value of $a0 to another register
                                 
    jr $ra                              #returns
       


  ################ Prompt_User ################
  #Subroutine which prompts the user to enter an option
  #############################################
  # $a0 is used to pass arguments to subroutine Print_Syscall
  # $v0 is used by the syscall, also, it stores and returns user input character
  # $ra is used to store the return address of the subroutine
  # $sp: pointer to the head of the stack
  #############################################
  
Prompt_User:                          
		
    #Since there are nested subroutines,the return address for Prompt_User needs to be saved in the stack 
    #in order to return
    addi $sp,$sp,-4                     # reserving space in the stack to store the $ra               
    sw $ra,0($sp)                       # stores $ra in the address that $sp points to 
    
    la $a0, optionPrompt                #loads address of optionPrompt string, as an argument to $a0, to be printed by the Print_Syscall subroutine
    jal Print_Syscall                   #calls Print_Syscall
    
    li $v0, 12                          #syscall to get a character from the user 
    syscall
		
    lw $ra,0($sp)                       #loading in $ra the value of $ra that we had previously stored in the stack
    addi $sp,$sp,4                      #restoring the stack pointer
    
    jr $ra                              #return 
  

  ################ Get_Values ################
  # Prompts the user to enter the data for the field that is going to be stored
  # stores that data in the address that $s0(initialy the value of $a0) is pointing to 
  #############################################
  # $a0 initialy has the address in which each field is going to be stored
  # $a1 initialy has the address of the prompt that has to be printed
  # $a0,$a1 initialy contain the arguments passed to Get_Values and are then used to pass arguments to other subroutines
  #
  # $s0 stores the initial value of $a0. Since the value of $a0 is going to change throughout the Get_Values subroutine
  # and because the syscall to store each field uses $a0, the value of $s0 is reassigned to $a0 when needed
  # 
  # $s1 stores the initial value of $a1 
  # $ra is used to store the return address of the subroutine
  # $sp: pointer to the head of the stack
  #############################################
  Get_Values:                            

    addi $sp, $sp, -12                   # reserving space in the stack to store the $ra, $s0, $s1
    sw $ra, 0($sp)                       # stores $ra in the address that $sp points to
    sw $s0, 4($sp)                       # stores $s0 in the address that $sp+4 points to
    sw $s1, 8($sp)                       # stores $s1 in the address that $sp+8 points to
    
    move $s0,$a0                         #moving the values from argument $a0 to $s0
    move $s1,$a1                         #moving the values from argument $a1 to $s1
  	
    move $a0,$s1                         #moving the address of the prompt that $s1 is pointing to, to $a0, as an argument to Print_Syscall 
    jal Print_Syscall                    #calls Print_Syscall
    
    li $v0, 8                            #syscall to read data from the user and store it in the address that $a0 is pointing to 
    move $a0, $s0
    li $a1, 20                           #max number of character of the user's input data
    syscall
    
    lw $ra,0($sp)                        #loading in $ra the value of $ra that we had previously stored in the stack
    lw $s0,4($sp)                        #loading in $s0 the value of $s0 that we had previously stored in the stack
    lw $s1,8($sp)                        #loading in $s1 the value of $s1 that we had previously stored in the stack
    addi $sp,$sp,12                      #restoring the stack pointer
    
    jr $ra                               #return



################ New_Line_Filter ################
# subroutine to remove '\n' from the user input data if needed
#################################################
# $a0 initialy contains the address each stored field that may have a '\n' character to remove
# $s0 contains the value of $a0
# $t0 contains the ascii value of '\n' character (depending on the condiotion it may contain the ascii value of ' ')
# $t2 contains each word from the address $s0 points to (and its shifted version)
# $t1 is used as a mask to get the last byte from the word stored in $t2
# $t4 is used to store the last byte(ascii character) from the word stored in $t2
# $t3 contains the address of a byte from the word (depends from the conditions)
# $t5 used as a counter to mark when the for loop is over
# $sp: pointer to the head of the stack
# $ra is used to store the return address of the subroutine
#
#################################################

  New_Line_Filter:                        

  	addi $sp, $sp, -4                     # reserving space in the stack to store the $s0
    sw $s0, 0($sp)                        # stores $s0 in the address that $sp points to
    move $s0,$a0                          # moves the contents of $a0 to $s0
    
    li $t0,10                             # loads the ascii value of '\n' in $t0
    li $t1,255                            # loads the value 255 in $t1
    
    while2:                               # loops until program finds '\n' or '\0' in the address of the word that $s0 points to 
      lw $t2,0($s0)                       # loads the word in $t0 from the address that $s0 points to 
      move $t3,$s0                        # moves the value of $s0 in $t3
    
      li $t5,3                            #loads 3 in $t5( 4 iterations)
      
      for_loop1:                          #for loop to get and process every byte of the word
        bgt $zero,$t5,exit_cond1          #after 4 loops $t5<0 , branches to exit_cond1
                               
        and $t4,$t2,$t1                   #storing the last byte of $t2 in $t4
        beq $t4,$t0,new_line_cond         # if the character stored in $t2 is '\n' branch to new_line_cond
        beq $t4,$zero,null_byte_cond      # if the character stored in $t2 is '\0' branch to null_byte_cond
        srl $t2,$t2,8                     #shifts right by 8 '0' the word in $t4 in order to make next byte,the last byte 
        addi $t3,$t3,1                    # $t3++ ($t3 points to the 2nd byte of the word)
        addi $t5,$t5,-1                   #decrements $t5 by 1
        
        j for_loop1                       #jumps to next iteration
            
      exit_cond1:                         #if '\n' or '\0' was not found in the above process, $s0 will now point to the address of the next word
        addi $s0,$s0,4
        j while2                          #jump to label while2 to continue the processing of the field
      
  	new_line_cond:                        #if '\n' has been found, replaces it with the ascii value of ' ', and then returns
      li $t0,32                           #loads ascii value of ' ' in $t0 
      sb $t0,0($t3)                       #stores ' ' in the address that $t3 is pointing to , to replace the '\n'
      
        null_byte_cond:                       #if '\0' has been found ,it means thar no '\n' exists in the string, returns
          lw $s0,0($sp)                       #loading in $s0 the value of $s0 that we had previously stored in the stack
    	  addi $sp,$sp,4                      #restoring the stack pointer
        
      jr $ra                              #return 


################ Print ###########################
#Subroutine that prints a full entry
##################################################
# $a0 initialy contains the address of the entry to be printed
# $a1: initialy is the entry number  
# $a0,$a1 initialy contain the arguments passed to Print and are then used to pass arguments to other subroutines
#
# $s0 initialy contains the value of $a0, and then gets incremented by 20 bytes
# to point to the address of each field of the entry to be printed
# 
# $s1 contains the value of argument $a1
# $t0 contains the address of the entryNumber string
# $t1 contains number 10( special condition for tenth entry)
# $t2 used as a counter to mark when the for loop is over
# $sp: pointer to the head of the stack
# $ra is used to store the return address of the subroutine
###################################################

  Print:                                  

    addi $sp, $sp,-12                     # reserving space in the stack to store the $ra, $s0, $s1
    sw $ra,0($sp)                         # stores $ra in the address that $sp points to
    sw $s0, 4($sp)                        # stores $s0 in the address that $sp+4 points to
    sw $s1, 8($sp)                        # stores $s1 in the address that $sp+8 points to
    
    move $s0,$a0                          # moves the value of $a0 to $s0                                     
    move $s1,$a1                          # moves the value of $a1 to $s1
    li $t1,10                             # loads 10 in $t1
    la $t0,entryNumber                    # loads address of entryNumber string to $t0 in order to modify it, based on the number of the entry($s1)
 					# Subroutine Print modifies the entryNumber string by replacing one or both spaces or overwriting the existing numbers from previous entries before the '.'
 					# with the ascii characters that correspond to the proper entry number (contained in $s1) 
					 # When the entryNumber string is actually modified by the sb statements, 
					 # since the first character of entryNumber string is '\n' , the byte to be stored is 
 					# stored in the address, that $t0 is pointing to, with an offset of 1 or 2
 
    
    beq $s1,$t1,tenth_entry_cond          #if entry number==10 branch to tenth_entry_cond 
    
    end_if:
                                          #adding 48 to every number ranging from 0-9 will result in its ascii value
      addi $s1,$s1,48                                       
      sb $s1, 2($t0)                       #stores byte of $s1 in the address that $t0+2 points to 

      la $a0, entryNumber                 #loads address of entryNumber string, as an argument to $a0, to be printed by the Print_Syscall subroutine
      jal Print_Syscall                   #call Print_Syscall

      li $t2,2                             # loads 2 in $t2( 3 iterations)     
               
      for_loop2:                           #for loop to print every field of an entry
        bgt $zero,$t2,exit_cond2           #after 3 loops $t2<0 , branches to exit_cond2
        
        move $a0, $s0                      #moving the address of the field that $s0 is pointing to, to $a0, as an argument to Print_Syscall 
        jal Print_Syscall                  #call Print_Syscall
        
        la  $a0,printSpace                 #loads address of printSpace string, as an argument to $a0, to be printed by the Print_Syscall subroutine
                                           #to separate the fields with ' ' characters
        jal Print_Syscall                  #call Print_Syscall
        
        addi $s0,$s0,20                    #makes $s0 point to the next field

        addi $t2,$t2,-1                    #decrements $t2 by 1    
        j for_loop2                        # jumps to next iteration
     
      exit_cond2:         
        lw $ra,0($sp)                      #loading in $ra the value of $ra that we had previously stored in the stack
        lw $s0, 4($sp)                     #loading in $s0 the value of $s0 that we had previously stored in the stack
        lw $s1, 8($sp)                     #loading in $s1 the value of $s1 that we had previously stored in the stack
        addi $sp, $sp,12                   #restoring stack pointer

        jr $ra                             #return 
  	
    tenth_entry_cond:                         # Branch to store '1' and replace the first space character after the '\n' character in the entryNumber string,
                                              # in the address that $t0+1 points to 
    	li $t1,49                               # loads the ascii value of 1 in $t1
      sb $t1, 1($t0)                          # stores the byte of $t1 in the address that $t0+1 points to 

                                              #Since the entry number is 10, and only the '1' is stored, we need to store'0' in the entryNumber string too
      li $s1,0                                #However we jump to label end if, since the process to store '0' after '1' in the entryNumber string is 
                                              #the same as the one that processes that processes every other case                           
      j end_if                                #jumps to end_if label



  ################## Get_Entry #################
   #Subroutine to store a new entry in the phonebook and print it right after 
  ##############################################
  # $ra is used to store the return address of the subroutine
  # $sp: pointer to the head of the stack
  #
  # $a0: initialy is the pointer to the start of each new entry
  # $a1:  initialy is the number of entries+1
  # $a0,$a1 initialy contain the arguments passed to Get_Entry and are then used to pass arguments to other subroutines
  # 
  # $s0 stores the initial value of $a0
  #
  # $s1: Since each entry is 60 bytes long, and each field is 20 bytes long, when a field has to be stored the subroutine which stores it, has to know 
  # where to store it. This is accomplished by using $s1. $s1 initlialy has the address of the start of each new entry, and gets incremented 
  # by 20 bytes to seperate the fields from eachother in the memory
  #
  # $t6 stored the initial value of $a1
  # $v0 is used to store the returning value 
  ###############################################

  Get_Entry:                                             
  	
    #Since there are nested subroutines,the return address for Prompt_User needs to be saved in the stack 
    #in order to return
    addi $sp, $sp,-12                   # reserving space in the stack to store the $ra, $s0, $s1
    sw $ra, 0($sp)                      # stores $ra in the address that $sp points to
    sw $s0, 4($sp)                      # stores $s0 in the address that $sp+4 points to
    sw $s1, 8($sp)                      # stores $s1 in the address that $sp+8 points to
    
    move $t6,$a1                        #moving the values from the arguments to the registers $t6, $s0, $s1
    move $s0,$a0
    move $s1,$a0
    
    la $a1,firstNamePrompt              #loads address of firstNamePrompt in $a1 in order to pass it as an argument to Get_Values
                                        #No need to change the value of $a0, Get_Values uses it as it is
    jal Get_Values                      #calls Get_Values subroutine
    move $a0,$s1                        #moves the value of $s1 in $a0 in order to pass it as an argument to New_Line_Filter
    jal New_Line_Filter                 #calls New_Line_Filter to remove the '\n' from the given string
    addi $s1,$s1,20                     # $s1 points to the address that the next field will be stored
    
    move $a0,$s1                        #moving the address that $s1 is pointing to, to $a0, as an argument to Get_Values
    la $a1,lastNamePrompt               #loads address of firstNamePrompt in $a1 in order to pass it as an argument to Get_Values
    jal Get_Values                      #calls Get_Values
    
    move $a0,$s1                        #moving the address that $s1 is pointing to, to $a0, as an argument to Get_Values
    jal New_Line_Filter                 #calls New_Line_Filter 
    addi $s1,$s1,20                     # $s1 points to the address that the next field will be stored
    
    move $a0,$s1                        #moving the address that $s1 is pointing to, to $a0, as an argument to Get_Values
    la $a1,phoneNumberPrompt            #loads address of firstNamePrompt in $a1 in order to pass it as an argument to Get_Values
    jal Get_Values                      #calls Get_Values
    addi $s1,$s1,20                     # $s1 points to the address that the next field will be stored
    
    la $a0,fullEntry                    #loads address of firstNamePrompt in $a1 in order to pass it as an argument to Get_Values
    jal Print_Syscall                   #calls Print_Syscall
    
    move $a0,$s0                        #moving the address that $s0 is pointing to(address of the new complete entry), to $a0, as an argument to Print
    move $a1,$t6                        #moving value of $t6(ecurrent entry number), to $a0, as an argument to Print
    jal Print                           #calls Print 
    
    move $v0,$s1                        #returns the address of the next entry that will be stored                   
    
    lw $ra, 0($sp)                     #loading in $ra the value of $ra that we had previously stored in the stack
    lw $s0, 4($sp)                     #loading in $s0 the value of $s0 that we had previously stored in the stack
    lw $s1, 8($sp)                     #loading in $s1 the value of $s1 that we had previously stored in the stack
    addi $sp, $sp,12                   #restoring stack pointer
    
    jr $ra                             #returns
    
################## Enter_Number #################
#Subroutine to get phone number from the user
#################################################
# $a0 is used to pass arguments to other subroutines
# $v0 is used by the syscall, also, it stores and returns user input number
# $ra is used to store the return address of the subroutine
# $sp: pointer to the head of the stack
#################################################

Enter_Number:

  	addi $sp, $sp, -4                     # reserving space in the stack to store the $ra
    sw $ra, 0($sp)                        # stores $ra in the address that $sp points to
    
		la $a0, entryNumberPrompt             #loads address of entryNumberPrompt in $a0 in order to pass it as an argument to Print_Syscall          
    jal Print_Syscall                     #calls Print_Syscall
    
    li $v0, 5                             #syscall to read a number from the user                         
    syscall
    
    lw $ra ,0($sp)                        #loading in $ra the value of $ra that we had previously stored in the stack
    addi $sp,$sp,4                        #restoring stack pointer

    jr $ra                                #returns



################## Print_Entry #################
#Subroutine that prompts user to enter a number of an entry and then prints the requested entry
################################################
# $a0 initialy contains the address of the phonebook
# $a1:  initialy is the number of entries+1
# $a0,$a1 initialy contain the arguments passed to Print_Entry and are then used to pass arguments to other subroutines
#
# $s0 initialy contains the value of $a0, and then the address of the requested entry 
# $s1 contains the value of $a1, and then the number of bytes we need to add to $a0 in order to get the address of the requested entry
#
# $t0 contains number of $a1-1 (number of the last entry of the phonebook)
# $t1 contains number 60(distance between two succesive entries in bytes)
#
# $v0 contains the return value of Enter_Number(user requested entry number)
# $t2 contains the value of $v0
# 
# $ra is used to store the return address of the subroutine
# $sp: pointer to the head of the stack
#################################################

  Print_Entry:                              
  	
    addi $sp, $sp,-12                   # reserving space in the stack to store the $ra, $s0, $s1
    sw $ra, 0($sp)                      # stores $ra in the address that $sp points to
    sw $s0, 4($sp)                      # stores $s0 in the address that $sp+4 points to
    sw $s1, 8($sp)                      # stores $s1 in the address that $sp+8 points to
  	
    li $t1,60                           #loads 60 in $t1
    
    move $s0,$a0                        #moving the values from the arguments to the registers $s0, $s1          
    move $s1,$a1
    
    addi $t0,$s1,-1                     #decrements the value of $s1 by 1 and stores it in $t0 ($t0 now contains number of entries in the phonebook)
  	
    jal Enter_Number                    #calls Enter_Number( doesn't take any arguments)
    
    move $t2,$v0                        #stores the returned value from Enter_Number in $t2
    
    bgt $t2,$t0,incorrect_input         #if user has requested a entry nymber that is larger than the largest entry number($t0), branch to incorrect_input
    beq $t2,$zero,incorrect_input       #if user has entered 0, since there is not an entry labeled by 0 , branch to incorrect_input
    

    #To get the n-th(n=user input entry number) entry in the phonebook, it is necessary to have access phonebook + 60*(n-1) address   
    addi $t2,$t2,-1                     #assigning n-1 to $t2
    mul $s1,$t2,$t1                     #assigning 60*(n-1) ($t2*$t1) to $s1
    add $s0,$s0,$s1                     #assigning phonebook+60*(n-1) to $s0( $s0 initialy contains phonebook)
    addi $t2,$t2,1                      #assigning the user entry number n to $t2
    
    move $a0,$s0                        #moving $s0 to $a0 in order to pass it as an argument in Print subroutine
    move $a1,$t2                        #moving $s0 to $a1 in order to pass it as an argument in Print subroutine                    
    jal Print                           #calls Print
    
    end:
      lw $ra, 0($sp)                     #loading in $ra the value of $ra that we had previously stored in the stack
      lw $s0, 4($sp)                     #loading in $s0 the value of $s0 that we had previously stored in the stack
      lw $s1, 8($sp)                     #loading in $s1 the value of $s1 that we had previously stored in the stack
      addi $sp, $sp,12                   #restoring stack pointer

      jr $ra                             #returns
    
    incorrect_input:                    #Branch that handles incorrect inputs
    	
      la $a0, noEntry                   #loads address of noEntry in $a0 in order to pass it as an argument to Print_Syscall        
      jal Print_Syscall                 #calls Print_Syscall
    
      j end                             #jumps to end label
      
  
  
  	
  
  
  
  
