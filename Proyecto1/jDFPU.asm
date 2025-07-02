.model small
.stack 100h 
.386
.data 
	M 		dd 10.0
	Y		dd 2013.0
	D		dd 2.0
	const1  dd 365.250
	const2  dd 4716.0
	const3  dd 30.6
	const4  dd 1524.50
	A 		dd 0.0
	B 		dd 0.0      
	DJ 		dd ?
	uno     dd 1.0
	cien    dd 100.0
	cuatro  dd 4.0
	dos     dd 2.0
	siete   dd 7.0
	doce 	dd 12.0
	temp1   dd ?
	temp2	dd ?
	menos1     dd -1.0
	signo 	db 0
	mes     dw 10
	anio    dw 2013
	dia 	dw 2

.code 
 start:
		mov 	ax,@data 
		mov 	ds,ax 

		xor ax,ax                               ;se limpia el ax                  
		xor bx,bx                               ;se limpia el bx
		xor cx,cx                               ;se limpia el cx
		xor dx,dx                               ;se limpia el dx
		xor di,di                               ;se limpia el di    (almacena el mes)
		xor si,si                               ;se limpia el si    (almacena el anio

		;calculo a usar  
		;M <= entonces M = M + 12 y Y = Y-1
		;M > 2 entonces M e Y no varian 
		;Si anio es anterior al 15/10/1582 entonces A y B = 0
		;A = int(Y/100)
		;B = 2 - A + int(A/4)
		;DJ = int(365.25(Y+4716)) + int(30.6001(M+1)) + D + B - 1524 
		;M = mes, Y = anio, A = calculo extra, B = calculo extra, DJ = dia juliano, D = dia

		cmp signo,1                             ;se verifica si el signo del anio es 1 (negativo->ac)
		je anioAC                               ;de serlo salta a anioAC
		jne anioDC                              ;sion salta a anioDC
	
	anioAC:
		;poner le anio en negativo
		fld 	Y 
		fld 	menos1 
		fmul 
		fstp 	Y
		
		cmp mes,2                                ;compara el di (mes) con 3 -> (ya que con enero o febrero el mes debe aumentarse en 12)
		ja puenteCalcularDiaJuliano              

		;caso especial en que el mes sea 1 o 2
		;se decrementa el anio
		fld 	Y
		fld 	uno 
		fsub
		fstp 	Y 
		;se le suma 12 al mes 
		fld 	M 
		fld 	doce
		fadd 	
		jmp calcularDiaJuliano

	puenteCalcularDiaJuliano: 
		jmp calcularDiaJuliano

	anioDC:
		cmp mes,2                                ;compara el di (mes) con 3 -> (ya que con enero o febrero el mes debe aumentarse en 12)
		ja comprobarCalculo              

		;caso especial en que el mes sea 1 o 2
		;se decrementa el anio
		fld 	Y
		fld 	uno 
		fsub
		fstp 	Y 
		;se le suma 12 al mes 
		fld 	M 
		fld 	doce
		fadd

		;comprobar si hay que calcular A y B, ya que antes del 15/10/1582 no hace falta
	comprobarCalculo:
		cmp anio, 1582
		ja calcularA 
		cmp mes, 10
		ja calcularA 
		cmp dia, 15
		ja calcularA 
		jmp calcularDiaJuliano

	calcularA:
		;se calcula A
		fld 	Y 
		fld 	cien   
		fdiv
		fistp	dword ptr A

	calcularB:	
		;se calcula B
		fild 	dword ptr A 
		fld 	cuatro
		fdiv 	
		fistp  	dword ptr temp1			;se obtiene el valor entero del fpu
		fld 	dos
		fild 	dword ptr A 			;se carga en el fpu el valor entero de A
		fsub    	
		fild 	dword ptr temp1			;se carga el valor entero de temp1 en el fpu
		fadd 							;se suma los
		fistp 	dword ptr B				;se guarda el resultado entero en B

	calcularDiaJuliano:
		;se calcula el dia juliano
		;primer calculo
		fld 	Y 						;-> anio 
		fld 	const2 					;-> 4716
		fadd 
		fld 	const1 					;-> 365.25
		fmul 	
		fistp 	dword ptr temp1	

		;segundo calculo
		fld 	M
		fld 	uno 
		fadd  
		fld		const3
		fmul 
		fld 	uno 				;como redondea para arriba, decrementamos para evitar eso
		fsub 
		fistp	dword ptr temp2

		;calculo final
		fild	dword ptr temp2 
		fild	dword ptr temp1 
		fadd 						;temp1 + temp2 
		fld 	D 					;se mete el dia
		fadd 						;temp1 + temp2 + D
		fild	dword ptr B
		fadd   						;temp1 + temp2 + D + B 
		fld 	const4
		fsub						;temp1 + temp2 + D + B - 1524.5
		fstp	DJ					;se guarda el resultado final

 salir:		
		mov 	eax,4c00h
		int 	21h
end start