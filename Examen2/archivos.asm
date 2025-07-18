extrn GetCommanderLine:Near
include macrosA.asm

Datos Segment
    LineCommand db    0FFh Dup (?)
    ayuda       db "Bienvenido y gracias por usar mi calendario:",10,13,
                db   "la forma de usarlo es la siguiente",10,13,
                db   "ingrese: compi nombrePrograma procedim opcion",10,13,
                db   " si desea imprimir fechas, ingrese por commander line, con el formato: /a#anio/m#mes/",10,13,
                db   "   ",10,13,
                db   "   donde /: es el separador",10,13,
                db   "         a: indica que es el anio",10,13,
                db   "         m: indica que es el mes",10,13,
                db   "         #mes: es un numero entre 1 y 12",10,13,
                db   "         #anio: es un numero entre -5777 y 7777",10,13,
                db   " para convertir a juliano, lo mismo pero agregue al final j/",10,13,
                db   " para ingresar al manejo de archivos escriba solo: /f/",10,13,"$"

    mes         dw ?
    anio        dw ?
    
    nDiasSemanales EQU 7
    nDiasPorMes db 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    dias        db "s   domingo   lunes   martes   miercoles   jueves   viernes   sabado$",10,13
    dias2       db "    Do Lu Ma Mi Ju Vi Sa   $"
    separador   db "/$" 
    signoNegativo  db "-$" 
    primerDia   db ?
    fila        db ?
    columna     db ?
    nDia        dw ?
    msjFecha    db 10,13,"Fecha: $"
    msjDiasRestan   db 10,13,"Dias restantes: $"
    msjAvanzar  db 'Presione cualquier tecla para visualizar el siguiente mes...$' 
    msjNDias    db 10,13,"N dia de los 365: $"
    msjNSemana      db 10,13,"Numero de semana: $"
    num1        dw ?
    num2        dw ?
    num3        dw ?
    julianDayBinario db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
    signo       db 0 
    nCaracteresPorDia db 7,5,6,9,6,7,6
    nameMeses   db "Ene$", "Feb$", "Mar$"
    nameMes     db  ?
    ene         db "Ene$"
    feb         db "Feb$"
    mar         db "Mar$"
    abr         db "Abr$"
    may         db "May$"
    jun         db "Jun$"
    jul         db "Jul$"
    ago         db "Ago$"
    sep         db "Sep$"
    oct         db "Oct$"
    nov         db "Nov$"
    dic         db "Dic$"
    columnaActual db 5
    filaActual  db 1
    flag        db 0
    cont        dw ?

    ;variables del manejo de archivos
    EOF          dw 0h
	handle		 dw ?
    handle2      dw ?
	buffer       db ?
	MensajeError db "Error de operacion sobre el archivo",10,13,"$"
    file        db "        .txt", 0  ; Espacios en blanco para el nombre de 8 caracteres
    buffer2 db "         $" 
    recordatorio  db 255,?,255 dup (?),"$"  
    fecha   db 255,?,255 dup (?),"$"   
    solicitarFecha  db " Ingrese la fecha con el formato ddmmaaaa, sin espacios",10,13,
                    db  "En donde dd = dia, mm = mes y aaaa = anio",10,13
                    db  "Si el mes o el dia es de un digito, completelo con un 0 a la izquierda",10,13,"$"

    solicitarRecordatorio db 10,13," Ingrese el nuevo recordatorio", 10,13,"$"
    
    menuAgenda      db  "Menu de la agenda",10,13,
                    db  "1) Ingresar recordatorio",10,13,
                    db  "2) Desplegar recordatorio",10,13,
                    db  "3) Borrar recordatorio",10,13,
                    db  "4) Salir",10,13,
                    db  "Ingresa la opcion que desea: $"

    contrasegna  db 255,?,255 dup (?),"$"
    msjRecordatorio    db "Recordatorios de la fecha ingresada",10,13,"$"

    opcionAgenda    db ?
    saltoLinea      db  10,13,"$"   
    msjConvJD   db "La conversion a juliano es: $" 

Datos EndS

Codigo Segment
    Assume cs:Codigo, ds:Datos

Inicio:
    mov ax,Datos                        ;Inicializa el segmento de dato
    mov ds,ax                           ;para poder utilizar las variables

    LimpiarPantalla 
    ImprimirMensaje ayuda
    LeerTecla al 
    LimpiarPantalla

leerEntrada:                            ;se lee la entrada de datos (mes y/o anio)

    push ds                             ;guarda el segmento de datos en la pila
    Mov   Ax,Seg LineCommand            ; sp + 4
    Push  Ax
    Lea   Ax,LineCommand			    ; sp + 2 
    Push  Ax
    call  GetCommanderLine		        ; sp
    pop ds                              ;saca el valor de segmento de dato de la pila
    
    mov si,9
    cmp LineCommand[si],'/'             ;se verifica si el caracter actual de la entrada de datos es '/'
    ;jne salga1      
    inc si                              ;se incrementa el si (pos actual de la entrada de datos)                      

    cmp LineCommand[si],'f'
    jne comprobarPrinAnio
    inc si
    jmp hacerManejoArchivos 

