.text

main: li $t0,2

lacoesp:
	beq $t0, $zero, fimlacoesp
	addiu $t0,$t0,-1
	j lacoesp
	
fimlacoesp:
	#pega o endereço de  rx_busy
	li $t1, 0x10008004
	
loop_rx_busy:

	lbu $t2, 0($t1)
	bne $t2, $zero, loop_rx_busy
	
#aqui já temos rx_busy==0

#carregar dado1	
	la $t3, dado1
	lw $t3, 0($t3)
	
#enviar dado1
	#pega o endereço de TX_data
	li $t1, 0x10008000
	sb $t3, 0($t1)
	
	#pega o endereço de  rx_busy
	li $t1, 0x10008004
	
loop_rx_busy2:
	lbu $t2, 0($t1)
	bne $t2, $zero, loop_rx_busy2

#aqui já temos rx_busy==0

#carregar dado2	
	la $t3, dado2
	lw $t3, 0($t3)

	#enviar dado2
	#pega o endereço de TX_data
	li $t1, 0x10008000
	sb $t3, 0($t1)
	
	#pega o endereço de  rx_busy
	li $t1, 0x10008004
	
loop_rx_busy3:
	lbu $t2, 0($t1)
	bne $t2, $zero, loop_rx_busy3

#aqui já temos rx_busy==0
	
	li $t1, 0x10008002
	lbu $t1, 0($t1)
	
	jr $ra	
	
.data

dado1: .byte 10
dado2: .byte 14