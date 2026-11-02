# 1. Crear directorios de la estructura de dotfiles
$dotfiles = "$env:USERPROFILE\.dotfiles"; New-Item -ItemType Directory -Force -Path "$dotfiles\wallpapers", "$dotfiles\config\glazewm", "$dotfiles\config\terminal";

# 2. Descargar un wallpaper de Umamusume automáticamente
Invoke-WebRequest -Uri "https://unsplash.com" -OutFile "$dotfiles\wallpapers\umamusume_tracen.png" -ErrorAction SilentlyContinue;

# 3. Crear el Mega Script de Instalación (install.ps1)
@'
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; Exit }
Write-Host "🐎 Instalando herramientas de productividad y tema Umamusume..." -ForegroundColor Cyan
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) { Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser; Invoke-RestMethod -Uri https://scoop.sh | Invoke-Expression }
scoop bucket add extras; scoop bucket add nerdy-fonts; scoop install git windows-terminal glazewm JetBrainsMono-NF fzf zoxide;
Write-Host "✨ Herramientas instaladas correctamente." -ForegroundColor Green
'@ | Out-File -FilePath "$dotfiles\install.ps1" -Encoding utf8;

# 4. Crear el Script de Aplicación de Tema (apply_theme.ps1)
@'
$glazeDir = "$env:USERPROFILE\.config\glazewm"; $termDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState";
New-Item -ItemType Directory -Force -Path $glazeDir, $termDir -ErrorAction SilentlyContinue;
Remove-Item -Path "$glazeDir\config.yaml", "$termDir\settings.json" -Force -ErrorAction SilentlyContinue;
cmd /c mklink "$glazeDir\config.yaml" "$env:USERPROFILE\.dotfiles\config\glazewm\config.yaml";
cmd /c mklink "$termDir\settings.json" "$env:USERPROFILE\.dotfiles\config\terminal\settings.json";
$WP = "$env:USERPROFILE\.dotfiles\wallpapers\umamusume_tracen.png";
if (Test-Path $WP) { $c = @'
using System.Runtime.InteropServices; public class W { [DllImport("user32.dll", CharSet = CharSet.Auto)] public static extern int SystemParametersInfo(int a, int p, string v, int f); }
'@; Add-Type $c; [W]::SystemParametersInfo(20, 0, $WP, 3); Write-Host "🏁 ¡Tema e imagen de Umamusume aplicados!" -ForegroundColor Green }
'@ | Out-File -FilePath "$dotfiles\apply_theme.ps1" -Encoding utf8;

# 5. Crear configuración de GlazeWM (config.yaml)
@'
general: { focus_follows_cursor: false, cursor_follows_focus: true }
gaps: { inner_gaps: 8, outer_gaps: 8 }
bar:
  height: 30
  position: top
  background_color: '#0b132b'
  font_family: 'JetBrainsMonoNF'
  font_size: 13
  components:
    - type: workspaces
      focused_color: '#ffb703'
      unfocused_color: '#4ea8de'
    - type: spacer
    - type: text
      text: '🐎 Tracen Academy Workstation 🏆 '
      color: '#e0e1dd'
    - type: spacer
    - type: clock
      time_format: 'HH:mm'
      color: '#ffb703'
workspaces: [ { name: '1: 📝' }, { name: '2: 🌐' }, { name: '3: 🎮' } ]
keybindings:
  - { command: focus left, bindings: ['Alt+H', 'Alt+Left'] }
  - { command: focus right, bindings: ['Alt+L', 'Alt+Right'] }
  - { command: focus up, bindings: ['Alt+K', 'Alt+Up'] }
  - { command: focus down, bindings: ['Alt+J', 'Alt+Down'] }
  - { command: move left, bindings: ['Alt+Shift+H'] }
  - { command: move right, bindings: ['Alt+Shift+L'] }
  - { command: close, bindings: ['Alt+Shift+Q'] }
'@ | Out-File -FilePath "$dotfiles\config\glazewm\config.yaml" -Encoding utf8;

# 6. Crear configuración de Windows Terminal (settings.json)
@'
{
    "profiles": {
        "defaults": {
            "font": { "face": "JetBrainsMonoNF" },
            "colorScheme": "Tracen-Academy",
            "backgroundImage": "C:/Users/$env:USERNAME/.dotfiles/wallpapers/umamusume_tracen.png",
            "backgroundImageOpacity": 0.25,
            "backgroundImageAlignment": "bottomRight",
            "backgroundImageStretchMode": "uniform",
            "useAcrylic": true,
            "acrylicOpacity": 0.7
        }
    },
    "schemes": [
        {
            "name": "Tracen-Academy",
            "background": "#0b132b", "foreground": "#e0e1dd", "cursorColor": "#ffb703",
            "black": "#1c2541", "red": "#ff4d6d", "green": "#52b788", "yellow": "#ffb703",
            "blue": "#4cc9f0", "purple": "#7209b7", "cyan": "#4ea8de", "white": "#ffffff"
        }
    ]
}
'@ | Out-File -FilePath "$dotfiles\config\terminal\settings.json" -Encoding utf8;

Write-Host "✅ ¡Estructura de Dotfiles creada con éxito en $dotfiles!" -ForegroundColor Green;
