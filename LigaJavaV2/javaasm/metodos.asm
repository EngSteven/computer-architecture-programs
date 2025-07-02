.386
.model flat,stdcall
.data 
	const1  dd 365.250
	const2  dd 4716.0
	const3  dd 30.6
	const4  dd 1525
	
	const5  dd 24.0
	const6  dd 1440.0
	const7  dd 86400.0
	
	A 		dd 0.0
	B 		dd 0.0      
	DJ 		dd ?
	uno     dd 1.0
	cien    dd 100.0
	cuatro  dd 4.0
	dos     dd 2.0
	siete   dd 7.0
	tres	dd 3.0	
	doce 	dd 12.0
	unMedio dd 0.50 
	temp1   dd ?
	temp2	dd ?
	menos1     dd -1.0
	anioEsp dd 1583.0
	mesEsp  dd 11.0
	diaEsp  dd 16.0
	cienMil dd 100000.0

	decimales dd ?
	
.code

Java_ConversorAJuliano_calcularJuliano proc JNIEnv:DWORD, jobject:DWORD, Y:DWORD, M:DWORD, D:DWORD, S:DWORD, hora:DWORD 
        
		;calculo a usar  
		;Si M <= 2 entonces M = M + 12 y Y = Y-1
		;Si M > 2 entonces M e Y no varian 
		;Si anio es anterior al 15/10/1582 entonces A y B = 0
		;A = int(Y/100)
		;B = 2 - A + int(A/4)
		;DJ = int(365.25(Y+4716)) + int(30.6001(M+1)) + D + B - 1524 
		;M = mes, Y = anio, A = calculo extra, B = calculo extra, DJ = dia juliano, D = dia, S = signo
		
		finit 
		
		;se verifica si el signo del anio es 1 (negativo->ac)
		fld     uno					;se carga 1 en la pila
        ficomp   S                  ;compara el signo del anio ingresado con 1
        fnstsw  ax                  
        sahf                        
        jz     	anioAC             	;salta a anio ac si el signo del anio es 1 (negativo)
		jmp 	anioDC              ;de lo contrario, salta a anio dc

	anioAC:							;caso en el que el anio ingresado es negativo
		;poner el anio en negativo
		fild 	dword ptr Y 		;carga el anio
		fld 	menos1 				;carga un -1
		fmul 						;se multimplican para poner el anio en negativo
		fistp 	dword ptr Y 		;sacar el resultado y actualizar el valor del anio
		
		;compara el mes con 3 -> (ya que con enero o febrero el mes debe aumentarse en 12)
		fild    M                   ;se carga el mes
        fcomp   tres                ;se compara con el tres
        fnstsw  ax                  
        sahf                        
		jnb  puenteCalcularDiaJuliano  ;en caso de ser diferente de enero o febrero, salta a calcular dia juliano            

		;caso especial en que el mes sea 1 o 2
		;se le suma 12 al mes 
		fild 	dword ptr M 		;carga el mes
		fld 	doce				;carga un 12
		fadd 						;se suman
		fistp	dword ptr M 		;y se actualiza el valor del mes
		jmp calcularDiaJuliano		;salta a calcular dia juliano

	puenteCalcularDiaJuliano:		;puente que salta a calcular dia juliano
		;se decrementa el anio 
		fild 	dword ptr Y			;carga el anio 
		fld 	uno 				;carga un 1
		fsub						;se restan 
		fistp 	dword ptr Y			;se actualiza el valor del anio
		jmp calcularDiaJuliano		;salta a calcular el dia juliano

	anioDC:							;caso en el que el anio ingresado sea positivo
		;compara el mes con 3 -> (ya que con enero o febrero el mes debe aumentarse en 12)
		fild    M                   ;carga el mes
        fcomp   tres                ;carga un 3
        fnstsw  ax                
        sahf                        
		jnb  comprobarCalculo    	;en caso de ser diferente de enero o febrero, se empieza a calcular el dia juliano             

		;caso especial en que el mes sea 1 o 2
		;se decrementa el anio
		fild 	dword ptr Y			;se carga el anio
		fld 	uno 				;se carga un 1 
		fsub						;se restan
		fistp 	dword ptr Y 		;se actualiza el anio 
		;se le suma 12 al mes 		
		fild 	dword ptr M 		;se carga el mes
		fld 	doce				;se carga el 12
		fadd						;se le suma al mes 12
		fistp 	dword ptr M			;se actualiza el mes

		;comprobar si hay que calcular A y B, ya que antes del 15/10/1582 no hace falta
	comprobarCalculo:
		fild     Y                  ;carga el anio
        fcomp   anioEsp             ;compara el anio con 1583
        fnstsw  ax                 
        sahf                        
		jnb  calcularA				;salta a calcular A en caso de ser mayor o igual a 1583

		fild     M                  ;carga el mes
		fcomp   mesEsp              ;compara el mes con 11
        fnstsw  ax                  
        sahf                       
		jnb  calcularA				;salta a calcular A en caso de ser mayor o igual a 11
		
		fild    D                   ;carga el dia
        fcomp   diaEsp              ;compara el dia con 16
        fnstsw  ax                  
        sahf                        
		jnb  calcularA				;salta a calcular A en caso de ser mayor o igual 16
		jmp calcularDiaJuliano		;en caso de que no se cumpla ningun caso anterior se salta a calcular el dia juliano

	calcularA:						;calculo especial 1
		fild 	dword ptr Y 		;se carga el anio
		fld 	cien   				;se carga un 100 
		fdiv						;se divide el anio entre 100
		fistp	dword ptr A			;se actualiza el resultado en el anio

	calcularB:						;calculo especial 2
		fild 	dword ptr A 		;se carga el anio
		fld 	cuatro				;se carga un 4
		fdiv 						;se divide el anio entre 4
		fistp  	dword ptr temp1		;se obtiene el valor entero de la division y se guarda en temp1
		fld 	dos					;se carga un 2
		fild 	dword ptr A 		;se carga en el fpu el valor entero de A
		fsub    					;se resta A con temp1
		fild 	dword ptr temp1		;se carga el valor entero de temp1
		fadd 						;se suma el temp 1 con el resultado de la pila
		fistp 	dword ptr B			;se guarda el resultado entero en B

	calcularDiaJuliano:
		;se calcula el dia juliano
		;primer calculo
		fild 	dword ptr Y			;se carga el anio
		fld 	const2 				;se carga un 4716
		fadd 						;se suma el anio con 4716
		fld 	const1 				;se carga un 325.25
		fmul 						;(Y+4716) * 325.25
		fld		unMedio 			;se carga 0.5
		fsub						;(325.25*(Y+4716)) - 0.5
		fistp 	dword ptr temp1		;se guarda la parte entera del resultado en temp1

		;segundo calculo				
		fild 	dword ptr M			;carga el mes 
		fld 	uno 				;carga un 1
		fadd  						;1+mes 
		fld		const3				;carga un 30.6
		fmul 						;(1+mes)*30.6
		fld		unMedio 			;carga un 0.5
		fsub						;((1+mes)*30.6)-0.5
		fistp	dword ptr temp2		;se guarda la parte entera del resultado en temp2

		;calculo final		
		fild	dword ptr temp2 	;carga el temp2 -> int(30.6*(mes+1))
		fild	dword ptr temp1 	;carga el temp1 -> int(325.25*(Y+4716))
		fadd 						;int(325.25*(Y+4716)) + int(30.6*(mes+1))
		fild 	dword ptr D 		;carga el dia
		fadd 						;int(325.25*(Y+4716)) + int(30.6*(mes+1)) + D
		fild	dword ptr B			;carga el B
		fadd   						;int(325.25*(Y+4716)) + int(30.6*(mes+1)) + D + B 
		fild 	dword ptr const4	;carga un 1524
		fsub						;int(325.25*(Y+4716)) + int(30.6*(mes+1)) + D + B - 1524.5

		;se verifica si la hora ingresada es igual o mayor a 12
		fild     hora				
        fcomp   doce                 
        fnstsw  ax                  
        sahf                        
        jnb     sumar1             	
		jmp 	sacarDJ              

	sumar1:
		fld uno 
		fadd 

	sacarDJ:
		fistp	dword ptr DJ		;se guarda la parte entera del resultado final en DJ
		mov     eax, DJ					

    ret 
