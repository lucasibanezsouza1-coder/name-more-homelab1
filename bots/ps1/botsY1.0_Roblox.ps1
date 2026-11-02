# name more - Roblox Client Optimizer botsY1.0 [BETA]
$RutaDestino = "C:\Users\SysAdmin\Documents\SysAdmin-HomeLab\Juegos_Especificos"
if (!(Test-Path $RutaDestino)) { New-Item -ItemType Directory -Path $RutaDestino -Force | Out-Null }
if ($PSScriptRoot -ne $RutaDestino) { Copy-Item -Path $PSCommandPath -Destination $RutaDestino -Force -ErrorAction SilentlyContinue }

Host.UI.RawUI.ForegroundColor = "Green"
Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

# Buscar la ruta de instalación de Roblox (Bloxstrap o cliente clásico)
$LocalApp = "$env:LOCALAPPDATA\Roblox\Versions"
$Bloxstrap = "$env:LOCALAPPDATA\Bloxstrap\Modifications"

function Aplicar-FFlags ($RutaBase, $ApiVideo) {
    $ClientSettings = Join-Path $RutaBase "ClientSettings"
    if (!(Test-Path $ClientSettings)) { New-Item -ItemType Directory -Path $ClientSettings -Force | Out-Null }
    
    # Mapa de FastFlags para optimizar rendimiento y texturas
    $FFlagsJson = @{
        "DFIntTaskSchedulerTargetFps" = 9999              # Desbloquear FPS
        "FFlagDebugGraphicsDisableDirect3D11" = if ($ApiVideo -eq "Vulkan") { "True" } else { "False" }
        "FFlagDebugGraphicsPreferVulkan" = if ($ApiVideo -eq "Vulkan") { "True" } else { "False" }
        "FFlagDebugGraphicsPreferD3D11" = if ($ApiVideo -eq "DirectX") { "True" } else { "False" }
        "FIntFRMMinLevel" = 1                             # Forzar nivel bajo de render para mas rendimiento
        "FFlagGgRenderShadows" = "False"                  # Desactivar sombras pesadas
    }
    
    $JsonTexto = $FFlagsJson | ConvertTo-Json
    Set-Content -Path (Join-Path $ClientSettings "ClientAppSettings.json") -Value $JsonTexto -Force
    Write-Host "[+] FastFlags aplicadas con exito usando la API: $ApiVideo" -ForegroundColor Cyan
}

cls
Write-Host "=================================================="
Write-Host "       name more - ROBLOX BOOSTER botsY1.0        "
Write-Host "=================================================="
Write-Host "1. Optimizar Roblox con VULKAN (Mejor para GPUs modernas)"
Write-Host "2. Optimizar Roblox con DirectX 11 (Mas Estable)"
Write-Host "3. Lanzar Roblox en Alta Prioridad de CPU"
Write-Host "=================================================="
echo.
$opc = Read-Host "Elige una opcion (1-3)"

switch ($opc) {
    "1" {
        Clear-Host
        Write-Host "--- CONFIGURANDO VULKAN PARA ROBLOX ---"
        if (Test-Path $Bloxstrap) { Aplicar-FFlags $Bloxstrap "Vulkan" }
        # Buscar carpetas de versión clásicas e inyectar
        Get-ChildItem $LocalApp -Directory | ForEach-Object { Aplicar-FFlags $_.FullName "Vulkan" }
        Read-Host "`nPresiona Enter para continuar"
    }
    "2" {
        Clear-Host
        Write-Host "--- CONFIGURANDO DIRECTX 11 PARA ROBLOX ---"
        if (Test-Path $Bloxstrap) { Aplicar-FFlags $Bloxstrap "DirectX" }
        Get-ChildItem $LocalApp -Directory | ForEach-Object { Aplicar-FFlags $_.FullName "DirectX" }
        Read-Host "`nPresiona Enter para continuar"
    }
    "3" {
        Clear-Host
        Write-Host "--- OPTIMIZANDO PROCESO EN TIEMPO REAL ---"
        Write-Host "Buscando instancias de Roblox para forzar prioridad alta..."
        Get-Process -Name "RobloxPlayerBeta" -ErrorAction SilentlyContinue | ForEach-Object {
            $_.PriorityClass = "High"
            Write-Host "[+] RobloxPlayerBeta.exe cambiado a Prioridad Alta." -ForegroundColor Cyan
        }
        Read-Host "`nPresiona Enter para continuar"
    }
}
