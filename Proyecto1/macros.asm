;guarda el numero correspondiente en el ax, hasta que se lea un / que indica el final
ObtenerDatoEntrada macro entrada, pos 
    local while1, break1,noBreak1   ;locales del macro
    xor bx,bx                       ;se limpia el bx
    xor ax,ax                       ;se limpia el ax
    xor cx,cx                       ;se limpia el cx

    mov si,pos                      ;se le mueve pos al si
    
    mov cl,entrada[si]              ;se le mueve al cl el primer digito, del mes o del anio, segun lo que haya ingresado a la macro  
    sub cl,30h                      ;se ajusta el cl para obtener su valor numerico decimal
    mov al,cl                       ;se le mueve al al el cl que contiene el digito
    mov bx,10                       ;se le mueve un 10 al bl, para hace las mul
    
    while1:   
        inc si                      ;se incrementa la pos actual
        cmp entrada[si],'/'         ;se compara si el elemento en la pos actual es /
        jne noBreak1                ;en caso de no serlo entonces se sigue leyendo la entrada
        jmp break1                  ;en caso de que si lo sea entonces quiere decir que ya se leyo todo el mes o el anio y se sale
        
    noBreak1:                       ;continua el ciclo    
        mul bx                      ;multiplica el ax por 10, para agregar un 0 al final del numero

        mov cl,entrada[si]          ;se le mueve al cl el digito actual de la entrada
        sub cl,30h                  ;se ajusta el cl para obtener su valor numerico decimal
        mov num1,ax                 ;se le mueve a num1 numero formado hasta momento
        mov num2,cx                 ;se le mueve a num2 el digito actual

        push si                     ;se guarda en la pila el si, para conservar la pos actual
        push bx                     ;se guarda en la pila el bx, para guardar el 10
        sumarDosNumeros num1,num2   ;se se le agrega el digito actual al numero que se lleve hasta momento
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

;obtiene por commandLine la entrada de datos y la guarda en LineCommand
GetCommanderLine macro LineCommand
    local LongLC 
    LongLC    EQU   80h             ;define una constante con el valor hexadecimal 80h (max de la LineCommand)

    Mov   Bp,Sp                     ;establece un punto de referencia para acceder a los parametros y varibles locales de la pila
    Mov   Ax,Es                     ;mueve al ax el valor del segmento extra
    Mov   Ds,Ax                     ;mueve al ds el ax, pata que apunte al es
    Lea   Di,LineCommand            ;mueve al si la direccion de memoria de LineCommand
    Mov   Ax,Seg LineCommand        ;mueve al ax el segmento de direccion de memoria del LineCommand 
    Mov   Es,Ax                     ;mueve al es el segmento de direccion de memoria del LineCommand  
    Xor   Cx,Cx                     ;limpia el cx
    Mov   Cl,Byte Ptr Ds:[LongLC]   ;mueve al cl el largo de la entrada ingresada
    dec   cl                        ;decrementa el cl 
    Mov   Si,2[LongLC]              ;mueve al si [LongLC+2]
    cld                             ;limpia el bit de dirección del registro de flags 
    Rep   Movsb                     ;repite la operacion de mover byte segun el contenido del cl, para guardar la entrada en LineCommand
EndM

;imprime un mensaje en pantalla
ImprimirMensaje Macro mensaje
    PushA                   ;se guardan los registros en la pila                     
    mov ah,09h              ;impresion de cadena de caracteres                  
    mov dx,offset mensaje   ;se mueve al dx el desplazamiento de mensaje
    int 21h                 ;interrupcion 21h                    
    PopA                    ;se sacan los registros de la pila
EndM

;imprime un caracter en pantalla
ImprimirCaracter Macro Caracter
    PushA                   ;se guardan los registrose en la pila
    mov ah,02h              ;funcion para imprimir 1 caracter de la interrupcion 21h
    mov dl,Caracter         ;se le mueve al dl el caracter a imprimir
    int 21h                 ;interrupcion 21h
    PopA                    ;se sacan los registros de la pila
EndM 

