@echo off
:: =========================================================================
:: 📚 CRÓNICAS DE NAME MORE — VOLUMEN 1 (MÓDULO ASISTENTE NATIVO v3.4)
:: Código: 'ONE OF NAME' — Versión CMD con Sistema de Ejecución de Tareas
:: Especialidad: Linux, Particionado y Automatización de Archivos Locales
:: Desarrollador Principal: SysAdmin / Name More
:: =========================================================================
chcp 65001 > nul
cls

echo =======================================================
echo      SYNTH COMPANION v3.4 [NATIVO CMD EXECUTOR]        
echo =======================================================
echo 💡 Estado: Modo Automatización Local Activo (Consumo: 0%%)
echo 🎯 Especialidad: Linux Core, Particionado ^& File Ops
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
echo 🤖 ASISTENTE: ¡SISTEMAS ONLINE! ¡CON TODA LA ENERGÍA Y LISTO PARA EJECUTAR ÓRDENES, SYSADMIN! 🚀
echo             (Escribe 'salir' para cerrar el bot)
echo =======================================================

:LOOP
echo.
set "input="
set /p "input=👑 ONE_OF_NAME@NameMore_Lab> "

if "%input%"=="" goto LOOP

if /i "%input%"=="salir" (
    echo.
    echo 🤖 ASISTENTE: ¡Entendido! Desconectando sistemas del laboratorio. ¡Buen trabajo hoy, Creador! ⚡
    timeout /t 2 > nul
    exit
)
if /i "%input%"=="adios" (
    echo.
    echo 🤖 ASISTENTE: ¡Nos vemos, SysAdmin! 🔥 ¡Los servidores quedan protegidos bajo tu guardia! ¡Hasta la próxima misión! ⚡
    timeout /t 2 > nul
    exit
)

:: =========================================================================
:: 🧠 MOTOR DE VOCABULARIO Y ACCIONES REALES
:: =========================================================================

:: --- Saludos ---
if /i "%input%"=="hola" (
    echo.
    echo 🤖 ASISTENTE: ¡HOLA, CREADOR! 🔥 ¡Qué excelente día para configurar servidores y romper cuellos de botella! ¿Qué comando destruiremos hoy? 💻💥
    goto LOOP
)

:: --- Teoría de Sistemas ---
if /i "%input%"=="como funcionan las particiones" (
    echo.
    echo 🤖 ASISTENTE: ¡MIRA ESTA MARAVILLA! 🛠️ El sistema operativo lee la tabla de particiones (GPT/MBR) al inicio del disco. Esta tabla le dice exactamente en qué sector de bytes empieza y termina cada unidad lógica (como el C: o el D:). Es como un mapa de carreteras dentro del silicio del disco para que el cabezal sepa dónde buscar los bloques de datos sin mezclar los sistemas de archivos. ¡Pura eficiencia! ⚡
    goto LOOP
)

:: --- ACCIÓN 1: Mover archivos a carpeta de juegos ---
if /i "%input%"=="mueve este archivo a este lugar como dowlands carpeta de juegos" (
    echo.
    echo 🤖 ASISTENTE: ¡ENTENDIDO! Iniciando protocolo de transferencia de infraestructura... 🚚
    set /p "ArchivoAMover=📁 Arrastra o escribe el nombre del archivo a mover: "
    
    :: Creamos la carpeta de juegos si no existe en tus documentos
    if not exist "C:\Users\SysAdmin\Documents\CarpetaDeJuegos" mkdir "C:\Users\SysAdmin\Documents\CarpetaDeJuegos"
    
    :: Ejecutamos la acción real
    move "%ArchivoAMover%" "C:\Users\SysAdmin\Documents\CarpetaDeJuegos\" > nul
    if %errorlevel%==0 (
        echo 🤖 ASISTENTE: ¡ÉXITO! El archivo fue movido limpiamente a la carpeta 'Documents\CarpetaDeJuegos'. 🎮✅
    ) else (
        echo ❌ ASISTENTE: Error en la ruta. Asegúrate de que el archivo exista en la carpeta actual.
    )
    goto LOOP
)

:: --- ACCIÓN 2: Cambiar nombre a un archivo ---
if /i "%input%"=="cambiale el nombre a este archivo" (
    echo.
    echo 🤖 ASISTENTE: ¡Entrando en modo renombrador de sistemas! 📝
    set /p "ArchivoOriginal=🔹 Nombre del archivo actual (ej: foto.txt): "
    set /p "NuevoNombre=🔸 Nuevo nombre que deseas ponerle (ej: modificado.txt): "
    
    ren "%ArchivoOriginal%" "%NuevoNombre%" 2>nul
    if %errorlevel%==0 (
        echo 🤖 ASISTENTE: ¡Nombre cambiado con éxito! Sistema de archivos actualizado. 🔄🔥
    ) else (
        echo ❌ ASISTENTE: No pude renombrar el archivo. Verifica que el nombre sea correcto y no esté abierto.
    )
    goto LOOP
)

:: --- ACCIÓN 3: Ejecutar ArchWSL (Entorno Linux) ---
if /i "%input%"=="ejecuta archwsl" (
    echo.
    echo 🤖 ASISTENTE: ¡LEVANTANDO ENTORNO SUBSISTEMA DE LINUX! 🐧🔥
    echo 🤖 ASISTENTE: Conectando con el Kernel de Arch Linux en Windows... ¡Iniciando consola WSL!
    echo ----------------------------------------------------------------------
    
    :: Ejecuta tu distribución de Arch en WSL (Cambia 'Arch' si tu distro se llama diferente)
    wsl -d Arch
    
    echo ----------------------------------------------------------------------
    echo 🤖 ASISTENTE: Sesión de ArchWSL finalizada. Volviendo al núcleo del bot. 👑
    goto LOOP
)

:: --- Cortafuegos por defecto ---
echo.
echo 🤖 ASISTENTE: Comando no indexado. Recuerda que puedes pedirme:
echo              • hola / adios
echo              • como funcionan las particiones
echo              • mueve este archivo a este lugar como dowlands carpeta de juegos
echo              • cambiale el nombre a este archivo
echo              • ejecuta archwsl
goto LOOP
