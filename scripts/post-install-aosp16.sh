#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo ">>> Attente de la tablette en ADB..."
adb wait-for-device
adb devices -l

echo ">>> [1/4] Fix WebView (évite MissingWebViewPackageException sur AOSP Vanilla)..."
adb shell cmd webviewupdate set-webview-implementation com.android.webview

echo ">>> [2/4] Optimisations fluidité (3 Go RAM / GPU Mali-G52)..."
adb shell '
  settings put global window_animation_scale 0.5
  settings put global transition_animation_scale 0.5
  settings put global animator_duration_scale 0.5
  settings put global disable_window_blurs 1
'

echo ">>> [3/4] Installation des APK (si présents dans apk/)..."
for apk in "$DIR"/apk/F-Droid.apk "$DIR"/apk/koreader-android-arm64*.apk "$DIR"/apk/AuroraStore.apk; do
  if [[ -f "$apk" ]]; then
    echo "  - Installation de $(basename "$apk")..."
    adb install -r "$apk"
  fi
done

echo ">>> [4/4] Ouverture de Phh Treble Settings (pour débrider la luminosité Samsung)..."
adb shell am start -n me.phh.treble.app/.SettingsActivity >/dev/null 2>&1 || true

echo ""
echo "Post-installation terminée !"
echo "Action manuelle recommandée sur la tablette :"
echo "  1) Dans Phh Treble Settings -> Samsung features -> activer 'Enable extended brightness range' puis redémarrer."
echo "  2) (Optionnel) Paramètres -> Réseau -> DNS privé -> dns.adguard-dns.com"
