#!/bin/bash

echo "Building Clipboard Manager..."

APP_NAME="ClipboardManager"
BUILD_DIR="build"
APP_DIR="$BUILD_DIR/$APP_NAME.app"

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"

# Compile Swift files
swiftc -o "$APP_DIR/Contents/MacOS/$APP_NAME" \
    -target x86_64-apple-macos13.0 \
    -framework SwiftUI \
    -framework AppKit \
    -framework Foundation \
    ClipboardManager/*.swift

if [ $? -eq 0 ]; then
    # Copy Info.plist
    cp ClipboardManager/Info.plist "$APP_DIR/Contents/"
    
    # Make executable
    chmod +x "$APP_DIR/Contents/MacOS/$APP_NAME"
    
    # Sign app (disable sandboxing)
    codesign --force --sign - --entitlements ClipboardManager/ClipboardManager.entitlements "$APP_DIR" 2>/dev/null
    
    echo "✅ Build successful! App created at: $APP_DIR"
    
    # Run the app
    open "$APP_DIR"
    
else
    echo "❌ Build failed!"
    exit 1
fi