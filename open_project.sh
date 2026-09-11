#!/bin/bash
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

GODOT_VERSION="4.7.2-stable"
GODOT_EXE="Godot_v${GODOT_VERSION}_mono_linux.x86_64"
BIN_DIR="./bin"

if [ ! -f "$BIN_DIR/$GODOT_EXE" ]; then
    echo "Godot not found, downloading..."
    ZIP_NAME="Godot_v${GODOT_VERSION}_mono_linux_x86_64.zip"
    mkdir -p "$BIN_DIR"
    curl -L -o "$BIN_DIR/$ZIP_NAME" "https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/${ZIP_NAME}"
    unzip -q "$BIN_DIR/$ZIP_NAME" -d "$BIN_DIR/tmp_extract"
    mv "$BIN_DIR"/tmp_extract/*/* "$BIN_DIR/"
    rm -rf "$BIN_DIR/tmp_extract"
    rm "$BIN_DIR/$ZIP_NAME"
    chmod +x "$BIN_DIR/$GODOT_EXE"
fi

"$BIN_DIR/$GODOT_EXE" -e --path ./project