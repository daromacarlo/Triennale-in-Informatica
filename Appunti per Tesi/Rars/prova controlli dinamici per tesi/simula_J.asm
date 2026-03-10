# IL PROGRAMMA SIMULA LE SEGUENTI:

#-----------------------------------------------------------------------------#
# jal Jump And Link J 1101111 rd = PC+4; PC += imm
#-----------------------------------------------------------------------------#

# imm | rd | opcode (J-type)


.globl simula_J


.text
simula_J:
    # Estrazione campi rs1, rs2, funct3 con una maschera
    srli t1, t6, 12
    andi t1, t1, 31          # t1 = imm
    
    srli s10, t6, 7
    andi s10, s10, 31        # s10 = rd

    # Ricostruzione func7
    srli t4, t6, 30      
    andi t4, t4, 127       
    
    # Caricamento valori reali dai registri virtuali
    # la   a5, REGISTRI_VIRTUALI
    
    slli t1, t1, 2           # offset rs1
    add  t1, t1, a5
    lw   a3, 0(t1)           # a3 = valore rs1
   
	
	JAL:
    # 1. Calcolo del Link Register (PC + 8)
    addi s11, s2, 8          # Nel tuo simulatore ogni istruzione HEX occupa 8 unit�
    
    # 2. Salvataggio di PC+8 in RD
    slli t0, s10, 2          # Offset rd (indice * 4)
    add  t0, t0, a5          # Indirizzo nel vettore registri virtuali
    sw   s11, 0(t0)          # Salva l'indirizzo di ritorno
    
    # 3. Ricostruzione dell'immediato J-type (t2)
    # Nota: L'immediato J � rimescolato: [20|10:1|11|19:12]
    # Estraiamo i pezzi dal registro dell'istruzione t6
    srli t1, t6, 21          # Bit 10:1
    andi t1, t1, 0x3FF
    slli t1, t1, 1
    
    srli t2, t6, 20          # Bit 11
    andi t2, t2, 1
    slli t2, t2, 11
    
    srli t3, t6, 12          # Bit 19:12
    andi t3, t3, 0xFF
    slli t3, t3, 12
    
    srli t4, t6, 31          # Bit 20 (segno)
    slli t4, t4, 20
    
    or t2, t1, t2            # Unione dei pezzi in t2
    or t2, t2, t3
    or t2, t2, t4
    
    # Estensione del segno di t2 (da 21 bit a 32 bit)
    slli t2, t2, 11
    srai t2, t2, 11
    
    # 4. Aggiornamento del PC (s2)
    # JAL fa PC = PC + offset_immediato
    add  s2, s2, t2          
    
    jr ra