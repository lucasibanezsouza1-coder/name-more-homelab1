# NAME MORE HOMELAB SERVER v1.1
$ErrorActionPreference = "Stop"
$BaseDir = $PSScriptRoot

Clear-Host
Write-Host "  +----------------------------------------------+" -ForegroundColor Cyan
Write-Host "  |  [1] Espanol                                 |" -ForegroundColor Cyan
Write-Host "  |  [2] Portugues                               |" -ForegroundColor Cyan
Write-Host "  |  [3] English                                 |" -ForegroundColor Cyan
Write-Host "  +----------------------------------------------+" -ForegroundColor Cyan
$Lang = Read-Host "  Idioma"

$T = @{}
if ($Lang -eq "1") {
    $T = @{ Warning="ADVERTENCIA: Esta accion puede modificar el sistema operativo. Las dependencias faltantes se indicaran."; Confirm="Continuar? (y/n)"; Yes="y"; Menu1="SYNTH COMPANION"; Menu2="OPTIMIZADOROS"; Menu3="BOTS"; Menu4="CONFIG"; Menu5="SOBRE"; Menu0="SALIR"; Exit="Hasta luego."; Invalid="Opcion invalida."; Back="Enter para volver"; Running="Ejecutando:" }
} elseif ($Lang -eq "2") {
    $T = @{ Warning="AVISO: Esta acao pode modificar o sistema operacional. As dependencias faltantes serao indicadas."; Confirm="Continuar? (s/n)"; Yes="s"; Menu1="SYNTH COMPANION"; Menu2="OPTIMIZADOROS"; Menu3="BOTS"; Menu4="CONFIG"; Menu5="SOBRE"; Menu0="SAIR"; Exit="Ate logo."; Invalid="Opcao invalida."; Back="Enter para voltar"; Running="Executando:" }
} else {
    $T = @{ Warning="WARNING: This can modify your OS. Missing dependencies will be listed."; Confirm="Continue? (y/n)"; Yes="y"; Menu1="SYNTH COMPANION"; Menu2="OPTIMIZADOROS"; Menu3="BOTS"; Menu4="CONFIG"; Menu5="ABOUT"; Menu0="EXIT"; Exit="Goodbye."; Invalid="Invalid option."; Back="Enter to return"; Running="Running:" }
}

Clear-Host
Write-Host "  NAME MORE HOMELAB SERVER v1.1" -ForegroundColor Cyan
$RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)
$Cores = (Get-CimInstance Win32_Processor).NumberOfLogicalProcessors
Write-Host "  User: $env:USERNAME | CPU: $Cores cores | RAM: $RAM GB" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [!] $($T.Warning)" -ForegroundColor Yellow
Write-Host ""
Write-Host "  $($T.Confirm)" -ForegroundColor Cyan
$R = Read-Host "  >"
if ($R -ne $T.Yes) { Write-Host "  $($T.Exit)"; exit 0 }

Write-Host ""
Write-Host "  CHECK DEPENDENCIES" -ForegroundColor DarkGray
if (Get-Command git -ErrorAction SilentlyContinue) { Write-Host "  [OK] Git" -ForegroundColor Green } else { Write-Host "  [!] Git - winget install Git.Git" -ForegroundColor Yellow }
if (Get-Command ollama -ErrorAction SilentlyContinue) { Write-Host "  [OK] Ollama" -ForegroundColor Green } else { Write-Host "  [!] Ollama - winget install Ollama.Ollama" -ForegroundColor Yellow }
$Bots = @(Get-ChildItem "$BaseDir\bots" -Recurse -File -ErrorAction SilentlyContinue)
Write-Host "  [OK] Bots: $($Bots.Count) encontrados" -ForegroundColor Green
Write-Host ""
Read-Host "  $($T.Back)"

while ($true) {
    Clear-Host
    Write-Host "  +----------------------------------------------+" -ForegroundColor Cyan
    Write-Host "  |  [1] $($T.Menu1.PadRight(38)) |" -ForegroundColor Cyan
    Write-Host "  |  [2] $($T.Menu2.PadRight(38)) |" -ForegroundColor Cyan
    Write-Host "  |  [3] $($T.Menu3.PadRight(38)) |" -ForegroundColor Cyan
    Write-Host "  |  [4] $($T.Menu4.PadRight(38)) |" -ForegroundColor Cyan
    Write-Host "  |  [5] $($T.Menu5.PadRight(38)) |" -ForegroundColor Cyan
    Write-Host "  |  [0] $($T.Menu0.PadRight(38)) |" -ForegroundColor Cyan
    Write-Host "  +----------------------------------------------+" -ForegroundColor Cyan
    Write-Host ""
    $O = Read-Host "  NameMore>"
    switch ($O) {
        "1" { if (Test-Path "$BaseDir\synth.ps1") { & "$BaseDir\synth.ps1" } else { Write-Host "  [!] synth.ps1 no encontrado" -ForegroundColor Red }; Read-Host "  $($T.Back)" }
        "2" { if (Test-Path "$BaseDir\optimizador.ps1") { & "$BaseDir\optimizador.ps1" } else { Write-Host "  [!] optimizador.ps1 no encontrado" -ForegroundColor Red }; Read-Host "  $($T.Back)" }
        "3" {
            Clear-Host
            $B = @(Get-ChildItem "$BaseDir\bots" -Recurse -File -ErrorAction SilentlyContinue)
            if (-not $B) { Write-Host "  (No bots)"; Read-Host "  $($T.Back)"; continue }
            $i=1; foreach($f in $B){ Write-Host "  [$i] $($f.Name)" -ForegroundColor White; $i++ }
            Write-Host "  [0] Volver" -ForegroundColor DarkGray
            $S = Read-Host "  >"
            if ($S -ne "0" -and [int]$S -ge 1 -and [int]$S -le $B.Count) { $Bot=$B[[int]$S-1]; if($Bot.Extension -eq ".bat"){ cmd /c ""$($Bot.FullName)`" } else { & "$($Bot.FullName)" } }
            Read-Host "  $($T.Back)"
        }
        "4" { Clear-Host; Write-Host "  CPU: $env:PROCESSOR_IDENTIFIER" -ForegroundColor White; Write-Host "  RAM: $RAM GB" -ForegroundColor White; Read-Host "  $($T.Back)" }
        "5" { Clear-Host; Write-Host "  NAME MORE HOMELAB v1.1 - SysAdmin (11) - MIT" -ForegroundColor Cyan; Read-Host "  $($T.Back)" }
        "0" { Write-Host "  $($T.Exit)"; exit 0 }
        default { Write-Host "  $($T.Invalid)" -ForegroundColor Red }
    }
}
