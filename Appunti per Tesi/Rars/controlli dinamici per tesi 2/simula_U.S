# IL PROGRAMMA SIMULA LE SEGUENTI:

#-----------------------------------------------------------------------------#
# lui   Load Upper Imm      U 0110111   rd = imm << 12
# auipc Add Upper Imm to PC U 0010111   rd = PC_simulato + (imm << 12)
#-----------------------------------------------------------------------------#

.globl simula_U

.text
simula_U:
    # 1. Estrai il registro di destinazione rd (bit 7-11)
    srli s9, t6, 7
    andi s9, s9, 31          # s9 = indice registro rd

    # 2. Isola l'immediato (bit 31-12). 
    # Poiché t6 contiene l'istruzione intera, basta azzerare i primi 12 bit.
    lui  t2, 0xFFFFF
    and  t2, t6, t2          # t2 = imm << 12
    
    # 3. Identifica l'operazione tramite l'opcode (s10)
    li   t4, 55              # Opcode per LUI (0110111)
    beq  s10, t4, LUI
    
    li   t4, 23              # Opcode per AUIPC (0010111)
    beq  s10, t4, AUIPC
    
    jr ra

LUI:
    # Carica semplicemente l'immediato nel registro virtuale rd
    mv   s11, t2
    j    salva_e_prosegui

AUIPC:   
    # Calcola il PC simulato relativo alla base standard 0x00400000
    # s2 = puntatore corrente alla stringa esadecimale (host)
    # s8 + 4096 = indirizzo host dell'inizio della stringa 'programma'
    li s9, 4096
    add t0, s8, s9     
    sub  t1, s2, t0        # t1 = offset in caratteri (es. 0, 8, 16...)
    srai t1, t1, 1         # t1 = offset in byte (divisione per 2 perché 1 byte = 2 char hex)
    
    lui  t0, 0x00400       # Base PC standard di RARS
    add  t1, t1, t0        # t1 = PC simulato attuale
    
    add  s11, t1, t2       # rd = PC_simulato + imm
    j    salva_e_prosegui

salva_e_prosegui:
    # Salva il risultato (s11) nel registro virtuale (s9)
    slli t0, s9, 2        
    add  t0, t0, a5        # Indirizzo in REGISTRI_VIRTUALI
    sw   s11, 0(t0)        
    
    j vai_avanti_con_pc

vai_avanti_con_pc:
    addi s2, s2, 8         # Avanza alla prossima istruzione hex (8 caratteri)
    jr ra
