# name more - SYSTEM DEEP OPTIMIZER v1.1 POWERSHELL
$RutaDestino = "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab\Generales_PowerShell"
if (!(Test-Path $RutaDestino)) { New-Item -ItemType Directory -Path $RutaDestino -Force | Out-Null }
if ($PSScriptRoot -ne $RutaDestino) { Copy-Item -Path $PSCommandPath -Destination $RutaDestino -Force -ErrorAction SilentlyContinue }

Host.UI.RawUI.ForegroundColor = "Green"
Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

function Menu {
    Clear-Host
    Write-Host "=================================================="
    Write-Host "    name more - SYSTEM DEEP OPTIMIZER v1.1 .PS1   "
    Write-Host "=================================================="
    Write-Host "1. Analisis de Integridad y Reparacion (DISM+SFC)"
    Write-Host "2. Purga y Desactivacion Completa de Telemetria"
    Write-Host "3. Optimizar Tiempos de Respuesta del Nucleo (Kernel)"
    Write-Host "=================================================="
}

do {
    Menu
    $opc = Read-Host "SysAdmin"
    switch ($opc) {
        "1" {
            Clear-Host
            Write-Host "--- EJECUTANDO REPARACION DE COMPONENTES ---"
            Repair-WindowsImage -Online -RestoreHealth
            sfc /scannow
            Read-Host "`nPresiona Enter para volver"
        }
        "2" {
            Clear-Host
            Write-Host "--- ELIMINANDO TELEMETRIA PROFUNDA ---"
            Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
            Set-Service -Name "DiagTrack" -StartupType Disabled
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force
            Write-Host "[+] Rastreadores apagados en registro." -ForegroundColor Cyan
            Read-Host "`nPresiona Enter para volver"
        }
        "3" {
            Clear-Host
            Write-Host "--- AJUSTES DE LATENCIA DEL KERNEL ---"
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 0 -Force
            Write-Host "[+] Cache del sistema optimizada para bajas latencias de E/S." -ForegroundColor Cyan
            Read-Host "`nPresiona Enter para volver"
        }
    }
} while ($true)
