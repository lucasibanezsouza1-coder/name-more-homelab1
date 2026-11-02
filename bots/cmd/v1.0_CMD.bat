@echo off
title name more - SYSTEM DEEP OPTIMIZER v1.0 CMD [BETA]
color 0A

:: --- LINEA DE GUARDADO AUTOMATICO ---
if not exist "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab" mkdir "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab"
if /i not "%~dp0"=="C:\Users\SysAdmin\Documents\SysAdmin-HomeLab\" copy /y "%~f0" "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab\" > nul

:menu
cls
echo =======================================================
echo        name more - SYSTEM DEEP OPTIMIZER v1.0 [BETA]
echo =======================================================
echo 1. Reparar Archivos Corruptos del Sistema (SFC / DISM)
echo 2. Desactivar Servicios de Telemetria (Privacidad y CPU)
echo 3. Limpieza de Logs y Eventos Viejos de Windows
echo =======================================================
echo         [ Presiona Ctrl + C para Salir ]           
echo =======================================================
echo.
set /p opcion="Elige una opcion (1-3): "

if "%opcion%"=="1" goto reparar
if "%opcion%"=="2" goto servicios
if "%opcion%"=="3" goto logs
goto menu

:reparar
cls
echo === SISTEMA: REPARACION PROFUNDA DE COMPONENTES ===
echo.
echo [1/2] Analizando y reparando imagen del sistema (DISM)...
dism /online /cleanup-image /restorehealth
echo [2/2] Verificando integridad de archivos protegidos (SFC)...
sfc /scannow
echo.
echo Archivos del sistema verificados y optimizados.
pause
goto menu

:servicios
cls
echo === SISTEMA: DESACTIVANDO RASTREADORES DE WINDOWS ===
echo.
echo Deteniendo y deshabilitando servicio de Experiencias del Usuario (DiagTrack)...
sc stop DiagTrack > nul 2>&1
sc config DiagTrack start= disabled > nul 2>&1
echo Deteniendo y deshabilitando el servicio de Reporte de Errores (WerSvc)...
sc stop WerSvc > nul 2>&1
sc config WerSvc start= disabled > nul 2>&1
echo.
echo ¡Servicios innecesarios apagados! CPU liberada.
pause
goto menu

:logs
cls
echo === SISTEMA: LIMPIEZA DE HISTORIALES DE EVENTOS ===
echo.
echo Vaciando registros de eventos de Windows (Event Viewer logs)...
for /f "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G") > nul 2>&1
echo.
echo ¡Todos los logs antiguos han sido borrados de raíz!
pause
goto menu
