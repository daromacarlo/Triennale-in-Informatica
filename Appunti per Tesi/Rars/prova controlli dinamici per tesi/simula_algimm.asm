.text
.globl simula_algimm

simula_algimm:
    # 1. Estrazione dei campi (Formato I: imm[11:0] | rs1 | funct3 | rd | opcode)
    
    # Estraggo RD (bit 7-11)
    srli t1, t6, 7
    andi t1, t1, 0x1F            # t1 = indice rd [cite: 5, 8]
    
    # Estraggo RS1 (bit 15-19)
    srli t2, t6, 15
    andi t2, t2, 0x1F            # t2 = indice rs1
    
    # 2. Estrazione e Estensione del Segno dell'Immediato (bit 20-31)
    srli a1, t6, 20              # Isolo i 12 bit alti in a1 
    
    # Controllo il bit di segno (bit 11 dell'immediato isolato)
    li t4, 0x800                 # Maschera per il bit 11 (2048) 
    and t5, a1, t4
    beqz t5, calcolo_imm         # Se il bit è 0, l'immediato è positivo
    
    # Se negativo, estendo il segno a 32 bit
    li t4, 0xFFFFF000            # Maschera per riempire i bit 12-31 
    or a1, a1, t4

calcolo_imm:
    # 3. Caricamento del valore dal registro virtuale RS1
    # t0 punta a virtual_regs 
    slli t4, t2, 2               # Indice rs1 * 4 byte
    add  t4, t4, t0
    lw   a2, 0(t4)               # a2 = valore virtuale di rs1

    # 4. Decodifica funct3 (bit 12-14) per l'operazione
    srli t4, t6, 12
    andi t4, t4, 7               # t4 = funct3 

    # Controllo se è ADDI (funct3 = 0)
    li t5, 0
    beq t4, t5, esegui_addi
    
    # Controllo se è ANDI (funct3 = 7)
    li t5, 7
    beq t4, t5, esegui_andi
    
    # Controllo se è ORI (funct3 = 6)
    li t5, 6
    beq t4, t5, esegui_ori

    # Se l'operazione non è implementata, procedi comunque (fallback su ADDI)
    j esegui_addi

esegui_addi:
    add  a4, a2, a1              # a4 = virtual_rs1 + immediato_esteso
    j salva_risultato_imm

esegui_andi:
    and  a4, a2, a1
    j salva_risultato_imm

esegui_ori:
    or   a4, a2, a1

salva_risultato_imm:
    # 5. Scrittura in virtual_regs[rd]
    slli t4, t1, 2               # Indice rd * 4
    add  t4, t4, t0
    sw   a4, 0(t4)               # Salva il risultato 

    # Garantisco che x0 rimanga 0 [cite: 1, 5]
    sw   zero, 0(t0)

    jr ra
