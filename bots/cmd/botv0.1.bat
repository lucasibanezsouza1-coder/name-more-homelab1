@echo off
color 0A
title Mi Primer Bot de SysAdmin

:menu
cls
echo ===================================================
echo           BOT DE AUTOMATIZACION - SYSADMIN
echo ===================================================
echo  1. Ver estado del Procesador y la Memoria RAM
echo  2. Verificar conexion a Internet (Ping a Google)
echo  3. Limpiar archivos temporales del sistema
echo  4. Abrir la terminal de Linux (WSL Ubuntu)
echo  5. Salir del Bot
echo ===================================================
echo.

set /p opcion="Elige una opcion (1-5) y presiona Enter: "

if "%opcion%"=="1" goto opc1
if "%opcion%"=="2" goto opc2
if "%opcion%"=="3" goto opc3
if "%opcion%"=="4" goto opc4
if "%opcion%"=="5" goto salir

echo Opcion no valida, intenta de nuevo...
pause
goto menu

:opc1
cls
echo === INFORMACION DEL SISTEMA ===
echo.
echo Memoria RAM Total y Libre:
systeminfo | findstr /C:"Total Physical Memory" /C:"Available Physical Memory"
echo.
echo Presione una tecla para volver al menu...
pause > nul
goto menu

:opc2
cls
echo === VERIFICANDO INTERNET ===
ping google.com -n 4
echo.
pause
goto menu

:opc3
cls
echo === LIMPIANDO ARCHIVOS TEMPORALES ===
del /s /f /q %temp%\*.*
echo.
echo Limpieza completada con exito!
pause
goto menu

:opc4
cls
echo === ABRIENDO LINUX (WSL) ===
echo Escribe 'exit' en Linux cuando quieras regresar al Bot.
echo.
wsl
goto menu

:salir
cls
echo Hasta luego, SysAdmin! Gracias por usar el bot.
timeout /t 3 > nul
exit
