#include <stdio.h>

int variable;               //variable local
extern dato;                //dato externo
extern imprimirAnio();      //funcion que impreme un anio ingresado
extern imprimirMes();       //funcion que imprime un mes ingresado
extern conversorAJuliano(); //funcion que convierte una fecha gregoriana a juliana
extern double resultado;    //se guarda el resultado de la conversion a juliano

int main(){
    int Y = 0;   //anio  
    int M = 0;   //mes
    int D = 0;   //dia
    int S = 0;   //signo del anio
    int opcion = 0; //opcion escogida por el usuario

    system("cls"); // Limpia la pantalla

    //meu principal
    printf("       Menu Principal \n"       );
    printf("1. Convertir fecha a juliano\n");
    printf("2. Imprimir calendario mensual\n");
    printf("3. Imprimir calendario mensual\n");
    printf("4. Salir\n");

    printf("\nIngrese la opcion que desea realizar: ");
    scanf("%d", &opcion); 

    system("cls"); // Limpia la pantalla

    //opcion 1 -> conversor a juliano
    if(opcion == 1){
        //se solicitan los datos
        printf("Ingrese un anio entre 1583 y 7777: ");
        scanf("%d", &Y);

        printf("Ingrese el mes: ");
        scanf("%d", &M);

        printf("Ingrese el dia: ");
        scanf("%d", &D);
        //se verifica que los datos ingresados enten dentro de los limites permitidos
        if(Y >= 1583 && Y <= 7777 && Y != 0 && M > 0 && M <= 12 && D > 0 && D <= 32){
            variable = conversorAJuliano(Y, M, D);
            printf("\nEl resultado de la conversion es:  %ld",resultado);
        }
        else{   //de no estarlo, se le manda el aviso al usuario
            printf("\nPor favor, asegurece de ingresar los datos correctamente");
        }
        getch();        //pausa para mostrar la impresion
    }

    //option 2 -> desplegar el calendario mensual 
    else if(opcion == 2){   
        //se solicitan los datos necesarios
        printf("Ingrese un anio entre -5777 a 7777: ");
        scanf("%d", &Y);

        printf("Ingrese el mes: ");
        scanf("%d", &M);
        system("cls"); // Limpia la pantalla

        //se verifica que los datos ingresados esten dentro de los limites permitidos
        if(Y >= -5777 && Y <= 7777 && Y != 0 && M > 0 && M <= 12){
            if(Y < 0){  //caso en que el anio sea negativo (ac)
                S = 1;  //se pone el signo de negativo en 1
                Y *= -1;    //se pone positivo el anio
            }
            imprimirMes(Y, M, S);   //se llama a la funcion que imprime un mes ingresado
        }
        else{   //se manda el aviso al usuario en caso de haber ingresado mal los datos
            printf("\nPor favor, asegurece de ingresar los datos correctamente");
        }
        getch();                //pausa para poder ver el print 
    }
    
    //option 3 -> se realiza el despliegue anual 
    else if(opcion == 3){
        //se solicitan los datos necesarios
        printf("Ingrese un anio entre -5777 a 7777: ");
        scanf("%d", &Y);
        system("cls"); // Limpia la pantalla
        //se verifica que esten dentro de los limites permitidos
        if(Y >= -5777 && Y <= 7777 && Y != 0){
            if(Y < 0){      //caso en el que el anio sea negativo
                S = 1;      //se pone el signo del anio en 1
                Y *= -1;    //se pone el anio en positivo
            }
            imprimirAnio(Y, S);     //se llama a la funcion que imprime el anio por completo
        }
        else{   //se manda un aviso al usuario en caso de haber ingresado mal algun dato
            printf("\nPor favor, asegurece de ingresar los datos correctamente");
        }
        getch();            //pausa para poder ver el print
    }

    return 0;
}