;imprime cada digito de un numero dw
PrintHex Macro Numero,fila,columna 
    local whilePH, salgaPH    
    pushA                       ;guardan todos los registros
    xor ax,ax                   ;se limpia el ax, que se usa para ir haciendo cada operacion de division
    xor bx,bx                   ;se limpia el bx, que se usa para almacenar el 10 con el que se hace cada division
    xor dx,dx                   ;se limpia el dx, que se usa para ir imprimiendo cada digito del numero
    mov ax,numero               ;se mueve al ax el numero ingresado
    mov bx,10                   ;se le mueve al bx un 10, que se usa para obtener cada digito mediante divisiones 
    
    whilePH:
        
        gotoxy fila,columna     ;coloca el cursor en la fila y columna correspondiente
        
        xor dx,dx               ;limpia el dx
        div bx                  ;divide el numero entre bx (10), para obtener cada digito, imprimirlo y quitarlo del numero
        add dl,30h              ;se le agrega al dl (digito) un 30h, para ajustarlo a su valor numerico decimal
        ImprimirCaracter dl     ;se imprime el digito obtenido    
        dec columna             ;se decrementa la columna, para imprimir el siguiente digito un espacio a la izquierda
        
        cmp ax,0                ;compara si el ax ya es 0
        je salgaPH              ;de serlo entonces se sale del ciclo
                                ;sino entonces sigue con las operaciones
        jmp whilePH             ;repite el ciclo        
    
    salgaPH:                    ;sale del ciclo

    popA                        ;saca los registros guardados en la pila
EndM

;imprime el numero de semana de cada final de mes
ImprimirNumeroSemana macro mes, anio, nDiasPorMes, nSemana, fila, columna,num1,num2
    local whileNS, breakNS, imprimirNS, sigaNS

    xor ax,ax                       ;se limpia el ax, que se va a usar para almacenar el numero de la semana
    xor bx,bx                       ;se limpia el bx, que se va a usar para obtener cada nDiasPorMes
    xor cx,cx                       ;se limpia el cx, que se va a usar como contador del ciclo
    xor dx,dx                       ;se limpia el dx, que se va a usar para guardar temporalmente cada n dias por mes
    xor si,si                       ;se limpia el si, que se va a usar como el index de cada nDiasPorMes

    mov si,1                        ;mueve un 1 al si para empezar en la pos 1
    mov ax,31                       ;mueve al ax un 31, que corresponde a los n dias del mes de enero
    mov cx,1                        ;mueve un 1 al cx 

    mov bx, offset nDiasPorMes      ;mueve el bx el desplazamiento de nDiasPorMes

    whileNS:
        cmp cx,mes                  ;compara el mes ingresado con el cx
        jne sigaNS                  ;en caso de no ser iguales, entonces sigue el ciclo
        jmp breakNS                 ;si es igual entonces se sale del ciclo

    sigaNS:                         ;etiqueta para continuar el ciclo

        mov dl,[bx+si]              ;mueve al dl los n dias por mes, correspondiente a la posicion en la que este el si
        mov num2,dx                 ;le pasa ese n dias por mes del dx, al num2
        mov num1,ax                 ;le pasa la sumatoria de los dias por mes que lleve el ax, al num2
        push ax                     ;guarda el valor del ax en la pila
        push bx                     ;guarda el valor del bx en la pila
        push cx                     ;guarda el valor del cx en la pila
        push dx                     ;guarda el valor del dx en la pila
        push si                     ;guarda el valor del si en la pila

        sumarDosNumeros num1, num2  ;hace la suma del num1 (sumatoria de n dias de los meses) con el num2 (n dias del mes actual) y se guarda en el di

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
    cmp mes,12                      ;verica si el mes ingresado es 12
    je imprimirNS                   ;de serlo, entonces no se incrementa el numero de semana
    inc al                          ;sino, entonces incremente el numero de la semana

    imprimirNS:                     ;etique para imprimir el numero de la semana
        mov nSemana, ax             ;mueve a nSemana, el resultado obtenido
        inc fila                    ;incrementa la fila, para dar un salto de linea
        mov columna,20              ;se posiciona la columna en 20
        PrintHex nSemana, fila, columna   ;se imprime el numero de la semana
EndM 

;imprime que numero del dia de los 365 es 
ImprimirNumeroDelDiaAnual macro mes, anio, nDiasPorMes, nDias, fila, columna, num1,num2 
    local forND, printHexND

    xor ax,ax                       ;se limpia el ax, que se va a usar para almacenar los n dias restantes
    xor bx,bx                       ;se limpia el bx, que se va a usar para obtener cada nDiasPorMes
    xor cx,cx                       ;se limpia el cx, que se va a usar como contador del for
    xor dx,dx                       ;se limpia el dx, que se va a usar para guardar temporalmente cada n dias por mes 
    xor di,di                       ;se limpia el di, que se va a usar para almacenar el resultado de las sumas
    xor si,si                       ;se limpia el si, que se va a usar como index de cada nDiasPorMes

    mov bx,offset nDiasPorMes       ;se mueve al bx el desplazamiento de la cantidad de dias por mes
    mov cx,mes                      ;se le mueve al cx, el numero del mes ingresado

    forND:
        mov dl,[bx+si] 
        mov num1,ax
        mov num2,dx 

        push ax
        push bx 
        push cx
        push dx 
        push si  

        sumarDosNumeros num1,num2 

        pop si 
        pop dx 
        pop cx 
        pop bx 
        pop ax 

        mov ax,di 
        inc si 

    loop forND 

    printHexND:                         ;etiqueta que imprime el resultado
        mov nDias,ax 
        inc fila 
        mov columna,20 
        PrintHex nDias,fila,columna
    
