$ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear$ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   $ErrorActionPreference = "Stop"
$Console.Title = "kaitOS v1.0 [devsWL]"

$RunningApps = @()
$OSStart = Get-Date

function Draw-Taskbar {
    $Time = Get-Date -Format "HH:mm"
    $Date = Get-Date -Format "dd/MM/yyyy"
    $AppsStr = ($RunningApps -join " ")
    if ($AppsStr.Length -gt 50) { $AppsStr = $AppsStr.Substring(0, 50) }
    $Pad = [Math]::Max(0, 50 - $AppsStr.Length)
    $Y = $Console.WindowHeight - 3
    $Console.SetCursorPosition(0, $Y)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
    $Console.SetCursorPosition(0, $Y + 1)
    Write-Host ("|  devsWL  " + ("." * 20) + "  " + $AppsStr + (" " * $Pad) + "  " + $Time + " " + $Date + "  |") -ForegroundColor Cyan
    $Console.SetCursorPosition(0, $Y + 2)
    Write-Host ("+" + ("-" * 78) + "+") -ForegroundColor DarkGray
}

function Draw-Desktop {
    $Console.Clear()
    $Uptime = (Get-Date) - $OSStart
    $UpStr = "{0:D2}:{1:D2}:{2:D2}" -f $Uptime.Hours, $Uptime.Minutes, $Uptime.Seconds

    $Console.SetCursorPosition(10, 3)
    Write-Host "=============================================" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 4)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 5)
    Write-Host "  d e v s W L" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 6)
    Write-Host "  . . . . . . . . . . . . . . . . . . . . ." -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 7)
    Write-Host "  | |  | |  | |  | |  | |  | |" -ForegroundColor Cyan
    $Console.SetCursorPosition(10, 8)
    Write-Host "=============================================" -ForegroundColor Cyan

    $Console.SetCursorPosition(10, 11)
    Write-Host "  kaitOS v1.0 - devsWL" -ForegroundColor White
    $Console.SetCursorPosition(10, 12)
    Write-Host "  Name More / Kait / Cebollas" -ForegroundColor DarkGray
    $Console.SetCursorPosition(10, 14)
    Write-Host "  [1] Navegador (Google)" -ForegroundColor Green
    $Console.SetCursorPosition(10, 15)
    Write-Host "  [2] Tetris" -ForegroundColor Green
    $Console.SetCursorPosition(10, 16)
    Write-Host "  [3] Snake" -ForegroundColor Green
    $Console.SetCursorPosition(10, 17)
    Write-Host "  [4] Archivos" -ForegroundColor Green
    $Console.SetCursorPosition(10, 18)
    Write-Host "  [5] Terminal" -ForegroundColor Green
    $Console.SetCursorPosition(10, 19)
    Write-Host "  [6] Calculadora" -ForegroundColor Green
    $Console.SetCursorPosition(10, 20)
    Write-Host "  [0] Apagar" -ForegroundColor Red
    $Console.SetCursorPosition(10, 22)
    Write-Host "  Uptime: $UpStr" -ForegroundColor DarkGray

    Draw-Taskbar
}

function Start-Browser {
    $RunningApps += "Navegador"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo Google..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    start "https://www.google.com"
    Write-Host "  Google abierto." -ForegroundColor Green
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Navegador" }
    Draw-Desktop
}

function Start-Files {
    $RunningApps += "Archivos"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo archivos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process explorer.exe "$env:USERPROFILE"
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Archivos" }
    Draw-Desktop
}

function Start-Terminal {
    $RunningApps += "Terminal"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo terminal..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process powershell.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Terminal" }
    Draw-Desktop
}

function Start-Calc {
    $RunningApps += "Calc"
    Draw-Taskbar
    $Console.SetCursorPosition(0, 0)
    Write-Host "  Abriendo calculadora..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Start-Process calc.exe
    Read-Host "  Enter para cerrar"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Calc" }
    Draw-Desktop
}

