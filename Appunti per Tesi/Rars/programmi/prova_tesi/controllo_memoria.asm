.globl controllo_memoria

.data
    err_align_mem: .asciz "Errore: Accesso in memoria non allineato (deve essere multiplo di 4)\n"
    err_range_mem: .asciz "Errore: Accesso fuori dai limiti della sezione dati\n"

.text
controllo_memoria:
    # t6 = istruzione a 32 bit
    
    # 1. Identifichiamo se è un'istruzione Load (Opcode 3) o Store (Opcode 35)
    andi t1, t6, 0x7F
    li t2, 3                # Opcode LOAD
    beq t1, t2, verifica_load_store
    li t2, 35               # Opcode STORE
    beq t1, t2, verifica_load_store
    j fine_mem              # Se non è memoria, esci

verifica_load_store:
    # 2. Estraiamo l'immediato (offset della memoria)
    # Nelle Load/Store è un formato I-type o S-type (sempre 12 bit)
    # Per semplicità verifichiamo l'allineamento dell'offset statico
    # Se l'istruzione è LW/SW (funct3 = 2), l'offset deve essere multiplo di 4
    srli t3, t6, 12
    andi t3, t3, 7          # Isola funct3 (bit 12-14)
    li t4, 2                # Valore per WORD (lw/sw)
    bne t3, t4, fine_mem    # Se non è una Word (ma byte o half), l'allineamento è meno stringente

    # Estraiamo l'immediato (bit 20-31 per Load, rimescolato per Store)
    # Nota: Statica, verifichiamo solo l'offset immediato.
    # In un'istruzione I-type (Load):
    srli t1, t6, 20         # t1 = immediato a 12 bit
    
    # 3. Controllo allineamento dell'offset
    andi t2, t1, 3          # Verifica se gli ultimi 2 bit sono 00
    beqz t2, fine_mem       # Se multiplo di 4, tutto ok
    
    # Se arriviamo qui, l'offset non è allineato
    la a0, err_align_mem
    li a7, 4
    ecall

fine_mem:
    jr ra