EndM 

;imprime los dias restantes de cada final de mes
ImprimirDiasRestantes macro mes, anio, nDiasPorMes, nDias, fila, columna,num1,num2
    local forDR, printHexDR 
    xor ax,ax                       ;se limpia el ax, que se va a usar para almacenar los n dias restantes
    xor bx,bx                       ;se limpia el bx, que se va a usar para obtener cada nDiasPorMes
    xor cx,cx                       ;se limpia el cx, que se va a usar como contador del for
    xor dx,dx                       ;se limpia el dx, que se va a usar para guardar temporalmente cada n dias por mes 
    xor di,di                       ;se limpia el di, que se va a usar para almacenar el resultado de las sumas
    xor si,si                       ;se limpia el si, que se va a usar como index de cada nDiasPorMes
    mov nDias,30h                   ;mueve a nDias un 30h

    mov bx,offset nDiasPorMes       ;se mueve al bx el desplazamiento de la cantidad de dias por mes
    mov cx,12                       ;se le mueve al cx, la cantidad de meses por año
    sub cx,mes                      ;se le resta al cx el mes ingresado
    mov si,12                       ;se le mueve al si, la cantidad de meses por año

    cmp mes,12                      ;se compara el mes con 12
    je printHexDR                   ;en caso de serlo, no se entra al for, ya que tan solo imprime un 0 

    forDR:                          ;for que obtiene los dias restantes de un mes ingresado
        dec si                      ;decrementa el si, para actualizar la posicion actual                    
        mov dl,[bx+si]              ;se guarda los n dias del mes actual en el dl
        mov num1,ax                 ;se le pasa al num1 la sumatoria de los n dias restantes
        mov num2,dx                 ;se le pasa los n dias del mes actual a num2

        push ax                     ;se guarda el ax en la pila
        push bx                     ;se guarda el bx en la pila
        push cx                     ;se guarda el cx en la pila
        push dx                     ;se guarda el dx en la pila
        push si                     ;se guarda el si en la pila

        sumarDosNumeros num1,num2   ;hace la suma del num1 (sumatoria de n dias de los meses) con el num2 (n dias del mes actual) y se guarda en el di

        pop si                      ;se obtiene el valor del si en la pila
        pop dx                      ;se obtiene el valor del dx en la pila
        pop cx                      ;se obtiene el valor del cx en la pila
        pop bx                      ;se obtiene el valor del bx en la pila
        pop ax                      ;se obtiene el valor del ax en la pila

        mov ax,di                   ;se le mueve al ax resultado de la suma
        
    loop forDR                      ;repite el for y decrementa en el contador

    printHexDR:                         ;etiqueta que imprime el resultado
        mov nDias,ax                    ;le mueve a nDias la cantidad de dias restantes
        inc fila                        ;incrementa la fila, para hacer un salto de linea
        mov columna,20                  ;le mueve 20 a la columna para posicionar el cursor
        PrintHex nDias,fila,columna     ;imprime la cantidad de dias restantes
EndM 

;imprime un mes ingresado, con la fecha, numero de semana y dias restantes 
ImprimirMes macro primerDia, mes, anio, nDiasPorMes, nDia, fila, columna,num1,num2,signo
    local whileIM, breakIM, salteIM, sigaIM, noIncrementeCol,noImprimirNegativo,noIncrementarFebrero,noHacerAjuste1582
    PushA                           ;se guardan los registros en la pila
    ObtenerJulianDay mes,anio,num1,num2,signo       ;se obtiene el dia juliano de la fecha ingresada, para saber el primer dia del mes
    mov primerDia,dl                ;se guarda el primer dia del mes        
    PopA                            ;se sacan los registros de la pila

    mov fila,1                      ;pasa la fila en la posicion 0
    mov columna,27                   ;pasa la columna en la posicion 5
    gotoxy fila,columna             ;coloca el cursor
    PrintHex mes,fila,columna       ;se imprime el numero de mes
    
    mov columna,28                   ;pasa la columna a la posicion 6
    gotoxy fila,columna             ;coloca el cursor
    ImprimirCaracter separador      ;imprime el separador (/)
    
    cmp signo,1                     ;verificar si el anio es negativo
    jne noImprimirNegativo          ;de no serlo entonces no imprime el signo menos
    mov columna,29                   ;posiciona la columna en 7
    gotoxy fila,columna             ;posiciona el cursor en la fila y columna ingresada
    ImprimirCaracter signoNegativo  ;imprime el caracter menos

