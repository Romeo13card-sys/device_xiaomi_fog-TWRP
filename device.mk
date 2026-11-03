# SPDX-License-Identifier: Apache-2.0
LOCAL_PATH := device/xiaomi/fog
# Keep shipping API aligned with the original device, NOT Android 16's API.
PRODUCT_SHIPPING_API_LEVEL := 30
PRODUCT_TARGET_VNDK_VERSION := 30
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)
PRODUCT_PACKAGES += \
    fastbootd \
    f2fs_io \
    check_f2fs \
    lpmake \
    lpunpack \
    qcom_decrypt \
    qcom_decrypt_fbe
# Hardware-specific Qualcomm userspace libraries already present in the
# source tree are left intact, but no old HAL modules are force-built until
# the first AERA 16 build resolves the required dependency closure.
$(call inherit-product, $(LOCAL_PATH)/aera_fog.mk)
