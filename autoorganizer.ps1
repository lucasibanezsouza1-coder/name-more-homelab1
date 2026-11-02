$ErrorActionPreference = "Stop"
$Repo = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$Log  = "$Repo\auto_organizer.log"

function Log($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $Log -Value "[$ts] $msg"
}

Clear-Host
Write-Host "  AUTO ORGANIZER v1.0" -ForegroundColor Cyan
Write-Host "  ----------------------------------------------" -ForegroundColor DarkGray
Write-Host "  Repo: $Repo" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  [1] ORGANIZAR TODO Y SUBIR A GIT" -ForegroundColor Cyan
Write-Host "  [2] SOLO VERIFICAR" -ForegroundColor Cyan
Write-Host "  [3] CREAR ESTRUCTURA DESDE CERO" -ForegroundColor Cyan
Write-Host "  [4] ABRIR FILE EXPLORER" -ForegroundColor Cyan
Write-Host "  [5] VER ULTIMO LOG" -ForegroundColor Cyan
Write-Host "  [0] SALIR" -ForegroundColor Cyan
Write-Host ""
$Opcion = Read-Host "  >"

switch ($Opcion) {
    "1" {
        Log "=== ORGANIZACION ==="
        $Dirs = @("bots\cmd","bots\ps1","backup","docs")
        foreach ($d in $Dirs) {
            $Full = Join-Path $Repo $d
            if (-not (Test-Path $Full)) { New-Item -ItemType Directory -Force -Path $Full | Out-Null; Write-Host "  [CREADO] $d" -ForegroundColor DarkGray }
        }
        $BatSueltos = Get-ChildItem $Repo -Filter "*.bat" -File -ErrorAction SilentlyContinue
        foreach ($f in $BatSueltos) { Move-Item $f.FullName -Destination (Join-Path $Repo "bots\cmd") -Force; Write-Host "  [MOVIDO] $($f.Name)" -ForegroundColor Yellow }
        $Principales = @("setup.ps1","synth.ps1","optimizador.ps1","autoorganizer.ps1")
        $Ps1Sueltos = Get-ChildItem $Repo -Filter "*.ps1" -File -ErrorAction SilentlyContinue
        foreach ($f in $Ps1Sueltos) { if ($Principales -notcontains $f.Name) { Move-Item $f.FullName -Destination (Join-Path $Repo "bots\ps1") -Force; Write-Host "  [MOVIDO] $($f.Name)" -ForegroundColor Yellow } }
        $Permitidos = @("README.md",".gitattributes","auto_organizer.log")
        $Otros = Get-ChildItem $Repo -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in @(".txt",".json",".md",".cfg",".ini") -and $Permitidos -notcontains $_.Name }
        foreach ($f in $Otros) { Move-Item $f.FullName -Destination (Join-Path $Repo "docs") -Force; Write-Host "  [MOVIDO] $($f.Name)" -ForegroundColor Yellow }
        Set-Location $Repo
        git add . 2>&1 | Out-Null
        $Status = git status --porcelain 2>&1
        if ($Status) {
            $Fecha = Get-Date -Format "yyyy-MM-dd HHmm"
            git commit -m "auto-organizer: $Fecha" 2>&1 | Out-Null
            Write-Host "  [COMMIT] $Fecha" -ForegroundColor Green
            $Remote = git remote -v 2>&1
            if ($Remote) { cmd /c "git push >nul 2>&1"   ; Write-Host "  [PUSH] OK" -ForegroundColor Green }
            else { Write-Host "  [PUSH] Sin remote." -ForegroundColor DarkGray }
        } else { Write-Host "  [OK] Todo limpio." -ForegroundColor Green }
        Log "=== FIN ==="
    }
    "2" {
        Set-Location $Repo
        $Status = git status --porcelain 2>&1
        if ($Status) { Write-Host "  [!] Sin commitear:" -ForegroundColor Yellow; $Status | ForEach-Object { Write-Host "      $_" } }
        else { Write-Host "  [OK] Git limpio." -ForegroundColor Green }
        $B = Get-ChildItem $Repo -Filter "*.bat" -File -ErrorAction SilentlyContinue
        if ($B) { Write-Host "  [!] .bat sueltos:" -ForegroundColor Yellow; $B | ForEach-Object { Write-Host "      $($_.Name)" } }
    }
    "3" {
        $Dirs = @("bots\cmd","bots\ps1","backup","docs")
        foreach ($d in $Dirs) {
            $Full = Join-Path $Repo $d
            if (-not (Test-Path $Full)) { New-Item -ItemType Directory -Force -Path $Full | Out-Null; Write-Host "  [CREADO] $d" -ForegroundColor Green }
            else { Write-Host "  [OK] $d" -ForegroundColor DarkGray }
        }
        if (-not (Test-Path "$Repo\.gitattributes")) { "*.bat text eol=crlf`n*.ps1 text eol=crlf" | Set-Content "$Repo\.gitattributes" -Encoding UTF8; Write-Host "  [CREADO] .gitattributes" -ForegroundColor Green }
    }
    "4" { Start-Process explorer.exe $Repo }
    "5" { if (Test-Path $Log) { Get-Content $Log -Tail 20 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray } } else { Write-Host "  (Sin log)" } }
    "0" { exit 0 }
}
Write-Host ""
Read-Host "  Enter para cerrar"   