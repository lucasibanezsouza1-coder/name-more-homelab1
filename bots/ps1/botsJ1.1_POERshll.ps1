# name more - GLOBAL GAMING BOOSTER botsJ1.1 POWERSHELL
$RutaDestino = "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab\Optimizacion_Juegos"
if (!(Test-Path $RutaDestino)) { New-Item -ItemType Directory -Path $RutaDestino -Force | Out-Null }
if ($PSScriptRoot -ne $RutaDestino) { Copy-Item -Path $PSCommandPath -Destination $RutaDestino -Force -ErrorAction SilentlyContinue }

Host.UI.RawUI.ForegroundColor = "Green"
Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

function Menu {
    Clear-Host
    Write-Host "=================================================="
    Write-Host "    name more - GLOBAL GAMING BOOSTER botsJ1.1    "
    Write-Host "=================================================="
    Write-Host "1. Forzar Plan de Maximo Rendimiento Absoluto"
    Write-Host "2. Modificar Network Throttling (Liberar Red)"
    Write-Host "3. Flush de Memoria Virtual y DNS"
    Write-Host "=================================================="
}

do {
    Menu
    $opc = Read-Host "SysAdmin"
    switch ($opc) {
        "1" {
            Clear-Host
            powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
            Write-Host "[+] Perfil de energia establecido a Maximo Rendimiento." -ForegroundColor Cyan
            Read-Host "`nPresiona Enter para volver"
        }
        "2" {
            Clear-Host
            Write-Host "--- OPTIMIZANDO NETWORK THROTTLING INDEX ---"
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xffffffff -Force
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -Force
            Write-Host "[+] El sistema ya no limitara los paquetes de red mientras juegas." -ForegroundColor Cyan
            Read-Host "`nPresiona Enter para volver"
        }
        "3" {
            Clear-Host
            Clear-DnsClientCache
            [System.GC]::Collect()
            Write-Host "[+] Cache DNS purgada y Recolector de Basura de RAM ejecutado." -ForegroundColor Cyan
            Read-Host "`nPresiona Enter para volver"
        }
    }
} while ($true)
