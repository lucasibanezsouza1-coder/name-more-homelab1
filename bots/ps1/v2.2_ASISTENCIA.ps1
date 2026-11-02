# name more - PRIVATE ASSISTANT v2.2 [POWERSHELL COGNITIVO]
Host.UI.RawUI.ForegroundColor = "Cyan"
Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

$LAB_ROOT = "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab"
$SUB_CMD = "$LAB_ROOT\Generales_CMD"
$SUB_PS = "$LAB_ROOT\Generales_PowerShell"
$SUB_J = "$LAB_ROOT\Optimizacion_Juegos"
$SUB_Y = "$LAB_ROOT\Juegos_Especificos"

do {
    Clear-Host
    Write-Host "======================================================================="
    Write-Host "      name more - PRIVATE ASSISTANT v2.2 [INTERFAZ LIBRE PS]          "
    Write-Host "======================================================================="
    Write-Host "  Escribe tu orden libremente (palabras clave: cmd, powershell, botj, botsy)."
    Write-Host "  Escribe 'limpiar' o 'salir'."
    Write-Host "======================================================================="
    echo.
    
    $orden = Read-Host "SysAdmin"
    if ($orden -eq "salir") { exit }
    if ($orden -eq "limpiar") { continue }
    
    # Respuestas aleatorias de carga
    $rand = Get-Random -Min 1 -Max 4
    if ($rand -eq 1) { Write-Host "[name more AI] Escaneando directorios de infraestructura..." }
    if ($rand -eq 2) { Write-Host "[name more AI] Procesando tu solicitud de ordenamiento, jefe..." }
    if ($rand -eq 3) { Write-Host "[name more AI] Ejecutando comando en el backend..." }
    Start-Sleep -Seconds 1
    
    if ($orden -match "cmd") {
        if (Test-Path "$LAB_ROOT\v*CMD.bat") {
            Move-Item -Path "$LAB_ROOT\v*CMD.bat" -Destination $SUB_CMD -Force
            $msg = Get-Random -InputObject "¡Hecho! Los .bat ya estan en la subcarpeta CMD.","Operacion exitosa en el modulo Batch.","Limpieza terminada en el area CMD."
            Write-Host "[+] $msg" -ForegroundColor Green
        } else { Write-Host "[!] No encontre archivos sueltos de CMD para mover." -ForegroundColor Yellow }
    }
    elseif ($orden -match "powershell") {
        if (Test-Path "$LAB_ROOT\*.ps1") {
            # Evitar mover el propio asistente si se ejecuta desde la raíz
            Get-ChildItem "$LAB_ROOT\*.ps1" | Where-Object { $_.Name -ne "v2.2_ASISTENCIA.ps1" } | ForEach-Object { Move-Item $_.FullName $SUB_PS -Force }
            $msg = Get-Random -InputObject "Scripts de PowerShell reubicados.","Modulos .ps1 organizados de forma limpia.","Listo, los megacomandos avanzados estan a salvo."
            Write-Host "[+] $msg" -ForegroundColor Green
        } else { Write-Host "[!] La subcarpeta de PowerShell ya esta al dia." -ForegroundColor Yellow }
    }
    elseif ($orden -match "botj") {
        if (Test-Path "$LAB_ROOT\botsJ*.bat") {
            Move-Item -Path "$LAB_ROOT\botsJ*.bat" -Destination $SUB_J -Force
            Write-Host "[+] Los optimizadores globales de juegos estan en su lugar." -ForegroundColor Green
        } else { Write-Host "[!] No hay botsJ en la raiz del lab." -ForegroundColor Yellow }
    }
    elseif ($orden -match "botsy") {
        if (Test-Path "$LAB_ROOT\botsY*.ps1") {
            Move-Item -Path "$LAB_ROOT\botsY*.ps1" -Destination $SUB_Y -Force
            Write-Host "[+] Tus armas secretas para Roblox y otros juegos especificos estan guardadas." -ForegroundColor Green
        } else { Write-Host "[!] No hay scripts de optimizacion dedicados sueltos." -ForegroundColor Yellow }
    }
    else {
        $err = Get-Random -InputObject "Mis sensores no detectaron palabras claves conocidas.","Sintaxis no reconocida por 'name more'.","¡Ups! Orden invalida, intenta de nuevo."
        Write-Host "[!] $err" -ForegroundColor Red
    }
    Read-Host "`nPresiona Enter para continuar"
} while ($true)
