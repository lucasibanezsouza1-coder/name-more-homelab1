# --- LÍNEA DE GUARDADO AUTOMÁTICO EN TU CARPETA ---
$RutaDestino = "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab"
if (!(Test-Path $RutaDestino)) { New-Item -ItemType Directory -Path $RutaDestino -Force | Out-Null }
if ($PSScriptRoot -ne $RutaDestino) { Copy-Item -Path $PSCommandPath -Destination $RutaDestino -Force -ErrorAction SilentlyContinue }

Host.UI.RawUI.ForegroundColor = "Green"
Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

[console]::TreatControlCAsInput = $false

function Mostrar-Menu {
    Clear-Host
    Write-Host "=================================================="
    Write-Host "    SYSADMIN HOME LAB - BOT GAMER v0.2 POWERSHELL  "
    Write-Host "=================================================="
    Write-Host "1. Optimizar OS (Plan de Maximo Rendimiento)"
    Write-Host "2. Limpieza Avanzada de Archivos Temporales"
    Write-Host "3. Abrir ArchWSL (Entorno Linux para Devs)"
    Write-Host "4. Activar Windows Game Mode (Modo Juego)"
    Write-Host "5. Verificar Soporte DirectX y Configurar Vulkan"
    Write-Host "=================================================="
    Write-Host "       [ Presiona Ctrl + C para Salir ]           "
    Write-Host "=================================================="
}

do {
    Mostrar-Menu
    $opcion = Read-Host "Elige una opcion (1-5)"

    switch ($opcion) {
        "1" {
            Clear-Host
            Write-Host "--- OPTIMIZANDO SISTEMA OPERATIVO ---"
            powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
            Write-Host "¡Plan de maximo rendimiento activado!" -ForegroundColor Cyan
            Read-Host "`nPresiona Enter para volver al menu"
        }
        "2" {
            Clear-Host
            Write-Host "--- LIMPIEZA AVANZADA DE TEMPORALES ---"
            Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "¡Limpieza profunda completada!" -ForegroundColor Cyan
            Read-Host "`nPresiona Enter para volver al menu"
        }
        "3" {
            Clear-Host
            Write-Host "--- ABRIENDO ARCHWSL ---"
            Start-Process wsl.exe -ArgumentList "-d Arch" -ErrorAction SilentlyContinue
            Write-Host "ArchWSL se ha ejecutado en segundo plano."
            Read-Host "`nPresiona Enter para volver al menu"
        }
        "4" {
            Clear-Host
            Write-Host "--- ACTIVANDO WINDOWS GAME MODE ---"
            if (!(Test-Path "HKCU:\Software\Microsoft\GameBar")) {
                New-Item -Path "HKCU:\Software\Microsoft\GameBar" -Force | Out-Null
            }
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1
            Write-Host "¡Windows Game Mode activado!" -ForegroundColor Cyan
            Read-Host "`nPresiona Enter para volver al menu"
        }
        "5" {
            Clear-Host
            Write-Host "--- CONTROL DE DIRECTX Y VULKAN ---"
            Start-Process dxdiag.exe
            Write-Host "Revisa la ventana de DxDiag para comprobar tu version."
            Read-Host "`nPresiona Enter para volver al menu"
        }
        Default {
            Write-Host "Opcion no valida." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($true)
