#!/bin/bash
set -euo pipefail
export LC_ALL=C

echo "Building Clipboard Manager (universal)..."

APP_NAME="ClipboardManager"
BUILD_DIR="build"
APP_DIR="$BUILD_DIR/$APP_NAME.app"
BIN_DIR="$APP_DIR/Contents/MacOS"

# Resolve SDK path for correct framework linking
SDK_PATH=$(xcrun --sdk macosx --show-sdk-path)

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$BIN_DIR"

# Compile per-arch slices
ARCHS=("arm64" "x86_64")
for ARCH in "${ARCHS[@]}"; do
  echo "- Compiling for $ARCH..."
  OUT_DIR="$BUILD_DIR/$ARCH"
  mkdir -p "$OUT_DIR"
  xcrun swiftc \
    -target "$ARCH-apple-macos13.0" \
    -sdk "$SDK_PATH" \
    -framework SwiftUI \
    -framework AppKit \
    -framework Foundation \
    ClipboardManager/*.swift \
    -o "$OUT_DIR/$APP_NAME"
done

# Create a universal binary
echo "- Creating universal binary..."
lipo -create -output "$BIN_DIR/$APP_NAME" \
  "$BUILD_DIR/arm64/$APP_NAME" \
  "$BUILD_DIR/x86_64/$APP_NAME"

# Copy Info.plist
cp ClipboardManager/Info.plist "$APP_DIR/Contents/"

# Ensure executable permissions
chmod +x "$BIN_DIR/$APP_NAME"

# Ad-hoc sign for local dev (sandbox disabled via entitlements file)
codesign --force --sign - --entitlements ClipboardManager/ClipboardManager.entitlements "$APP_DIR" 2>/dev/null || true

echo "✅ Build successful! App created at: $APP_DIR"
echo "To run the app manually: open \"$APP_DIR\""