comprobarPrinAnio:
    cmp LineCommand[si],'a'             ;se verifica si el caracter actual de la entrada de datos es 'a', (indica que se ingreso el anio)
    inc si                              ;se incrementa el si (pos actual de la entrada de datos) 

    cmp LineCommand[si],'-'             ;se verifica si el caracter actual de la entrada de datos es '-' (indica que se ingreso un anio AC)
    jne dejarSignoPositivo              ;de no serlo, entonces salta a dejarSignoPositivo (el anio es DC)
    mov signo,1                         ;de serlo, entonces el anio es negativo (AC)
    inc si                              ;se incrementa el si (pos actual de la entrada de datos)

dejarSignoPositivo:                     ;deja el signo en del anio en 0
    ObtenerDatoEntrada LineCommand, si  ;se llama a obtenerDatoEntrada, para guardar el anio ingresado (resultado en ax)
    mov anio,ax                         ;se le mueve al anio, el ax (anio ingresado por el usuario)
verificacion1:                          ;primera verificacion (revisar que el anio no sea cero)
    cmp anio,0                          ;se compara el anio ingresado con 0
    je salga1                           ;en caso de serlo entonces cierra el programa, ya que el anio 0 no existe

verificacion2:                          ;segunda verificacion, ver si el anio es positivo o negativo (AC o DC)
    cmp signo,1                         ;compara el signo del anio con 1 (negativo)
    jne verificacion4                   ;en caso de no serlo pasa la cuarta verificacion        

verificacion3:                          ;tercera verificacion, se revisa que el anio no sea anterior al -5777, ya que este es el limite inferior del programa
    cmp anio,5777                       ;compara el anio con -5777
    ja salga1                           ;en caso de ser mayor entonces se sale, ya que esto indica que sobrepaso el limite del programa
    jbe esPrintAnualOMensual            ;de ser menor o igual, entonces salta a verificar si hay que hacer el print mensual o anual

verificacion4:                          ;cuarta verificacion, se revisa que el anio no sea superior al 7777, ya que ese el limite superior del programa
    cmp anio,7777                       ;compara el anio con 7777
    ja salga1                           ;en caso de ser mayor, entonces se sale, ya que esto indica que sobrepaso el limite del programa

esPrintAnualOMensual:                   ;se verifica si se ingreso un mes especifico a desplegar
    inc si                              ;se incrementa el si (pos actual de la entrada de datos)
    cmp LineCommand[si],'m'             ;se compara si la pos actual es una m (indica que se ingreso un mes)
    je obtenerMes                       ;en caso de serlo, entonces salta a leer el mes ingresado
    jmp hacerPrintYear1                 ;de lo contrario entonces hace el print de todo el anio, ya que no se ingreso un mes en especifico

salga1:                                 ;salta a la salida del programa
    jmp salir                           

hacerPrintYear1:                        ;salta a hacer el print de todos los meses del anio ingresado
    jmp hacerPrintYear

obtenerMes:                             ;obtiene el mes en caso de haber sido ingresado 
    inc si                              ;incrementa el si (pos actual de la entrada de dato)
    ObtenerDatoEntrada LineCommand, si  ;se obtiene el mes ingresado por el usuario y se guarda en el ax 
    mov mes,ax                          ;se mueve el ax (mes ingresado) a mes

    cmp mes,12                          ;compara el mes con 12 (limite superior de los meses)
    ja salga2                           ;en caso de ser mayor se sale del programa, ya que el mes ingresado supera el limite superior        
    jmp hacerPrintMes                   ;de lo contrario entonces hace el print del mes ingresado

salga2:                                 ;sale del programa
    jmp salir

hacerManejoArchivos:
    mov fila,0 
    mov columna,0
    gotoxy fila,columna 
    DesplegarOpcionesArchivo menuAgenda
    jmp salir 

hacerPrintMes:
    inc si 
    cmp LineCommand[si],'j'
    jne hacerPrintMes2
    jmp hacerConversionAJuliano

hacerPrintMes2:
    ImprimirMes primerDia, mes, anio, nDiasPorMes, nDia, fila, columna,num1,num2,signo ;se hace el print del mes ingresado
    jmp salir                           ;sale del programa

hacerPrintYear:
    ImprimirAnio2 primerDia, mes, anio, nDiasPorMes, nDia, fila, columna,num1,num2,signo ;se hace el print de todo el anio ingresado
    jmp salir                           ;sale del programa

hacerConversionAJuliano:
    ImprimirConversionAJuliano mes,anio,signo 
    jmp salir

salir:
    mov ax,4c00h
    int 21h

Codigo Ends
    End Inicio