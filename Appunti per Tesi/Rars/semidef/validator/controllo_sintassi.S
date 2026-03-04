#include <soc/gpio_reg.h>

.globl controllo_sintassi

.section .data
    scritta: .asciz "fail_sintassi\n"

.section .text             
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
    # Segnalazione via Serial (se supportata dall'ambiente)
    # la a0, scritta
    # li a7, 4
    # ecall
    j errore_sintassi_morse

Rcheck:
    srli s4, t6, 12
    andi s4, s4, 7           # s4 = funct3
    srli s5, t6, 25          # s5 = funct7
    
    li s2, 0x01              # Estensione M
    beq s5, s2, fine_ok
    li s2, 0x00              # Standard
    beq s5, s2, fine_ok
    
    li s2, 0x20              # SUB / SRA
    bne s5, s2, fail
    li s2, 0                 # funct3 per SUB
    beq s4, s2, fine_ok
    li s2, 5                 # funct3 per SRA
    beq s4, s2, fine_ok
    j fail

Icheck:
    srli s4, t6, 12
    andi s4, s4, 7           # s4 = funct3
    andi s3, t6, 127         # ricarico opcode
    
    li s2, 3                 # Load
    beq s3, s2, check_load
    li s2, 19                # Op-Imm
    beq s3, s2, check_imm
    li s2, 103               # JALR
    beq s3, s2, check_jalr
    j fine_ok                # System call

check_load:
    li s2, 5
    bgt s4, s2, fail
    li s2, 3
    beq s4, s2, fail
    j fine_ok

check_imm:
    li s2, 1
    beq s4, s2, check_shift
    li s2, 5
    beq s4, s2, check_shift
    j fine_ok

check_shift:
    srli s5, t6, 31          # Bit 31 deve essere 0
    bne s5, zero, fail
    j fine_ok

check_jalr:
    bne s4, zero, fail
    j fine_ok

Scheck:
    srli s4, t6, 12
    andi s4, s4, 7
    li s2, 2
    bgt s4, s2, fail
    j fine_ok
    
Bcheck:
    srli s4, t6, 12
    andi s4, s4, 7
    li s2, 2
    beq s4, s2, fail
    li s2, 3
    beq s4, s2, fail
    j fine_ok
    
Ucheck: j fine_ok
Jcheck: j fine_ok

fine_ok:
    li a0, 0                 # Successo
    ret

# --- SEGNALAZIONE ERRORE MORSE "SIN" (LENTO E LIMITATO) ---
# S: . . .  |  I: . .  |  N: - .

errore_sintassi_morse:
    li a4, 0x60004000       # Base GPIO ESP32-C3
    li a5, (1 << 8)         # Maschera Pin 8 (LED)
    li t5, 3                # CONTATORE: 3 ripetizioni

morse_repeat_loop:
    # --- Lettera S (· · ·) ---
    jal ra, dot
    jal ra, dot
    jal ra, dot
    jal ra, letter_space

    # --- Lettera I (· ·) ---
    jal ra, dot
    jal ra, dot
    jal ra, letter_space

    # --- Lettera N (- ·) ---
    jal ra, dash
    jal ra, dot
    
    jal ra, word_space      # Pausa tra le ripetizioni della parola
    
    addi t5, t5, -1
    bnez t5, morse_repeat_loop

    sw a5, 0x0004(a4)       # Spegne il LED (Logica: bit a 1 = OFF)
    li a0, 1                # Ritorna 1 (errore)
    ret

# --- SUBROUTINE MORSE (RALLENTATE) ---

dot:
    addi sp, sp, -4
    sw ra, 0(sp)
    sw zero, 0x0004(a4)     # LED ON
    li a6, 2500000          
    jal ra, delay
    sw a5, 0x0004(a4)       # LED OFF
    li a6, 2500000          
    jal ra, delay
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

dash:
    addi sp, sp, -4
    sw ra, 0(sp)
    sw zero, 0x0004(a4)     # LED ON
    li a6, 7500000          
    jal ra, delay
    sw a5, 0x0004(a4)       # LED OFF
    li a6, 2500000          
    jal ra, delay
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

letter_space:               # Spazio tra lettere (3 unità)
    li a6, 7500000
    j delay

word_space:                 # Spazio tra parole (7 unità)
    li a6, 17500000
    j delay

delay:
1:  addi a6, a6, -1
    bnez a6, 1b
    ret