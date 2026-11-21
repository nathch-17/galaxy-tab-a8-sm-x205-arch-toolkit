#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Vérification de la connexion ADB..."
adb wait-for-device
adb devices

echo "Installation de F-Droid..."
adb install -r "$DIR/apk/F-Droid.apk"

echo "Installation de KOReader (liseuse PDF/EPUB)..."
adb install -r "$DIR/apk/koreader-android-arm64-v2026.07.1.apk"

echo "Terminé !"
