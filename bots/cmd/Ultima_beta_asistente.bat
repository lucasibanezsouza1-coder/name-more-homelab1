@echo off
:: =========================================================================
:: 📚 CRÓNICAS DE NAME MORE — VOLUMEN 1 (MÓDULO ASISTENTE NATIVO v3.3)
# Código: 'ONE OF NAME' — Versión CMD de Alta Velocidad (0%% Consumo)
# Especialidad: Soporte Core de Linux y Sistemas de Particionado
# Desarrollador Principal: SysAdmin / Name More
:: =========================================================================
chcp 65001 > nul
cls

echo =======================================================
echo      SYNTH COMPANION v3.3 [NATIVO CMD CORE]            
echo =======================================================
echo 💡 Estado: Modo Local Off-line Activo (Consumo: 0%%)
echo 🎯 Especialidad: Linux Kernel ^& Partition Systems
echo =======================================================
echo.

:: 1. Validación de Seguridad Local de "ONE OF NAME"
set "OwnerUsername=SysAdmin"
set "TokenDeOne=SysAdmin15"

if not "%USERNAME%"=="%OwnerUsername%" (
    echo 🔒 Acceso Denegado: Entorno local no autorizado.
    timeout /t 3 > nul
    exit
)

echo 🔓 [OK] Entorno de desarrollo de 'ONE OF NAME' detectado.
set /p "PasswordInput=🔐 Ingrese Token de Acceso Maestra: "

if not "%PasswordInput%"=="%TokenDeOne%" (
    echo ⚠️ Token incorrecto. Cerrando laboratorio por seguridad.
    timeout /t 2 > nul
    exit
)

cls
echo =======================================================
echo 🔥 ACCESO CONCEDIDO: Modo Creador 'ONE OF NAME' Activo.
echo =======================================================
echo 🤖 ASISTENTE: ¡SISTEMAS ONLINE! ¡ESTOY LISTO Y CON TODA LA ENERGÍA, SYSADMIN! 🚀
echo             (Escribe 'salir' para cerrar el bot)
echo =======================================================

:LOOP
echo.
set "input="
set /p "input=👑 ONE_OF_NAME@NameMore_Lab> "

:: Normalizar entrada vacía y comandos de salida
if "%input%"=="" goto LOOP
if /i "%input%"=="salir" (
    echo.
    echo 🤖 ASISTENTE: ¡Entendido! Desconectando sistemas del laboratorio. ¡Buen trabajo hoy, Creador! ⚡
    timeout /t 2 > nul
    exit
)

:: =========================================================================
:: 🧠 MOTOR DE VOCABULARIO Y COINCIDENCIAS (MÉTODO MATRIX DE CMD)
:: =========================================================================

:: --- Saludos Enérgicos ---
if /i "%input%"=="hola" (
    echo.
    echo 🤖 ASISTENTE: ¡HOLA, CREADOR! 🔥 ¡Qué excelente día para configurar servidores y romper cuellos de botella! ¿Qué comando destruiremos hoy? 💻💥
    goto LOOP
)

if /i "%input%"=="buenos dias" (
    echo.
    echo 🤖 ASISTENTE: ¡BUENOS DÍAS! ☀️ ¡Los discos duros están limpios y los scripts listos para la acción! ¡A darle con todo!
    goto LOOP
)

:: --- Vocabulario Especializado: LINUX ---
if /i "%input%"=="que es linux" (
    echo.
    echo 🤖 ASISTENTE: ¡LINUX ES EL REY DE LOS SERVIDORES! 🐧 Es un núcleo (kernel) de código abierto, ultrapotente, seguro y ligero. ¡Todo SysAdmin Junior debe dominarlo para dominar el mundo! 👑
    goto LOOP
)

if /i "%input%"=="comandos basicos linux" (
    echo.
    echo 🤖 ASISTENTE: ¡AQUÍ ESTÁ EL ARSENAL CORE, SYSADMIN! 🔥
    echo              • 'ls'   - Lista archivos
    echo              • 'cd'   - Navega entre carpetas
    echo              • 'pwd'  - Muestra dónde estás parado
    echo              • 'sudo' - ¡Poder absoluto de administrador!
    goto LOOP
)

:: --- Vocabulario Especializado: PARTICIOMANIENTO ---
if /i "%input%"=="que es una particion" (
    echo.
    echo 🤖 ASISTENTE: ¡PIENSA EN UN DISCO DURO COMO UNA CASA! 🏠 Las particiones son las paredes que dividen los cuartos. Puedes tener Windows en un cuarto y Linux en el otro sin que se peleen. ¡Organización máxima! 🛠️
    goto LOOP
)

if /i "%input%"=="gpt vs mbr" (
    echo.
    echo 🤖 ASISTENTE: ¡PREGUNTA ÉPICA DE ARQUITECTURA! 💥
    echo              • MBR: Viejo, límite de 4 particiones primarias y discos de máximo 2TB. 💾
    echo              • GPT: El estándar moderno, soporta hasta 128 particiones, discos gigantescos y viene con seguridad UEFI. ¡Usa siempre GPT! 🚀
    goto LOOP
)

if /i "%input%"=="sistemas de archivos linux" (
    echo.
    echo 🤖 ASISTENTE: ¡EN LINUX EL REY ES **EXT4**! 🐧 También existe **XFS** para servidores empresariales gigantes y **Btrfs** para copias de seguridad avanzadas. ¡Evita usar NTFS aquí!
    goto LOOP
)

:: --- Cortafuegos de Temática (Filtro Estricto) ---
echo.
echo 🤖 ASISTENTE: ¡Sistemas cargados! Mi base de datos actual está configurada EN EXCLUSIVA para el Kernel de Linux y Sistemas de Particionado. 🔒
echo              ¡Hazme una pregunta sobre esos temas o añade esta palabra a mi vocabulario en el código! ⚡
goto LOOP

