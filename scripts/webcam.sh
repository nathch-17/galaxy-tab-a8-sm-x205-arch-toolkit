#!/usr/bin/env bash
set -euo pipefail

VIDEO_DEV="${1:-/dev/video10}"
FACING="${2:-front}" # front ou back

if ! lsmod | grep -q "^v4l2loopback"; then
  echo "Le module noyau v4l2loopback n'est pas chargé."
  echo "Sur Arch Linux, installe-le si besoin puis charge-le :"
  echo "  sudo pacman -S v4l2loopback-dkms linux-headers"
  echo "  sudo modprobe v4l2loopback video_nr=10 card_label=\"TabA8-Webcam\" exclusive_caps=1"
  exit 1
fi

echo "Démarrage de la webcam SM-X205 ($FACING) sur $VIDEO_DEV..."
exec scrcpy --video-source=camera --camera-facing="$FACING" --camera-size=1280x720 --v4l2-sink="$VIDEO_DEV" --no-playback