function Start-Tetris {
    $RunningApps += "Tetris"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  TETRIS - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Espacio: rotar  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 10
    $H = 20
    $Grid = New-Object int[] ($W * $H)
    $Score = 0
    $GameOver = $false

    $PI = @(1,1,1,1)
    $PO = @(1,1,1,1)
    $PT = @(0,1,0,1,1,1)
    $PL = @(0,1,0,0,1,1,1)
    $PJ = @(1,0,0,1,1,1)
    $PS = @(0,1,1,1,1,0)
    $PZ = @(1,1,0,0,1,1)
    $AllPieces = @($PI, $PO, $PT, $PL, $PJ, $PS, $PZ)
    $AllCols = @(4, 2, 3, 3, 3, 3, 3)

    function New-Piece {
        $Idx = Get-Random -Maximum 7
        $X = 3
        $Y = 0
        return @{ Shape=$AllPieces[$Idx]; Cols=$AllCols[$Idx]; X=$X; Y=$Y; Idx=$Idx }
    }

    function Get-Rows($Shape, $Cols) {
        return [Math]::Ceiling($Shape.Count / $Cols)
    }

    function Check-Coll($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TX -lt 0 -or $TX -ge $W -or $TY -ge $H) { return $true }
                    if ($TY -ge 0 -and $G[$TY * $W + $TX] -ne 0) { return $true }
                }
            }
        }
        return $false
    }

    function Lock-P($G, $C) {
        $Rows = Get-Rows $C.Shape $C.Cols
        for ($pr = 0; $pr -lt $Rows; $pr++) {
            for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                $SI = ($pr * $C.Cols) + $pc
                if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                    $TX = $C.X + $pc
                    $TY = $C.Y + $pr
                    if ($TY -ge 0 -and $TY -lt $H -and $TX -ge 0 -and $TX -lt $W) {
                        $G[$TY * $W + $TX] = 1
                    }
                }
            }
        }
        $Lines = 0
        for ($r = $H - 1; $r -ge 0; $r--) {
            $Full = $true
            for ($c = 0; $c -lt $W; $c++) {
                if ($G[$r * $W + $c] -eq 0) { $Full = $false; break }
            }
            if ($Full) {
                $Lines++
                for ($rr = $r; $rr -gt 0; $rr--) {
                    for ($c = 0; $c -lt $W; $c++) {
                        $G[$rr * $W + $c] = $G[($rr - 1) * $W + $c]
                    }
                }
                for ($c = 0; $c -lt $W; $c++) { $G[$c] = 0 }
            }
        }
        return $Lines
    }

    function Draw-Board($G, $C, $S) {
        $Rows = Get-Rows $C.Shape $C.Cols
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "|"
            for ($c = 0; $c -lt $W; $c++) {
                $IsPiece = $false
                for ($pr = 0; $pr -lt $Rows; $pr++) {
                    for ($pc = 0; $pc -lt $C.Cols; $pc++) {
                        $SI = ($pr * $C.Cols) + $pc
                        if ($SI -lt $C.Shape.Count -and $C.Shape[$SI] -eq 1) {
                            if (($C.X + $pc) -eq $c -and ($C.Y + $pr) -eq $r) { $IsPiece = $true }
                        }
                    }
                }
                if ($IsPiece) { $Row += "[]" }
                elseif ($G[$r * $W + $c] -ne 0) { $Row += "##" }
                else { $Row += "  " }
            }
            $Row += "|"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2, 3 + $H)
        Write-Host "  Score: $S" -ForegroundColor Yellow
    }

    $Cur = New-Piece

    while (-not $GameOver) {
        Draw-Board $Grid $Cur $Score
        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Left" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X-1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X-- }
            }
            "Right" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=($Cur.X+1); Y=$Cur.Y; Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.X++ }
            }
            "Down" {
                $Test = @{ Shape=$Cur.Shape; Cols=$Cur.Cols; X=$Cur.X; Y=($Cur.Y+1); Idx=$Cur.Idx }
                if (-not (Check-Coll $Grid $Test)) { $Cur.Y++ }
                else {
                    $Lines = Lock-P $Grid $Cur
                    $Score += $Lines * 100
                    $Cur = New-Piece
                    if (Check-Coll $Grid $Cur) { $GameOver = $true }
                }
            }
            "Q" { $GameOver = $true }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Tetris" }
    Draw-Desktop
}

