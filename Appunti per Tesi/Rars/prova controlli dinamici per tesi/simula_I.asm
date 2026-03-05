# IL PROGRAMMA SIMULA LE SEGUENTI:

#-----------------------------------------------------------------------------#
# addi ADD Immediate I 0010011 0x0 rd = rs1 + imm
# xori XOR Immediate I 0010011 0x4 rd = rs1 ˆ imm
# ori OR Immediate I 0010011 0x6 rd = rs1 | imm
# andi AND Immediate I 0010011 0x7 rd = rs1 & imm
# slli Shift Left Logical Imm I 0010011 0x1 imm[5:11]=0x00 rd = rs1 << imm[0:4]
# srli Shift Right Logical Imm I 0010011 0x5 imm[5:11]=0x00 rd = rs1 >> imm[0:4]
# srai Shift Right Arith Imm I 0010011 0x5 imm[5:11]=0x20 rd = rs1 >> imm[0:4] msb-extends
# slti Set Less Than Imm I 0010011 0x2 rd = (rs1 < imm)?1:0
# sltiu Set Less Than Imm (U) I 0010011 0x3 rd = (rs1 < imm)?1:0 zero-extends
# lb Load Byte I 0000011 0x0 rd = M[rs1+imm][0:7]
# lh Load Half I 0000011 0x1 rd = M[rs1+imm][0:15]
# lw Load Word I 0000011 0x2 rd = M[rs1+imm][0:31]
# lbu Load Byte (U) I 0000011 0x4 rd = M[rs1+imm][0:7] zero-extends
# lhu Load Half (U) I 0000011 0x5 rd = M[rs1+imm][0:15] zero-extends
# jalr Jump And Link Reg I 1100111 0x0 rd = PC+4; PC = rs1 + imm
# ecall Environment Call I 1110011 0x0 imm=0x0 Transfer control to OS
# ebreak Environment Break I 1110011 0x0 imm=0x1 Transfer control to debugger
#-----------------------------------------------------------------------------#

# imm | rs1 | funct3 | rd | opcode (I-type)


.globl simula_I

.text
simula_I:
    # Estrazione campi rs1, rs2, funct3, func7. rd con una maschera
    srli t1, t6, 15
    andi t1, t1, 31          # t1 = rs1
    
    srli t2, t6, 20
    andi t2, t2, 2047        # t2 = imm
    
    srli t3, t6, 12
    andi t3, t3, 7           # t3 = funct3
    
    srli s10, t6, 7
    andi s10, s10, 31        # s10 = rd   
    
    srli t4, t6, 25
    andi t4, t4, 127         # t4 = imm[5:11] (func7)
    
    # Caricamento valori reali dai registri virtuali
    # la   a5, REGISTRI_VIRTUALI
    
    slli t1, t1, 2           # offset rs1
    add  t1, t1, a5
    lw   a3, 0(t1)           # a3 = valore rs1
    
    # capiamo che tipo di istruzione stiamo trattando
      li s11,19
      beq t3, s11, vai_simula_ALGI
      li s11,3
      beq t3, s11, vai_simula_LOAD
      li s11,103
      beq t3, s11, vai_simula_JALR
      li s11,115
      beq t3, s11, vai_simula_SYST    
    
        vai_simula_ALGI:
        	beq t3,zero, ADDI
        	li t5, 1
		beq t3, t5, SLLI   # SLLI (funct3=1)
		li t5, 2
		beq t3, t5, SLTI    # SLTI (funct3=2)
		li t5, 3
		beq t3, t5, SLTIU    # SLTIU (funct3=3)
		li t5, 4
		beq t3, t5, XORI    # XORI (funct3=4)
		li t5, 5
		beq t3, t5, SRLI_SRAI    # SRLI/SRAI (funct3=5)
		li t5, 6
		beq t3, t5, ORI    # ORI (funct3=6)
		li t5, 7
		beq t3, t5, ANDI    # ANDI (funct3=7)
		jr ra
        	
        	ADDI:
	 	add s11,a3,t2
		slli s10, s10, 2
		add  t0, s10, a5     
		sw   s11, 0(t0)      
		j vai_avanti_con_pc
		
			    
		SLLI:
	        sll s11, a3, a4           
		slli s10, s10, 2
		add  t0, s10, a5     
		sw   s11, 0(t0)     
	        j vai_avanti_con_pc
	
		SLTI:                           
		slt s11, a3, a4           
		slli s10, s10, 2
		add  t0, s10, a5    
		sw   s11, 0(t0)      
	        j vai_avanti_con_pc
	
	        SLTIU:                          
	        sltu s11, a3, a4            
		slli s10, s10, 2
		add  t0, s10, a5     
		sw   s11, 0(t0)      
	        j vai_avanti_con_pc
	
	        XORI:
	        xor s11, a3, a4             
		slli s10, s10, 2
		add  t0, s10, a5    
		sw   s11, 0(t0)      
	        j vai_avanti_con_pc

       SRLI_SRAI:
	        bgt t4, zero, SRAI          
	        SRLI:
	        srl s11, a3, a4             
	        slli s10, s10, 2
		add  t0, s10, a5   
		sw   s11, 0(t0)     
	        j vai_avanti_con_pc
	        
	        SRAI:
	        sra s11, a3, a4             
		slli s10, s10, 2
		add  t0, s10, a5   
		sw   s11, 0(t0)     
	        j vai_avanti_con_pc
	
	        ORI:
	        or s11, a3, a4              
		slli s10, s10, 2
		add  t0, s10, a5     
		sw   s11, 0(t0)
	        j vai_avanti_con_pc
	
	        ANDI:
	        and s11, a3, a4             
		slli s10, s10, 2
		add  t0, s10, a5    
		sw   s11, 0(t0)
	        j vai_avanti_con_pc
        
	vai_simula_LOAD:
	
	vai_simula_JALR:
	
	vai_simula_SYST:  
	
vai_avanti_con_pc:
      addi s2, s2, 8                 # Prossima istruzione HEX (8 caratteri)
      jr ra
  	