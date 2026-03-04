#include <soc/gpio_reg.h>

.section .data
    .align 4
    err_align_mem: .asciz "Errore: Accesso in memoria non allineato\n"

.section .text
.globl controllo_memoria

controllo_memoria:
    # t6 contiene l'istruzione a 32 bit da validare
    
    # 1. Identifichiamo se è un'istruzione Load (Opcode 3) o Store (Opcode 35)
    andi t1, t6, 127         # Isola l'opcode (bit 0-6)
    li t2, 3                 # Opcode LOAD
    beq t1, t2, verifica_allineamento
    li t2, 35                # Opcode STORE
    beq t1, t2, verifica_allineamento
    
    j fine_mem               # Se non è un'istruzione di memoria, esci correttamente

verifica_allineamento:
    # 2. Controlliamo se è una Word (funct3 deve essere 2 per LW/SW)
    srli t3, t6, 12
    andi t3, t3, 7           # Isola funct3
    li t4, 2                 # Valore 2 = Word
    bne t3, t4, fine_mem     # Se è un byte (0) o half-word (1), l'allineamento a 4 non è richiesto

    # 3. Estraiamo l'immediato per verificare l'allineamento dell'offset
    # Per LOAD (I-type): immediato è nei bit 20-31
    # Per STORE (S-type): immediato è diviso, ma i bit 0-1 dell'offset sono comunque nei bit 7-8 dell'istruzione
    # Per semplicità di convalida statica, controlliamo i bit che determinano l'allineamento a 4 (ultimi 2 bit dell'offset)
    
    andi t1, t6, 127         # Ricarica opcode
    li t2, 3
    beq t1, t2, imm_load

imm_store:
    # In Store (S-type), l'offset basso (bit 0-4) è nei bit 7-11 dell'istruzione
    srli t1, t6, 7           
    j check_bits

imm_load:
    # In Load (I-type), l'offset è nei bit 20-31
    srli t1, t6, 20

check_bits:
    andi t1, t1, 3           # Verifica i bit 0 e 1 dell'offset
    beqz t1, fine_mem        # Se sono 00, l'offset è multiplo di 4 -> OK

# --- SEGNALAZIONE ERRORE MORSE "MEM" ---
# M: - -  |  E: .  |  M: - -

errore_memoria_morse:
    li a4, 0x60004000       # Base GPIO ESP32-C3
    li a5, (1 << 8)         # Maschera Pin 8 (LED)
    li t5, 3                # CONTATORE: 3 ripetizioni

morse_repeat_loop:
    # --- Lettera M (- -) ---
    jal ra, dash
    jal ra, dash
    jal ra, letter_space

    # --- Lettera E (·) ---
    jal ra, dot
    jal ra, letter_space

    # --- Lettera M (- -) ---
    jal ra, dash
    jal ra, dash
    
    jal ra, word_space      # Pausa lunga prima della ripetizione
    
    addi t5, t5, -1
    bnez t5, morse_repeat_loop

    sw a5, 0x0004(a4)       # Spegne il LED alla fine
    li a0, 1                # Ritorna 1 (errore)
    ret

fine_mem:
    li a0, 0                # Ritorna 0 (successo)
    ret

# --- SUBROUTINE MORSE (LENTE) ---

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