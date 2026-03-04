.text
.globl simula_alg

simula_alg:
    # 1. Estrazione dei campi (Formato R: funct7 | rs2 | rs1 | funct3 | rd | opcode)
    
    # Estraggo RD (bit 7-11)
    srli t1, t6, 7
    andi t1, t1, 0x1F            # t1 = indice rd
    
    # Estraggo RS1 (bit 15-19)
    srli t2, t6, 15
    andi t2, t2, 0x1F            # t2 = indice rs1
    
    # Estraggo RS2 (bit 20-24)
    srli t3, t6, 20
    andi t3, t3, 0x1F            # t3 = indice rs2

    # 2. Caricamento dei valori dai registri virtuali
    # t0 contiene l'indirizzo di virtual_regs (caricato all'inizio di controllo_dinamico_loop)
    
    # Carico virtual_regs[rs1]
    slli t4, t2, 2               # Indice * 4 byte
    add  t4, t4, t0
    lw   a2, 0(t4)               # a2 = valore rs1

    # Carico virtual_regs[rs2]
    slli t5, t3, 2               # Indice * 4 byte
    add  t5, t5, t0
    lw   a3, 0(t5)               # a3 = valore rs2

    # 3. Decodifica funct3 (bit 12-14) per capire l'operazione
    srli t4, t6, 12
    andi t4, t4, 7               # t4 = funct3

    # Se funct3 == 0, può essere ADD o SUB
    bnez t4, altre_operazioni
    
    # Controllo funct7 (bit 30) per distinguere ADD da SUB
    srli t5, t6, 30
    andi t5, t5, 1
    bnez t5, esegui_sub

esegui_add:
    add  a4, a2, a3              # a4 = rs1 + rs2
    j salva_risultato

esegui_sub:
    sub  a4, a2, a3              # a4 = rs1 - rs2
    j salva_risultato

altre_operazioni:
    # Esempio per AND (funct3 = 7)
    li t5, 7
    beq t4, t5, esegui_and
    # Esempio per OR (funct3 = 6)
    li t5, 6
    beq t4, t5, esegui_or
    
    # Se l'operazione non è implementata, facciamo finta sia un'aggiunta 
    # per non bloccare la simulazione
    add a4, a2, a3 
    j salva_risultato

esegui_and:
    and a4, a2, a3
    j salva_risultato

esegui_or:
    or a4, a2, a3

salva_risultato:
    # 4. Scrittura del risultato in virtual_regs[rd]
    slli t4, t1, 2               # Indice rd * 4
    add  t4, t4, t0
    sw   a4, 0(t4)               # Salva in memoria

    # 5. IMPORTANTE: Garantire che x0 sia sempre 0
    # Se il programma ha scritto in virtual_regs[0], lo resettiamo
    sw   zero, 0(t0)

    jr ra
