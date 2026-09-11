@echo off
set GODOT_VERSION=4.7.2-stable
set GODOT_EXE=Godot_v%GODOT_VERSION%_win64.exe
set ZIP_NAME=Godot_v%GODOT_VERSION%_win64.exe.zip
set BIN_DIR=.\bin

if not exist "%BIN_DIR%\%GODOT_EXE%" (
    echo Godot not found, downloading...
    mkdir "%BIN_DIR%" 2>nul

    curl.exe -L --fail --silent --show-error -o "%BIN_DIR%\%ZIP_NAME%" "https://github.com/godotengine/godot-builds/releases/download/%GODOT_VERSION%/%ZIP_NAME%"

    powershell -NoProfile -Command "Expand-Archive '%BIN_DIR%\%ZIP_NAME%' '%BIN_DIR%\tmp_extract' -Force; Get-ChildItem '%BIN_DIR%\tmp_extract' | Get-ChildItem | Move-Item -Destination '%BIN_DIR%'; Remove-Item '%BIN_DIR%\tmp_extract' -Recurse -Force; Remove-Item '%BIN_DIR%\%ZIP_NAME%' -Force"
)

"%BIN_DIR%\%GODOT_EXE%" -e --path .\project