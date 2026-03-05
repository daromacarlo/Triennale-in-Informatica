# IL PROGRAMMA SIMULA LE SEGUENTI:

#-----------------------------------------------------------#
# sb Store Byte S 0100011 0x0 M[rs1+imm][0:7] = rs2[0:7]    #
# sh Store Half S 0100011 0x1 M[rs1+imm][0:15] = rs2[0:15]  #
# sw Store Word S 0100011 0x2 M[rs1+imm][0:31] = rs2[0:31]  #
#-----------------------------------------------------------#

# |imm | rs2 | rs1 | funct3 | imm | opcode | (S-type)


.text
.globl simula_S


.text
simula_S:
    # Estrazione campi rs1, rs2, funct3 con una maschera
    srli t1, t6, 15
    andi t1, t1, 31          # t1 = rs1
    
    srli t2, t6, 20
    andi t2, t2, 31          # t2 = rs2
    
    srli t3, t6, 12
    andi t3, t3, 7           # t3 = funct3
    
    srli t2, t6, 7
    andi t2, t2, 31          # s10 = imm[4:0]

    srli t4, t6, 30      
    andi t4, t4, 127         # t4 = imm[11:5]
                  
    slli t4, t4, 5
    or t0, t4, t2          
    slli t0, t0, 20        
    srai t0, t0, 20     # t0 = imm   
    
    # Caricamento valori reali dai registri virtuali
    # la   a5, REGISTRI_VIRTUALI
    
    slli t1, t1, 2           # offset rs1
    add  t1, t1, a5
    lw   a3, 0(t1)           # a3 = valore rs1
    
    slli t2, t2, 2           # offset rs2
    add  t2, t2, a5
    lw   a4, 0(t2)           # a4 = valore rs2

    add t5, a3, t0           # t5 = rs1 + imm
    add t5, t5, a1           # t5 = t5 + indirizzo base memoria virtuale


    beq t3, zero, SB  # SB (funct3=0)
    li t5, 1
    beq t3, t5, SH  # SH (funct3=1)
    li t5, 2
    beq t3, t5, SW    # SW(funct3=2)
    jr ra

	SB:
	    sb a4, 0(t5)
	    j vai_avanti_con_pc
	SH:
            sh a4, 0(t5)
            j vai_avanti_con_pc
	    
	SW:
            sw a4, 0(t5)
            j vai_avanti_con_pc
	
vai_avanti_con_pc:
      addi s2, s2, 8                 # Prossima istruzione HEX (8 caratteri)
      jr ra
