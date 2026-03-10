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
#------------------------------------------------------------------------------
# lb Load Byte I 0000011 0x0 rd = M[rs1+imm][0:7]
# lh Load Half I 0000011 0x1 rd = M[rs1+imm][0:15]
# lw Load Word I 0000011 0x2 rd = M[rs1+imm][0:31]
# lbu Load Byte (U) I 0000011 0x4 rd = M[rs1+imm][0:7] zero-extends
# lhu Load Half (U) I 0000011 0x5 rd = M[rs1+imm][0:15] zero-extends
#------------------------------------------------------------------------------
# jalr Jump And Link Reg I 1100111 0x0 rd = PC+4; PC = rs1 + imm
#------------------------------------------------------------------------------
# ecall Environment Call I 1110011 0x0 imm=0x0 Transfer control to OS
# ebreak Environment Break I 1110011 0x0 imm=0x1 Transfer control to debugger
#-----------------------------------------------------------------------------#

# imm | rs1 | funct3 | rd | opcode (I-type)

.globl simula_I

.text
simula_I:
    srli t1, t6, 15
    andi t1, t1, 31          # t1 = rs1
    
    srli t3, t6, 12
    andi t3, t3, 7           # t3 = funct3
    
    srli t4, t6, 7
    andi t4, t4, 31         # t4 = rd
    
    srli t5, t6, 20	    # immediato
    slli t5, t5, 20
    srai t5, t5, 20
 
    slli t1, t1, 2           # offset rs1
    add t1, t1, a5
    lw a3, 0(t1)           # a3 = valore rs1
    
      # Confronti con opcode (#s10 opcode fisso)
      li s9,19
      beq s10, s9, vai_simula_ALGI
      li s9,3
      beq s10, s9, vai_simula_LOAD
      li s9,103
      beq s10, s9, vai_simula_JALR
      li s9,115
      beq s10, s9, vai_simula_SYST    
    
      # Confronti con func3
        vai_simula_ALGI:
        	beq t3,zero, ADDI   # ADD, LOADBYTE (func3=0)
        	li s9, 1
		beq t3, s9, SLLI   # SLLI (funct3=1)
		li s9, 2
		beq t3, s9, SLTI    # SLTI (funct3=2)
		li t5, 3
		beq t3, s9, SLTIU    # SLTIU (funct3=3)
		li t5, 4
		beq t3, s9, XORI    # XORI (funct3=4)
		li s9, 5
		beq t3, s9, SRLI_SRAI    # SRLI/SRAI (funct3=5)
		li t5, 6
		beq t3, s9, ORI    # ORI (funct3=6)
		li t5, 7
		beq t3, s9, ANDI    # ANDI (funct3=7)
		jr ra
        	
        	ADDI:
	 	add a6,a3,t5
		slli t4, t4, 2
		add s7, t4, a5     
		sw a6, 0(s7)      
		j vai_avanti_con_pc
			    
		SLLI:
		bgt t3, zero, SLLI_REAL
		j vai_avanti_con_pc
		SLLI_REAL: 
		andi t5, t5, 31       
   		sll a6, a3, t5	
		slli t4, t4, 2
		add s7, t4, a5     
		sw a6, 0(s7)         
	        j vai_avanti_con_pc
	
		SLTI:                           
		slt  a6, a3, t5     
		slli t4, t4, 2
		add s7, t4, a5     
		sw a6, 0(s7)           
	        j vai_avanti_con_pc
	
	        SLTIU:                          
	        sltu a6, a3, t5          
		slli t4, t4, 2
		add s7, t4, a5     
		sw a6, 0(s7)           
	        j vai_avanti_con_pc
	
	        XORI:
	        xor a6, a3, t5             
		slli t4, t4, 2
		add s7, t4, a5     
		sw a6, 0(s7)         
	        j vai_avanti_con_pc

       SRLI_SRAI:
       		andi t5,t5, 31
	        bgt t3, zero, SRAI          
	        SRLI:
	        srl a6, a3, t5             
		slli t4, t4, 2
		add s7, t4, a5     
		sw a6, 0(s7)          
	        j vai_avanti_con_pc
	        
	        SRAI:
	        sra a6, a3, t5            
		slli t4, t4, 2
		add s7, t4, a5     
		sw a6, 0(s7)         
	        j vai_avanti_con_pc
	
	        ORI:
	        or a6, a3, t5             
		slli t4, t4, 2
		add s7, t4, a5     
		sw a6, 0(s7)      
	        j vai_avanti_con_pc
	
	        ANDI:
	        and a6, a3, t5           
		slli t4, t4, 2
		add s7, t4, a5     
		sw a6, 0(s7)      
	        j vai_avanti_con_pc
        
#--------------------------------------------------------------------------------------------------------------        
# """"""""funzioni"""""""" "algi" scritte di fretta, sono da ricontrollare, potrbbero contenere errori e orrori   
 
     vai_simula_LOAD:
		
	    beq t3, zero, LB  # LB (funct3=0)
	    li s9, 1
	    beq t3, s9, LH  # LH (funct3=1)
	    li s9, 2
	    beq t3, s9, LW    # LW(funct3=2)
	    li s9, 4
	    beq t3, s9, LBU    # LW(funct3=3)
	    li s9, 5
	    beq t3, s9, LHU    # LW(funct3=4)
	    jr ra
	    
	       LB:
	       add a6, a3, t5
	       add a6, s8, a6   # indirizzo alla memoria virtuale.
	       lb a7, 0(a6)      
	       slli t4, t4, 2     
	       add s7, t4, a5   
	       sw a7, 0(s7)     
	       j vai_avanti_con_pc
	
	       LH:
	       add a6, a3, t5
	       add a6, s8, a6         
	       lh a7, 0(a6)      
	       slli t4, t4, 2     
	       add s7, t4, a5   
	       sw a7, 0(s7)        
	       j vai_avanti_con_pc
	
	       LW:
	       add a6, a3, t5
	       add a6, s8, a6        
	       lw a7, 0(a6)      
	       slli t4, t4, 2     
	       add s7, t4, a5   
	       sw a7, 0(s7)         
	       j vai_avanti_con_pc
	
	       LBU:
	       add a6, a3, t5
	       add a6, s8, a6        
	       lbu a7, 0(a6)      
	       slli t4, t4, 2     
	       add s7, t4, a5   
	       sw a7, 0(s7)       
	       j vai_avanti_con_pc
	
	       LHU:
	       add a6, a3, t5
	       add a6, s8, a6  
	       lhu a7, 0(a6)      
	       slli t4, t4, 2     
	       add s7, t4, a5   
	       sw a7, 0(s7)     
	       j vai_avanti_con_pc
	
#---------------------------------------------------------------------
		
	vai_simula_JALR:
	    srli t4, t6, 7
	    andi t4, t4, 31         # t4 = rd
    
	    slli a6, t4, 2          
	    add  a6, a6, a5     # indirizzo a memoria virtuale con indirizzo base a5 memoria virtuale
	    addi a7, s2, 8	# PC + 4    
	    sw a7, 0(a6)
	         
	    add s2, a3, t5     # PC = rs1 + imm
	    add s2, s2, s8     # aggiungo indirizzo base programma.
	    
   	    jr ra		

#------------------------------------------------------------------------	

	vai_simula_SYST:
	    j    vai_avanti_con_pc    
 
	
vai_avanti_con_pc:
      addi s2, s2, 8 
      jr ra
  	
