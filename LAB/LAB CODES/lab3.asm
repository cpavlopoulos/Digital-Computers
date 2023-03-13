.data

input:.space 100
output:.space 100
print_input: .asciiz "Please Enter your String:\n"
.align 2
print_output: .asciiz "The Processed String is:\n"
.align 2

.text

main:

jal Get_Input		#jumps to get input
jal Transform		#jumps to transform
jal Print_output	#jumps to print output

li $v0,10		#syscall of programm termination
syscall  


###########
#Get_Input
# $t2 mem address pointer for input 
                
                              
###########
Get_Input:

li $v0,4		#syscall for printing string print_input
la $a0,print_input
syscall

li $v0,8
la $a0,input
li $a1,100		#length of input 
syscall   
move $t2,$a0		#moving memory address pointer from $a0 to $t2

jr $ra

############ 
#Transform
# $t0 word which is processed                
# $t1 byte which is processed                 
# $t2 memory address pointer for input                
# $t3 memory adress pointer for output
# $t6 is 1 if previoys byte printed is space or else it is 0
# $t8 used for logical operations
# $t9 used for mathematical operations
# $s6 used in forloop to pick character from word 
# $s7 used to insert /n in input and to terminate process               
############
Transform:

li $t6,1    	#Initialize the registers
la $t3,output	#loading address of output on $t3
li $s7,10	#loading "new line" in $s7
li $t7,32	#loading SPACE in %t7

while:      	#We take the word(4bytes)	
li $s6,4	
lw $t0,0($t2)	#loading $t2 contents to $t0
add $t2,$t2,4	#picking the next 4 bytes

##Begin of for##
for:
li $t8,255   	#We pick a letter each time (255 is the number of all ascii chars)
and $t1,$t0,$t8	
beq $s7,$t1,whileout

li $t9,122   	#Symbols to space
bgt $t1,$t9,Case
li $t9,96    	#Keeping small letters
bgt $t1,$t9,Case_keeps
li $t9,90    	#Symbols to space
bgt $t1,$t9,Case
li $t9,64    	#Capital letters to small
bgt $t1,$t9,Case_converts
li $t9,57    	#Symbols to space
bgt $t1,$t9,Case
li $t9,47    	#Keeping numbers
bgt $t1,$t9,Case_keeps
li $t9,32    	#Symbols to space
bge $t1,$t9,Case

Case:       #If there is a space before the character it deletes the character or else it prints a space
beq $t6,1,Move_byte
li $t6,1
j Store_space	#jumps to store_space

Case_keeps:      #It keeps small letters and numbers
li $t6,0
j endif		#jumps to endif

Case_converts:  #It converts capital letters into small
li $t6,0
add $t1,$t1,32
j endif		#jumps to endif

Store_space:  	#Stores in $t1 32 in ascii(space)
li $t1,32
j endif		#jumps to endif

endif:     	#If in $t1 is 0 it does not store the byte or else it jumps to Store_byte
bne $t1,$zero,Store_byte
j Move_byte	#jumps to move byte

Store_byte:   	#It stores the least significant byte that is in $t1 in $t3's adress and then it moves $t3's adress by one byte
sb $t1,0($t3)
add $t3,$t3,1

Move_byte:    	#Takes the next byte to be processed 
srl $t0,$t0,8
addi $s6 , $s6 , -1	#moves to next byte
beq $zero,$s6,outfor	
j for

outfor: 	#Jumps to While  
j while

whileout:   #Store /n
sb $s7,0($t3)

jr $ra


###########
#Print_Output                       
# $t3 memory adress pointer for output 
# $a0 stores the output                 
############

Print_output:

li $v0, 4
la $a0, print_output
syscall
move $a0,$t3

li $v0,4 
la $a0,output
syscall

jr $ra
