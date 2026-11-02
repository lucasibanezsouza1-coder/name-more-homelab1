@echo off
title SYSADMIN HOME LAB - BOT GAMER v0.2 CMD
color 0A

:: --- LÍNEA DE GUARDADO AUTOMÁTICO EN TU CARPETA ---
if not exist "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab" mkdir "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab"
if /i not "%~dp0"=="C:\Users\SysAdmin\Documents\SysAdmin-HomeLab\" copy /y "%~f0" "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab\" > nul

:menu
cls
echo ==================================================
echo        SYSADMIN HOME LAB - BOT GAMER v0.2 CMD     
echo ==================================================
echo 1. Optimizar OS (Maximo Rendimiento)
echo 2. Limpieza Avanzada de Temporales
echo 3. Abrir ArchWSL (Entorno Linux)
echo 4. Activar Windows Game Mode
echo 5. Verificar Soporte DirectX y Vulkan
echo ==================================================
echo        [ Presiona Ctrl + C para Salir ]           
echo ==================================================
echo.
set /p opcion="Elige una opcion (1-5): "

if "%opcion%"=="1" (
    cls
    echo === OPTIMIZANDO SISTEMA OPERATIVO ===
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo.
    echo ¡Plan de maximo rendimiento activado!
    pause
    goto menu
)

if "%opcion%"=="2" (
    cls
    echo === LIMPIEZA AVANZADA DE TEMPORALES ===
    del /s /f /q %temp%\*.* > nul 2>&1
    del /s /f /q C:\Windows\Temp\*.* > nul 2>&1
    echo.
    echo ¡Limpieza profunda completada!
    pause
    goto menu
)

if "%opcion%"=="3" (
    cls
    echo === ABRIENDO ARCHWSL ===
    start wsl -d Arch
    echo.
    echo ArchWSL ejecutado en segundo plano.
    pause
    goto menu
)

if "%opcion%"=="4" (
    cls
    echo === ACTIVANDO WINDOWS GAME MODE ===
    reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f > nul
    echo.
    echo ¡Windows Game Mode activado!
    pause
    goto menu
)

if "%opcion%"=="5" (
    cls
    echo === CONTROL DE DIRECTX Y VULKAN ===
    start dxdiag.exe
    echo.
    echo Revisa la ventana de DxDiag para comprobar tu version.
    pause
    goto menu
)

goto menu