noImprimirNegativo:     
    
    add columna,4                  ;coloca la columna en la posicion 11
    gotoxy fila,columna             ;coloca el cursor 
    PrintHex anio,fila,columna      ;se imprime el numero de anio
    
    add fila,2                      ;se incrementa en 2 posicion de la fila
    mov columna,0                   ;se coloca la columna en 0     
    gotoxy fila,columna             ;se coloca el cursor
    ImprimirMensaje dias            ;se imprime los dias de la semana

    xor ax,ax                       ;se limpia el ax
    xor bx,bx                       ;se limpia el bx
    xor cx,cx                       ;se limpia el cx
    xor si,si                       ;se limpia el si

    mov bx,offset nDiasPorMes       ;coloca el bx en el offset de la cantidad de dias por mes
    mov di,mes                      ;se almacena el numero del mes en di
    dec di                          ;se decrementa la escala del mes de 0 a 11, para obtener los n dias mensuales
    mov cl,[bx+di]                  ;se obtiene la cantidad de dias mensuales y se guarda en el cl
    
    ;VERIFICAR SI EL ANIO ES BISIESTO O NO PARA INCREMENTAR LOS DIAS DE FEBRERO A 29
    cmp mes,2                       ;compara si el mes es 2, para ver si es febrero
    jne noIncrementarFebrero        ;de no serlo entonces no incrementa los n dias de febrero
    EsAnioBisiesto anio             ;de lo contrario entonces se verifica si el anio es bisiesto
    cmp di,1                        ;verifica si es bisiesto (di = 1)
    jne noIncrementarFebrero        ;no es 1 entonces no es bisiesto, por ende no se incrementa febrero
    inc cl                          ;si es 1, incrementa el cl (n dias del mes), lo que significa que febrero tendra 29 dias
    mov nDiasPorMes[di],cl 

    noIncrementarFebrero:
    mov di,cx                       ;se le mueve a di el cx (cantidad de dias del mes)
    mov bl,7                        ;corresponde a la cantidad de dias semanales
    inc fila                        ;se incrementa la fila, para dar un salto de linea
    xor cx,cx                       ;se limpia el cx

    whileIM:
        cmp ax,di                   ;se verifica si ya se llego a imprimir todos los dias del mes
        jne sigaIM                  ;de no ser asi, entonces sigue el while
        jmp breakIM                 ;sino, entonces se sale
        
    sigaIM: 
        mov si,cx                   ;mueve al si el cx (guardar el n dia actual)

        mov cl,al                   ;se mueve al cl el al
        add al,primerDia            ;le agrega al al el primer dia del mes
        mov bx,7                    ;mueve al bx un 7 (n dias de la semana)
        xor dx,dx                   ;limpia el dx 
        div bx                      ;divide el ax (n dia actual + primerDia mensual) entre bx (7)
        mov nDia,dx                 ;le mueve el residuo al nDia, ya que calcula en que dia de la semana debe imprimir

        push si                     ;guarda el si (n dia actual) en la pila
        CalcularPosColumna nDia,columna     ;se calcula la posicion en la que debe estar la columna
        pop si                      ;se saca de la pila el si
        
        ;verificar si el anio es octubre de 1582 DC para quitar los dias fantasmas
        cmp signo,1                 ;compara el signo del anio con 1 (negativo)
        je noHacerAjuste1582         ;de serlo entonces salta a noHacerAjuste1582, ya que el anio no seria DC

        cmp anio,1582               ;comparar el anio con 1582
        jne noHacerAjuste1582       ;de no serlo entonces no hace el ajuste, ya que el anio no es 1582

        cmp mes,10                  ;compara el mes con 10 para ver si es octubre
        jne noHacerAjuste1582       ;de no serlo entonces no hace el ajuste, ya que el mes no es octubre
                                    ;caso en el que la fecha si sea octubre de 1582 DC
        cmp cl,4                    ;compara el n dia actual con 4
        jb noHacerAjuste1582        ;de ser menor entonces no hace el ajuste

        add cl,10                   ;de lo contrario, le suma 10 al dia actual
        push di                     ;guarda el di en la pila
        mov di,9                    ;mueve al di un 9 para modificar los dias de octubre
        mov nDiasPorMes[di],21      ;se ajusta octubre de 31 a 21 dias (dias faltantes)
        pop di                      ;saca el di de la pila
        cmp cl,30                   ;compara si el dia actual es 30
        jbe noHacerAjuste1582       ;de ser menor o igual entonces sigue con el ciclo
        jmp breakIM                 ;de lo contrario se sale del while, ya que indica que se llego al dia final

    noHacerAjuste1582:

        inc cl                      ;incrementa el numero del dia actual    
        mov al,cl                   ;se mueve el dia actual al al
        mov nDia,cx                 ;se mueve el dia actual a nDia

        cmp nDia,10                 ;verifica el dia actual con 10
        jb noIncrementeCol          ;de ser menor, entonces no se incrementa la columna 1 espacio demas
        inc columna                 ;si es 10 o mayor, entonces se incrementa la columna 1 espacio deman

        noIncrementeCol:            ;etiqueta para saltarse el incremento cuando no es necesario
            push si                 ;guarda el si en la pila
            PrintHex nDia,fila,columna  ;se imprime el dia actual    
            inc columna             ;se  incrementa la columna
            pop si                  ;se saca el si de la pila
            inc si                  ;se incrementa el si (dia actual sin modificaciones)
            mov ax,si               ;se le pasa al ax el dia actual
            add al,primerDia        ;se agrega el valor del primer dia al dia actual
            div bl                  ;se divide ese valor entre 7, que son los dias semanales
            
            cmp ah,0                ;se verifica si el residuo es 0
            jne salteIM             ;de no serlo, brinque al final
            inc fila                ;de serlo, se incrementa la fila para hacer un salto de linea

    salteIM:
        mov cx,si                   ;se reinicia el valor del dia actual en el cx
        mov ax,si                   ;y tambien en el ax
        jmp whileIM                 ;se repite el ciclo

    breakIM:                        ;break para salirse del ciclo

    inc fila
    gotoxy fila,columna 
    ImprimirMensaje msjDiasRestan   ;se imprime el mensaje de los dias restantes
    ImprimirDiasRestantes mes, anio, nDiasPorMes, nDia, fila, columna,num1,num2  ;se imprime la cantidad de dias restantes 

    ImprimirMensaje msjNDias
    ImprimirNumeroDelDiaAnual mes, anio, nDiasPorMes, nDia, fila, columna, num1,num2 

    ImprimirMensaje msjNSemana      ;se imprime el mensaje del numero de semana
    ImprimirNumeroSemana mes, anio, nDiasPorMes, nDia, fila,columna,num1,num2    ;se imprime el numero de la semana 
    inc fila 
    gotoxy fila,columna 


