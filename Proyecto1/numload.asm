;COMPILAR PROGRAMA EN TASM VIEJO
;tasm /zi /l /r programName
;tlink /v /3 programName
;td programName
.model small
.stack 100h 
.386
.data 
var1 		dd 		5.43 
var  		dd 		5.42999999999999999999999999999
var2 		dd 		1.89 
var3 		dd 		2.77
var4 		dd 		1.0
X           dd      1.2
Y           dd      3.0
N           dd      0
resultado 	dd 		0.5 

.code 
 start:
		mov 	ax,@data 
		mov 	ds,ax 
		
		finit    					;inicializa el segmento  
		fld     resultado			
		fld     var
		fld     var1
		
									; if( X < Y )
		finit						; N = 1
		fld 	Y				    ; ST(0) = X
		fcomp 	X				    ; compare ST(0) to Y
		fnstsw  ax				    ; move status word into AX
		sahf 					    ; copy AH into EFLAGS
		jnb     L1 				    ; X = Y? skip
		fld 	var4			    
		fstp 	N  			        ; N = 1
		jmp   short salto1
    
 L1:

		fld 	var1
		fld 	st(0)
		fmul
		
		fld 	var3
		fld 	st(0)
		fmul
		
		fadd
		fsqrt
		fstp 	resultado		  ;libera el fpu y lo pone en resultado
		ffree          			  ;finaliza coprocesador 
		jmp   short salir

 salto1:
		fld     N
		ffree
 
 salir:		
		mov 	eax,4c00h
		int 	21h
end start