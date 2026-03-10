# IL PROGRAMMA SIMULA LE SEGUENTI:

#-----------------------------------------------------------------------------#
# jal Jump And Link J 1101111 rd = PC+4; PC += imm
#-----------------------------------------------------------------------------#
# imm | rd | opcode (J-type)

.globl simula_J

.text
simula_J:
    srli t4, t6, 7
    andi t4, t4, 31        # t4 = rd

    addi a7, s2, 8        # pc + 4
    
    slli t4, t4, 2      # indirizzo ai registri virtuali   
    add  t4, t4, a5          
    sw   a7, 0(t4)          
    
    # Ricostruzione Immediato     
#-----------------------------------------------------------------------------------------------

# Bit 20 (Segno)
    srli t1, t6, 31
    slli t1, t1, 20
    
    # Bit 19:12
    lui  t2, 0x000FF        # Maschera per bit 19:12
    and  t2, t2, t6
    
    # Bit 11
    srli t3, t6, 20
    andi t3, t3, 1
    slli t3, t3, 11
    
    # Bit 10:1
    srli t5, t6, 21
    andi t5, t5, 0x3FF
    slli t5, t5, 1
    
    # Unione 
    or   t1, t1, t2
    or   t1, t1, t3
    or   t1, t1, t5         # t1 ha l'immediato a 21 bit
    
    # Estensione del segno (da 21 a 32 bit)
    slli t1, t1, 11
    srai t1, t1, 11
    
#-----------------------------------------------------------------------------------------------
    li s11,2
    mul t1, t1, s11
    add s2, s2, t1          # nuovo PC (simulato) = PC (simulato) + immediato
    jr ra
