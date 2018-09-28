# DEFINICIOENES:
# D# -> Disco número tal
# n -> Número de discos
# T# -> Número de la torre. T1 -> inicio, T3 -> objetivo
# t0 -> Copia operacional de n
# t9 -> Banderas 

.data

.text

	lui $s0, 0x1001 # T1
	ori $s0, 0x00
	lui $s1, 0x1001 # T2
	ori $s1, 0x40
	lui $s2, 0x1001 # T3
	ori $s2, 0x80
	ori $s3, $zero, 3 # n 
	# Movimientos= 2POW(n) - 1
	ori $s4, $zero, 1
	sllv $s4, $s4, $s3 
	addi $s4, $s4, -1 # Número de movimientos
	addi $s5, $zero, 1
Main: # Main
	add $t0, $zero, $s3 # Copiar valor de n
	jal Init # Llama rutina de inicialización
	
	add $s0, $v0, $zero	# Apuntador T1		
	add $a0, $s3, $zero	# Argumento n
	add $a1, $zero, $s0	# Argumento T1 (origen)	# a1 = origen 	---	
	add $a2, $zero, $s1	# Argumento T2 (aux)		# a2 = aux 	---	
	add $a3, $zero, $s2	# Argumento T3 (destino)	# a3 = destino	---	
	jal Hanoi # Hanoi(n, T1, T2, T3)
	j End
	
Init: # Inicialización
	beq $t0, $zero, Init_out # n == 0 ? continue : Return to Main
	sw $t0, 0($s0) # Almacena el valor actual de n
	addi $t0, $t0, -1 # Reduce el valor de n
	addi $s0, $s0, 4 # Aumenta dirección de memoria
	j Init
	
Init_out: # Salida de inicialización
	addi $s0, $s0, -4 # Ajusta dirección de memoria  de T1
	add $v0, $s0, $zero # Guardar direcciones de retorno
	jr $ra
	
Hanoi: # Rutina para Hanoi
	bne $a0, $s5, Hanoi_rep # Si n = 1 continúa y guarda la ejecución
	
	
	addi $s3, $s3, -4
	lw $t1, 0($a1)	#inicia movimiento de discos		
	sw $zero, 0($a1)	#	       
	sw $t1, 0($a3)	#		
	add $a3, $a3, 4	#		
	# Guarda el par de apuntadores
	# sw primer apuntador (origen)
	# sw segundo apuntador (destino)
	
	#beq $t8, 1, ra_1
	#beq $t8, 2, ra_2
	# Si s4 < 1 regresar ???
	# lw primer apuntador (origen)
	# sw al segundo apuntador (dest)
	jr $ra
		
Hanoi_rep: # Recursión

	# n-1, origen, destino, aux
	addi $sp, $sp, -8    #reservamos espacio en el stack
	sw $a0, 0($sp) 	#
	sw $ra, 4($sp)	#
	add $a0, $a0, -1     
	add $t1, $zero, $a2  #almacenamos datos 
	#add $a1, $zero, $a1	# origen
	add $a2, $zero, $a3	# destino
	add $a3, $zero, $t1	# aux
	j Hanoi
ra_1:	
	addi $t8, $t8, 1
	# 1, origen, aux, destino
	add $a0, $s3, $zero	# Argumento n
	addi $a0, $zero, 1 	# n-1
	add $a1, $zero, $s0	# origen
	add $a2, $zero, $s2	# destino
	add $a3, $zero, $s3	# aux
	j Hanoi
ra_2:
	# n-1 aux, origen, destino
	add $a0, $s3, $zero	# Argumento n
	addi $a0, $a0, -1 	# n-1
	add $a1, $zero, $s0	# origen
	add $a2, $zero, $s3	# destino
	add $a3, $zero, $s2	# aux
	j Hanoi
End: