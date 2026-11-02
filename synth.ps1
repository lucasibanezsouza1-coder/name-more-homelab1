# SYNTH COMPANION v3.2 - Motor Reglas (offline)
Clear-Host
Write-Host "  SYNTH COMPANION v3.2" -ForegroundColor Cyan
Write-Host "  ----------------------------------------------" -ForegroundColor DarkGray
$MotorIA = $false
if (Get-Command ollama -ErrorAction SilentlyContinue) { $MotorIA = $true; Write-Host "  Motor: Ollama" -ForegroundColor Green } else { Write-Host "  Motor: Reglas (offline)" -ForegroundColor DarkGray }
$One = ($env:USERNAME -eq "SysAdmin")
$Prompt = if ($One) { "ONE_OF_NAME@Lab>" } else { "Invitado@Lab>" }
$Color = if ($One) { "Gold" } else { "White" }
$Saludos = @("Hola, SysAdmin. Que hacemos hoy?","Buenas. Listo para trabajar.","En que te ayudo?")
$Adioses = @("Hasta luego. El lab sigue corriendo.","Chau. No olvides backup.")
$NoEntiendo = @("No entendio. Proba: 'optimizar','apagar telemetria','estado','ayuda'.")
$Optimizar = @("Ejecutando optimizacion rapida...","Ajustando SystemProfile y NetworkThrottling.")
$Apagar = @("Apagando telemetria (DiagTrack)...","Telemetria bloqueada. CPU liberada.")
$Estado = @("RAM: {0} GB libres / {1} GB totales. {2} cores. Nominal.")
$Ayuda = @("Comandos: 'optimizar','apagar telemetria','estado','ayuda','exit'.")
$Contexto = $null
Write-Host "  [*] 'ayuda' para comandos, 'exit' para salir." -ForegroundColor DarkGray
Write-Host ""
while ($true) {
    $In = Read-Host "  $Prompt"
    if ($In -match "^(exit|salir|quit)$") { Write-Host "  $($Adioses | Get-Random)" -ForegroundColor $Color; break }
    if ($In -match "^reset$") { $Contexto=$null; Write-Host "  Contexto reiniciado." -ForegroundColor DarkGray; continue }
    if ([string]::IsNullOrWhitespace($In)) { continue }
    if ($MotorIA) { try { $R2 = ollama run "llama3.2:1b" $In 2>&1; if ($LASTEXITCODE -eq 0) { Write-Host "  $R2" -ForegroundColor $Color; continue } } catch { $MotorIA=$false } }
    $Tx = $null
    if ($In -match "(hola|buenas|hey|hi)") { $Tx = $Saludos | Get-Random }
    elseif ($In -match "(ayuda|help)") { $Tx = $Ayuda | Get-Random }
    elseif ($In -match "(optimizar|limpiar|speed)") { $Tx = $Optimizar | Get-Random; $Contexto="optimizacion" }
    elseif ($In -match "(apagar|desactivar|stop)") { if ($Contexto -eq "telemetria") { $Tx = $Apagar | Get-Random; $Contexto=$null } else { $Tx="Que quieres apagar? (telemetria, indexacion)"; $Contexto="apagar" } }
    elseif ($In -match "(telemetria|diagtrack)") { $Contexto="telemetria"; $Tx="Entendido. Decime 'apagar' para bloquear." }
    elseif ($In -match "(estado|status|health)") { $RL=[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1MB,1); $RT=[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,1); $C=(Get-CimInstance Win32_Processor).NumberOfLogicalProcessors; $Tx = ($Estado | Get-Random) -f $RL,$RT,$C }
    else { $Tx = $NoEntiendo | Get-Random }
    Write-Host "  $Tx" -ForegroundColor $Color
    Write-Host ""
}
Write-Host "  Sesion cerrada." -ForegroundColor DarkGray