EndM

;imprime un anio ingreado
ImprimirAnio macro primerDia, mes, anio, nDiasPorMes, nDia, fila, columna,num1,num2,signo
    local whileIA, whileIA1,  noBreakIA, breakIA, breakIA1 
    mov mes,1                       ;le mueve al mes un 1, para que empiece a imprimir desde enero
    xor cx,cx                       ;limpia el cx
    
    whileIA:        

        mov ah, 00h                 ;mueve un 0 al ah que indica una funcion de video        
        mov al, 03h                 ;mueve un 3 al al, que indica un mode de video 80x25 caracteres
        int 10h                     ;interrupcion del BIOS del video
        
        cmp cl,12                   ;compara el cl con 12 (codicion de salida del while)
        jb noBreakIA                ;de ser menor, entonces no se sale del ciclo
        jmp breakIA1                ;sino, entonces se sale del ciclo
        
    breakIA1:                       ;etiqueta para hacer un doble salto            
        jmp breakIA                 ;se sale del ciclo

    noBreakIA: 
        push cx                     ;guarda el valor del cx en la pila
        
        ImprimirMes primerDia, mes, anio, nDiasPorMes, nDia, fila, columna,num1,num2,signo  ;se imprime el mes actual del anio ingresado

        inc fila                    ;incrementa la fila para hacer un salto de linea
        mov columna,0               ;mueve la columna a la posicio 0    
        gotoxy fila,columna         ;posicion el cursor

        ; Imprime un mensaje en la pantalla
        ImprimirMensaje msjAvanzar  ;imprime el mensaje, que indica que presione cualquier tecla para avanzar

        ; Espera a que se presione una tecla
        mov ah, 00h                 ;mueve al ah un 0, que indica una funcion de lectura del teclado
        int 16h                     ;interrupcion BIOS del teclado

        ; Avanza a la siguiente pÃ¡gina
        mov ah, 06h                 ;indica una funcion de scroll de ventana
        mov al, 01h                 ;indica al scroll una linea hacia arriba
        int 10h                     ;interrupcion del BIOS del video

        inc mes                     ;incrementa el mes                     
        pop cx                      ;recupera el valor del cx de la pila    
        inc cl                      ;incrementa el contador del cl

        jmp whileIA1                ;repite el ciclo    
        
    whileIA1:                                       
        jmp whileIA                 ;doble salto, para poder repetir el ciclo

    breakIA:                        ;se sale del ciclo
