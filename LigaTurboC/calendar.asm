;tasm /zi /l /mx /o name
.model small
.stack 100h

.DATA

	_mes         dw ?
    _anio        dw ?
    
    _nDiasSemanales EQU 7
    _nDiasPorMes db 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    _dias        db "s   domingo   lunes   martes   miercoles   jueves   viernes   sabado$",10,13
    _dias2       db "    Do Lu Ma Mi Ju Vi Sa   $"
    _separador   db "/$" 
    _signoNegativo  db "-$" 
    _primerDia   db ?
    _fila        db ?
    _columna     db ?
    _nDia        dw ?
    _msjFecha    db 10,13,"Fecha: $"
    _msjDiasRestan   db 10,13,"Dias restantes: $"
    _msjAvanzar  db 'Presione cualquier tecla para visualizar el siguiente mes...$' 
    _msjNDias    db 10,13,"N dia de los 365: $"
    _msjNSemana      db 10,13,"Numero de semana: $"
    _num1        dw ?
    _num2        dw ?
    _num3        dw ?
    _julianDayBinario db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
    _signo       db 0 
    _nCaracteresPorDia db 7,5,6,9,6,7,6
    _nameMeses   db "Ene$", "Feb$", "Mar$"
    _nameMes     db  ?
    _ene         db "Ene$"
    _feb         db "Feb$"
    _mar         db "Mar$"
    _abr         db "Abr$"
    _may         db "May$"
    _jun         db "Jun$"
    _jul         db "Jul$"
    _ago         db "Ago$"
    _sep         db "Sep$"
    _oct         db "Oct$"
    _nov         db "Nov$"
    _dic         db "Dic$"
    _columnaActual db 5
    _filaActual  db 1
    _flag        db 0
    _cont        dw ?
    _msjConvJD   db "La conversion a juliano es: $"

_DATA ENDS

_BSS SEGMENT WORD PUBLIC 'BSS'

    EXTRN _variable:DWORD   ; Variable externa
    _info DW ?              ; Variable sin valor inicial

_BSS ENDS

.code
    ASSUME CS:_TEXT,DS:DGROUP,SS:DGROUP
	PUBLIC _imprimirMes 
    PUBLIC _imprimirAnio

;guarda el numero correspondiente en el ax, hasta que se lea un / que indica el final
ObtenerDatoEntrada macro _entrada, _pos 
    local while1, break1,noBreak1   ;locales del macro
    xor bx,bx                       ;se limpia el bx
    xor ax,ax                       ;se limpia el ax
    xor cx,cx                       ;se limpia el cx

    mov si,_pos                      ;se le mueve pos al si
    mov cl,_entrada[si]              ;se le mueve al cl el primer digito, del mes o del anio, segun lo que haya ingresado a la macro  
    sub cl,30h                      ;se ajusta el cl para obtener su valor numerico decimal
    mov al,cl                       ;se le mueve al al el cl que contiene el digito
    mov bx,10                       ;se le mueve un 10 al bl, para hace las mul
    
    while1:   
        inc si                      ;se incrementa la pos actual
        cmp _entrada[si],'/'         ;se compara si el elemento en la pos actual es /
        jne _noBreak1                ;en caso de no serlo entonces se sigue leyendo la entrada
        jmp _break1                  ;en caso de que si lo sea entonces quiere decir que ya se leyo todo el mes o el anio y se sale
        
    noBreak1:                       ;continua el ciclo    
        mul bx                      ;multiplica el ax por 10, para agregar un 0 al final del numero
        
        mov cl,_entrada[si]          ;se le mueve al cl el digito actual de la entrada
        sub cl,30h                  ;se ajusta el cl para obtener su valor numerico decimal
        mov _num1,ax                 ;se le mueve a num1 numero formado hasta momento
        mov _num2,cx                 ;se le mueve a num2 el digito actual

        push si                     ;se guarda en la pila el si, para conservar la pos actual
        push bx                     ;se guarda en la pila el bx, para guardar el 10
        sumarDosNumeros _num1,_num2   ;se se le agrega el digito actual al numero que se lleve hasta momento
        pop bx                      ;se le regresa el valor al bx guardado en la pila
        pop si                      ;se le regresa el valor al si guardado en la pila

        mov ax,di                   ;le pasa ese numero formado al ax

        jmp while1                  ;repite el ciclo
    break1:                         ;sale del ciclo
EndM

;lee una tecla ingresada
LeerTecla Macro CaracterLeido
    mov ah,01h                      ;funcion para leer una tecla de la interrupcion 21h
    int 21h                         ;interrupcion 21h
    mov CaracterLeido, al           ;mueve a caracterLeido, la tecla ingresada
EndM 

ImprimirMensaje Macro _mensaje
    PushA1                   ;se guardan los registros en la pila                     
    mov ah,09h              ;impresion de cadena de caracteres                  
    mov dx,offset _mensaje   ;se mueve al dx el desplazamiento de mensaje
    int 21h                 ;interrupcion 21h                    
    PopA1                    ;se sacan los registros de la pila
EndM

;imprime un caracter en pantalla
ImprimirCaracter Macro _Caracter
    PushA1                   ;se guardan los registrose en la pila
    mov ah,02h              ;funcion para imprimir 1 caracter de la interrupcion 21h
    mov dl,_Caracter         ;se le mueve al dl el caracter a imprimir
    int 21h                 ;interrupcion 21h
    PopA1                    ;se sacan los registros de la pila
EndM 

;imprime cada digito de un numero dw
PrintHex Macro _numero,_fila,_columna 
    local whilePH, salgaPH    
    pushA1                       ;guardan todos los registros
    xor ax,ax                   ;se limpia el ax, que se usa para ir haciendo cada operacion de division
    xor bx,bx                   ;se limpia el bx, que se usa para almacenar el 10 con el que se hace cada division
    xor dx,dx                   ;se limpia el dx, que se usa para ir imprimiendo cada digito del numero
    mov ax,_numero               ;se mueve al ax el numero ingresado
    mov bx,10                   ;se le mueve al bx un 10, que se usa para obtener cada digito mediante divisiones 
    
    whilePH:
        
        gotoxy _fila,_columna     ;coloca el cursor en la fila y columna correspondiente
        
        xor dx,dx               ;limpia el dx
        div bx                  ;divide el numero entre bx (10), para obtener cada digito, imprimirlo y quitarlo del numero
        add dl,30h              ;se le agrega al dl (digito) un 30h, para ajustarlo a su valor numerico decimal
        ImprimirCaracter dl     ;se imprime el digito obtenido    
        dec _columna             ;se decrementa la columna, para imprimir el siguiente digito un espacio a la izquierda
        
        cmp ax,0                ;compara si el ax ya es 0
        je salgaPH              ;de serlo entonces se sale del ciclo
                                ;sino entonces sigue con las operaciones
        jmp whilePH             ;repite el ciclo        
    
    salgaPH:                    ;sale del ciclo

    popA1                        ;saca los registros guardados en la pila
EndM

