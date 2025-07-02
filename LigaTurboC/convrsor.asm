;tasm /zi /l /mx /o name
.model small
.stack 100h

.DATA

	PUBLIC _resultado ; Variable publica para almacenar el resultado

    _Y      dd 0         
    _M      dd 0        
    _D      dd 0   
    _A 		dd 0.0
	_B 		dd 0.0       
    _const1  dd 365.250
	_const2  dd 4716.0
	_const3  dd 30.6
	_const4  dd 1524    
	_resultado dd ?
	_uno     dd 1.0
	_cien    dd 100.0
	_cuatro  dd 4.0
	_dos     dd 2.0
	_siete   dd 7.0
	_tres	dd 3.0	
	_doce 	dd 12.0
	_unMedio dd 0.50 
	_temp1   dd ?
	_temp2	dd ?
	_menos1     dd -1.0
	_anioEsp dd 1583.0
	_mesEsp  dd 11.0
	_diaEsp  dd 16.0
    _DJ dd ?
_DATA ENDS

_BSS SEGMENT WORD PUBLIC 'BSS'

    EXTRN _variable:DWORD   ; Variable externa
    _info DW ?              ; Variable sin valor inicial

_BSS ENDS

.code
    ASSUME CS:_TEXT,DS:DGROUP,SS:DGROUP
    PUBLIC _conversorAJuliano 

_conversorAJuliano PROC NEAR        

        PUSH BP
        MOV BP,SP
        MOV BX,[BP+4]           ; Recuperar el valor de anio
        MOV CX,[BP+6]           ; Recuperar el valor de mes
        MOV AX,[BP+8]           ; Recuperar el valor de dia
    
        ; Configurar el coprocesador FPU
        mov word ptr _Y, bx          
        mov word ptr _M, cx           
        mov word ptr _D, ax           

        finit

		;calculo a usar  
		;M <= entonces M = M + 12 y Y = Y-1
		;M > 2 entonces M e Y no varian 
		;Si anio es anterior al 15/10/1582 entonces A y B = 0
		;A = int(Y/100)
		;B = 2 - A + int(A/4)
		;DJ = int(365.25(Y+4716)) + int(30.6001(M+1)) + D + B - 1524 
		;M = mes, Y = anio, A = calculo extra, B = calculo extra, DJ = dia juliano, D = dia

	_calcularA:						;calculo especial 1
		fild 	dword ptr _Y 		;se carga el anio
		fld 	_cien   				;se carga un 100 
		fdiv						;se divide el anio entre 100
		fistp	dword ptr _A			;se actualiza el resultado en el anio

	_calcularB:						;calculo especial 2
		fild 	dword ptr _A 		;se carga el anio
		fld 	_cuatro				;se carga un 4
		fdiv 						;se divide el anio entre 4
		fistp  	dword ptr _temp1		;se obtiene el valor entero de la division y se guarda en temp1
		fld 	_dos					;se carga un 2
		fild 	dword ptr _A 		;se carga en el fpu el valor entero de A
		fsub    					;se resta A con temp1
		fild 	dword ptr _temp1		;se carga el valor entero de temp1
		fadd 						;se suma el temp 1 con el resultado de la pila
		fistp 	dword ptr _B			;se guarda el resultado entero en B

	_calcularDiaJuliano:
		;se calcula el dia juliano
		;primer calculo
		fild 	dword ptr _Y			;se carga el anio
		fld 	_const2 				;se carga un 4716
		fadd 						;se suma el anio con 4716
		fld 	_const1 				;se carga un 325.25
		fmul 						;(Y+4716) * 325.25
		fld		_unMedio 			;se carga 0.5
		fsub						;(325.25*(Y+4716)) - 0.5
		fistp 	dword ptr _temp1		;se guarda la parte entera del resultado en temp1

		;segundo calculo				
		fild 	dword ptr _M			;carga el mes 
		fld 	_uno 				;carga un 1
		fadd  						;1+mes 
		fld		_const3				;carga un 30.6
		fmul 						;(1+mes)*30.6
		fld		_unMedio 			;carga un 0.5
		fsub						;((1+mes)*30.6)-0.5
		fistp	dword ptr _temp2		;se guarda la parte entera del resultado en temp2

		;calculo final		
		fild	dword ptr _temp2 	;carga el temp2 -> int(30.6*(mes+1))
		fild	dword ptr _temp1 	;carga el temp1 -> int(325.25*(Y+4716))
		fadd 						;int(325.25*(Y+4716)) + int(30.6*(mes+1))
		fild 	dword ptr _D 		;carga el dia
		fadd 						;int(325.25*(Y+4716)) + int(30.6*(mes+1)) + D
		fild	dword ptr _B			;carga el B
		fadd   						;int(325.25*(Y+4716)) + int(30.6*(mes+1)) + D + B 
		fild 	dword ptr _const4	;carga un 1524
		fsub						;int(325.25*(Y+4716)) + int(30.6*(mes+1)) + D + B - 1524.5
        fld     _uno 
        fadd    
        fistp	dword ptr _resultado		;se guarda la parte entera del resultado final 

        MOV SP,BP
        POP BP
    RET

_conversorAJuliano ENDP

_TEXT ENDS
END