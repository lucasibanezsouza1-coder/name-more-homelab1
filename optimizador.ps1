# OPTIMIZADOROS v2.0
$ErrorActionPreference = "Continue"
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $IsAdmin) { Write-Host "Ejecuta como Administrador." -ForegroundColor Red; Read-Host "Enter"; exit 1 }
Clear-Host
Write-Host "  OPTIMIZADOROS v2.0" -ForegroundColor Cyan
$RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)
$Cores = (Get-CimInstance Win32_Processor).NumberOfLogicalProcessors
Write-Host "  CPU: $Cores cores | RAM: $RAM GB" -ForegroundColor DarkGray
$Full = ($RAM -ge 4) -and ($Cores -ge 2)
$BackupDir = "$PSScriptRoot\backup\$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
Write-Host "  Backup: $BackupDir" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [S] SAFE (todas las PCs)" -ForegroundColor Cyan
Write-Host "  [F] FULL (4GB+ RAM)" -ForegroundColor Cyan
Write-Host "  [A] TODO" -ForegroundColor Cyan
Write-Host "  [0] Salir" -ForegroundColor Cyan
$M = Read-Host "  Modo"
function Do-Opt([int]$Id) {
    switch ($Id) {
        1 { Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; Write-Host "  [OK] Temporales" -ForegroundColor Green }
        2 { Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue; Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue; Write-Host "  [OK] Telemetria" -ForegroundColor Green }
        3 { Stop-Service WSearch -Force -ErrorAction SilentlyContinue; Set-Service WSearch -StartupType Disabled -ErrorAction SilentlyContinue; Write-Host "  [OK] Indexacion" -ForegroundColor Green }
        4 { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "SystemProfileScheduler" -Value 0 -Type DWord; Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "SystemProfilePerformance" -Value 0 -Type DWord; Write-Host "  [OK] Low Latency" -ForegroundColor Green }
        5 { $p="HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"; if(Test-Path $p){Set-ItemProperty $p -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord}; Write-Host "  [OK] NetThrottling" -ForegroundColor Green }
        6 { Set-ItemProperty "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord -ErrorAction SilentlyContinue; Write-Host "  [OK] GameDVR OFF" -ForegroundColor Green }
    }
}
switch ($M) {
    "S" { 1..3 | ForEach-Object { Write-Host "  [$_]..."; Do-Opt $_ } }
    "F" { if(-not $Full){Write-Host "  Hardware insuficiente." -ForegroundColor Red; break}; 4..6 | ForEach-Object { Write-Host "  [$_]..."; Do-Opt $_ } }
    "A" { 1..3 | ForEach-Object { Write-Host "  [$_]..."; Do-Opt $_ }; if($Full){4..6 | ForEach-Object { Write-Host "  [$_]..."; Do-Opt $_ }} }
    "0" { exit 0 }
}
Write-Host ""
Write-Host "  Reinicia para aplicar." -ForegroundColor Yellow
