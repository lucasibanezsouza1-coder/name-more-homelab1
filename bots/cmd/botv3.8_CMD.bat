@echo off
title OPTIMIZADOR OS - SYSTEM DEEP GAMER BOT v1.0 [PREMIUM BETA]
color 0A
chcp 65001 > nul

:: --- LÍNEA DE GUARDADO AUTOMÁTICO (DE TU INSPIRACIÓN) ---
if not exist "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab" mkdir "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab"
if /i not "%~dp0"=="C:\Users\SysAdmin\Documents\SysAdmin-HomeLab\" copy /y "%~f0" "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab\" > nul

:menu
cls
echo =======================================================
echo    SYSADMIN HOME LAB - OPTIMIZADOR OS v1.0 [BETA]
echo =======================================================
echo  1. ENTRAR AL "OPTIMIZADOR OS" (Menú de Control Total)
echo  2. INICIAR LIMPIADOR EN TIEMPO REAL (Mientras juegas)
echo  3. FORZAR CONTROLADORES Y GRÁFICOS AL MÁXIMO
echo  4. Abrir ArchWSL (Entorno Linux)
echo  5. Verificar Soporte DirectX / Vulkan (DxDiag)
echo =======================================================
echo              [ Presiona Ctrl + C para Salir ]           
echo =======================================================
echo.
set /p opcion="Elige una opcion (1-5): "

if "%opcion%"=="1" goto optimizador_os
if "%opcion%"=="2" goto live_clean
if "%opcion%"=="3" goto max_graphics
if "%opcion%"=="4" goto wsl_launch
if "%opcion%"=="5" goto dx_vulkan
goto menu

:: =======================================================
:: 3. MINI SISTEMA OPERATIVO "OPTIMIZADOR OS"
:: =======================================================
:optimizador_os
cls
echo =======================================================
echo                  MENU: OPTIMIZADOR OS
echo     (Control total de lo que decides borrar o activar)
echo =======================================================
echo  1. Reparar Archivos Corruptos (SFC / DISM)
echo  2. Desactivar Servicios de Telemetría (DiagTrack/WerSvc)
echo  3. Vaciar Registro de Eventos de Windows (Event Viewer)
echo  4. Limpieza Profunda de Archivos Temporales
echo  5. Activar Windows Game Mode de Raíz
echo  6. Activar Plan de Energía "Máximo Rendimiento"
echo  7. Volver al Menú Principal
echo =======================================================
echo.
set /p opt_os="Selecciona qué deseas procesar (1-7): "

if "%opt_os%"=="1" goto reparar
if "%opt_os%"=="2" goto telemetria
if "%opt_os%"=="3" goto clear_events
if "%opt_os%"=="4" goto clean_temp
if "%opt_os%"=="5" goto game_mode
if "%opt_os%"=="6" goto power_plan
if "%opt_os%"=="7" goto menu
goto optimizador_os

:reparar
cls
echo === OPTIMIZADOR OS: REPARACIÓN PROFUNDA ===
echo [1/2] Reparando imagen del sistema (DISM)...
dism /online /cleanup-image /restorehealth
echo [2/2] Verificando integridad de archivos protegidos (SFC)...
sfc /scannow
echo ¡Verificación completada!
pause
goto optimizador_os

:telemetria
cls
echo === OPTIMIZADOR OS: APAGANDO RASTREADORES ===
sc stop DiagTrack > nul 2>&1
sc config DiagTrack start= disabled > nul 2>&1
sc stop WerSvc > nul 2>&1
sc config WerSvc start= disabled > nul 2>&1
echo Servicios de telemetría y reportes deshabilitados. CPU liberada.
pause
goto optimizador_os

:clear_events
cls
echo === OPTIMIZADOR OS: BORRADO DE LOGS VIEJOS ===
echo Vaciando registros de eventos de Windows (Por favor espere)...
for /f "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G") > nul 2>&1
echo ¡Todos los eventos antiguos borrados de raíz!
pause
goto optimizador_os

