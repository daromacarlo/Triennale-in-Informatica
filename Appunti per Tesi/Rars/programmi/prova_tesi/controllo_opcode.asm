.globl controllo_opcode
.data
		scritta: .asciz "fail_opcode\n"
.text:			   
	controllo_opcode:
			andi s3,t6,127
			# controlliamo se l'operazione è di tipo algebrico
			li s2, 51 #opcode 0110011
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo algebrico immediato
			li s2, 19 #opcode 0010011
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo caricamento
			li s2, 3 #opcode 0000011
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo store
			li s2, 35 #opcode 0100011
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo branch
			li s2, 99 #opcode 1100011
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo Jump And Link
			li s2, 111 #opcode 1100111
			beq s2,s3,ok
			# controlliamo se l'operazione è di tipo Jump And Link Reg
			li s2, 103 #opcode 1100111
			beq s2,s3,ok
			# controlliamo se l'operazione è Add Upper Imm to PC
			li s2, 23 #opcode 0010111
			beq s2,s3,ok
			# controlliamo sel'operazione è Load Upper Imm
			li s2, 55 #opcode 0110111
			beq s2,s3,ok
			# controlliamo se l'operazione è una chiamata a sistema
			li s2, 115 #opcode 1110011
			beq s2,s3,ok
			
			fail:
				la a0, scritta
		 		li a7, 4
		 	 	ecall
		 	 	li a7, 10
		 		ecall
			
			ok:
			jr ra