Java_ConversorAJuliano_calcularJuliano endp

Java_ConversorAJuliano_calcularDecimalesJulianos proc JNIEnv:DWORD, jobject:DWORD, Y:DWORD, M:DWORD, D:DWORD, S:DWORD, hora:DWORD, minutos:DWORD, segundos:DWORD
		fild hora
		fld const5
		fild minutos 
		fld const6
		fild segundos 
		fld const7 
		fdiv 
		fstp temp1
		fdiv 
		fstp temp2
		fdiv 
		fld temp1 
		fld temp2 
		fld unMedio
		fadd 
		fadd
		fadd

		;se verifica si la hora ingresada es igual o mayor a 12
		fild     hora				
        fcomp   doce                 
        fnstsw  ax                  
        sahf                        
        jnb     restar1             	;
		jmp 	sacarDecimales              

	restar1:
		fld uno
		fsub  

	sacarDecimales:
		fld cienMil
		fmul 
		fistp dword ptr decimales

		mov eax, decimales
	ret 
Java_ConversorAJuliano_calcularDecimalesJulianos endp 

Java_DesplegarCalendario_calcularPrimerDiaMes proc JNIEnv:DWORD, jobject:DWORD, DiaJuliano:DWORD
		fild 	dword ptr DiaJuliano 	;carga el dia juliano
		fld 	dos  					;carga un 1
		fadd							;diaJuliano + 1
		fistp 	dword ptr DiaJuliano	;actualiza el resultado en el diajuliano

		fild 	dword ptr DiaJuliano	;carga dos veces el diaJuliano
		fild 	dword ptr DiaJuliano 
		fld  	siete 					;carga un 7
		fdiv 							;diaJuliano / 7
		fld		unMedio 				;carga un 0.5
		fsub    						;diaJuliano / 7 - 0.5
		fistp 	dword ptr DiaJuliano	;actualiza el resultado en el diaJuliano
		fld 	siete 					;carga un 7
		fild 	dword ptr DiaJuliano 	;carga el dia juliano
		fmul 	 						;(diaJuliano / 7 - 0.5) * 7
		fsub 							;((diaJuliano / 7 - 0.5) * 7) - diaJulianoOriginal
		fistp 	dword ptr DiaJuliano 	;guarda la parte entera del resultado en el diaJuliano
		mov 	eax, DiaJuliano			
	ret 
Java_DesplegarCalendario_calcularPrimerDiaMes endp 

END