EndM

;posiciona el cursor en una fila y columna ingresada
gotoxy macro fil,col    
    push bx                         ;guarda el bx en la pila
    push ax                         ;guarda el ax en la pila 
    mov ah,02h                      ;funcion 02h para mover el cursor de la interrupcion 10h
    mov bh,0                        ;mueve al bh un 0 (# pagina)
    mov dh,fil                      ;posiciona la fila 
    mov dl,col                      ;posiciona la columna
    int 10h                         ;interrupcion 10h
    pop ax                          ;saca el ax de la pila 
    pop bx                          ;saca el bx de la pila 
    
EndM

;limpia la pantalla 
limpiarPantalla Macro 
    pushA                           ;guarda los registros en la pila 
    mov ah,07h                      ;funcion 07h de la interrupcion 10 
    mov al,0
    mov bh,0fh                      ;le mueve al bh 
    mov ch,00                       ;fila esquina superior izquierda en 0
    mov cl,00                       ;columna esquina superior izquierda en 0
    mov dh,25                       ;fila esquina inferior derecha en 25
    mov dl,80                       ;columna esquina inferior derecha en 80
    int 10h                         ;interrupcion 10h
    popA                            ;se sacan los registros de la pila
EndM

;suma dos numeros en cuyo resultado sea menor a 0ffffh y guarda el resultado en el di 
sumarDosNumeros macro num1, num2 
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

        cmp num1,0              ;se compara el num1 con 0
        jne seguirSN            ;de no serlo sigue la suma
        cmp num2,0              ;compara el num2 con 0
        jne seguirSN            ;de no serlo sigue con la suma   
        cmp cx,0                ;compara el cx con 0 (indica que ya no hay nada que sumar)
        je breakSN              ;de serlo entonces se sale del ciclo
        

    seguirSN:

        xor ax,ax               ;limpia el ax
        xor dx,dx               ;limpia el dx
        mov ax,num1             ;mueve al ax el num1

        div bx                  ;divide el ax entre bx (num1 / 10)
        mov num1,ax             ;se guarda el conciente en el num1 (se le quita el digito menos significativo)
        push di                 ;se guarda el di en la pila
        mov di,dx               ;se guarda el residuo en el di (digito menos significativo)

        xor ax,ax               ;limpia el ax
        xor dx,dx               ;limpia el dx
        mov ax,num2             ;mueve al ax el num2

        div bx                  ;divide el ax entre bx (num2 / 10)
        mov num2,ax             ;se guarda el conciente en el num2 (se le quita el digito menos significativo)
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
EsAnioBisiesto macro anio
    local comparacion2, comparacion3,noEsBisiesto,siEsBisiesto,salirAB

    push ax                         ;se guarda el ax en la pila               
    
    xor ax,ax                       ;se limpia el ax
    xor bx,bx                       ;se limpia el bx
    xor dx,dx                       ;se limpia el dx
    xor di,di                       ;se limpia el di
    
    ;revisar si el anio es divisible entre 4 
    mov ax,anio                     ;se mueve el anio al ax
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
    mov ax,anio                     ;se le mueve al ax el anio
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
    mov ax,anio                     ;se mueve el anio al ax
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
ObtenerJulianDay macro mes,anio,num1,num2,signo
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
    mov di,mes                              ;se mueve el mes al di           
    mov si,anio                             ;se mueve el anio al si

    cmp signo,1                             ;se verifica si el signo del anio es 1 (negativo->ac)
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
    cmp anio,1582                           ;se compara si el anio es 1582 (caso especial)
    je es1582                               ;de serlo entonces se salta a es1582
    ja noPonerBEn0                          ;sino entonces se salta a noPonorBEn0 (B-> calculo extra)

ponerBEn0:                                  ;se pone el B en 0 de octubre de 1582 hacia atras     
    mov dl,0                                ;mueve al dl (B->calculo extra) un 0
    jmp calculoFinal                        ;salta al calculoFinal

es1582:                                     ;caso en el que sea 1582
    cmp mes,11                              ;compara el mes con 11 (ver si es octubre o inferior)
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

    cmp signo,1                             ;ver si el anio es negativo
    je restar2                              ;si es negativo se hace una resta
    jne sumar2                              ;si es positivo se hace una suma

restar2:                                    ;caso en el que el anio sea negativo (AC)             
    mov ax,4716                             ;se mueve al ax el constante (4716) 
    sub ax,si                               ;se le resta a ax (4716) con el si (anio) 
    mov di,ax                               ;se le mueve al di ese resultado                      
    jmp seguirCJL                           ;salta a seguirCJL (calculo julian day)
sumar2:                                     ;caso en el que el anio sea positivo (DC)                         
    mov num1,si                             ;se le mueve al num1 el si (anio)
    mov num2,4716                           ;se le mueve la constante (4716) a num2
    sumarDosNumeros num1,num2               ;se hace la suma de esos dos numeros y se guarda en el di
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

    mov num1,cx                             ;le pasa a num1 el cx (cuarta parte de Y+4716)
    mov num2,dx                             ;le pasa a num2 el dx (digitos menos significativos de 365*(y+4716))
    push ax                                 ;guarda el ax (digitos mas significativos de 365*(y+4716)) el la pila
    sumarDosNumeros num1,num2               ;suma ambos numeros y lo guarda en el di
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

    mov num1,ax                             ;le pasa al num1 el ax [(M+1)*3 / 5]

    mov ax,di                               ;le pasa al ax el di (M+1)
    xor dx,dx                               ;limpia el dx
    mov bx,30                               ;le mueve al bx un 30
    mul bx                                  ;multiplica el ax (M+1) por bx (30)

    mov num2,ax                             ;se le pasa a num2 el ax [30*(M+1)]

    sumarDosNumeros num1,num2               ;suma ambos numeros [(M+1)*3 / 5] + [30*(M+1)] y lo guarda en di

    pop dx                                  ;se obtiene el dx de la pila
    pop ax                                  ;se obtiene el ax de la pila

    mov num1,dx                             ;se le pasa a num1 el dx (digitos menos significativos de 365*(y+4716))
    mov num2,di                             ;le pasa a num2 el di [(M+1)*3 / 5] + [30*(M+1)]
    push ax                                 ;guarda el ax en la pila
    push dx                                 ;guarda el dx en la pila
    sumarDosNumeros num1,num2               ;suma el ambos numeros (digitos menos significativos + [(M+1)*3 / 5] + [30*(M+1)])
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
    mov num1,cx                             ;mueve a num1 el cx (digitos menos sigficativos del calculo)
    mov num2,bx                             ;mueve a num2 el bx (B)

    sumarDosNumeros num1,num2               ;se suman ambos numeros y queda el resultado en el di

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

    mov num2,ax                             ;le pasa al num2 el ax (dos digitos mas significativos de los digitos menos significativos del calculo)
    pop ax                                  ;se obtiene el ax de la pila
    mov num1,ax                             ;le pasa a num1 el ax (los digitos mas significativos del calculo con dos ceros a la derecha)
    push dx                                 ;se guarda el dx en la pila
    sumarDosNumeros num1,num2               ;se suman ambos numeros
    pop dx                                  ;se obtiene el dx de la pila
    mov ax,di                               ;se le mueve el resultado del di (5 digitos mas significativos del calculo) al ax 

    mov num1,ax                             ;mueve al num1 el ax (5 digitos mas significativos del calculo)
    mov num2,dx                             ;mueve al num2 el dx (2 digitos menos significativos del calculo)

    ;proceso para dejar los registros con los valores correspondientes para poder dividir entre 7 y obtener el primer dia del mes
    ConvertirNumeroABinario num1,num2       ;se convierte el calculo del julian day a binario
    GuardarBitsEnAxYDX julianDayBinario     ;y se guardan los primeros 16 bits en el ax y los restantes en el dx 

    ;proceso para obtener el primer dia del mes
    mov bx,7777                             ;se le pasa un 7777 al bx, ya que dividir entre 7 provoca un desbordamiento
    div bx                                  ;se divide el dia juliano entre 7777

    mov bx,7                                ;mueve al bx un 7
    mov ax,dx                               ;mueve los 8 bits menos significativos al ax
    xor dx,dx                               ;limpia dx        
    div bx                                  ;divide el ax (8 bits menos significativos) entre el bx (7), para obtener el restos que corresponde a un dia de la semana
EndM

;recibe el numero en dos partes y lo convierte a su equivalencia binaria de max 24 bits
ConvertirNumeroABinario macro parteAlta,parteBaja 
    local whileCB1,breakCB1,whileCB2,breakCB2

    ;PROCESO PARA CONVERTIR UN NUMERO DE 7 DIGITOS A BINARIO
    mov ax,parteAlta                        ;se guarda la parte alta del numero en el ax   
    mov dx,parteBaja                        ;se guarda la parte baja del numero en el dx

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
        mov [julianDayBinario + si], dl     ;se guarda el resto (bit) en el julianDayBinario, segun la pos actual
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
        mov num1,ax                         ;se le mueve al num1 el ax (digito menos significativo con 2 ceros a la derecha
        mov num2,dx                         ;se le mueve al num2 el dx (parte baja sin actualizar)
        push si                             ;guarda el si en la pila (index de los bits)
        push cx                             ;guarda el cx en la pila (parte alta actualizada)
        sumarDosNumeros num1,num2           ;le agrega al digito menos significativo sin actualizar la parte baja
        
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
    mov num1,ax                             ;se le pasa la parte alta actualizada con dos ceros a num1
    mov num2,dx                             ;se le pasa la parte baja actualizada al num2

    push si                                 ;se guarda el si (index de los bits) en la pila
    sumarDosNumeros num1,num2               ;se une la parte alta y baja actualizada en el di
    pop si                                  ;se recupera el si de la pila (index de bits)
    mov ax,di                               ;se le pasa el numero unido al ax

    ;proceso para terminar de obtener la conversion en bits del las ultima 4 cifras
    whileCB2:    

        mov bx,2                            ;se le pasa un 2 al bx
        xor dx,dx                           ;se limpia el dx
        div bx                              ;se divide el numero entre 2

        mov [julianDayBinario + si],dl      ;se guarda el resto en el julianDayBinario en la pos actual
        dec si                              ;se decrementa el si (index de bits)

        cmp ax,0                            ;se compara si el numeo ya llego a ser 0
        je breakCB2                         ;de ser cero, entonces se sale del ciclo
        jmp whileCB2                        ;sino entonces continua el ciclo
    breakCB2:                               ;salida del ciclo dos
EndM 

;recibe los 24 bits y los guarda en el registro ax (primeros 16 bits) y dx (8 bits restantes)
GuardarBitsEnAxYDX macro julianDay
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
        
        mov bl, [julianDayBinario + si]     ;mueve al bl el bit actual 
        mov [julianDayBinario + si],0       ;se limpia el bit actual para que este listo en futuras llamadas
        
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
CalcularPosColumna macro nDia,columna 
    local whileCC,noDecrementarColumna,breakCC 

    push ax                                 ;se guarda el ax, en la pila
    push bx                                 ;se guarda el bx en la pila
    push cx                                 ;se guarda el cx en la pila
    push dx                                 ;se guarda el dx en la pila

    xor ax,ax                               ;se limpia el ax 
    xor si,si                               ;se limpia el si
    xor dx,dx                               ;se limpia el dx
    mov columna,0                           ;se inicializa la columna en 0
    
    whileCC:
        mov al,nCaracteresPorDia[si]        ;se le pasa al al los n caracteres del nombre completo de un dia de la semana
        mov cl,al                           ;se le pasa esos n caracteres al cl
        mov bx,2                            ;se le pasa al bx un 2
        xor dx,dx                           ;se limpia el dx 
        div bx                              ;se divide el ax (n caracteres del nombre completo de un dia de la semana) entre bx (2)
        add columna,al                      ;se le agrega a columna ese cociente de la division (posiciona en la mitad del nombre del dia)

        xor bx,bx                           ;se limpia el bx 
        mov bx,nDia                         ;se le mueve el nDia ingresado al bx  
        inc si                              ;se incrementa el si (pos actual los n caracteres de los dias)
        cmp si,bx                           ;compara el si (pos actual) con bx (n dia ingresado)
        ja breakCC                          ;en caso de ser mayor entonces sale del ciclo

        add columna,al                      ;se le agrega a la columna el al (los n caracteres restantes del nombre del dia)
        add columna,4                       ;se le agrega 4 a la columna (3 espacios entre cada nombre + 1 para posicionarlo en la inicial del nombre del siguiente dia)

        mov al,cl                           ;se le mueve al al el cl (los n caracteres del nombre del dia actual)
        mov bl,2                            ;se le mueve al bl un 2
        div bl                              ;se divide el al (n caracteres) entre bl (2)

        cmp ah,0                            ;compara si el resto es 0
        jne noDecrementarColumna            ;de no serlo no se decrecrementa la columna
        dec columna                         ;de lo contrario si la decrementa (n caracteres pares no tienen resto entonces no ocupa sumarle el 1 de mas)

        noDecrementarColumna:                  ;salto para no decrementar la columna        
            xor ax,ax                       ;limpia el ax 

        jmp whileCC                         ;se repite el ciclo
    breakCC:                                ;se sale del ciclo

    pop dx                                  ;se saca de la pila el dx
    pop cx                                  ;se saca de la pila el cx
    pop bx                                  ;se saca de la pila el bx 
    pop ax                                  ;se saca de la pila el ax
EndM

;guarda todos los registos en la pila
PushA Macro 
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
PopA Macro 
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