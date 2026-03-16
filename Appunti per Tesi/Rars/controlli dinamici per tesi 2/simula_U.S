# IL PROGRAMMA SIMULA LE SEGUENTI:

#-----------------------------------------------------------------------------#
# lui   Load Upper Imm      U 0110111   rd = imm << 12
# auipc Add Upper Imm to PC U 0010111   rd = PC_simulato + (imm << 12)
#-----------------------------------------------------------------------------#

.globl simula_U

.text
simula_U:
    
    srli s9, t6, 7
    andi s9, s9, 31          # s9 = rd

    lui  t2, 0xFFFFF
    and  t2, t6, t2          # t2 = imm << 12
    
    # capisco che op è
    li   t4, 55              # LUI
    beq  s10, t4, LUI
    
    li   t4, 23              # AUIPC
    beq  s10, t4, AUIPC
    
    jr ra

LUI:
    # salvo in s11 per non creare sovrapposizioni dopo
    mv   s11, t2
    j    salva_e_prosegui

AUIPC:   

    li s9, 4096
    add t0, s8, s9 
    sub  t1, s2, t0 
    srai t1, t1, 1     
    
    lui  t0, 0x00400  
    add  t1, t1, t0
    
    add  s11, t1, t2
    j    salva_e_prosegui

salva_e_prosegui:
    slli t0, s9, 2        
    add  t0, t0, a5        # Indirizzo ai registri virtuali
    sw   s11, 0(t0)        
    
    j vai_avanti_con_pc

vai_avanti_con_pc:
    addi s2, s2, 8
    jr ra
