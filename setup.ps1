$ErrorActionPreference = "Stop"
$BaseDir = $PSScriptRoot

Clear-Host
Write-Host "  NAME MORE HOMELAB SERVER v1.1" -ForegroundColor Cyan
Write-Host "  ----------------------------------------------" -ForegroundColor DarkGray
$RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)
$Cores = (Get-CimInstance Win32_Processor).NumberOfLogicalProcessors
Write-Host "  User: $env:USERNAME | CPU: $Cores cores | RAM: $RAM GB" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [1] SYNTH COMPANION" -ForegroundColor Cyan
Write-Host "  [2] OPTIMIZADOROS" -ForegroundColor Cyan
Write-Host "  [3] BOTS" -ForegroundColor Cyan
Write-Host "  [0] SALIR" -ForegroundColor Cyan
Write-Host ""

while ($true) {
    $O = Read-Host "  NameMore>"
    switch ($O) {
        "1" { Write-Host "  -> SYNTH (en desarrollo para este nodo)"; Read-Host "  Enter" }
        "2" { Write-Host "  -> OPTIMIZADOR (en desarrollo para este nodo)"; Read-Host "  Enter" }
        "3" {
            $Bots = Get-ChildItem "$BaseDir\bots" -Recurse -File -ErrorAction SilentlyContinue
            if (-not $Bots) { Write-Host "  (No bots en este nodo)"; Read-Host "  Enter"; continue }
            $i=1; foreach($f in $Bots){ Write-Host "  [$i] $($f.Name)" -ForegroundColor White; $i++ }
            Write-Host "  [0] Volver" -ForegroundColor DarkGray
            $S = Read-Host "  >"
            if ($S -ne "0" -and $S -match "^\d+$" -and [int]$S -le $Bots.Count) {
                $Bot = $Bots[[int]$S-1]
                if ($Bot.Extension -eq ".bat") { cmd /c `"$($Bot.FullName)`" } else { & "$($Bot.FullName)" }
                Read-Host "  Enter"
            }
        }
        "0" { Write-Host "  Nodo cerrado." -ForegroundColor DarkGray; exit 0 }
        default { Write-Host "  Opcion invalida." -ForegroundColor Red }
    }
}
