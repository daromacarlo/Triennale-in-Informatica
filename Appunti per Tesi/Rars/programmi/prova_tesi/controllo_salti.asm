.globl controllo_salti

.data
        scritta2: .asciz "fail_salti: indirizzodi arrivo fuori range\n"
        scritta3: .asciz "fail_salti: possibile loop infinito\n"

.text             
controllo_salti:

    # Identificazione tipo di salto
    li t1, 99               # Opcode Branch 
    beq s3, t1, decode_branch
    li t1, 111              # Opcode JAL 
    beq s3, t1, decode_jal
    li t1, 103              # Opcode JALR # cheè di tipo immediato 
    beq s3, t1, decode_jalr
    j uscita

	# LO STESSO CODICE E' OTTENIBILE UTILIZZANDO UNA FLAG,
	#  QUESTO EVITEREBBE LA RIPETIZIONE DI QUESTA OPERAZIONE
	# TUTTAVIA VA A COMPLICARE TROPPO IL MAIN...
	# PER ORA HO DECISO DI LASCIARLO COSI'

decode_branch:

    # Ricostruiamo l'offset
    srli t1, t6, 31        
    slli t1, t1, 12        
    srli t2, t6, 7
    andi t2, t2, 1         
    slli t2, t2, 11        
    srli t3, t6, 25
    andi t3, t3, 0x3F      
    slli t3, t3, 5         
    srli t4, t6, 8
    andi t4, t4, 0xF       
    slli t4, t4, 1         
    
    or a1, t1, t2          
    or a1, a1, t3
    or a1, a1, t4          

    li t2, 0x1000          # 4096: Maschera per il bit 12 (segno del branch)
    and t1, a1, t2         
    beqz t1, check_range
    li t2, 0xFFFFE000      # Estensione del segno per branch
    or a1, a1, t2
    j check_range

decode_jal:
    # Estrazione bit e ricostruzione offset per JAL (J-type)
    srli t1, t6, 31        
    slli t1, t1, 20
    srli t2, t6, 21
    andi t2, t2, 0x3FF     
    slli t2, t2, 1
    srli t3, t6, 20
    andi t3, t3, 1         
    slli t3, t3, 11
    srli t4, t6, 12
    andi t4, t4, 0xFF      
    slli t4, t4, 12
    
    or a1, t1, t2
    or a1, a1, t3
    or a1, a1, t4
    

    li t2, 0x100000        # Maschera per il bit 20 (segno del JAL)
    and t1, a1, t2         
    beqz t1, check_range
    li t2, 0xFFE00000      # Estensione del segno per J-type
    or a1, a1, t2

decode_jalr:
    # Formato I-type: | imm[11:0] (12 bit) | rs1 (5b) | funct3 (3b) | rd (5b) | opcode (7b) |
    
    # 1. Estrazione dell'immediato (i primi 12 bit dell'istruzione t6)
    srli a1, t6, 20         # Sposta a destra di 20 bit per isolare imm[11:0]
    
    # 2. Estensione del segno
    # Poiché l'immediato è di 12 bit, il bit di segno è il bit 11 (2^11 = 2048)
    li t2, 2048             # Carichiamo la maschera per il bit 11
    and t1, a1, t2          # Verifichiamo se il bit di segno è 1
    beqz t1, fine_jalr      # Se è 0, il numero è positivo
    
    # Se è negativo, estendiamo il segno a 32 bit
    li t2, 0xFFFFF000       # Maschera per riempire i bit alti da 12 a 31
    or a1, a1, t2

fine_jalr:
    # NOTA: Staticamente l'indirizzo finale sarebbe: Registro(rs1) + a1.
    # Non avendo il valore del registro, terminiamo la decodifica qui.
    # Se volessi essere pignolo, potresti controllare che l'offset non sia 
    # assurdamente grande, ma solitamente si esce e si prosegue.
    j uscita

check_range:

    # Poiché ogni istruzione nella stringa occupa 8 byte (8 caratteri hex),
    # ma l'offset assembly conta in word (4 byte), raddoppio l'offset.
    slli a1, a1, 1         
    add  a2, t0, a1        # a2 = Destinazione calcolata nella stringa

    # Verifica se il target è tra l'inizio (s4) e la fine (s0)
    blt a2, s4, fail_range
    bgt a2, s0, fail_range
    
# Verifica loop infinito (salto su se stesso)
    beq a2, t0, fail_loop    

    j uscita

fail_range:
    la a0, scritta2
    li a7, 4
    ecall
    j uscita

fail_loop:
    la a0, scritta3
    li a7, 4
    ecall

uscita:
    jr ra