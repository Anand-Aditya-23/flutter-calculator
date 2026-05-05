#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# download_fonts.sh — Downloads JetBrains Mono fonts for NeonCalc
# Run this once from the project root before `flutter run`
# ─────────────────────────────────────────────────────────────────────────────

set -e

FONT_DIR="assets/fonts"
mkdir -p "$FONT_DIR"

BASE_URL="https://github.com/JetBrains/JetBrainsMono/raw/master/fonts/ttf"

echo "⬇  Downloading JetBrains Mono Regular..."
curl -L "$BASE_URL/JetBrainsMono-Regular.ttf" -o "$FONT_DIR/JetBrainsMono-Regular.ttf"

echo "⬇  Downloading JetBrains Mono Bold..."
curl -L "$BASE_URL/JetBrainsMono-Bold.ttf" -o "$FONT_DIR/JetBrainsMono-Bold.ttf"

echo "✅  Fonts downloaded to $FONT_DIR/"
echo "    Run: flutter pub get && flutter run"
