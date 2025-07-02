#include <iostream>
#include <string>
#include <windows.h>
#include <stdlib.h>
#include <conio.h>
#include <cmath>

using namespace std;

bool isJulianLeapYear(int anio) {
    if (anio % 4 == 0 && (anio % 100 != 0 || anio % 400 == 0)) {
        return true;
    }
    return false;
}

int toJulianDay(int year, int month) {

}

void julianToGregorian(int julianDay, int& year, int& month, int& day) {
    int JD = julianDay - 1721119;
    int century = (JD - 1) / 36524;
    int remainingDays = JD - century * 36524;
    int quadricent = remainingDays / 146097;
    remainingDays -= quadricent * 146097;
    int leapYears = remainingDays / 36524;
    remainingDays -= leapYears * 36524;
    int yearNum = remainingDays / 365;
    remainingDays -= yearNum * 365;
    if (leapYears == 4 || yearNum == 0 && remainingDays == 0) {
        year = quadricent * 400 + century * 100 + leapYears * 4 + 4;
        month = 2;
        day = 29;
    } else {
        year = quadricent * 400 + century * 100 + leapYears * 4 + yearNum;
        if (yearNum == 4 || remainingDays == 0) {
            month = 12;
            day = 31;
        } else {
            month = (remainingDays + 50) / 31;
            day = remainingDays - (month * 31 - 29) / 16;
        }
    }
}



//coloca el cursor en las coordenadas x,y, según los valores recibidos
void gotoxy(short x, short y){
   HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE); // obtiene el identificador de la consola
   COORD pos = {x, y}; // crea una estructura COORD con las coordenadas
   SetConsoleCursorPosition(hConsole, pos); // establece la posición del cursor
}

bool isLeapYear(int year) {
    if (year % 4 == 0) {
        if (year % 100 == 0) {
            if (year % 400 == 0)
                return true;
            else
                return false;
        }
        else
            return true;
    }
    else
        return false;
}

void printMonth(int firstDay, int month, int year){
    int daysPerMonth [] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    const string days [] = {"domingo", "lunes", "martes", "miercoles", "jueves", "viernes", "sabado"};
    const string months [] = {"enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"};
    int x = 0,y = 0;

    if(isLeapYear(year)){
        daysPerMonth[1] += 1;
    }

    cout << "\n\t\t\t\t\t\t" << months[month - 1] << " de " << year << endl << endl;

    //y = 5;
    for(int i = 0; i < 7; i++){
        x += 10;
        if(i == 3){
            cout << days[i] << "\t";
        }
        else{
            cout << days[i] << "\t\t";
        }
    }

    cout << endl;


    for(int i = 0; i < firstDay; i++){
        cout << "\t\t";
    }

    for(int i = 1; i < daysPerMonth[month-1] + 1; i++){

        cout << i << "\t\t";

       /* if(i == firstDay -1){
            cout << endl;
        }*/

         if((i+firstDay) % 7 == 0){
            cout << endl;
        }

    }
}

void printDay(int day){
    if(day == 0){
        cout << "domingo" << endl;
    }
    else if(day == 1){
        cout << "lunes" << endl;
    }

    else if(day == 2){
        cout << "martes" << endl;
    }

    else if(day == 3){
        cout << "miercoles" << endl;
    }
    else if(day == 4){
        cout << "jueves" << endl;
    }
    else if(day == 5){
        cout << "viernes" << endl;
    }
    else if(day == 6){
        cout << "sabado" << endl;
    }
}

int getDoomDayOfMonth(int month, int year){
    int doomDayOfMonth = 0;

    if(month == 1){
        if(!isLeapYear(year)){
            doomDayOfMonth = 3;
        }

        else{
            doomDayOfMonth = 4;
        }
    }

    else if(month == 2){
        if(!isLeapYear(year)){
            doomDayOfMonth = 7;
        }

        else{
            doomDayOfMonth = 1;
        }
    }

    else if(month == 3){
        doomDayOfMonth = 14;
    }

    else if(month == 4){
        doomDayOfMonth = 4;
    }

    else if(month == 5){
        doomDayOfMonth = 9;
    }

    else if(month == 6){
        doomDayOfMonth = 6;
    }

    else if(month == 7){
        doomDayOfMonth = 11;
    }

    else if(month == 8){
        doomDayOfMonth = 8;
    }

    else if(month == 9){
        doomDayOfMonth = 5;
    }

    else if(month == 10){
        doomDayOfMonth = 10;
    }

    else if(month == 11){
        doomDayOfMonth = 7;
    }

    else if(month == 12){
        doomDayOfMonth = 12;
    }

    return doomDayOfMonth;
}

int firstMonthDay(int doomDay, int month, int year){
    int doomDayOfMonth = getDoomDayOfMonth(month, year);

    while(doomDayOfMonth > 1){
        doomDay--;

        if(doomDay < 0){
            doomDay = 6;
        }

        doomDayOfMonth--;
    }

    cout << "\nPrimer dia del mes: ";
    printDay(doomDay);
    return doomDay;
}

int getNDigits(int num){
    int n = 0;
    while(num != 0){
        num /= 10;
        n++;
    }
    return n;
}

int doomsDayOfYear(int doomDay, int dosUltimasCifras){
    int num1, num2, num3, suma;

    num1 = dosUltimasCifras / 12;
    num2 = dosUltimasCifras % 12;
    num3 = num2 / 4;

    suma  = num1 + num2 + num3;

    suma %= 7;

    doomDay += suma;

    doomDay %= 7;

    cout<< "Doomsday: " << doomDay << endl;


    cout << "Doomsday del anio: ";
    printDay(doomDay);
    return doomDay;
}

int doomsDayOfCentury(int month, int year){
    //20 de enero de 2023

    int nDigits = 0, num2 = 0, day = 0, dosUltimasCifras = 0;
    int doomDay = 0;

    nDigits = getNDigits(year);

    if(nDigits > 0){
        num2 = year / 100;
        dosUltimasCifras = year % 100;
    }

    num2 %= 4;

    cout<< "Mod: " << num2 << endl;


    if(num2 == 0){
        day = 2;
    }

    else if(num2 == 1){
        day = 0;
    }

    else if(num2 == 2){
        day = 5;
    }

    else if(num2 == 3){
        day = 3;
    }

    doomDay = doomsDayOfYear(day, dosUltimasCifras);

    return doomDay;
}

int main(){

    int year = 0, month = 0, firstDay = 0, julianDay = 0, day = 1;



    /*
    cout << "Ingrese el anio: ";
    cin >> year;

    cout << "Ingrese el mes: ";
    cin >> month;


    firstDay = firstMonthDay(doomsDayOfCentury(month, year), month, year);

    printMonth(firstDay, month, year);
    */
    //245848 = 1
    //2458485
    //2457910
    //9456235

    julianDay = 2269269;

    int r = (julianDay ) % 7777;
    cout << r << endl;
    cout << r % 7 << endl;

    cout << "Esto es el resultado que debe dar: " << (2269267+2) % 7 << endl;

    julianDay = 2458;

    int r1 = (julianDay ) / 777;    //127




    //julianToGregorian( julianDay, year, month, day);

    //cout << year << month << day;

    return 0;
}
