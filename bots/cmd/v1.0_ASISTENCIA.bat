@echo off
title name more - PRIVATE ASSISTANT v1.0 [BETA INTERNA]
color 0B

:menu
cls
echo =======================================================
echo       name more - PRIVATE ASSISTANT v1.0 [INTERNAL]
echo =======================================================
echo 1. Buscar bots (.bat/.ps1) en Escritorio y mover a HomeLab
echo 2. Mover archivos de Descargas (Downloads) a HomeLab
echo 3. Mostrar lista de archivos actuales de mi Laboratorio
echo =======================================================
echo         [ Presiona Ctrl + C para Salir ]           
echo =======================================================
echo.
set /p orden="¿Que comando deseas ejecutar, SysAdmin? (1-3): "

if "%orden%"=="1" goto mover_escritorio
if "%orden%"=="2" goto mover_descargas
if "%orden%"=="3" goto listar
goto menu

:mover_escritorio
cls
echo === ASISTENCIA: MOVIENDO SCRIPT DESDE EL ESCRITORIO ===
echo.
set "ORIGEN=C:\Users\SysAdmin\Desktop"
set "DESTINO=C:\Users\SysAdmin\Documents\SysAdmin-HomeLab"

echo Buscando archivos .bat o .ps1 para organizar...
if exist "%ORIGEN%\*.bat" (
    move /y "%ORIGEN%\*.bat" "%DESTINO%"
    echo [+] Archivos .bat movidos con exito.
)
if exist "%ORIGEN%\*.ps1" (
    move /y "%ORIGEN%\*.ps1" "%DESTINO%"
    echo [+] Archivos .ps1 movidos con exito.
)
echo.
echo Operacion completada. Tu Escritorio esta limpio.
pause
goto menu

:mover_descargas
cls
echo === ASISTENCIA: ABSORBIENDO ARCHIVOS DE DESCARGAS ===
echo.
set "ORIGEN_DL=C:\Users\SysAdmin\Downloads"
set "DESTINO=C:\Users\SysAdmin\Documents\SysAdmin-HomeLab"

echo Moviendo archivos de scripts descargados a tu HomeLab...
if exist "%ORIGEN_DL%\*.bat" move /y "%ORIGEN_DL%\*.bat" "%DESTINO%"
if exist "%ORIGEN_DL%\*.ps1" move /y "%ORIGEN_DL%\*.ps1" "%DESTINO%"
echo.
echo ¡Archivos absorbidos con exito!
pause
goto menu

:listar
cls
echo === ASISTENCIA: INVENTARIO DE ARCHIVOS EN HOMELAB ===
echo.
echo Directorio: C:\Users\SysAdmin\Documents\SysAdmin-HomeLab
echo -------------------------------------------------------
dir /b "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab"
echo -------------------------------------------------------
echo.
pause
goto menu
