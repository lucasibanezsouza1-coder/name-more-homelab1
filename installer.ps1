# =========================================================================
# NAME MORE - DEPENDENCY INSTALLER v1.0
# Detecta, descarga e instala dependencias con un solo click.
# Uso: .\installer.ps1
# =========================================================================

$ErrorActionPreference = "Continue"
$Base = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

Clear-Host
Write-Host "  DEPENDENCY INSTALLER v1.0" -ForegroundColor Cyan
Write-Host "  ----------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

$Deps = @(
    @{
        Nombre    = "Git"
        Desc      = "Control de version (auto-push)"
        Check     = { Get-Command git -ErrorAction SilentlyContinue }
        Instalar  = { winget install Git.Git -e --accept-source-agreements --accept-package-agreements }
        Nota      = "Reinicia PowerShell despues"
    }
    @{
        Nombre    = "WSL"
        Desc      = "Windows Subsystem for Linux"
        Check     = { wsl --status 2>&1 | Select-String "Default Distribution" }
        Instalar  = { wsl --install --no-launch }
        Nota      = "Reinicia la PC despues"
    }
    @{
        Nombre    = "Arch Linux (WSL)"
        Desc      = "Distro Arch para WSL"
        Check     = { wsl -l -v 2>&1 | Select-String "Arch" }
        Instalar  = { wsl --install -d ArchLinux --no-launch }
        Nota      = "Reinicia la PC despues"
    }
    @{
        Nombre    = "Ollama"
        Desc      = "IA local (opcional, para SYNTH)"
        Check     = { Get-Command ollama -ErrorAction SilentlyContinue }
        Instalar  = { winget install Ollama.Ollama -e --accept-source-agreements --accept-package-agreements }
        Nota      = "Reinicia PowerShell despues"
    }
    @{
        Nombre    = "Python"
        Desc      = "Runtime (para bots futuros)"
        Check     = { Get-Command python -ErrorAction SilentlyContinue }
        Instalar  = { winget install Python.Python.3.12 -e --accept-source-agreements --accept-package-agreements }
        Nota      = "Reinicia PowerShell despues"
    }
    @{
        Nombre    = "Node.js"
        Desc      = "Runtime (para bots futuros)"
        Check     = { Get-Command node -ErrorAction SilentlyContinue }
        Instalar  = { winget install OpenJS.NodeJS.LTS -e --accept-source-agreements --accept-package-agreements }
        Nota      = "Reinicia PowerShell despues"
    }
)

Write-Host "  ESCANEANDO..." -ForegroundColor DarkGray
Write-Host "  ----------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

$Idx = 1
foreach ($D in $Deps) {
    $Instalado = & $D.Check
    if ($Instalado) {
        Write-Host "  [$Idx] $($D.Nombre.PadRight(20)) [OK] $($D.Desc)" -ForegroundColor Green
    } else {
        Write-Host "  [$Idx] $($D.Nombre.PadRight(20)) [!]  $($D.Desc)" -ForegroundColor Yellow
    }
    $Idx++
}

Write-Host ""
Write-Host "  [A] Instalar TODO lo que falta" -ForegroundColor Cyan
Write-Host "  [N] Instalar uno especifico" -ForegroundColor Cyan
Write-Host "  [0] Salir" -ForegroundColor Cyan
Write-Host ""

$Opcion = Read-Host "  >"

function Invoke-Install($D) {
    Write-Host ""
    Write-Host "  Instalando $($D.Nombre)..." -ForegroundColor Cyan
    Write-Host "  ----------------------------------------------" -ForegroundColor DarkGray
    try {
        & $D.Instalar
        Write-Host "  [OK] $($D.Nombre) instalado." -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
    }
    if ($D.Nota) {
        Write-Host "  [!] $($D.Nota)" -ForegroundColor Yellow
    }
    Write-Host ""
}

if ($Opcion -eq "A") {
    foreach ($D in $Deps) {
        $Instalado = & $D.Check
        if (-not $Instalado) {
            Invoke-Install $D
        }
    }
    Write-Host "  TODO INSTALADO." -ForegroundColor Green
}
elseif ($Opcion -eq "N") {
    $Idx = 1
    $Faltantes = @()
    foreach ($D in $Deps) {
        $Instalado = & $D.Check
        if (-not $Instalado) {
            Write-Host "  [$Idx] $($D.Nombre)" -ForegroundColor White
            $Faltantes += $D
            $Idx++
        }
    }
    if ($Faltantes.Count -eq 0) {
        Write-Host "  No falta nada." -ForegroundColor Green
    } else {
        $Sel = Read-Host "  Cual? (numero)"
        if ($Sel -match "^\d+$" -and [int]$Sel -ge 1 -and [int]$Sel -le $Faltantes.Count) {
            Invoke-Install $Faltantes[[int]$Sel - 1]
        }
    }
}
elseif ($Opcion -eq "0") {
    exit 0
}

Write-Host ""
Read-Host "  Enter para cerrar"   