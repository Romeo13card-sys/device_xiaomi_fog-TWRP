#!/usr/bin/env bash
set -euo pipefail
# Run AFTER repo sync, from the Android source root.
: "${DEVICE_DIR:=device/xiaomi/fog}"
IMG_URL="https://github.com/Romeo13card/releases/releases/download/OFRP-R12.0/OrangeFox-R12.0_1-Stable-fog.img"
[ -f system/tools/mkbootimg/unpack_bootimg.py ] || { echo "Run inside synced AERA source root" >&2; exit 1; }
mkdir -p "$DEVICE_DIR/prebuilt"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/fog-boot.XXXXXXXX")"
trap 'rm -rf "$TMP"' EXIT
if [ -n "${FOG_REFERENCE_IMG:-}" ]; then
  cp "$FOG_REFERENCE_IMG" "$TMP/orangefox.img"
else
  curl --fail --location --retry 3 --connect-timeout 30 "$IMG_URL" -o "$TMP/orangefox.img"
fi
python3 system/tools/mkbootimg/unpack_bootimg.py --boot_img "$TMP/orangefox.img" --out "$TMP/unpacked" > "$TMP/unpack-info.txt"
cat "$TMP/unpack-info.txt"
[ -s "$TMP/unpacked/kernel" ] || { echo 'ERROR: no kernel extracted' >&2; exit 1; }
# Kernel format is retained verbatim from known-working OFRP; do not recompress.
cp "$TMP/unpacked/kernel" "$DEVICE_DIR/prebuilt/Image.gz"
# Boot header v3 typically stores DTB in vendor_boot, not in boot.img.
# AERA bring-up deliberately does not invent DTB bytes or vendor_boot output.
if [ -s "$TMP/unpacked/dtb" ]; then
  echo 'NOTE: DTB found, but not included in the header-v3 bootimage configuration.'
fi
printf 'Prebuilt created: %s\n' "$DEVICE_DIR/prebuilt/Image.gz"
