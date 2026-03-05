# IL PROGRAMMA SIMULA LE SEGUENTI OPERAZIONI:

#-------------------------------------------------------#
# beq Branch == B 1100011 0x0 if(rs1 == rs2) PC += imm	#
# bne Branch != B 1100011 0x1 if(rs1 != rs2) PC += imm	#
# blt Branch < B 1100011 0x4 if(rs1 < rs2)   PC += imm	#
# bge Branch ? B 1100011 0x5 if(rs1 >= rs2)  PC += imm	#
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

    # Ricostruzione Immediato B-type
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
    
    # Unione corretta (t0 temporaneo per non perdere pezzi)
    or t4, t4, t5
    or t4, t4, a2
    or t4, t4, a3            # t4 = immediato a 13 bit
    
    # Estensione del segno
    slli t4, t4, 19
    srai t4, t4, 19          # t4 = immediato finale con segno

    # Caricamento valori reali dai registri virtuali
    # la   a5, REGISTRI_VIRTUALI
    
    slli t1, t1, 2           # offset rs1
    add  t1, t1, a5
    lw   a3, 0(t1)           # a3 = valore rs1
    
    slli t2, t2, 2           # offset rs2
    add  t2, t2, a5
    lw   a4, 0(t2)           # a4 = valore rs2

    # Confronti
    beq t3, zero, branch_eq  # BEQ (funct3=0)
    li t5, 1
    beq t3, t5, branch_ne    # BNE (funct3=1)
    li t5, 4
    beq t3, t5, branch_lt    # BLT (funct3=4)
    li t5, 5
    beq t3, t5, branch_ge    # BGE (funct3=5)
    jr ra

branch_eq:
    beq a3, a4, esegui_salto
    jr ra
branch_ne:
    bne a3, a4, esegui_salto
    jr ra
branch_lt:
    blt a3, a4, esegui_salto
    jr ra
branch_ge:
    bge a3, a4, esegui_salto
    jr ra
    
vai_avanti_con_pc:
      addi s2, s2, 8                 # Prossima istruzione HEX (8 caratteri)
      jr ra

esegui_salto:
    add s2, s2, t4              # nuovo PC (simuato) = PC (simulato) + immediato
    jr ra
