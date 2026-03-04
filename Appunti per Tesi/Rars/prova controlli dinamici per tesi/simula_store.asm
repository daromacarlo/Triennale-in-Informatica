.text
.globl simula_store


simula_store:
    # 1. Estrazione dei campi (Formato S: imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode)
    
    # Nelle istruzioni Store non esiste il registro di destinazione (RD).
    # L'unico effetto è sulla memoria, che non simuliamo per proteggere la ESP32.

    # Estraggo RS1 (bit 15-19) - Registro base per l'indirizzo
    srli t1, t6, 15
    andi t1, t1, 0x1F            # t1 = indice rs1
    
    # Estraggo RS2 (bit 20-24) - Registro sorgente (valore da scrivere)
    srli t2, t6, 20
    andi t2, t2, 0x1F            # t2 = indice rs2

    # 2. Estrazione dell'Immediato (diviso in bit 25-31 e bit 7-11)
    srli t3, t6, 25              # t3 = imm[11:5] (i 7 bit alti)
    slli t3, t3, 5               # Sposta i bit in posizione corretta
    srli t4, t6, 7
    andi t4, t4, 0x1F            # t4 = imm[4:0] (i 5 bit bassi)
    or   a1, t3, t4              # a1 = offset a 12 bit

    # Estensione del segno dell'offset
    li t4, 0x800                 # Maschera per il bit 11 (segno)
    and t5, a1, t4
    beqz t5, fine_simula_store   # Se il bit è 0, è positivo
    li t4, 0xFFFFF000            # Riempimento per i bit 12-31
    or a1, a1, t4

fine_simula_store:
    # 3. Simulazione dell'effetto
    # Non effettuiamo la scrittura reale in memoria per sicurezza.
    # Lo stato dei registri virtuali non cambia.
    
    jr ra