CalcularNumeroSemana macro _mes, _anio, _nDiasPorMes, _nSemana, _fila, _columna,_num1,_num2
    local whileNS, breakNS, salirNS, sigaNS

    xor ax,ax                       ;se limpia el ax, que se va a usar para almacenar el numero de la semana
    xor bx,bx                       ;se limpia el bx, que se va a usar para obtener cada nDiasPorMes
    xor cx,cx                       ;se limpia el cx, que se va a usar como contador del ciclo
    xor dx,dx                       ;se limpia el dx, que se va a usar para guardar temporalmente cada n dias por mes
    xor si,si                       ;se limpia el si, que se va a usar como el index de cada nDiasPorMes

    mov si,1                        ;mueve un 1 al si para empezar en la pos 1
    mov ax,31                       ;mueve al ax un 31, que corresponde a los n dias del mes de enero
    mov cx,2                        ;mueve un 1 al cx 

    mov bx, offset _nDiasPorMes      ;mueve el bx el desplazamiento de nDiasPorMes
    
    cmp _mes,1
    ja whileNS 
    mov ax,0
    jmp salirNS

    whileNS:
        cmp cx,_mes                  ;compara el mes ingresado con el cx
        jb sigaNS                  ;en caso de no ser iguales, entonces sigue el ciclo
        jmp breakNS                 ;si es igual entonces se sale del ciclo

    sigaNS:                         ;etiqueta para continuar el ciclo

        mov dl,[bx+si]              ;mueve al dl los n dias por mes, correspondiente a la posicion en la que este el si
        mov _num2,dx                 ;le pasa ese n dias por mes del dx, al num2
        mov _num1,ax                 ;le pasa la sumatoria de los dias por mes que lleve el ax, al num2
        push ax                     ;guarda el valor del ax en la pila
        push bx                     ;guarda el valor del bx en la pila
        push cx                     ;guarda el valor del cx en la pila
        push dx                     ;guarda el valor del dx en la pila
        push si                     ;guarda el valor del si en la pila

        sumarDosNumeros _num1, _num2  ;hace la suma del num1 (sumatoria de n dias de los meses) con el num2 (n dias del mes actual) y se guarda en el di

        pop si                      ;se obtiene el valor guardado del si
        pop dx                      ;se obtiene el valor guardado del dx
        pop cx                      ;se obtiene el valor guardado del cx
        pop bx                      ;se obtiene el valor guardado del bx
        pop ax                      ;se obtiene el valor guardado del ax

        mov ax,di                   ;se mueve el resulto de la suma y se guarda en el ax

        inc cl                      ;incrementa el cl (condicion de salida)
        inc si                      ;incrementa el si (posicion de n dias del mes actual)   

        jmp whileNS                 ;repite el ciclo

    breakNS:                        ;se sale del ciclo
    
        mov cl,7                        ;mueve al cl un 7 (cantidad de dias por semana)

        div cl                          ;divide el ax entre 7, para obtener el numero de semana 
        mov ah,0                        ;mueve al ah un 0, para que no tome en cuenta el resto
    
    salirNS:                     ;etique para imprimir el numero de la semana
        inc al 

EndM

;imprime que numero del dia de los 365 es 
ImprimirNumeroDelDiaAnual macro _mes, _anio, _nDiasPorMes, _nDias, _fila, _columna, _num1,_num2 
    local forND, printHexND

    xor ax,ax                       ;se limpia el ax, que se va a usar para almacenar los n dias restantes
    xor bx,bx                       ;se limpia el bx, que se va a usar para obtener cada nDiasPorMes
    xor cx,cx                       ;se limpia el cx, que se va a usar como contador del for
    xor dx,dx                       ;se limpia el dx, que se va a usar para guardar temporalmente cada n dias por mes 
    xor di,di                       ;se limpia el di, que se va a usar para almacenar el resultado de las sumas
    xor si,si                       ;se limpia el si, que se va a usar como index de cada nDiasPorMes

    mov bx,offset _nDiasPorMes       ;se mueve al bx el desplazamiento de la cantidad de dias por mes
    mov cx,_mes                      ;se le mueve al cx, el numero del mes ingresado
    dec cx 
    
    forND:                          ;se recorren hasta que el contador sea igual al mes ingresado
        mov dl,[bx+si] 
        mov _num1,ax
        mov _num2,dx 

        push ax                     //se guardan los registros
        push bx 
        push cx
        push dx 
        push si  

        sumarDosNumeros _num1,_num2    //se realiza la suma de los numeros correspondientes 

        pop si 
        pop dx 
        pop cx 
        pop bx 
        pop ax 

        mov ax,di                   //se saca la suma del di y se guarda en el ax
        inc si                      //se aumenta el indice del mes actual

    loop forND 

    printHexND:                         ;etiqueta que imprime el resultado
        mov _nDias,ax 
        inc _fila 
        mov _columna,20 
        PrintHex _nDias,_fila,_columna  
    
EndM 

;imprime los dias restantes de cada final de mes
ImprimirDiasRestantes macro _mes, _anio, _nDiasPorMes, _nDias, _fila, _columna,_num1,_num2
    local forDR, printHexDR 
    xor ax,ax                       ;se limpia el ax, que se va a usar para almacenar los n dias restantes
    xor bx,bx                       ;se limpia el bx, que se va a usar para obtener cada nDiasPorMes
    xor cx,cx                       ;se limpia el cx, que se va a usar como contador del for
    xor dx,dx                       ;se limpia el dx, que se va a usar para guardar temporalmente cada n dias por mes 
    xor di,di                       ;se limpia el di, que se va a usar para almacenar el resultado de las sumas
    xor si,si                       ;se limpia el si, que se va a usar como index de cada nDiasPorMes
    mov _nDias,30h                   ;mueve a nDias un 30h

    mov bx,offset _nDiasPorMes       ;se mueve al bx el desplazamiento de la cantidad de dias por mes
    mov cx,12                       ;se le mueve al cx, la cantidad de meses por año
    sub cx,_mes                      ;se le resta al cx el mes ingresado
    inc cx 
    mov si,12                       ;se le mueve al si, la cantidad de meses por año

    cmp _mes,12                      ;se compara el mes con 12
    je printHexDR                   ;en caso de serlo, no se entra al for, ya que tan solo imprime un 0 

    forDR:                          ;for que obtiene los dias restantes de un mes ingresado
        dec si                      ;decrementa el si, para actualizar la posicion actual                    
        mov dl,[bx+si]              ;se guarda los n dias del mes actual en el dl
        mov _num1,ax                 ;se le pasa al num1 la sumatoria de los n dias restantes
        mov _num2,dx                 ;se le pasa los n dias del mes actual a num2

        push ax                     ;se guarda el ax en la pila
        push bx                     ;se guarda el bx en la pila
        push cx                     ;se guarda el cx en la pila
        push dx                     ;se guarda el dx en la pila
        push si                     ;se guarda el si en la pila

        sumarDosNumeros _num1,_num2   ;hace la suma del num1 (sumatoria de n dias de los meses) con el num2 (n dias del mes actual) y se guarda en el di

        pop si                      ;se obtiene el valor del si en la pila
        pop dx                      ;se obtiene el valor del dx en la pila
        pop cx                      ;se obtiene el valor del cx en la pila
        pop bx                      ;se obtiene el valor del bx en la pila
        pop ax                      ;se obtiene el valor del ax en la pila

        mov ax,di                   ;se le mueve al ax resultado de la suma
        
    loop forDR                      ;repite el for y decrementa en el contador

    printHexDR:                         ;etiqueta que imprime el resultado
        mov _nDias,ax                    ;le mueve a nDias la cantidad de dias restantes
        inc _fila                        ;incrementa la fila, para hacer un salto de linea
        mov _columna,20                  ;le mueve 20 a la columna para posicionar el cursor
        PrintHex _nDias,_fila,_columna     ;imprime la cantidad de dias restantes
EndM 

