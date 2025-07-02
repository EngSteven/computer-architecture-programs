include macros.asm
Datos Segment
    colores  db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    mes         dw 12
    anio        dw 2023
    LineCommand db    0FFh Dup (?)
    nDiasSemanales EQU 7
    nDiasPorMes db 31,28,31,30,31,30,31,31,30,31,30,31
    sumDiasPorMes dw 31,59,90,120,151,181,212,243,273,304,334,365
    dias        db "dom   lun   mar   mie   jue   vie   sab$",10,13
    enero       db "enero$"
    separador   db "/$"  
    primerDia   db 3
    fila        db ?
    columna     db ?
    nDias        dw ?
    nDia       dw ?

    msjDiasRestan   db 10,13,"Dias restantes: $"
    msjNSemana      db 10,13,"Numero de semana: $"
    msjAvanzar  db 'Presione cualquier tecla para avanzar a la siguiente página...$' 
    num1        dw ?
    num2        dw ?

Datos EndS

Codigo Segment
    Assume cs:Codigo, ds:Datos

Begin:
    mov ax,Datos    ;Inicializa el segmento de dato
    mov ds,ax       ;para poder utilizar las variables

    LimpiarPantalla
    ImprimirAnio primerDia, mes, anio, nDiasPorMes, nDia, fila, columna,num1,num2,signo ;se hace el print de todo el anio ingresado



    mov ax,4c00h
    int 21h

    

Codigo Ends
    End Begin