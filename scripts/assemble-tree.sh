#!/usr/bin/env bash
set -euo pipefail
# Assemble the COMPLETE tree, including upstream device-specific binary files.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_URL="https://github.com/Romeo13card-sys/device_xiaomi_fog-TWRP.git"
BASE_BRANCH="aera-16.0"
OUT="${1:-${ROOT}/output}"
mkdir -p "$OUT/device/xiaomi"
if [ -e "$OUT/device/xiaomi/fog/.git" ] || [ -f "$OUT/device/xiaomi/fog/BoardConfig.mk" ]; then
  echo "Refusing to overwrite existing tree: $OUT/device/xiaomi/fog" >&2
  exit 1
fi
git clone --depth=1 --branch "$BASE_BRANCH" "$BASE_URL" "$OUT/device/xiaomi/fog"
# Remove two old Soong modules with unresolved 12.1-only dependencies.
rm -rf "$OUT/device/xiaomi/fog/bootctrl" "$OUT/device/xiaomi/fog/gpt-utils"
cp -a "$ROOT/device/xiaomi/fog/." "$OUT/device/xiaomi/fog/"
# Root-level GitHub Actions and scripts go in the device-tree repo root.
cp -a "$ROOT/.github" "$OUT/device/xiaomi/fog/"
cp -a "$ROOT/scripts" "$OUT/device/xiaomi/fog/"
cp "$ROOT/.gitignore" "$OUT/device/xiaomi/fog/.gitignore"
cp "$ROOT/README.md" "$OUT/device/xiaomi/fog/README.md"
cat <<MSG
COMPLETE DEVICE TREE READY:
  $OUT/device/xiaomi/fog
Includes original recovery/root proprietary files plus AERA configuration.
Next: cd $OUT/device/xiaomi/fog; git status; git add -A; git commit ...; git push ...
MSG
