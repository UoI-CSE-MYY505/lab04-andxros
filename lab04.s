
.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria, marios 

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:

loop:                   
            lbu    t0, 0(a0)
            lbu    t1, 0(a1)
            
            # check if: a word is completed / words are equal / character == '\0'
            bne    t0,zero, if_t0_<_t1 #if t0 !=0: return
            bne    t1,zero, if_t0_<_t1 #if t1 !=0: return
            
            j      return_if_t0==zero_&&_t1==zer0
if_t0_<_t1:
            blt    t0, t1, return_if_t0_<_t1
if_t0_>_t1:           
            blt    t1, t0, return_if_t0_>_t1
            
            #take next character from string
            addi    a0, a0, 1
            addi    a1, a1, 1
            j    loop
return_if_t0_<_t1:
            addi    a0, zero, 0
            jr    ra
return_if_t0_>_t1:
            addi    a0, zero, 1
            jr    ra
return_if_t0==zero_&&_t1==zer0:
            addi    a0, zero, 1
            jr    ra
 
# ----------------------------------------------------------------------------

recCheck:
            slti t0, a1,   2 # t0 = a1*4
            beq  t0, zero, check_Array_i_and_Array_i_plus_1
            addi a0, zero, 1  # if size =0,1:
            jr   ra           #     return a0 = 1
check_Array_i_and_Array_i_plus_1:
    
            #push to stack
            addi sp, sp,   -12
            sw   ra, 8(sp)
            sw   a0, 4(sp)
            sw   a1, 0(sp)
            
            #check 
            lw   a1, 0(a0)  # a1 = array[i]
            lw   a0, 4(a0)  # a0 = array[i+1] 
            jal  str_ge 
            beq  a0, zero, return_recCheck  # if a0 == 0: array is not sorted -> return 
            
            #pull from stack
            lw   a0, 4(sp)    # get a0 from stack
            lw   a1, 0(sp)    # get a1 from stack
            addi a0, a0,   4   # i = i + 1
            
            #recursion
            addi a1, a1,   -1  # size-1
            jal  recCheck
return_recCheck:
            lw   ra, 8(sp)
            addi sp, sp,   12
            jr   ra
