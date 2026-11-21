# Galaxy Tab A8 (SM-X205) — AOSP 16 Vanilla & Toolkit Arch Linux

Guide complet et scripts Linux pour remplacer **Samsung One UI** par un **Android 16 AOSP Vanilla ultra-léger** (Project Treble GSI) sur une **Samsung Galaxy Tab A8 10.5" LTE (`SM-X205` / `gta8`)** depuis **Arch Linux** (sans Windows), puis l'utiliser comme :

- **Webcam USB haute qualité** sous Linux (`scrcpy` + `v4l2loopback`, zéro appli à installer sur la tablette)
- **Écran secondaire Wayland/X11** (`Deskreen` / `Weylus` via tunnel USB `adb reverse`)
- **Liseuse PDF/EPUB** (`KOReader`) + écosystème léger sans Google Play Services (`F-Droid` + `Aurora Store`)

> **Testé et validé sur** : `SM-X205` (`gta8eea`, SoC Unisoc Tiger T618, 3 Go RAM, noyau `4.14.199`, bootloader Binary 6 `X205XXS6DYG6`) depuis **Arch Linux (Wayland)**.

> **Avertissement** : Déverrouiller le bootloader efface toutes les données de la tablette et fait sauter définitivement **Samsung Knox**. Utilisez ces scripts en connaissance de cause.

---

## Prérequis sur Arch Linux

```bash
# Paquets officiels
sudo pacman -S android-tools scrcpy v4l2loopback-dkms linux-headers curl tar xz python

# Outil de flashage officiel Samsung pour Linux (AUR)
yay -S odin4-cli
```

Télécharger automatiquement tous les binaires (GSI, TWRP, APK, Deskreen) depuis leurs releases officielles :

```bash
./scripts/download-assets.sh
```

---

## Installation étape par étape

### 1. Préparer la tablette & déverrouiller le bootloader
1. Dans One UI : *Paramètres → À propos → Informations sur le logiciel* → 7 appuis sur **Numéro de version**.
2. Dans *Options pour les développeurs* : activer **Déverrouillage OEM** et **Débogage USB**.
3. Éteindre complètement la tablette, maintenir **uniquement Volume Haut + Volume Bas** (ne pas appuyer sur Power), puis brancher le câble USB au PC.
4. Sur l'écran bleu/vert *Warning* : **appui long sur Volume Haut** (*Device unlock mode*), puis **Volume Haut** pour confirmer.
5. Passer rapidement l'assistant One UI (en connectant le Wi-Fi pour éviter le blocage *KG Prenormal*) et réactiver **Débogage USB**.

### 2. Flasher TWRP avec `odin4`
```bash
adb reboot download
sudo modprobe -r cdc_acm 2>/dev/null || true
sudo odin4 -a recovery/AP_TWRP-SM-X205.tar
```
> **Point critique** : dès que l'écran s'éteint à la fin du flash (~3 s), maintenez **immédiatement Volume Haut + Power** jusqu'à voir **TWRP** (sinon One UI restaure le recovery d'origine).

### 3. Formater Data et flasher la GSI AOSP 16 via `fastbootd`
1. Dans **TWRP** : **Wipe → Format Data** → tapez `yes` → puis **Reboot → Fastboot** (`fastbootd`).
2. Sur Arch Linux :
```bash
fastboot devices                      # doit afficher : <ID> fastbootd
fastboot getvar is-userspace          # doit afficher : yes
fastboot erase system
fastboot flash system rom/aosp-arm64-ab-vanilla-16.0-20250625.img
fastboot reboot
```
*(Le premier démarrage prend 2 à 5 minutes. Le message `Invalid sparse file format at header magic` est normal.)*

### 4. Post-installation automatisée (fixes + optimisations + APK)
Une fois sur AOSP 16, réactivez **Débogage USB** (*Paramètres → À propos → 7 appuis sur Numéro de build → Système → Options pour les développeurs*), puis lancez :

```bash
./scripts/post-install-aosp16.sh
```

Ce script applique automatiquement :
- Le **fix WebView** (`cmd webviewupdate set-webview-implementation com.android.webview`)
- Les **optimisations UI 3 Go RAM / GPU Mali-G52** (`animation_scale=0.5`, `disable_window_blurs=1`)
- L'installation de **F-Droid**, **KOReader** et **Aurora Store**
- L'ouverture de **Phh Treble Settings** pour débrider la luminosité Samsung (*Samsung features → Enable extended brightness range*)

---

## Utilisation quotidienne sur Arch Linux

### Webcam USB (`TabA8-Webcam`)
```bash
sudo modprobe v4l2loopback video_nr=10 card_label="TabA8-Webcam" exclusive_caps=1
./scripts/webcam.sh                  # caméra avant sur /dev/video10
./scripts/webcam.sh /dev/video10 back # caméra arrière
```

### Écran secondaire (Wayland / X11)
```bash
./scripts/screen-usb.sh deskreen     # ou: ./scripts/screen-usb.sh weylus
```

---

## Pièges connus sur SM-X205 (déjà résolus ici)

| Symptôme | Cause | Solution |
|---|---|---|
| Crash de DuckDuckGo / applis web (`MissingWebViewPackageException`) | `com.android.webview` non sélectionné par défaut sur AOSP Vanilla | Inclus dans `post-install-aosp16.sh` (`set-webview-implementation com.android.webview`) |
| Écran sombre même à 100 % | Rétroéclairage Samsung bridé par défaut sur GSI | *Phh Treble Settings → Samsung features → Enable extended brightness range* + reboot |
| Bootloop sur GSI EROFS | Noyau `4.14.199` incompatible avec EROFS (requiert Linux ≥ 5.4) | Toujours utiliser une GSI **EXT4** |
| YouTube officiel ne démarre pas | Exige Google Play Services (absents sur Vanilla) | Utiliser **NewPipe / PipePipe** (F-Droid) ou `m.youtube.com` |

---

## Crédits & Projets upstream
- GSI AOSP 16 : [ponces/treble_aosp](https://github.com/ponces/treble_aosp) (basé sur TrebleDroid)
- TWRP SM-X205 : communauté XDA / [Haxxsimd/TabA8-SM-X205-Root-Toolkit](https://github.com/Haxxsimd/TabA8-SM-X205-Root-Toolkit)
- Outils : [scrcpy](https://github.com/Genymobile/scrcpy), [Deskreen](https://github.com/pavlobu/deskreen), [Weylus](https://github.com/H-M-H/Weylus), [KOReader](https://github.com/koreader/koreader), [F-Droid](https://f-droid.org), [Aurora Store](https://f-droid.org/packages/com.aurora.store/)
