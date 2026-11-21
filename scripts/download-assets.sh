#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$DIR"/{rom,recovery,apk,tools}

echo ">>> [1/5] Téléchargement de la GSI AOSP 16 Vanilla (arm64-ab, EXT4)..."
curl -fL "https://github.com/ponces/treble_aosp/releases/download/v2025.06.25/aosp-arm64-ab-vanilla-16.0-20250625.img.xz" \
  -o "$DIR/rom/aosp-arm64-ab-vanilla-16.0-20250625.img.xz"
echo ">>> Décompression de la GSI..."
xz -dkf "$DIR/rom/aosp-arm64-ab-vanilla-16.0-20250625.img.xz"

echo ">>> [2/5] Téléchargement de TWRP communautaire pour SM-X205..."
curl -fL "https://raw.githubusercontent.com/Haxxsimd/TabA8-SM-X205-Root-Toolkit/main/04-TWRP/TWRP-3.7.x-SM-X205-XDA-community-ODIN.tar" \
  -o "$DIR/recovery/AP_TWRP-SM-X205.tar"

echo ">>> [3/5] Téléchargement de F-Droid et KOReader (arm64)..."
curl -fL "https://f-droid.org/F-Droid.apk" -o "$DIR/apk/F-Droid.apk"
curl -fL "https://github.com/koreader/koreader/releases/download/v2026.07.1/koreader-android-arm64-v2026.07.1.apk" \
  -o "$DIR/apk/koreader-android-arm64.apk"

echo ">>> [4/5] Téléchargement d'Aurora Store (via API F-Droid)..."
AURORA_VER=$(curl -sL "https://f-droid.org/api/v1/packages/com.aurora.store" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['suggestedVersionCode'])")
curl -fL "https://f-droid.org/repo/com.aurora.store_${AURORA_VER}.apk" \
  -o "$DIR/apk/AuroraStore.apk"

echo ">>> [5/5] Téléchargement de Deskreen (AppImage x86_64 pour Wayland/X11)..."
curl -fL "https://github.com/pavlobu/deskreen/releases/download/v3.2.16/deskreen-ce-3.2.16-x86_64.AppImage" \
  -o "$DIR/tools/deskreen-x86_64.AppImage"
chmod +x "$DIR/tools/deskreen-x86_64.AppImage"

echo "Terminé ! Tous les fichiers sont prêts dans : $DIR"