:clean_temp
cls
echo === OPTIMIZADOR OS: LIMPIEZA DE BASURA ===
del /s /f /q %temp%\*.* > nul 2>&1
del /s /f /q C:\Windows\Temp\*.* > nul 2>&1
del /f /s /q C:\Windows\Prefetch\*.* > nul 2>&1
rd /s /q %systemdrive%\$Recycle.Bin > nul 2>&1
echo ¡Temporales, Prefetch y Papelera completamente limpios!
pause
goto optimizador_os

:game_mode
cls
echo === OPTIMIZADOR OS: REGISTRO GAME MODE ===
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f > nul
echo ¡Windows Game Mode forzado vía Registro!
pause
goto optimizador_os

:power_plan
cls
echo === OPTIMIZADOR OS: MÁXIMO RENDIMIENTO DE ENERGÍA ===
:: Intenta activar el plan de Máximo Rendimiento por defecto
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul 2>&1
:: Si no existe, intenta duplicar el esquema definitivo oculto de Windows
if %errorlevel% neq 0 (
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 > nul 2>&1
    powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 > nul 2>&1
)
echo ¡Esquema de energía de Alto/Máximo Rendimiento establecido!
pause
goto optimizador_os


:: =======================================================
:: 1. LIMPIADOR EN TIEMPO REAL (BUCLE SEGUNDO PLANO)
:: =======================================================
:live_clean
cls
echo =======================================================
echo    MODO ULTRA-GAMING: LIMPIADOR EN TIEMPO REAL ACTIVO
echo =======================================================
echo  Este CMD borrará de inmediato cada pequeño log y temporal
echo  que Windows intente generar en segundo plano MIENTRAS JUEGAS.
echo.
echo  [ MINIMIZA ESTA VENTANA Y ABRE TU JUEGO ]
echo  [ Para detener el bucle al terminar: Presiona Ctrl + C ]
echo =======================================================
echo.
:loop
:: Escaneo agresivo cada 3 segundos de archivos temporales y ETW logs activos
del /f /q /s %userprofile%\AppData\Local\Temp\*.* > nul 2>&1
del /f /q /s C:\Windows\Temp\*.* > nul 2>&1
del /f /q /s C:\Windows\Logs\*.* > nul 2>&1
del /f /q /s C:\Windows\System32\LogFiles\*.* > nul 2>&1
:: Comando timeout silencioso de 3 segundos para el refresco en "tiempo real"
timeout /t 3 /nobreak > nul
goto loop


:: =======================================================
:: 2. OPTIMIZACIÓN MÁXIMA DE CONTROLADORES Y GRÁFICOS
:: =======================================================
:max_graphics
cls
echo === CONFIGURACIÓN DE DRIVERS AL MÁXIMO RENDIMIENTO ===
echo.
echo 1. Optimizando el programador de GPU (HAGS)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f > nul 2>&1

echo 2. Forzando prioridad máxima de GPU y CPU para Juegos...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f > nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f > nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f > nul 2>&1

echo 3. Iniciando paneles gráficos del sistema...
:: Comando para abrir panel de NVIDIA si existe
start nvcplui.exe > nul 2>&1
:: Comando para abrir panel de AMD Radeon si existe
start bin\AMDarius.exe > nul 2>&1
start RadeonSoftware.exe > nul 2>&1

echo.
echo [INFO] El registro ha sido optimizado para exprimir tus drivers.
echo El panel de NVIDIA/AMD debería abrirse automáticamente.
echo Recuerda activar DLSS, FSR o NIS manualmente DENTRO de los ajustes de tu juego.
echo.
pause
goto menu


:: =======================================================
:: EXTENSIONES REUTILIZADAS DE TU CÓDIGO ORIGINAL
:: =======================================================
:wsl_launch
cls
echo === ABRIENDO ARCHWSL ===
start wsl -d Arch
echo.
echo ArchWSL ejecutado en segundo plano con éxito.
pause
goto menu

:dx_vulkan
cls
echo === CONTROL DE DIRECTX Y VULKAN ===
start dxdiag.exe
echo.
echo Revisa la ventana de DxDiag para comprobar tu versión de drivers y API.
pause
goto menu
