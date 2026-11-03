#!/usr/bin/env bash
# AERA-specific exports. Never git clone from envsetup.sh.
export AERA_BUILD_DEVICE=fog
export AERA_TARGET_DEVICES="fog,rain,wind"
export TARGET_DEVICE_ALT="fog,rain,wind"
export AERA_AB_DEVICE=1
export AERA_VIRTUAL_AB_DEVICE=1
export AERA_PRODUCT_PREFIX="AERA"
export AERA_BUILD_STATUS="Unofficial"
export AERA_BUILD_TYPE="Beta"
export AERA_USE_TAR_BINARY=1
export AERA_USE_SED_BINARY=1
export AERA_USE_LZ4_BINARY=1
export AERA_USE_XZ_UTILS=1
export AERA_USE_ZSTD_BINARY=1
export AERA_USE_BUSYBOX_BINARY=1
export AERA_USE_UPDATED_MAGISKBOOT=1
