# =========================================================================
# 📚 CRÓNICAS DE NAME MORE — VOLUMEN 1 (MÓDULO ASISTENTE IA v3.2)
# Código: 'ONE OF NAME' — Edición de Código Abierto (Open-Source Edition)
# Desarrollador Principal: SysAdmin / Name More
# =========================================================================

if ($env:USERNAME -ne "SysAdmin") {
    Write-Host "🔒 Acceso Denegado: Usuario local no autorizado." -ForegroundColor Red
    Start-Sleep -Seconds 3; exit
}

Clear-Host
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "     SYNTH COMPANION v3.2 [OPEN-SOURCE & NO-KEY]       " -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "💡 Estado: Conectado a Servidor Público Gratuito (Kilo API)" -ForegroundColor Green
Write-Host ""

# Verificación por palabra clave (Token de One)
$TienePermisosDeOne = $false
$TokenDeOne = "SysAdmin15"

$SecurePrompt = Read-Host -AsSecureString "🔐 Ingrese Token de Acceso Maestra"
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePrompt)
$PasswordInput = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

if ($PasswordInput -eq $TokenDeOne) {
    $TienePermisosDeOne = $true
    Write-Host "🔥 ACCESO CONCEDIDO: Modo Creador 'ONE OF NAME' Activo. Privilegios Máximos." -ForegroundColor Yellow
} else {
    Write-Host "⚠️ Token incorrecto. Iniciando en Modo Restringido." -ForegroundColor Yellow
    Start-Sleep -Seconds 2; exit
}

$Url = "https://kilo.ai"

while ($true) {
    Write-Host ""
    $InputUsuario = Read-Host "👑 ONE_OF_NAME@NameMore_Lab> "

    if ($InputUsuario -match "exit" -or $InputUsuario -match "salir") { 
        Write-Host "Desconectando Asistente... ¡Buen trabajo, SysAdmin!" -ForegroundColor Yellow
        Start-Sleep -Seconds 2; break 
    }
    if ([string]::IsNullOrWhitespace($InputUsuario)) { continue }

    Write-Host "🤖 Pensando..." -ForegroundColor DarkGray

    $SystemInstruction = "Eres un asistente de TI cyberpunk para SysAdmin (Name More). Responde de forma técnica y compacta."
    $BodyObj = @{
        model = "kilo-auto/free"
        messages = @(
            @{ role = "system"; content = $SystemInstruction },
            @{ role = "user"; content = $InputUsuario }
        )
    }
    $BodyJson = $BodyObj | ConvertTo-Json -Depth 10 -Compress

    try {
        $Response = Invoke-RestMethod -Method Post -Uri $Url -ContentType "application/json" -Body $BodyJson
        $RespuestaIA = $Response.choices.message.content
        Write-Host ""
        Write-Host "🤖 Asistente:" -ForegroundColor Yellow
        Write-Output $RespuestaIA
    }
    catch {
        Write-Host "❌ Error de conexión al Gateway público." -ForegroundColor Red
    }
}
