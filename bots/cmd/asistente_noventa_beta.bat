# =========================================================================
# 📚 CRÓNICAS DE NAME MORE — VOLUMEN 1 (MÓDULO ASISTENTE IA v3.1)
# Código: Privilegios 'ONE OF NAME' (Modo de Desarrollo Abierto)
# Desarrollador Principal: SysAdmin / Name More
# =========================================================================

Clear-Host

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "     SYNTH COMPANION v3.1 [ONE OF NAME ACTIVE]         " -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "[*] Modo de compatibilidad: Verificación de Hash omitida para desarrollo." -ForegroundColor Yellow

# Configuración de Seguridad de "ONE OF NAME"
$OwnerUsername = "SysAdmin"     # Tu usuario exacto de Windows
$TokenDeOne    = "SysAdmin15"   # Tu contraseña maestra para el bot

Write-Host "[*] Verificando entorno de ejecución..." -ForegroundColor DarkGray
$UsuarioActual = $env:USERNAME

if ($UsuarioActual -eq $OwnerUsername) {
    Write-Host "🔓 [OK] Entorno de desarrollo de 'ONE OF NAME' detectado." -ForegroundColor Green
    $SecurePrompt = Read-Host -AsSecureString "🔐 Ingrese Token de Acceso Maestra"
    
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePrompt)
    $PasswordInput = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    if ($PasswordInput -eq $TokenDeOne) {
        $TienePermisosDeOne = $true
        Write-Host "🔥 ACCESO CONCEDIDO: Modo Creador 'ONE OF NAME' Activo. Privilegios Máximos." -ForegroundColor Gold
    } else {
        $TienePermisosDeOne = $false
        Write-Host "⚠️ Token incorrecto. Iniciando en Modo Restringido." -ForegroundColor Yellow
    }
} else {
    $TienePermisosDeOne = $false
    Write-Host "🔒 Modo Invitado Activo." -ForegroundColor Red
}

# Configuración de la API (Gemini Free)
$ApiKey = "TU_API_KEY_AQUI"
$Url = "https://googleapis.com"

if ($TienePermisosDeOne) {
    $SystemInstruction = "Eres el asistente de SysAdmin (Name More). El usuario cuenta con los privilegios máximos 'One of Name'. Modo total activo."
} else {
    $SystemInstruction = "Eres un asistente básico. El usuario actual no posee privilegios avanzados. Acceso restringido."
}

while ($true) {
    Write-Host ""
    $InputUsuario = if ($TienePermisosDeOne) { Read-Host "👑 ONE_OF_NAME@NameMore_Lab" } else { Read-Host "👤 Invitado@NameMore_Lab" }

    if ($InputUsuario -match "exit" -or $InputUsuario -match "salir") { break }
    if ([string]::IsNullOrWhitespace($InputUsuario)) { continue }

    $Body = @{
        systemInstruction = @{ parts = @( @{ text = $SystemInstruction } ) }
        contents = @( @{ parts = @( @{ text = $InputUsuario } ) } )
    } | ConvertTo-Json -Depth 10

    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Post -Body $Body -ContentType "application/json"
        Write-Host "`n🤖 Asistente:" -ForegroundColor (if ($TienePermisosDeOne) { "Gold" } else { "White" })
        Write-Output $Response.candidates.content.parts.text
    }
    catch {
        Write-Host "❌ Error de comunicación. Asegúrate de configurar tu API Key real." -ForegroundColor Red
    }
}
