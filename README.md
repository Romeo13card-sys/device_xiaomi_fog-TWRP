# AERA Recovery 16.0 — Redmi 10C (`fog`, `rain`, `wind`)

**Bring-up candidate / UNTESTED**, based on the public TWRP/OrangeFox device
source: https://github.com/Romeo13card-sys/device_xiaomi_fog-TWRP/tree/aera-16.0

AERA upstream: https://github.com/AERA-Recovery/android_manifest (aera-16.0)

## Why this archive has an assembly step

The upstream device repository includes Qualcomm userspace binaries, firmware,
input firmware and many init/manifest/fstab files. They are **not recreated** in
this archive. Run the assembly script to fetch the complete upstream tree and
apply the tested-for-syntax AERA overlay. The result is a full `device/xiaomi/fog`
tree with GitHub Actions in its repository root. Without running this step,
`device/xiaomi/fog` in the archive is an overlay, **not** a full hardware tree.

## In WSL Ubuntu

```bash
sudo apt-get update
sudo apt-get install -y git rsync python3
unzip AERA_fog_16_bringup.zip -d ~/AERA_package
cd ~/AERA_package
bash scripts/assemble-tree.sh "$HOME/AERA_build"
cd ~/AERA_build/device/xiaomi/fog
git status --short
# Review all changes, then:
git add -A
git commit -m 'Bring up AERA 16.0 for fog (initial, untested)'
git push origin aera-16.0
```

Because the clone is from `Romeo13card-sys`, ensure `gh auth status` shows
`Romeo13card-sys` active. No token is required in the archive.

## GitHub Actions

Open the repository's Actions tab and run **AERA 16.0 - Redmi 10C (fog)**.
Default runner is `self-hosted` because public standard hosted runners commonly
lack the disk capacity to sync Android 16. The workflow checks for 100 GiB free
before starting, and uploads build logs even on failure. Your WSL2 machine can
host the runner, but you must install/register a GitHub Actions self-hosted
runner with GitHub's instructions, run it while building, and provision >=120
GiB storage and >=24 GiB RAM if practical. The Ubuntu runner choice is an
experimental option and will usually fail the free-disk check.

The workflow syncs upstream AERA sources and installs the checked-out tree at
`device/xiaomi/fog`. It downloads the public OrangeFox R12.0_1 `boot.img`
reference and extracts its kernel to `prebuilt/Image.gz` using `unpack_bootimg`.
This does not compile the `Romeo13card/kernel_xiaomi_sm6225` repository;
that kernel is reserved for later source-kernel integration after baseline boots.
The reference image is 128 MiB. `recovery-as-boot` uses header v3; DTB is **not**
added to the boot header v3 image here. Validate vendor_boot and running-device
layout before flashing.

**Known limits / next work:** AERA 16.0 platform may reject some old fog
proprietary service or Makefile settings; FBE, touch, slot management and
bootability are NOT yet verified. The initial tree omits legacy standalone
`bootctrl/` and `gpt-utils/` Soong modules because their dependencies may be
absent from AERA 16.0. The binary files elsewhere stay intact. Recovery init
still refers to existing old boot/health services, so boot-control needs runtime
validation. The workflow uses `m ... recoveryimage`; depending on the
`recovery-as-boot` packaging, `boot.img` can be the generated image.

Do **not** use `fastboot flash` or format data using this test image until boot
header, vendor_boot, DTB handling and real hardware tests confirm compatibility.

### File layout

- `device/xiaomi/fog/*`: modified AERA makefiles to overlay upstream tree
- `.github/workflows/build-aera.yml`: GitHub Actions sync, build, artifacts/logs
- `scripts/assemble-tree.sh`: fetch complete upstream device tree and overlay
- `scripts/prepare-prebuilt.sh`: extract kernel from reference OFRP IMG
