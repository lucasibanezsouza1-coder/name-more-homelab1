#define MyAppName "Name More Homelab"
#define MyAppVersion "1.1"

[Setup]
AppId={{B7E5A8C2-1D3F-4E6A-9C8B-2F5D7A1E0C3B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
DefaultDirName={userdocs}\NameMoreHomelab
DefaultGroupName=Name More Homelab
OutputBaseFilename=name-more-homelab-setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Files]
Source: "setup.ps1"; DestDir: "{app}"
Source: "synth.ps1"; DestDir: "{app}"
Source: "optimizador.ps1"; DestDir: "{app}"
Source: "autoorganizer.ps1"; DestDir: "{app}"
Source: "installer.ps1"; DestDir: "{app}"
Source: ".gitattributes"; DestDir: "{app}"
Source: "README.md"; DestDir: "{app}"
Source: "bots\cmd\*"; DestDir: "{app}\bots\cmd"; Flags: recursesubdirs
Source: "bots\ps1\*"; DestDir: "{app}\bots\ps1"; Flags: recursesubdirs
Source: "docs\*"; DestDir: "{app}\docs"; Flags: recursesubdirs

[Dirs]
Name: "{app}\backup"
Name: "{app}\shared\state"

[Icons]
Name: "{autodesktop}\Name More Homelab"; Filename: "powershell.exe"; Parameters: "-NoExit -File ""{app}\setup.ps1"""

[Run]
Filename: "powershell.exe"; Parameters: "-NoExit -Command ""Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force; cd '{app}'; .\setup.ps1"""; Flags: nowait postinstall skipifsilent   