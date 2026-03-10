# IL PROGRAMMA SIMULA LE SEGUENTI OPERAZIONI:

#-------------------------------------------------------#
# beq Branch == B 1100011 0x0 if(rs1 == rs2) PC += imm	
# bne Branch != B 1100011 0x1 if(rs1 != rs2) PC += imm	
# blt Branch < B 1100011 0x4 if(rs1 < rs2)   PC += imm	
# bge Branch ? B 1100011 0x5 if(rs1 >= rs2)  PC += imm	
# bltu Branch < (U) B 1100011 0x6 if(rs1 < rs2) PC += imm zero-extends
# bgeu Branch ? (U) B 1100011 0x7 if(rs1 >= rs2) PC += imm zero-extends
#-------------------------------------------------------#

# imm | rs2 | rs1 | funct3 | imm | opcode (B-type)

.globl simula_B

.text
simula_B:
    # Estrazione campi rs1, rs2, funct3
    srli t1, t6, 15
    andi t1, t1, 31          # t1 = rs1
    
    srli t2, t6, 20
    andi t2, t2, 31          # t2 = rs2
    
    srli t3, t6, 12
    andi t3, t3, 7           # t3 = funct3
    
# Ricostruzione Immediato     
#-----------------------------------------------------------------------------------------------

    # Bit 12 (segno)
    srli t4, t6, 31
    slli t4, t4, 12
    
    # Bit 11
    srli t5, t6, 7
    andi t5, t5, 1
    slli t5, t5, 11
    
    # Bit 10:5
    srli a2, t6, 25
    andi a2, a2, 0x3F
    slli a2, a2, 5
    
    # Bit 4:1
    srli a3, t6, 8
    andi a3, a3, 0xF
    slli a3, a3, 1
    
    or t4, t4, t5
    or t4, t4, a2
    or t4, t4, a3            # t4 contiene l'immediato unito e completo
    
    slli t4, t4, 19
    srai t4, t4, 19          # t4 = immediato finale con segno
    
#-----------------------------------------------------------------------------------------------

    # Carico valori dai registri virtuali
    
    
    slli t1, t1, 2           # offset rs1
    add  t1, t1, a5
    lw   a3, 0(t1)           # a3 = valore rs1
    
    slli t2, t2, 2           # offset rs2
    add  t2, t2, a5
    lw   a4, 0(t2)           # a4 = valore rs2

    # Confronti con func3
    beq t3, zero, branch_eq  # BEQ (funct3=0)
    li s9, 1
    beq t3, s9, branch_ne    # BNE (funct3=1)
    li s9, 4
    beq t3, s9, branch_lt    # BLT (funct3=4)
    li s9, 5
    beq t3, s9, branch_ge    # BGE (funct3=5)
    li s9, 6
    beq t3, s9, branch_ltu    # BGE (funct3=6)
    li s9, 7
    beq t3, s9, branch_leu    # BGE (funct3=7)
    jr ra

branch_eq:
    beq a3, a4, esegui_salto
    j vai_avanti_con_pc
branch_ne:
    bne a3, a4, esegui_salto
    j vai_avanti_con_pc
branch_lt:
    blt a3, a4, esegui_salto
    j vai_avanti_con_pc
branch_ge:
    bge a3, a4, esegui_salto
    j vai_avanti_con_pc
branch_ltu:
    bltu a3, a4, esegui_salto
    j vai_avanti_con_pc
branch_leu:
    bgeu a3, a4, esegui_salto
    j vai_avanti_con_pc
    
vai_avanti_con_pc:
      addi s2, s2, 8
      jr ra

esegui_salto:
    li s11,2
    mul t4, t4, s11
    add s2, s2, t4          # nuovo PC (simuato) = PC (simulato) + immediato
    jr ra
