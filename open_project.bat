@echo off
set GODOT_VERSION=4.7.2-stable
set GODOT_EXE=Godot_v%GODOT_VERSION%_mono_win64.exe
set BIN_DIR=.\bin

if not exist "%BIN_DIR%\%GODOT_EXE%" (
    echo Godot not found, downloading...
    set ZIP_NAME=Godot_v%GODOT_VERSION%_mono_win64.zip
    mkdir "%BIN_DIR%" 2>nul
    powershell -Command "Invoke-WebRequest 'https://github.com/godotengine/godot/releases/download/%GODOT_VERSION%/%ZIP_NAME%' -OutFile '%BIN_DIR%\%ZIP_NAME%'"
    powershell -Command "Expand-Archive '%BIN_DIR%\%ZIP_NAME%' '%BIN_DIR%\tmp_extract' -Force; Get-ChildItem '%BIN_DIR%\tmp_extract' | Get-ChildItem | Move-Item -Destination '%BIN_DIR%'; Remove-Item '%BIN_DIR%\tmp_extract' -Recurse -Force"
    del "%BIN_DIR%\%ZIP_NAME%"
)

"%BIN_DIR%\%GODOT_EXE%" -e --path .\project