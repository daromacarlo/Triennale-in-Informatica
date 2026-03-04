.text
.globl simula_load

simula_load:
    # 1. Estrazione dei campi (Formato I: imm[11:0] | rs1 | funct3 | rd | opcode)
    
    # Estraggo RD (bit 7-11)
    srli t1, t6, 7
    andi t1, t1, 0x1F            # t1 = indice rd
    
    # Estraggo RS1 (bit 15-19) - Registro base
    srli t2, t6, 15
    andi t2, t2, 0x1F            # t2 = indice rs1
    
    # 2. Estrazione e Estensione del Segno dell'Immediato (bit 20-31)
    # L'offset del caricamento è contenuto nei 12 bit più significativi
    srli a1, t6, 20              # Isolo i 12 bit in a1
    
    # Controllo il bit di segno (bit 11 dell'immediato isolato)
    li t4, 0x800                 # Maschera per il bit 11 (2048)
    and t5, a1, t4
    beqz t5, esegui_load_sim     # Se il bit è 0, l'immediato è positivo
    
    # Se negativo, estendo il segno a 32 bit per coerenza nel calcolo dell'indirizzo
    li t4, 0xFFFFF000            # Maschera per i bit 12-31
    or a1, a1, t4

esegui_load_sim:
    # 3. Caricamento del valore simulato
    # Nota: Non leggiamo dalla memoria reale per evitare crash.
    # Inseriamo 0 nel registro rd per simulare il completamento dell'operazione.
    li a4, 0                     # Valore "finto" caricato

    # 4. Scrittura in virtual_regs[rd]
    # t0 punta alla base di virtual_regs
    slli t4, t1, 2               # Indice rd * 4 byte
    add  t4, t4, t0
    sw   a4, 0(t4)               # Salva il valore nel registro virtuale

    # 5. Protezione Registro Zero
    # RISC-V impone che x0 sia sempre zero
    sw   zero, 0(t0)

    jr ra
