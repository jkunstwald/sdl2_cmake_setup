
[Setup]
AppName                = SDL2
AppVersion             = 2.0.10
AppPublisher           = SDL Community / Jonathan Kunstwald
AppPublisherURL        = https://github.com/jkunstwald/sdl2_cmake_setup
DefaultDirName         = C:\Libraries\SDL2
OutputBaseFilename     = SDL2_Setup
ExtraDiskSpaceRequired = 1937408
ChangesEnvironment     = yes  

#include <idp.iss>
    
[Files]
; Copy the CMake config file to the target directory
Source: "data\sdl2-config.cmake"; DestDir: "{app}\SDL2-2.0.10"; Flags: ignoreversion

[Dirs]
; Create the include/SDL2 folder to later on move headers into
Name: "{app}\SDL2-2.0.10\include\SDL2"

[Registry]
; Create a system-wide environment variable SDL2_DIR for automatic CMake detection
Root: HKLM; Subkey: "System\CurrentControlSet\Control\Session Manager\Environment"; ValueType:string; ValueName: "SDL2_DIR"; \
    ValueData: "{app}\SDL2-2.0.10"; Flags: preservestringtype uninsdeletevalue

[UninstallDelete]
Type: filesandordirs; Name: "{app}\SDL2-2.0.10"

[Code]
procedure InitializeWizard();
begin
    idpAddFile('https://www.libsdl.org/release/SDL2-devel-2.0.10-VC.zip', ExpandConstant('{tmp}\SDL2.zip'));
    idpDownloadAfter(wpReady);
end;

const
    SHCONTCH_NOPROGRESSBOX = 4;
    SHCONTCH_RESPONDYESTOALL = 16;

procedure UnZip(ZipPath, TargetPath: string); 
var
    Shell: Variant;
    ZipFile: Variant;
    TargetFolder: Variant;
begin
    Shell := CreateOleObject('Shell.Application');

    ZipFile := Shell.NameSpace(ZipPath);
    if VarIsEmpty(ZipFile) then
        RaiseException(Format('ZIP file "%s" does not exist or cannot be opened', [ZipPath]));

    TargetFolder := Shell.NameSpace(TargetPath);
    if VarIsEmpty(TargetFolder) then
        RaiseException(Format('Target path "%s" does not exist', [TargetPath]));

    TargetFolder.CopyHere(ZipFile.Items, SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL);
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
    ErrorCode: Integer;
begin
    if CurStep = ssPostInstall then 
    begin
        // Unzip downloaded files to application directory
        UnZip(ExpandConstant('{tmp}\SDL2.zip'), ExpandConstant('{app}\'));
        // Move headers to include/SDL2/ for proper include paths
        Exec('cmd.exe', ExpandConstant('/c MOVE "{app}\SDL2-2.0.10\include\*" "{app}\SDL2-2.0.10\include\SDL2\"'), '', SW_HIDE, ewWaitUntilTerminated, ErrorCode);
    end;
end;

