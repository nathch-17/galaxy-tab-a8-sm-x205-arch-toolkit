#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-deskreen}" # deskreen ou weylus

if adb get-state >/dev/null 2>&1; then
  echo "Tablette détectée en USB : activation des tunnels ADB reverse..."
  adb reverse tcp:3131 tcp:3131 || true # Deskreen
  adb reverse tcp:1701 tcp:1701 || true # Weylus
fi

if [[ "$MODE" == "weylus" ]]; then
  echo "Lancement de Weylus (ouvrir http://localhost:1701 sur la tablette)..."
  exec "$DIR/tools/weylus/weylus"
else
  echo "Lancement de Deskreen (Wayland compatible)..."
  exec "$DIR/tools/deskreen-x86_64.AppImage"
fi
