# Doomday ASM + Turbo C + Java

A calendar computing project combining Assembly (x86), Turbo C, and Java GUI development — inspired by the Doomsday algorithm and rooted in low-level architecture studies.

## 🧠 Project Context

This project was developed as part of the **Computer Architecture** course (IC-3101) at the **Technological Institute of Costa Rica**, under the guidance of Prof. Carlos Benavides. The aim was to bridge theoretical knowledge of low-level architecture with practical implementations using assembly language and GUI-based interfaces in Turbo C and Java.

## 📅 Problem Statement

The Gregorian calendar, widely used today, replaced the Julian calendar due to inaccuracies in its leap year calculations. This project focuses on computing calendar dates accurately using the **Doomsday algorithm** (proposed by John Horton Conway) or any equivalent method. It corrects previous issues with Julian date calculations by incorporating floating-point operations using the **x87 FPU**, and it enhances user interaction through GUI interfaces.

## 🛠️ Implementations

This repository includes:
- An **x86 Assembly** program that calculates Gregorian calendar data from -5777 to 7777.
- A **Turbo C** application linked to the ASM component, with a user interface.
- A **Java** application also linked to the ASM component via graphical interface.

## 🧩 Key Features

- Gregorian calendar rendering by **month** or **year**, with full weekday names (e.g., Sunday, Monday).
- Supports historical transition from Julian to Gregorian (e.g., 5th to 15th October 1582).
- User input via **command-line arguments** with optional help flags.
- Displays:
  - The day of the week for a given date.
  - The **ordinal day** of the year (e.g., 112th day).
  - Days remaining in the year.
- Handles leap years and absence of year zero.
- GUI integration in both **Java** and **Turbo C**.
- All parameters passed using **stack-based procedures**.
- Internal code structure based on **modular libraries and macros**.

## 🎯 Educational Objectives

- Gain hands-on experience in **x86 Assembly programming**.
- Learn to integrate ASM with higher-level languages (C/Java).
- Develop better understanding of **stack usage**, **FPU operations**, and **calendar computation logic**.
- Reinforce theoretical computer architecture concepts with practical applications.

## 📚 References

- [Doomsday Algorithm – AmmanU Wiki](http://www.ammanu.edu.jo/wiki1/es/articles/a/l/g/Algoritmo_Doomsday_4b4e.html)
- [Doomsday PDF (Colegio Albariza)](http://www.colegioalbariza.es/documentos/areas/El%20algoritmo%20de%20Doomsday.pdf)
- [Hyperkubo Blog on Doomsday Algorithm](https://hyperkubo.wordpress.com/2012/05/06/algoritmo-doomsday/)
- [ABC Science Article](http://www.abc.es/20101112/ciencia/algoritmomundo-201011121523.html)
- [WikiHow – How to Calculate the Day of the Week](http://es.wikihow.com/calcular-el-d%C3%ADa-de-la-semana)


