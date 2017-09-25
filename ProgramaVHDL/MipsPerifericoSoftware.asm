.text
.globl main
########
# Vinicius Cerutti e Yuri Bittencourt
# Trabalho T1 - Organização e arquitetura de Computadores II
# parte do software para realizar a comunicao entre o periferico e
# o processador mips

# 0x1008000 - Tx_data
# 0x1008001 - Tx_av
# 0x1008002 - Rx_Data
# 0x1008003 - Rx_start
# 0x1008004 - Rx_busy
######
main: 					
	li 	$t0, 470			# tempo de espera para carregar 0x55
lacoesp:	
	beq 	$t0, $zero, fimlacoesp
	addiu 	$t0, $t0, -1
	j 	lacoesp
fimlacoesp:	
	li	$t2, 0x10008004			# recebe endereco de rx_busy

loop_rxbusy00:
	lbu 	$t3, 0($t2)
	bne	$t3, $zero, loop_rxbusy00	
	
	# aqui ja temos rx_busy = 0
	
	la	$t3, dado1			# carrega dado1
	lw	$t3, 0($t3)
	
	li	$t2, 0x10008002			# carrega o endereco de rx_data
	sb	$t3, 0($t2)			# salva o valor de dado1 em rx_data
	
	li	$t2, 0x10008004			# carrega endereco de rx_busy

loop_rxbusy01:
	lbu 	$t3, 0($t2)
	bne	$t3, $zero, loop_rxbusy01
	
	# aqui ja temos rx_busy = 0
	
	la	$t3, dado2			# carrega dado1
	lw	$t3, 0($t3)			
	
	li	$t2, 0x10008002			# carrega o endereco de rx_data
	sb	$t3, 0($t2)			# salva o valor de dado1 em rx_data
	
	#recebimento do periferico

	li	$t2, 0x10008001			# carrega o endereco de tx_av
	li 	$t0, 1
	
loop_tvav01:
	lbu 	$t3, 0($t2)
	bne	$t3, $t0, loop_tvav01
	
	# aqui ja temos tx_av = 1
	
	li	$t4,0x10008000			#  carrega o endereco de tx_data
	lbu	$t4, 0($t4)			#  realiza a leitura de tx_data		   
	la	$t5,result			
	sb	$t4,0($t5)			# guarda o valor de tx_data em result
									
fim:	
	j 	fim
.data
dado1: .byte 10
dado2: .byte 30
result: .byte 0
