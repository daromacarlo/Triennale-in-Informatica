#include <soc/gpio_reg.h>

.section .data
    .align 4
    avviso_x0: .asciz "Warning: scrittura in x0 rilevata.\n"

.section .text
.globl controllo_registro_zero

controllo_registro_zero:
    # t6 contiene l'istruzione a 32 bit
    andi t1, t6, 0x7F       # Isola l'opcode (bit 0-6)
    
    # Opcodes che hanno il campo RD (Destination Register)
    li t2, 51               # R-type (add, sub, etc.)
    beq t1, t2, verifica_rd
    li t2, 19               # I-type arithmetic (addi, andi, etc.)
    beq t1, t2, verifica_rd
    li t2, 3                # Load (lw, lb, etc.)
    beq t1, t2, verifica_rd
    li t2, 55               # LUI
    beq t1, t2, verifica_rd
    li t2, 23               # AUIPC
    beq t1, t2, verifica_rd
    
    # JAL (111) e JALR (103) usano spesso x0 per i salti (j, jr), li ignoriamo
    j fine_check

verifica_rd:
    srli t1, t6, 7          # Sposta RD (bit 7-11) in posizione 0
    andi t1, t1, 0x1F       # Maschera per ottenere solo i 5 bit di RD
    bnez t1, fine_check     # Se RD != 0, tutto ok
    
    # Escludiamo il NOP standard (addi x0, x0, 0)
    li t2, 0x00000013
    beq t6, t2, fine_check
    
    # Se RD è 0 e non è un NOP, segnala errore RGZ
    j errore_reg_zero_morse

fine_check:
    li a0, 0                # Ritorna OK (0)
    ret

# --- SEGNALAZIONE ERRORE MORSE "RGZ" (LENTO E LIMITATO) ---
# R: . - .  |  G: - - .  |  Z: - - . .

errore_reg_zero_morse:
    li a4, 0x60004000       # Base GPIO ESP32-C3
    li a5, (1 << 8)         # Maschera Pin 8 (LED)
    li t5, 3                # CONTATORE: 3 ripetizioni

morse_repeat_loop:
    # --- Lettera R (· - ·) ---
    jal ra, dot
    jal ra, dash
    jal ra, dot
    jal ra, letter_space

    # --- Lettera G (- - ·) ---
    jal ra, dash
    jal ra, dash
    jal ra, dot
    jal ra, letter_space

    # --- Lettera Z (- - · ·) ---
    jal ra, dash
    jal ra, dash
    jal ra, dot
    jal ra, dot
    
    jal ra, word_space      # Pausa lunga prima della ripetizione
    
    addi t5, t5, -1
    bnez t5, morse_repeat_loop

    sw a5, 0x0004(a4)       # Spegne il LED
    li a0, 1                # Ritorna 1 (errore)
    ret

# --- SUBROUTINE MORSE (RALLENTATE) ---

dot:
    addi sp, sp, -4         # Salva l'indirizzo di ritorno
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

letter_space:
    li a6, 7500000
    j delay

word_space:
    li a6, 17500000
    j delay

delay:
1:  addi a6, a6, -1
    bnez a6, 1b
    ret