function Start-Snake {
    $RunningApps += "Snake"
    Draw-Taskbar
    $Console.Clear()
    $Console.SetCursorPosition(0, 0)
    Write-Host "  SNAKE - kaitOS" -ForegroundColor Cyan
    Write-Host "  Flechas: mover  Q: salir" -ForegroundColor DarkGray
    Write-Host ""

    $W = 30
    $H = 15
    $Snake = @(@([int]10,[int]10))
    $DirX = 1
    $DirY = 0
    $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
    $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
    $Score = 0
    $GameOver = $false

    while (-not $GameOver) {
        $Console.SetCursorPosition(2, 3)
        for ($r = 0; $r -lt $H; $r++) {
            $Row = "+"
            for ($c = 0; $c -lt $W; $c++) { $Row += "-" }
            $Row += "+"
            Write-Host $Row -ForegroundColor DarkGray
        }
        $Console.SetCursorPosition(2 + ($FoodX * 2), 3 + $FoodY)
        Write-Host "O" -ForegroundColor Yellow
        foreach ($Seg in $Snake) {
            $Console.SetCursorPosition(2 + ($Seg[0] * 2), 3 + $Seg[1])
            Write-Host "[]" -ForegroundColor Green
        }
        $Console.SetCursorPosition(2, 3 + $H + 1)
        Write-Host "  Score: $Score" -ForegroundColor Yellow

        $Key = $Console.ReadKey($true)
        switch ($Key.Key) {
            "Up"    { if ($DirY -ne 1)  { $DirX=0;  $DirY=-1 } }
            "Down"  { if ($DirY -ne -1) { $DirX=0;  $DirY=1 } }
            "Left"  { if ($DirX -ne 1)  { $DirX=-1; $DirY=0 } }
            "Right" { if ($DirX -ne -1) { $DirX=1;  $DirY=0 } }
            "Q"     { $GameOver = $true }
        }

        $HeadX = $Snake[0][0] + $DirX
        $HeadY = $Snake[0][1] + $DirY

        if ($HeadX -lt 0 -or $HeadX -ge $W -or $HeadY -lt 0 -or $HeadY -ge $H) { $GameOver = $true }
        foreach ($Seg in $Snake) {
            if ($Seg[0] -eq $HeadX -and $Seg[1] -eq $HeadY) { $GameOver = $true }
        }

        $NewHead = @([int]$HeadX, [int]$HeadY)
        $Snake = @($NewHead) + $Snake

        if ($HeadX -eq $FoodX -and $HeadY -eq $FoodY) {
            $Score += 10
            $FoodX = Get-Random -Minimum 1 -Maximum ($W-1)
            $FoodY = Get-Random -Minimum 1 -Maximum ($H-1)
        } else {
            if ($Snake.Count -gt 1) { $Snake = $Snake[0..($Snake.Count-2)] }
        }
    }

    $Console.Clear()
    Write-Host ""
    Write-Host "  GAME OVER" -ForegroundColor Red
    Write-Host "  Score: $Score" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "  Enter para volver"
    $RunningApps = $RunningApps | Where-Object { $_ -ne "Snake" }
    Draw-Desktop
}

# === BOOT ===
$Console.Clear()
$Console.SetCursorPosition(20, 8)
Write-Host "  kaitOS v1.0" -ForegroundColor Cyan
$Console.SetCursorPosition(20, 10)
Write-Host "  Iniciando..." -ForegroundColor DarkGray
Start-Sleep -Seconds 1
$Console.SetCursorPosition(20, 11)
Write-Host "  [OK] Nucleo" -ForegroundColor Green
$Console.SetCursorPosition(20, 12)
Write-Host "  [OK] Apps" -ForegroundColor Green
Start-Sleep -Seconds 1

# === MAIN ===
while ($true) {
    Draw-Desktop
    $Choice = Read-Host "  >"
    switch ($Choice) {
        "1" { Start-Browser }
        "2" { Start-Tetris }
        "3" { Start-Snake }
        "4" { Start-Files }
        "5" { Start-Terminal }
        "6" { Start-Calc }
        "0" {
            $Console.Clear()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   ()
            $Console.SetCursorPosition(20, 12)
            Write-Host "  kaitOS - Apagando..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
            $Console.SetCursorPosition(20, 14)
            Write-Host "  [OK] Sistema apagado." -ForegroundColor DarkGray
            Start-Sleep -Seconds 1
            exit 0
        }
    }
}   