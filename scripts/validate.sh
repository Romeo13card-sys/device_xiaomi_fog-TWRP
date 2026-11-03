#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
bash -n "$ROOT/scripts/assemble-tree.sh" "$ROOT/scripts/prepare-prebuilt.sh" "$ROOT/device/xiaomi/fog/vendorsetup.sh"
python3 - "$ROOT" <<'PY'
import pathlib,sys
root=pathlib.Path(sys.argv[1]); board=(root/'device/xiaomi/fog/BoardConfig.mk').read_text()
assert 'BOARD_BOOT_HEADER_VERSION := 3' in board
assert 'BOARD_USES_RECOVERY_AS_BOOT := true' in board
assert 'TARGET_PREBUILT_KERNEL :=' in board
assert 'BOARD_INCLUDE_DTB_IN_BOOTIMG := false' in board
assert not any(line.lstrip().startswith('git clone ') for line in (root/'device/xiaomi/fog/vendorsetup.sh').read_text().splitlines())
try:
 import yaml
 d=yaml.safe_load((root/'.github/workflows/build-aera.yml').read_text()); assert 'jobs' in d
except ImportError:
 print('PyYAML not installed; YAML parser check skipped')
print('Static validation passed.')
PY