;posiciona el cursor en una fila y columna ingresada
gotoxy macro _fil,_col    
    push bx                         ;guarda el bx en la pila
    push ax                         ;guarda el ax en la pila 
    mov ah,02h                      ;funcion 02h para mover el cursor de la interrupcion 10h
    mov bh,0                        ;mueve al bh un 0 (# pagina)
    mov dh,_fil                      ;posiciona la fila 
    mov dl,_col                      ;posiciona la columna
    int 10h                         ;interrupcion 10h
    pop ax                          ;saca el ax de la pila 
    pop bx                          ;saca el bx de la pila 
    
EndM

;limpia la pantalla 
limpiarPantalla Macro 
    pushA1                           ;guarda los registros en la pila 
    mov ah,07h                      ;funcion 07h de la interrupcion 10 
    mov al,0
    mov bh,0fh                      ;le mueve al bh 
    mov ch,00                       ;fila esquina superior izquierda en 0
    mov cl,00                       ;columna esquina superior izquierda en 0
    mov dh,25                       ;fila esquina inferior derecha en 25
    mov dl,80                       ;columna esquina inferior derecha en 80
    int 10h                         ;interrupcion 10h
    popA1                            ;se sacan los registros de la pila
EndM

;suma dos numeros en cuyo resultado sea menor a 0ffffh y guarda el resultado en el di 
sumarDosNumeros macro _num1, _num2 
    local whileSN, breakSN, seguirSN 
    xor ax,ax                   ;limpia el ax
    xor bx,bx                   ;limpia el bx
    xor cx,cx                   ;limpia el cx
    xor dx,dx                   ;limpia el dx
    xor di,di                   ;limpia el si
    xor si,si                   ;limpia el si

    mov bx,10                   ;mov al bx un 10 (divisor a utilizar)
    mov si,1                    ;mov al si un 1  (potencias de 10 a usar)

    whileSN: 

        cmp _num1,0              ;se compara el num1 con 0
        jne seguirSN            ;de no serlo sigue la suma
        cmp _num2,0              ;compara el num2 con 0
        jne seguirSN            ;de no serlo sigue con la suma   
        cmp cx,0                ;compara el cx con 0 (indica que ya no hay nada que sumar)
        je breakSN              ;de serlo entonces se sale del ciclo
        

    seguirSN:

        xor ax,ax               ;limpia el ax
        xor dx,dx               ;limpia el dx
        mov ax,_num1             ;mueve al ax el num1

        div bx                  ;divide el ax entre bx (num1 / 10)
        mov _num1,ax             ;se guarda el conciente en el num1 (se le quita el digito menos significativo)
        push di                 ;se guarda el di en la pila
        mov di,dx               ;se guarda el residuo en el di (digito menos significativo)

        xor ax,ax               ;limpia el ax
        xor dx,dx               ;limpia el dx
        mov ax,_num2             ;mueve al ax el num2

        div bx                  ;divide el ax entre bx (num2 / 10)
        mov _num2,ax             ;se guarda el conciente en el num2 (se le quita el digito menos significativo)
        push si                 ;se guarda el su en la pila
        mov si,dx               ;se guarda el residuo en el si (digito menos significativo)

        add di,si               ;le suma al di el si (suma de los digitos menos significativos de ambos numeros)
        add di,cx               ;le suma al di el cx (los carrys de cada suma de cada digito) 

        xor ax,ax               ;limpia el ax
        xor dx,dx               ;limpia el dx
        mov ax,di               ;le mueve al ax el di (el resultado de la suma los digitos mas el carry)
        div bx                  ;divide el ax entre bx (ax = el carry y dx = el digito a colocar en el resultado)

        mov cx,ax               ;mueve al cx el ax (el carry lo guarda en el cx)
        pop si                  ;obtiene el valor guardado en la pila del si
        pop di                  ;obtiene el valor guardado en la pila del si

        xor ax,ax               ;limpia el ax
        mov ax,dx               ;le mueve al ax el dx (el digito a colocar se lo mueve al ax)
        mul si                  ;multiplica el ax con si (donde si = 10^ndigitos del resultado actual, para colocarlo a la izquierda del digito mas significativo del resultado actual)
        add ax,di               ;le agrega al ax di (le suma al digito a colocar con n ceros el resultado actual con n digitos)
        mov di,ax               ;le mueve al di el ax (guarda el nuevo resultado actual en el di)

        xor ax,ax               ;limpia el ax 
        mov ax,si               ;le mueve al ax el si (donde si = 10^ndigitos del resultado actual)
        mul bx                  ;multiplica el ax con bx (ax por 10)
        mov si,ax               ;mueve al si el ax (guarda en si la siguiente potencia de 10)

        jmp whileSN             ;repite el ciclo

    breakSN:                    ;sale del ciclo
EndM 

;SABER SI UN ANIO ES BISIESTO->resultado en di (0 no bisiesto, 1 si bisiesto)  
EsAnioBisiesto macro _anio
    local comparacion2, comparacion3,noEsBisiesto,siEsBisiesto,salirAB

    push ax                         ;se guarda el ax en la pila               
    
    xor ax,ax                       ;se limpia el ax
    xor bx,bx                       ;se limpia el bx
    xor dx,dx                       ;se limpia el dx
    xor di,di                       ;se limpia el di
    
    ;revisar si el anio es divisible entre 4 
    mov ax,_anio                     ;se mueve el anio al ax
    mov bx,4                        ;se le mueve 4 al bx
    div bx                          ;se divide el ax (anio) entre el bx (4) 
    cmp dx,0                        ;se verifica si el resto de esa division es 0
    je comparacion2                 ;de serlo entonces se hace la comparacion 2 (ver si es divisible entre 100)
    jne noEsBisiesto                ;de no serlo entonces el anio no es bisiesto

comparacion2:
    ;revisar si el anio es divisible entre 100
    xor ax,ax                       ;se limpia el ax
    xor bx,bx                       ;se limpia el bx
    xor dx,dx                       ;se limpia el dx
    mov ax,_anio                     ;se le mueve al ax el anio
    mov bx,100                      ;se le mueve al bx un 100
    div bx                          ;se divide el ax (anio) entre bx (100)

    cmp dx,0                        ;se verifica si el resto de la division dio 0
    je comparacion3                 ;de serlo entonces se hace la compacion 3 (ver si es divisible entre 400)
    jne siEsBisiesto                ;de no serlo entonces el anio si es bisiesto

comparacion3:
    ;revisar si el anio es divisible entre 400
    xor ax,ax                       ;se limpia el ax
    xor bx,bx                       ;se limpia el bx
    xor dx,dx                       ;se limpia el dx
    mov ax,_anio                     ;se mueve el anio al ax
    mov bx,400                      ;se le pasa al bx 400
    div bx                          ;se divide el ax (anio) entre el bx (400)
    
    cmp dx,0                        ;se verifica si el resto de la division dio 0
    je siEsBisiesto                 ;de serlo entonces si es bisiesto
    jne noEsBisiesto                ;de lo contrario no es bisieto

siEsBisiesto:
                                    ;caso en el que sea bisiesto
    mov di,1                        ;mueve al di un 1 (indica que si es bisiesto)
    jmp salirAB                     ;sale de la macro

noEsBisiesto:                       ;caso en el que no sea bisiesto
    mov di,0                        ;mueve al di un 0 (indica que no es bisiesto)
    jmp salirAB                     ;sale de la macro

salirAB:
    pop ax
EndM 

;hace el calculo del dia juliano y almacena el resultado en ax y dx
CalcularJulianDay macro _mes,_anio,_num1,_num2,_signo
    local anioAC,anioDC,mesEs1o2AC,mesNoEs1o2DC,es1582,noPonerBEn0,ponerBEn0,noNegativo,restar,sumar,calculoFinal,restar2,sumar2,sumar3,restar3,calculoFinal2,noCarry,seguirCJL

    ;PROCESO PARA OBTENER EL JULIAN DAY 
    xor ax,ax                               ;se limpia el ax                  
    xor bx,bx                               ;se limpia el bx
    xor cx,cx                               ;se limpia el cx
    xor dx,dx                               ;se limpia el dx
    xor di,di                               ;se limpia el di    (almacena el mes)
    xor si,si                               ;se limpia el si    (almacena el anio

    ;calculo a usar  
    ;M <= entonces M = M + 12 y Y = Y-1
    ;M > 2 entonces M e Y no varian 
    ;A = int(Y/100)
    ;B = 2 - A int(A/4)
    ;DJ = int(365.25(Y+4716)) + int(30.6001(M+1)) + 1 + B - 1524 
    ;M = mes, Y = anio, A = calculo extra, B = calculo extra, DJ = dia juliano


    ;sacar el M->di y el Y->si 
    mov di,_mes                              ;se mueve el mes al di           
    mov si,_anio                             ;se mueve el anio al si

    cmp _signo,1                             ;se verifica si el signo del anio es 1 (negativo->ac)
    je anioAC                               ;de serlo salta a anioAC
    jne anioDC                              ;sion salta a anioDC

anioAC:
    cmp di,3                                ;compara el di (mes) con 3 -> (ya que con enero o febrero el mes debe aumentarse en 12)
    jb mesEs1o2AC                           ;de ser menor (mes enero o febrero) salta a mesES1o2AC
    dec si                                  ;sino entonces decrementa el si (anio) -> (si es ac y el mes no es enero o febrero, se decrementa el anio)
    jmp ponerBEn0                           ;salta a ponerBEn0 (B es un calculo extra)

mesEs1o2AC:                                 ;caso en el que el mes es enero o febrero y el anio es AC
    add di,12                               ;se le agrega 12 al di (mes) -> (ya que con enero o febrero el mes debe aumentarse en 12)
    jmp ponerBEn0                           ;salta a ponerBEn0 (B es un calculo extra)

anioDC:                                     ;caso en el que el anio es DC
    cmp di,2                                ;se compara el di (mes) con 2
    ja mesNoEs1o2DC                         ;de ser mayor (mes no es enero ni febrero)
    add di,12                               ;sino se le agrega 12 al di (mes) -> (ya que con enero o febrero el mes debe aumentarse en 12)
    dec si                                  ;y se decrementa el si (anio) -> (si es DC y el mes es enero o febrero, se decrementa el anio)

mesNoEs1o2DC:                               ;caso en el que el mes no es febrero ni enero y el anio es DC

    ;proceso para sacar el A->cx                         
    mov ax,si                               ;se le pasa el si (anio) al ax
    mov bx,100                              ;se le mueve un 100 al bx
    div bx                                  ;se divide el ax (anio) entre bx (100)  
    mov cx,ax                               ;se mueve el cociente (A) al cx

    ;proceso para sacar el B->dl
    cmp _anio,1582                           ;se compara si el anio es 1582 (caso especial)
    je es1582                               ;de serlo entonces se salta a es1582
    ja noPonerBEn0                          ;sino entonces se salta a noPonorBEn0 (B-> calculo extra)

ponerBEn0:                                  ;se pone el B en 0 de octubre de 1582 hacia atras     
    mov dl,0                                ;mueve al dl (B->calculo extra) un 0
    jmp calculoFinal                        ;salta al calculoFinal

es1582:                                     ;caso en el que sea 1582
    cmp _mes,11                              ;compara el mes con 11 (ver si es octubre o inferior)
    jae noPonerBEn0                         ;si es mayor o igual (noviembre o superior) se salta a noPonerBEn0 (B-calculo extra)
    mov dl,0                                ;se mueve al dl 0 (poner B en 0)
    jmp calculoFinal                        ;salta al calculo final

noPonerBEn0:                                ;calculo extra de B

    xor bx,bx                               ;limpia el bx 
    mov bl,2                                ;mueve al bl un 2
    sub bl,al                               ;resta al bl (2) con al (A)

    cmp bl,77                               ;compara si el bl quedo negativo
    jbe noNegativo                          ;si es menor o igual quiere decir que no quedo negativo
    
    ;ajuste para obtener el valor correcto al ser negativo
    mov al,255                              ;se mueve al al un 255
    sub al,bl                               ;se resta al (255) con bl para dejar el valor correspondiente
    inc al                                  ;se incrementa el al
    mov ah,1                                ;le mueve al ah un 1 (quedo negativo el al)

noNegativo:                                 ;caso en el que no sea negativo
    mov dx,ax                               ;le mueve el ax al dx
    mov ax,cx                               ;le pasa el cx (A) al ax
    mov bl,4                                ;mueve al bl un 4
    div bl                                  ;divide al (A) entre bl (4)

    cmp dh,1                                ;ver si dh es 1 (negativo)
    je restar                               ;de ser negativo salta a restar
    jne sumar                               ;sino entonces a sumar         

restar:                                     ;caso en que 2-A haya dado negativo
    sub dl,al                               ;resta el dl (2-A) con al (A/4)
    jmp calculoFinal                        ;salta a calculo final
sumar:                                      ;caso en que 2-A haya dado positivo
    add dl,al                               ;suma el dl (2-A) con al (A/4)   
    mov dh,0                                ;limpia el dh

calculoFinal:                               ;se hace el primer calculo final

    ;PROCESO FINAL PARA EL CALCULO DEL JULIAN DAY 
    
    xor ax,ax                               ;se limpia el ax 
    xor bx,bx                               ;se limpia el bx
    xor cx,cx                               ;se limpia el cx

    ;hace la primer operacion -> int(365.25*(Y+4716))
    push dx                                 ;se guarda el dx (B) en la pila
    push di                                 ;se guarda el di (mes) en la pila

    cmp _signo,1                             ;ver si el anio es negativo
    je restar2                              ;si es negativo se hace una resta
    jne sumar2                              ;si es positivo se hace una suma

restar2:                                    ;caso en el que el anio sea negativo (AC)             
    mov ax,4716                             ;se mueve al ax el constante (4716) 
    sub ax,si                               ;se le resta a ax (4716) con el si (anio) 
    mov di,ax                               ;se le mueve al di ese resultado                      
    jmp seguirCJL                           ;salta a seguirCJL (calculo julian day)
sumar2:                                     ;caso en el que el anio sea positivo (DC)                         
    mov _num1,si                             ;se le mueve al num1 el si (anio)
    mov _num2,4716                           ;se le mueve la constante (4716) a num2
    sumarDosNumeros _num1,_num2               ;se hace la suma de esos dos numeros y se guarda en el di
seguirCJL:

    ;se hace lo siguiente para simular la multiplicacion por 0.25, que equivale a 1/4
    mov ax,di                               ;mueve el resultado al ax
    xor dx,dx                               ;limpia el dx
    mov bx,4                                ;le mueve al bx un 4
    div bx                                  ;divide ax (resultado de Y + 4716) entre 4, que evale a multiplicar por 0.25
    mov cx,ax                               ;guarda en el cx el ax (cuarta parte de Y + 4716)

    mov ax,di                               ;se le mueve al ax el di(Y + 4716)
    xor dx,dx                               ;limpia el dx
    mov bx,365                              ;mueve al bx un 365
    mul bx                                  ;multiplica el ax (Y+4716) por bx (365)

    mov bx,dx                               ;le mueve al bx el dx 

    mov bx,10000                            ;le mueve al bx un 10000
    div bx                                  ;divide el ax y dx entre bx (10000) para ajustar el resultado y dejar los 5 digitos mas significativos en ax y los restantes en dx

    mov _num1,cx                             ;le pasa a num1 el cx (cuarta parte de Y+4716)
    mov _num2,dx                             ;le pasa a num2 el dx (digitos menos significativos de 365*(y+4716))
    push ax                                 ;guarda el ax (digitos mas significativos de 365*(y+4716)) el la pila
    sumarDosNumeros _num1,_num2               ;suma ambos numeros y lo guarda en el di
    pop ax                                  ;obtiene el ax de la pila
    mov dx,di                               ;le mueve el resultado de la suma al dx
    
    ;hace la segunda operacion  -> int(30.6001(M+1))
    pop di                                  ;optiene el di (mes) de la pila
    push ax                                 ;guarda el ax (digitos mas significativos de 365*(y+4716)) en la pila
    push dx                                 ;guarda el dx (digitos menos significativos de 365*(y+4716)) en la pila

    xor ax,ax                               ;limpia el ax 
    xor dx,dx                               ;limpia el dx
    inc di                                  ;incrementa el di (M)

    ;se hace el equivalente de multiplicar 0.6 * (M+1) que seria 3*(M+1)/5
    mov ax,di                               ;mueve al ax el di (M+1)
    mov bl,3                                ;mueve al bl un 3
    mul bl                                  ;multiplica el al (M+1) por bl (3)

    mov bx,5                                ;le mueve al bx un 5                               
    div bx                                  ;divide el ax [(M+1)*3] entre bx (5)

    mov _num1,ax                             ;le pasa al num1 el ax [(M+1)*3 / 5]

    mov ax,di                               ;le pasa al ax el di (M+1)
    xor dx,dx                               ;limpia el dx
    mov bx,30                               ;le mueve al bx un 30
    mul bx                                  ;multiplica el ax (M+1) por bx (30)

    mov _num2,ax                             ;se le pasa a num2 el ax [30*(M+1)]

    sumarDosNumeros _num1,_num2               ;suma ambos numeros [(M+1)*3 / 5] + [30*(M+1)] y lo guarda en di

    pop dx                                  ;se obtiene el dx de la pila
    pop ax                                  ;se obtiene el ax de la pila

    mov _num1,dx                             ;se le pasa a num1 el dx (digitos menos significativos de 365*(y+4716))
    mov _num2,di                             ;le pasa a num2 el di [(M+1)*3 / 5] + [30*(M+1)]
    push ax                                 ;guarda el ax en la pila
    push dx                                 ;guarda el dx en la pila
    sumarDosNumeros _num1,_num2               ;suma el ambos numeros (digitos menos significativos + [(M+1)*3 / 5] + [30*(M+1)])
    pop dx                                  ;se obtiene el dx de la pila
    pop ax                                  ;se obtiene el ax de la pila

    mov dx,di                               ;se mueve a dx el di (resultadod de la suma)

    inc dx                                  ;incrementa el dx
    mov cx,dx                               ;mueve el dx al cx

    ;sumar o restar el B 
    pop dx                                  ;obtiene el dx de la pila
    xor bx,bx                               ;limpia el bx
    mov bl,dl                               ;le mueve a bl el dl (B)

    cmp dh,1                                ;ver si es negativo el B
    je restar3                              ;de serlo entonces se resta
    jne sumar3                              ;sino se suma

restar3:                                    ;caso en que B sea negativo                       
    sub cx,bx                               ;resta el cx con bx (B) 
    jmp calculoFinal2                       ;salta a calculoFinal2

sumar3: 
    push ax                                 ;guarda el ax (digitos mas significativos del calculo)
    mov _num1,cx                             ;mueve a num1 el cx (digitos menos sigficativos del calculo)
    mov _num2,bx                             ;mueve a num2 el bx (B)

    sumarDosNumeros _num1,_num2               ;se suman ambos numeros y queda el resultado en el di

    pop ax                                  ;obtiene el ax de la pila
    mov cx,di                               ;mueve al cx el di (resultado de la suma (digitos menos sigficativos del calculo + B))

calculoFinal2:                              ;hace la resta entre el calculo actual y 1524 

    sub cx,1524                             ;le resta al cx (digitos menos significativos del calculo actual) con 1524 (constante)
    mov dx,cx                               ;mueve ese resultado al dx
    inc dx                                  ;incrementa el dx

    cmp dx,10000                            ;compara ese resultado final con 10000 para ver si tiene 5 digitos
    jb noCarry                              ;de ser menor entonces el numero no se agrego digitos de mas por ende no hay carry 
    inc ax                                  ;sino entonces si lleva carry, entonces se incrementa el numero mas significativo del calculo
    push ax                                 ;guarda el ax (digitos mas significativos del calculo) en la pila    
    mov ax,dx                               ;le pasa el ax al dx (digitos menos significativos del calculo)
    xor dx,dx                               ;limpia el dx 
    mov bx,10000                            ;mueve al bx un 10000
    div bx                                  ;divide el ax (digitos menos significativos del calculo) entre el bx (10000), para quitar la cifra mas significativa del dx ya que esta se pasa para el ax
    pop ax                                  ;se obtiene el ax de la pila

noCarry:

    ;acomodar el formato para pasarlo a binario
    push dx                                 ;se guarda el dx (digitos menos significativos del calculo) en la pila
    mov bx,100                              ;mueve al bx un 100
    xor dx,dx                               ;limpia el dx 
    mul bx                                  ;multiplica el ax (digitos mas significativos del calculo) por bx (100), para agregarle 2 ceros a la derecha 

    pop dx                                  ;se obtiene el dx de pila
    push ax                                 ;se guarda el ax ya ajustado en la pila
    mov ax,dx                               ;se mueve al ax el dx (digitos menos significativos del calculo)
    xor dx,dx                               ;se limpia el dx
    div bx                                  ;se divide el ax (digitos menos significativos del calculo) entre bx (100)

    mov _num2,ax                             ;le pasa al num2 el ax (dos digitos mas significativos de los digitos menos significativos del calculo)
    pop ax                                  ;se obtiene el ax de la pila
    mov _num1,ax                             ;le pasa a num1 el ax (los digitos mas significativos del calculo con dos ceros a la derecha)
    push dx                                 ;se guarda el dx en la pila
    sumarDosNumeros _num1,_num2               ;se suman ambos numeros
    pop dx                                  ;se obtiene el dx de la pila
    mov ax,di                               ;se le mueve el resultado del di (5 digitos mas significativos del calculo) al ax 
EndM

ImprimirConversionAJuliano macro _mes,_anio,_signo
    CalcularJulianDay _mes,_anio,_num1,_num2,_signo      ;se calcula el dia juliano
    mov _num1,ax                                     ;se guarda la parte mas significativa en num1
    mov _num2,dx                                     ;y la menos significativa en num2
    dec _num2                                        ;se decrementa para ajustarlo
    mov _columna,0                                  
    mov _fila,0  
    gotoxy _fila, _columna                            ;se coloca el cursor en la pos 0,0
    ImprimirMensaje _msjConvJD                       ;se imprime el mensaje del conversor
    mov _columna,35                                  
    gotoxy _fila, _columna                            ;se coloca el cursor en la pos 0,35
    PrintHex _num2,_fila,columna                      ;se imprime la parte menos significativa
    PrintHex _num1,_fila,columna                      ;y la mas significativa

EndM 

ObtenerJulianDay macro _mes,_anio,_num1,_num2,_signo
    CalcularJulianDay _mes,_anio,_num1,_num2,_signo
    mov _num1,ax                             ;mueve al num1 el ax (5 digitos mas significativos del calculo)
    mov _num2,dx                             ;mueve al num2 el dx (2 digitos menos significativos del calculo)
    ;proceso para dejar los registros con los valores correspondientes para poder dividir entre 7 y obtener el primer dia del mes
    ConvertirNumeroABinario _num1,_num2       ;se convierte el calculo del julian day a binario
    GuardarBitsEnAxYDX _julianDayBinario     ;y se guardan los primeros 16 bits en el ax y los restantes en el dx 

    ;proceso para obtener el primer dia del mes
    mov bx,7777                             ;se le pasa un 7777 al bx, ya que dividir entre 7 provoca un desbordamiento
    div bx                                  ;se divide el dia juliano entre 7777

    mov bx,7                                ;mueve al bx un 7
    mov ax,dx                               ;mueve los 8 bits menos significativos al ax
    xor dx,dx                               ;limpia dx        
    div bx                                  ;divide el ax (8 bits menos significativos) entre el bx (7), para obtener el restos que corresponde a un dia de la semana
EndM 

;recibe el numero en dos partes y lo convierte a su equivalencia binaria de max 24 bits
ConvertirNumeroABinario macro _parteAlta,_parteBaja 
    local whileCB1,breakCB1,whileCB2,breakCB2

    ;PROCESO PARA CONVERTIR UN NUMERO DE 7 DIGITOS A BINARIO
    mov ax,_parteAlta                        ;se guarda la parte alta del numero en el ax   
    mov dx,_parteBaja                        ;se guarda la parte baja del numero en el dx

    xor bx,bx                               ;se limpia el bx (contiene los numeros por los cuales se va a dividir)
    xor cx,cx                               ;se limpia el cx (guarda momentaneamente la parte alta del numero)    
    xor si,si                               ;se limpia el si (index para ir guardando los bits en cada posicion) 

    mov si,23                               ;se le mueve al si un 23 (pos del ultimo bit posible)


    whileCB1:
        push dx                             ;se guarda el dx en la pila
        push ax                             ;se guarda el ax en la pila

        ;proceso para obtener el resto en cada vuelta (bits)
        xor ax,ax                           ;se limpia el ax
        mov ax,dx                           ;se mueve el dx al ax 
        xor dx,dx                           ;limpia el dx 
        mov bx,2                            ;mueve al bx un 2 
        div bx                              ;se divide entre 2 para obtener el resto (bit)
        mov [_julianDayBinario + si], dl     ;se guarda el resto (bit) en el julianDayBinario, segun la pos actual
        pop ax                              ;se le regresa el valor guardado en la pila al ax
        pop dx                              ;se le regresa el valor guardado en la pila al dx
        
        ;proceso para dividir entre dos el numero y actualizar el cociente
        ;proceso para actualizar la parte alta en cada vuelta
        push dx                             ;se guarda el dx en la pila           
        push ax                             ;se guarda el ax en la pila
        xor dx,dx                           ;se limpia el dx
        mov bx,2                            ;se le pasa un 2 al bx
        div bx                              ;se divide la parte alta entre dos para actualizarla
        mov cx,ax                           ;guarda esa parte alta actualizada en el cx 
        
        ;proceso para actualizar la parte baja en cada vuelta
        pop ax                              ;se le regresa el valor guardado en la pila al ax  
        mov bx,10                           ;se le mueve al bx un 10
        xor dx,dx                           ;se limpia el dx
        div bx                              ;divide la parte alta sin actualizar entre 10 
        xor ax,ax                           ;limpia el ax
        mov ax,dx                           ;mueve al ax el digito menos significativo de la parte alta sin actualizar
        mov bx,100                          ;mueve al ax un 100
        mul bx                              ;multiplica el ese digito menos significativo por 100
        pop dx                              ;se le regresa el valor guardado en la pila al dx (parte baja sin actualizar)
        mov _num1,ax                         ;se le mueve al num1 el ax (digito menos significativo con 2 ceros a la derecha
        mov _num2,dx                         ;se le mueve al num2 el dx (parte baja sin actualizar)
        push si                             ;guarda el si en la pila (index de los bits)
        push cx                             ;guarda el cx en la pila (parte alta actualizada)
        sumarDosNumeros _num1,_num2           ;le agrega al digito menos significativo sin actualizar la parte baja
        
        xor ax,ax                           ;limpia el ax
        xor dx,dx                           ;limpia el dx
        mov ax,di                           ;le mueve al ax esa suma obtenida
        mov bx,2                            ;se le pasa al bx un 2
        div bx                              ;se divide esa suma entre 2

        mov bx,100                          ;se le mueve al ax un 100
        xor dx,dx                           ;se limpia el dx
        div bx                              ;se divide la mitad de esa suma entre 2 (obtiene la actulizacion de la parte baja)

        pop cx                              ;se recupera el valor del cx guardado en la pila (parte alta actualizada)
        mov ax,cx                           ;se le pasa la parte alta actulizada al ax
        ;fin del proceso que imita la division de un numero de max 7 cifras entre 2

        xor cx,cx                           ;se limpia el cx
        pop si                              ;se recupera el valor del si guardado en la pila (index de los bits)
        dec si                              ;se decrementa el si (avanza un espacio a la izquierda de los bits)

        cmp ax,65                           ;compara el ax (parte alta actualizada) con 65 (dos digitos mas significativos del num max para el registro de 8 bits)
        jbe breakCB1                        ;si es menor o igual entonces se sale del break (aplicar el proceso normal)
        jmp whileCB1                        ;de lo contrario se continua con el ciclo
    breakCB1:                               ;salida del while

    ;proceso para juntar el contenido del ax (parte alta actualizada n veces) con el dx (parte baja actualizada n veces)
    push dx                                 ;se guarda el dx en la pila
    xor dx,dx                               ;se limpia el dx                  
    mov bx,100                              ;se le pasa un 100 al bx
    mul bx                                  ;le agrega a la parte alta actualizada dos ceros a la decha 
    
    pop dx                                  ;le regresa el valor guardado en la pila al dx
    mov _num1,ax                             ;se le pasa la parte alta actualizada con dos ceros a num1
    mov _num2,dx                             ;se le pasa la parte baja actualizada al num2

    push si                                 ;se guarda el si (index de los bits) en la pila
    sumarDosNumeros _num1,_num2               ;se une la parte alta y baja actualizada en el di
    pop si                                  ;se recupera el si de la pila (index de bits)
    mov ax,di                               ;se le pasa el numero unido al ax

    ;proceso para terminar de obtener la conversion en bits del las ultima 4 cifras
    whileCB2:    

        mov bx,2                            ;se le pasa un 2 al bx
        xor dx,dx                           ;se limpia el dx
        div bx                              ;se divide el numero entre 2

        mov [_julianDayBinario + si],dl      ;se guarda el resto en el julianDayBinario en la pos actual
        dec si                              ;se decrementa el si (index de bits)

        cmp ax,0                            ;se compara si el numeo ya llego a ser 0
        je breakCB2                         ;de ser cero, entonces se sale del ciclo
        jmp whileCB2                        ;sino entonces continua el ciclo
    breakCB2:                               ;salida del ciclo dos
EndM 

;recibe los 24 bits y los guarda en el registro ax (primeros 16 bits) y dx (8 bits restantes)
GuardarBitsEnAxYDX macro _julianDay
    local whilePB,breakPB,calParteBaja,comprobarSalidaPB
    xor ax,ax                               ;se limpia el ax
    xor bx,bx                               ;se limpia el bx
    xor cx,cx                               ;se limpia el cx 
    xor dx,dx                               ;se limpia el dx 
    xor si,si                               ;se limpia el si 

    mov ax,0000000000000000b                ;se inicializan los primeros 16 bits en 0    
    mov dx,00000000b                        ;se inicializan los 8 bit restantes en 0

    mov si,0                                ;se limpia el si
    whilePB:                        
        
        mov bl, [_julianDayBinario + si]     ;mueve al bl el bit actual 
        mov [_julianDayBinario + si],0       ;se limpia el bit actual para que este listo en futuras llamadas
        
        cmp si,8                            ;se compara si el si (index) con 8, para ver si ya se calcularon los ultimos 8 bits
        jae calParteBaja                    ;en caso de ser mayor o igual, entonces se empieza a calcular los primeros 16 bits
        
        ;proceso para pasar la parte alta al dx
        shl dx,1                            ;se mueven los bits del dx 1 espacio a la izquierda
        or dx,bx                            ;se hace un or entre el bit actual y el menos significativo del dx (si bx es 0 lo deja en 0, si es 1 lo pone en 1) 
        jmp comprobarSalidaPB               ;salta al condicional del ciclo de salida

    ;proceso para pasar la parte baja al ax
    calParteBaja:
        shl ax,1                            ;se mueven los bits del ax 1 espacio a la izquierda
        or ax,bx                            ;se hace un or entre el bit actual y el menos significativo del ax (si bx es 0 lo deja en 0, si es 1 lo pone en 1)

    comprobarSalidaPB:
        inc si                              ;se incrementa el si (index de los bits)    
        cmp si,24                           ;se compara el si con 24 (max cantidad de bits)     
        je breakPB                          ;si es igual entonces se sale (ya coloco todos los bits)
        jmp whilePB                         ;sino entonces repite el ciclo
    breakPB:                                ;se sale del ciclo
EndM

;calcula la posicion en la que hay que colocar la columna para imprimir en el dia correspondiente del calendario
CalcularPosColumna macro _nDia,_columna 
    local nDia1,nDia2,nDia3,nDia4,nDia5,nDia6,salirCPC

    push ax                                 ;se guarda el ax, en la pila
    push bx                                 ;se guarda el bx en la pila
    push cx                                 ;se guarda el cx en la pila
    push dx                                 ;se guarda el dx en la pila

    cmp _nDia,0
    jne nDia1
    mov _columna,8
    jmp salirCPC
nDia1:
    cmp _nDia,1
    jne nDia2
    mov _columna,17
    jmp salirCPC
nDia2:
    cmp _nDia,2
    jne nDia3
    mov _columna,26
    jmp salirCPC
nDia3:
    cmp _nDia,3
    jne nDia4
    mov _columna,36
    jmp salirCPC
nDia4:
    cmp _nDia,4
    jne nDia5
    mov _columna,47
    jmp salirCPC
nDia5:
    cmp _nDia,5
    jne nDia6
    mov _columna,56
    jmp salirCPC
nDia6:
    cmp _nDia,6
    jne salirCPC
    mov _columna,66
    jmp salirCPC

salirCPC:
    pop dx                                  ;se saca de la pila el dx
    pop cx                                  ;se saca de la pila el cx
    pop bx                                  ;se saca de la pila el bx 
    pop ax                                  ;se saca de la pila el ax
EndM

;guarda todos los registos en la pila
PushA1 Macro 
    push ax
    push bx
    push cx
    push dx
    push si 
    push di 
    push bp 
    push sp 
    push ds 
    push es 
    push ss 
    pushf 
EndM

;saca todos los registros de la pila
PopA1 Macro 
    popf
    pop ss
    pop es 
    pop ds 
    pop sp  
    pop bp 
    pop di   
    pop si  
    pop dx  
    pop cx  
    pop bx  
    pop ax 
EndM

_imprimirMes PROC Near
	PUSH BP
	MOV BP,SP
	MOV BX,[BP+4]           ; Recuperar el valor de anio
	MOV CX,[BP+6]           ; Recuperar el valor de mes
	MOV AX,[BP+8]           ; Recuperar el valor de signo

	; Configurar el coprocesador FPU
	mov word ptr _anio, bx          
	mov word ptr _mes, cx           
	mov word ptr _signo, ax   

    xor ax,ax
    xor bx,bx
    xor cx,cx         

	PushA1                           ;se guardan los registros en la pila
    ObtenerJulianDay _mes,_anio,_num1,_num2,_signo       ;se obtiene el dia juliano de la fecha ingresada, para saber el primer dia del mes
    mov _primerDia,dl                ;se guarda el primer dia del mes        
    PopA1                            ;se sacan los registros de la pila

    mov _fila,1                      ;pasa la fila en la posicion 0
    mov _columna,27                   ;pasa la columna en la posicion 5
    gotoxy _fila,_columna             ;coloca el cursor
    PrintHex _mes,_fila,_columna       ;se imprime el numero de mes
    
    mov _columna,28                   ;pasa la columna a la posicion 6
    gotoxy _fila,_columna             ;coloca el cursor
    ImprimirCaracter _separador      ;imprime el separador (/)
    
    cmp _signo,1                     ;verificar si el anio es negativo
    jne _noImprimirNegativoIM          ;de no serlo entonces no imprime el signo menos
    mov _columna,29                   ;posiciona la columna en 7
    gotoxy _fila,_columna             ;posiciona el cursor en la fila y columna ingresada
    ImprimirCaracter _signoNegativo  ;imprime el caracter menos

_noImprimirNegativoIM:     
    
    add _columna,4                  ;coloca la columna en la posicion 11
    gotoxy _fila,_columna             ;coloca el cursor 
    PrintHex _anio,_fila,_columna      ;se imprime el numero de anio
    
    add _fila,2                      ;se incrementa en 2 posicion de la fila
    mov _columna,1                   ;se coloca la columna en 0     
    gotoxy _fila,_columna             ;se coloca el cursor
    ImprimirMensaje _dias            ;se imprime los dias de la semana

    xor ax,ax                       ;se limpia el ax
    xor bx,bx                       ;se limpia el bx
    xor cx,cx                       ;se limpia el cx
    xor si,si                       ;se limpia el si

    mov bx,offset _nDiasPorMes       ;coloca el bx en el offset de la cantidad de dias por mes
    mov di,_mes                      ;se almacena el numero del mes en di
    dec di                          ;se decrementa la escala del mes de 0 a 11, para obtener los n dias mensuales
    mov cl,[bx+di]                  ;se obtiene la cantidad de dias mensuales y se guarda en el cl
    
    ;VERIFICAR SI EL ANIO ES BISIESTO O NO PARA INCREMENTAR LOS DIAS DE FEBRERO A 29
    cmp _mes,2                       ;compara si el mes es 2, para ver si es febrero
    jne _noIncrementarFebrero        ;de no serlo entonces no incrementa los n dias de febrero
    EsAnioBisiesto _anio             ;de lo contrario entonces se verifica si el anio es bisiesto
    cmp di,1                        ;verifica si es bisiesto (di = 1)
    jne _noIncrementarFebrero        ;no es 1 entonces no es bisiesto, por ende no se incrementa febrero
    inc cl                          ;si es 1, incrementa el cl (n dias del mes), lo que significa que febrero tendra 29 dias
    mov _nDiasPorMes[di],cl 

    _noIncrementarFebrero:
    mov di,cx                       ;se le mueve a di el cx (cantidad de dias del mes)
    mov bl,7                        ;corresponde a la cantidad de dias semanales
    inc _fila                        ;se incrementa la fila, para dar un salto de linea
    xor cx,cx                       ;se limpia el cx

    PushA1
    CalcularNumeroSemana _mes, _anio, _nDiasPorMes, _nDia, _fila,_columna,_num1,_num2
    mov _num1,ax
    PopA1

    whileIM:
        cmp ax,di                   ;se verifica si ya se llego a imprimir todos los dias del mes
        jne _sigaIM                  ;de no ser asi, entonces sigue el while
        jmp _breakIM                 ;sino, entonces se sale
        
    _sigaIM: 
        mov si,cx                   ;mueve al si el cx (guardar el n dia actual)

        mov cl,al                   ;se mueve al cl el al
        add al,_primerDia            ;le agrega al al el primer dia del mes
        mov bx,7                    ;mueve al bx un 7 (n dias de la semana)
        xor dx,dx                   ;limpia el dx 
        div bx                      ;divide el ax (n dia actual + primerDia mensual) entre bx (7)
        mov _nDia,dx                 ;le mueve el residuo al nDia, ya que calcula en que dia de la semana debe imprimir

        push si                     ;guarda el si (n dia actual) en la pila
        CalcularPosColumna _nDia,_columna     ;se calcula la posicion en la que debe estar la columna
        pop si                      ;se saca de la pila el si
        
        ;verificar si el anio es octubre de 1582 DC para quitar los dias fantasmas
        cmp _signo,1                 ;compara el signo del anio con 1 (negativo)
        je _noHacerAjuste1582         ;de serlo entonces salta a noHacerAjuste1582, ya que el anio no seria DC

        cmp _anio,1582               ;comparar el anio con 1582
        jne _noHacerAjuste1582       ;de no serlo entonces no hace el ajuste, ya que el anio no es 1582

        cmp _mes,10                  ;compara el mes con 10 para ver si es octubre
        jne _noHacerAjuste1582       ;de no serlo entonces no hace el ajuste, ya que el mes no es octubre
                                    ;caso en el que la fecha si sea octubre de 1582 DC
        cmp cl,4                    ;compara el n dia actual con 4
        jb _noHacerAjuste1582        ;de ser menor entonces no hace el ajuste

        add cl,10                   ;de lo contrario, le suma 10 al dia actual
        push di                     ;guarda el di en la pila
        mov di,9                    ;mueve al di un 9 para modificar los dias de octubre
        mov _nDiasPorMes[di],21      ;se ajusta octubre de 31 a 21 dias (dias faltantes)
        pop di                      ;saca el di de la pila
        cmp cl,30                   ;compara si el dia actual es 30
        jbe _noHacerAjuste1582       ;de ser menor o igual entonces sigue con el ciclo
        jmp _breakIM                 ;de lo contrario se sale del while, ya que indica que se llego al dia final

    _noHacerAjuste1582:

        inc cl                      ;incrementa el numero del dia actual    
        mov al,cl                   ;se mueve el dia actual al al
        mov _nDia,cx                 ;se mueve el dia actual a nDia

        cmp _nDia,10                 ;verifica el dia actual con 10
        jb _noIncrementeCol          ;de ser menor, entonces no se incrementa la columna 1 espacio demas
        inc _columna                 ;si es 10 o mayor, entonces se incrementa la columna 1 espacio deman

        _noIncrementeCol:            ;etiqueta para saltarse el incremento cuando no es necesario
            push si                 ;guarda el si en la pila
            PrintHex _nDia,_fila,_columna  ;se imprime el dia actual    
            inc _columna             ;se  incrementa la columna
            pop si                  ;se saca el si de la pila
            inc si                  ;se incrementa el si (dia actual sin modificaciones)
            mov ax,si               ;se le pasa al ax el dia actual
            add al,_primerDia        ;se agrega el valor del primer dia al dia actual
            div bl                  ;se divide ese valor entre 7, que son los dias semanales
            
            cmp ah,0                ;se verifica si el residuo es 0
            je _imprimirNS
            jmp _salteIM             ;de no serlo, brinque al final
            
        _imprimirNS:
            mov cl,_columna 
            mov _num2,cx
            mov _columna,1
            pushA1 
            PrintHex _num1,_fila,_columna
            popA1  
            mov cx,_num2
            mov _columna,cl
            inc _fila                ;de serlo, se incrementa la fila para hacer un salto de linea
            inc _num1 

    _salteIM:
        mov cx,si                   ;se reinicia el valor del dia actual en el cx
        mov ax,si                   ;y tambien en el ax
        jmp whileIM                 ;se repite el ciclo

    _breakIM:                        ;break para salirse del ciclo
        mov _columna,1
        pushA1 
        PrintHex _num1,_fila,_columna
        popA1
        inc _fila

        gotoxy _fila,_columna 
        ImprimirMensaje _msjDiasRestan   ;se imprime el mensaje de los dias restantes
        ImprimirDiasRestantes _mes, _anio, _nDiasPorMes, _nDia, _fila, _columna,_num1,_num2  ;se imprime la cantidad de dias restantes 

        MOV SP,BP
        POP BP
    RET
_imprimirMes EndP


;imprime un anio ingreado
_imprimirAnio PROC Near 
    PUSH BP
	MOV BP,SP
	MOV BX,[BP+4]           ; Recuperar el valor de anio
	MOV CX,[BP+6]           ; Recuperar el valor de mes

	; Configurar el coprocesador FPU
	mov word ptr _anio, bx          
	mov word ptr _signo, cx           

    mov _mes,1                       ;le mueve al mes un 1, para que empiece a imprimir desde enero
    xor cx,cx                       ;limpia el cx
    
    mov _columna,0                   ;se coloca el cursor en la pos 0,0
    mov _fila,0
    gotoxy _fila,_columna

    ImprimirMensaje _dias2           ;se imprime el mensaje que de los dias de la semana
    ImprimirMensaje _dias2
    ImprimirMensaje _dias2

    mov _columna,5                   ;se coloca la posicion inicial, en la 5,1
    inc _fila 
    mov _num2,0                      ;se limpia el num2

    whileIA:
        push cx                     ;se guarda en la pila el contador del while 1
        cmp cx,12                   ;condicion de salida contador igual a 12
        jb  noBreakIA               ;mientras sigue
        jmp breakIA                 ;cuando llegue a 12 se sale
        
    noBreakIA: 

        ;verificar si hay que ajustar fila 
        cmp _mes,3                   
        ja verificarPrimerAjuste
        jmp noAjusteInicialFila
        
    verificarPrimerAjuste:
        mov bx,offset _nDiasPorMes       ;coloca el bx en el offset de la cantidad de dias por mes
        mov si,_mes                      ;se almacena el numero del mes en di
        sub si,4                        ;se decrementa la escala del mes de 0 a 11, para obtener los n dias mensuales
        xor ax,ax 
        mov al,[bx+si]                  ;se obtiene la cantidad de dias mensuales y se guarda en el al
        
        PushA1                           ;se guardan los registros en la pila 
        sub _mes,3                       ;se le resta tres al mes, para compararlo con el que va arriba de el en el print
        ObtenerJulianDay _mes,_anio,_num1,_num2,_signo       ;se obtiene el dia juliano de la fecha ingresada, para saber el primer dia del mes
        add _mes,3                       ;se reinicia la cantidad que tenia el mes
        mov dh,0            
        mov _num1,dx                     ;se guarda el dia de la semana en num1
        PopA1                            ;se recuperan los registros
        mov dx,_num1                     

        xor bx,bx 
        xor si,si
        add al,dl                       ;se suma la cantidad de dias del mes con el dia de la semana
        cmp al,35                       ;en caso de ser mayor a 35, se ajusta la fila
        ja ajusteInicialFila 
        jmp noAjusteInicialFila

    ajusteInicialFila:
        inc _fila
        inc _filaActual

    noAjusteInicialFila:

        ;imprimir el nombre del mes actual  
        mov ax,cx                           ;se mueve el contador del while 1 a ax 
        mov bx,4                            ;guarda un 4
        mul bl                              ;multiplica el contador del while 1 con 4
        mov bx, offset _ene                  ; Dirección base de la tabla de nombres de meses
        add bx, ax                          
        mov al,_columna                      
        sub _columna,5
        gotoxy _fila, _columna 
        ImprimirMensaje bx 
        mov _columna,al 

        ;sacar los meses actuales
        mov bx,offset _nDiasPorMes       ;coloca el bx en el offset de la cantidad de dias por mes
        mov di,_mes                      ;se almacena el numero del mes en di
        dec di                          ;se decrementa la escala del mes de 0 a 11, para obtener los n dias mensuales
        mov cl,[bx+di]                  ;se obtiene la cantidad de dias mensuales y se guarda en el cl
        mov di, cx
        
        ;caso especial 1582
        cmp _anio,1582               ;comparar el anio con 1582
        jne noAjustarOctubre       ;de no serlo entonces no hace el ajuste, ya que el anio no es 1582

        cmp _mes,10                  ;compara el mes con 10 para ver si es octubre
        jne noAjustarOctubre       ;de no serlo entonces no hace el ajuste, ya que el mes no es octubre
        sub di,10

    noAjustarOctubre:
        ;pop cx

        ;calcular el primer dia del mes
        mov ax,_num1 
        PushA1                           ;se guardan los registros en la pila 
        ObtenerJulianDay _mes,_anio,_num1,_num2,_signo       ;se obtiene el dia juliano de la fecha ingresada, para saber el primer dia del mes
        mov _primerDia,dl                ;se guarda el primer dia del mes 
        mov al,3                        ;mueve al al 3
        mul dl                          ;multiplica el dl con 3
        add _columna,al  
        PopA1
        mov _num1,ax 

        xor bx,bx 
        xor si,si
    

        whileIA2:
            cmp si,di 
            jb noBreakIA2
            jmp breakIA2

        noBreakIA2: 

            ;verificar si el anio es octubre de 1582 DC para quitar los dias fantasmas
            cmp _signo,1                 ;compara el signo del anio con 1 (negativo)
            je puenteNoHacerAjuste1582         ;de serlo entonces salta a noHacerAjuste1582, ya que el anio no seria DC

            cmp _anio,1582               ;comparar el anio con 1582
            jne puenteNoHacerAjuste1582       ;de no serlo entonces no hace el ajuste, ya que el anio no es 1582

            cmp _mes,10                  ;compara el mes con 10 para ver si es octubre
            jne puenteNoHacerAjuste1582       ;de no serlo entonces no hace el ajuste, ya que el mes no es octubre
                                        ;caso en el que la fecha si sea octubre de 1582 DC
            cmp si,4                    ;compara el n dia actual con 4
            jb puenteNoHacerAjuste1582        ;de ser menor entonces no hace el ajuste

            cmp si,13
            jmp imprimirConAjuste1582

        puenteNoHacerAjuste1582:
            jmp noHacerAjuste1582

        imprimirConAjuste1582:
            add si,10
            mov _num3,si 
            inc _num3
            mov dl,_columna 
            PrintHex _num3,_fila,_columna 
            mov _columna,dl 
            add _columna,3
            sub si,10

            jmp noImprimir

        noHacerAjuste1582:
            mov _num3,si 
            inc _num3
            mov dl,_columna 
            PrintHex _num3,_fila,_columna 
            mov _columna,dl 
            add _columna,3

        noImprimir: 

            ;comprobar si hay que hace salto de linea  
            mov ax,si               ;se le pasa al ax el dia actual
            inc ax 
            add al,_primerDia        ;se agrega el valor del primer dia al dia actual
            mov bx,7
            div bl                  ;se divide ese valor entre 7, que son los dias semanales
            cmp ah,0                ;se verifica si el residuo es 0 
            je ajustarIA             ;de no serlo, brinque al final
            jmp noSaltoLinea

        ajustarIA:
            mov cl,_columnaActual
            mov _columna,cl             
            inc _fila
            inc _cont 

        noSaltoLinea:
            inc si
            jmp whileIA2 

        breakIA2: 
            add _columnaActual,27
            mov cl,_columnaActual 
            mov _columna,cl  

            ;comprobar si hay saltar al siguiente bloque
            pop cx 
            mov ax,cx 
            mov bx,3
            inc ax 
            div bl 
            cmp ah,0
            jne noIncFila

            add _fila,1
            mov al,_fila 
            mov _filaActual,al 
            mov _columna,5
            mov _columnaActual,5


        noIncFila:
            mov al,_filaActual 
            mov _fila,al
            inc _mes 
            inc cx
            jmp whileIA 
            
    breakIA:
    MOV SP,BP
    POP BP
    RET
_imprimirAnio EndP 


_TEXT ENDS
END