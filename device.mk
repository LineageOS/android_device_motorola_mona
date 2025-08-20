#
# Copyright (C) 2022 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Boot animation
TARGET_SCREEN_HEIGHT := 2712
TARGET_SCREEN_WIDTH := 1220

# Screen
TARGET_SCREEN_DENSITY := 450

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 450dpi
PRODUCT_AAPT_PREBUILT_DPI := xxxhdpi xxhdpi xhdpi hdpi

BOARD_SHIPPING_API_LEVEL := 202404
PRODUCT_SHIPPING_API_LEVEL := 35

# Inherit from motorola sm6475-common
$(call inherit-product, device/motorola/sm6475-common/common.mk)

# Overlay
PRODUCT_PACKAGES += \
    FrameworksResDevice \
    LineageSdkResDevice \
    LineageSystemUIResDevice \
    SettingsResDevice \
    SystemUIResDevice

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_parrot/audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_parrot_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_parrot/mixer_paths_parrot_qrd.xml \
    $(LOCAL_PATH)/configs/audio/resourcemanager_parrot_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_parrot/resourcemanager_parrot_qrd.xml \
    $(LOCAL_PATH)/configs/audio/audio_ext_spkr.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_ext_spkr.conf \
    $(LOCAL_PATH)/configs/audio/usecaseKvManager.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usecaseKvManager.xml

# Init
PRODUCT_PACKAGES += \
    init.mmi.overlay.rc \
    init.mmi.cap.sh \
    init.oem.fingerprint2.sh \
    init.vendor.st21nfc.rc

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc-service.st \
    com.android.nfc_extras \
    Tag

# PowerShare
PRODUCT_PACKAGES += \
    vendor.lineage.powershare-service.default

$(call soong_config_set,lineage_powershare,powershare_path,/sys/class/power_supply/wireless/device/tx_mode)

# Properties
PRODUCT_PACKAGES += \
    hardware.sku.XT2517-1.prop \
    hardware.sku.XT2517-2.prop \
    hardware.sku.XT2517-3.prop \
    hardware.sku.XT2517V.prop

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# StylusKeyHandler
PRODUCT_PACKAGES += \
    StylusKeyHandler

# Vibrator
$(call soong_config_set,qti_vibrator,effect_lib,libqtivibratoreffect.moto_sm6475-richtap)
$(call soong_config_set_bool,qti_vibrator,use_effect_stream,true)

# VINTF
ODM_MANIFEST_SKUS += dn n
ODM_MANIFEST_DN_FILES := $(LOCAL_PATH)/vintf/manifest_dn.xml
ODM_MANIFEST_N_FILES := $(LOCAL_PATH)/vintf/manifest_n.xml

# Inherit from vendor blobs
$(call inherit-product, vendor/motorola/mona/mona-vendor.mk)
