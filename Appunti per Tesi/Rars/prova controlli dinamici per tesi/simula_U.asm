# IL PROGRAMMA SIMULA LE SEGUENTI:

#-----------------------------------------------------------------------------#
# lui Load Upper Imm U 0110111 rd = imm << 12
# auipc Add Upper Imm to PC U 0010111 rd = PC + (imm << 12)
#-----------------------------------------------------------------------------#

# imm | rd | opcode (U-type)


.globl simula_U

.text
simula_U:
    srli s10, t6, 7
    andi s10, s10, 31

    lui  t2, 0xFFFFF
    and  t2, t6, t2
    
    andi t3, t6, 127
    
    li   t4, 55
    beq  t3, t4, LUI
    
    li   t4, 23
    beq  t3, t4, AUIPC
    
    jr ra

LUI:
    mv   s11, t2
    j    scrivi_rd_u

AUIPC:
    add  s11, s2, t2
    j    scrivi_rd_u

scrivi_rd_u:
    slli t0, s10, 2        
    add  t0, t0, a5      
    sw   s11, 0(t0)       
    
    j vai_avanti_con_pc
    
vai_avanti_con_pc:
      addi s2, s2, 8                 # Prossima istruzione HEX (8 caratteri)
      jr ra
