Procedimientos Segment 
    public GetCommanderLine

    Assume cs:Procedimientos 

    GetCommanderLine Proc Near
        LongLC    EQU   80h
      
        Mov   Bp,Sp                     ;establece un punto de referencia para acceder a los parametros y varibles locales de la pila
        Mov   Ax,Es                     ;mueve al ax el valor del segmento extra
        Mov   Ds,Ax                     ;mueve al ds el ax, pata que apunte al es
        Mov   Di,2[Bp]                  ;mueve al di la direccion de memoria de LineCommand
        Mov   Ax,4[Bp]                  ;mueve al ax el segmento de direccion de memoria del LineCommand
        Mov   Es,Ax                     ;mueve al es el segmento de direccion de memoria del LineCommand 
        Xor   Cx,Cx
        Mov   Cl,Byte Ptr Ds:[LongLC]   ;mueve al cl el largo de la entrada ingresada
        dec   cl                        ;decrementa el cl 
        Mov   Si,2[LongLC]              ;mueve al si [LongLC+2]
        cld                             ;limpia el bit de dirección del registro de flags 
        Rep   Movsb                     ;repite la operacion de mover byte segun el contenido del cl, para guardar la entrada en LineCommand

        Ret   2*2				        ; pop de linea de comando seg y offset.
        
    GetCommanderLine EndP

Procedimientos Ends 
End