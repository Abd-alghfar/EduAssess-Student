#define MyAppName "CodeKey"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "CodeKey"
#define MyAppExeName "CodeKey.exe"

[Setup]
AppId={{B9D3E1F4-9E1B-4E5E-A111-CKEY0001}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=Output
OutputBaseFilename=CodeKeySetup
Compression=lzma
SolidCompression=yes
;SetupIconFile=windows\runner\resources\app_icon.ico  ; مؤقتا لتعليق الأيقونة
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "build/windows/x64/runner/Release/*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Run CodeKey"; Flags: nowait postinstall skipifsilent
