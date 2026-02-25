.globl controllo_sintassi

.data
        scritta: .asciz "fail_sintassi\n"

.text             
    controllo_sintassi:
            andi s3, t6, 127         # Estraiamo l'opcode (bit 0-6)
            
            # verifichiamo che l'istruzione sia di TIPO R
            li s2, 51                # Opcode 0110011
            beq s2, s3, Rcheck
            
            # verifichiamo che l'istruzione sia di TIPO I
            li s2, 19                # Opcode 0010011 (Arimetica imm)
            beq s2, s3, Icheck
            li s2, 3                 # Opcode 0000011 (Load)
            beq s2, s3, Icheck
            li s2, 103               # Opcode 1100111 (JALR)
            beq s2, s3, Icheck
            li s2, 115               # Opcode 1110011 (System: ecall/ebreak)
            beq s2, s3, Icheck
            
            # verifichiamo che l'istruzione sia di TIPO S
            li s2, 35                # Opcode 0100011 (Store)
            beq s2, s3, Scheck
            
            # verifichiamo che l'istruzione sia di TIPO B 
            li s2, 99                # Opcode 1100011 (Branch)
            beq s2, s3, Bcheck
            
            # verifichiamo che l'istruzione sia di TIPO U
            li s2, 55                # Opcode 0110111 (LUI)
            beq s2, s3, Ucheck
            li s2, 23                # Opcode 0010111 (AUIPC)
            beq s2, s3, Ucheck
            
            # verifichiamo che l'istruzione sia di TIPO J
            li s2, 111               # Opcode 1101111 (JAL)
            beq s2, s3, Jcheck
            
    fail:
            la a0, scritta
            li a7, 4
            ecall
            li a0, 1                 # Ritorna 1 (errore)
            jr ra
            
    Rcheck:
            # Estrazione campi
            srli s4, t6, 12
            andi s4, s4, 7           # s4 = funct3
            srli s5, t6, 25          # s5 = funct7
            
            # Se funct7 == 0x01, è estensione M (Moltiplicazione/Divisione)
            li s2, 0x01
            beq s5, s2, fine_ok      # Tutte le funct3 (0-7) sono valide in M
            
            # Se funct7 == 0x00, tutte le funct3 (0-7) sono valide
            li s2, 0x00
            beq s5, s2, fine_ok
            
            # Se funct7 == 0x20, solo ADD (0) e SRL (5) diventano SUB e SRA
            li s2, 0x20
            bne s5, s2, fail
            li s2, 0                 # SUB
            beq s4, s2, fine_ok
            li s2, 5                 # SRA
            beq s4, s2, fine_ok
            j fail

    Icheck:
            srli s4, t6, 12
            andi s4, s4, 7           # s4 = funct3
            andi s3, t6, 127         # ricarico opcode
            
            # Caso Load (opcode 3)
            li s2, 3
            beq s3, s2, check_load
            
            # Caso Op-Imm (opcode 19)
            li s2, 19
            beq s3, s2, check_imm
            
            # Caso JALR (opcode 103)
            li s2, 103
            beq s3, s2, check_jalr

            # Caso System (ecall/ebreak)
            j fine_ok                # Semplificato per brevità

      check_load:
            li s2, 5                 # LBU/LHU max funct3 è 5
            bgt s4, s2, fail
            li s2, 3                 # funct3=3 non definita in RV32
            beq s4, s2, fail
            j fine_ok

     check_imm:
            # Controllo speciale per SLLI/SRLI/SRAI (funct3 1 e 5)
            li s2, 1
            beq s4, s2, check_shift
            li s2, 5
            beq s4, s2, check_shift
            j fine_ok                # Altri (ADDI, etc) sempre validi
        
    check_shift:
            srli s5, t6, 26          # Per gli shift, i bit 26-31 devono essere 0
            li s2, 0                 # (Tranne bit 30 per SRAI, gestito qui per semplicità)
            srli s5, t6, 31          # Bit 31 deve essere 0
            bne s5, zero, fail
            j fine_ok

    check_jalr:
            bne s4, zero, fail       # JALR richiede funct3 = 0
            j fine_ok

    Scheck:
            srli s4, t6, 12
            andi s4, s4, 7
            li s2, 2
            bgt s4, s2, fail         # SB(0), SH(1), SW(2)
            j fine_ok
            
    Bcheck:
            srli s4, t6, 12
            andi s4, s4, 7
            li s2, 2                 # funct3 2 e 3 non esistono
            beq s4, s2, fail
            li s2, 3
            beq s4, s2, fail
            j fine_ok
            
    Ucheck:
            j fine_ok
            
    Jcheck:
            j fine_ok
            
    fine_ok:
            li a0, 0                 # Ritorna 0 (successo)
            jr ra
