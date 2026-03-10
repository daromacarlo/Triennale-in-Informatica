# IL PROGRAMMA SIMULA LE SEGUENTI:

#-----------------------------------------------------------------------------#
# add ADD R 0110011 0x0 0x00 rd = rs1 + rs2                                   
# sub SUB R 0110011 0x0 0x20 rd = rs1 - rs2                                   
# xor XOR R 0110011 0x4 0x00 rd = rs1 ˆ rs2                                   
# or OR R 0110011 0x6 0x00 rd = rs1 | rs2                                     
# and AND R 0110011 0x7 0x00 rd = rs1 & rs2                                   
# sll Shift Left Logical R 0110011 0x1 0x00 rd = rs1 << rs2                   
# srl Shift Right Logical R 0110011 0x5 0x00 rd = rs1 >> rs2                  
# sra Shift Right Arith* R 0110011 0x5 0x20 rd = rs1 >> rs2 msb-extends       
# slt Set Less Than R 0110011 0x2 0x00 rd = (rs1 < rs2)?1:0                   
#-----------------------------------------------------------------------------#

# |funct7 | rs2 | rs1 | funct3 | rd | opcode | (R-type)


.globl simula_R


.text
simula_R:

    srli t1, t6, 15
    andi t1, t1, 31          # t1 = rs1
    
    srli t2, t6, 20
    andi t2, t2, 31          # t2 = rs2
    
    srli t3, t6, 12
    andi t3, t3, 7           # t3 = funct3
    
    srli t4, t6, 7
    andi t4, t4, 31         # t4 = rd

    srli t5, t6, 25          # t5 = func7
    andi t5, t5, 127   
    
   
    # Carico i dati dai registri virtuali (aggiungo l'indirizzo base dei registri virtuali nel calcolo)
    slli t1, t1, 2           # offset rs1
    add  t1, t1, a5
    lw   a3, 0(t1)           # a3 = valore rs1
    
    slli t2, t2, 2           # offset rs2
    add  t2, t2, a5
    lw   a4, 0(t2)           # a4 = valore rs2


    # Confronti con func3
    beq t3, zero, ADD_SUB  # ADD/SUB (funct3=0)
    li t6, 1
    beq t3, t6, SLL   # SLL (funct3=1)
    li t6, 2
    beq t3, t5, SLT    # SLT (funct3=2)
    li t6, 3
    beq t3, t6, SLTU    # SLTU (funct3=3)
    li t6, 4
    beq t3, t6, XOR    # XOR (funct3=4)
    li t6, 5
    beq t3, t6, SRL_SRA    # SRL/SRA (funct3=5)
    li t6, 6
    beq t3, t6, OR    # OR (funct3=6)
    li t6, 7
    beq t3, t6, AND    # AND (funct3=7)
    jr ra

    ADD_SUB:
    bgt t3, zero,SUB 
	ADD:
	add s7,a3,a4
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(s5)      
	j vai_avanti_con_pc
	SUB:
        sub s7,a3,a4
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(s5)        
	j vai_avanti_con_pc
	    
	SLL:
	sll s7, a3, a4           
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(s5)    
	j vai_avanti_con_pc
	
	SLT:                           
	slt s7, a3, a4           
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(s5)       
	j vai_avanti_con_pc
	
	SLTU:                          
	sltu s7, a3, a4            
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(s5)            
	j vai_avanti_con_pc
	
	XOR:
	xor s7, a3, a4             
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(s5)        
	j vai_avanti_con_pc

    SRL_SRA:
	bgt t4, zero, SRA           
	SRL:
	srl s7, a3, a4             
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(s5)        
	j vai_avanti_con_pc
	SRA:
	sra s7, a3, a4             
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(s5)        
	j vai_avanti_con_pc
	
	OR:
	or s7, a3, a4              
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(t0)    
	j vai_avanti_con_pc
	
	AND:
	and s7, a3, a4             
	slli t4, t4, 2
	add  s5, t4, a5     
	sw   s7, 0(t0)     
	j vai_avanti_con_pc
	
vai_avanti_con_pc:
      addi s2, s2, 8              
      jr ra
