# SPDX-License-Identifier: Apache-2.0
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, device/xiaomi/fog/device.mk)
$(call inherit-product, vendor/twrp/config/common.mk)
PRODUCT_NAME := twrp_fog
PRODUCT_DEVICE := fog
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi 10C
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_RELEASE_NAME := fog
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
