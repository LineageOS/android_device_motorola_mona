#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.extract import extract_fns_user_type
from extract_utils.extract_star import (
    extract_star_firmware,
    star_firmware_regex,
)
from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import lib_fixups
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'vendor/motorola/sm6475-common',
    'hardware/motorola',
    'hardware/qcom-caf/sm8450-6.6',
    'vendor/qcom/opensource/commonsys-intf/display',
]


blob_fixups: blob_fixups_user_type = {
    ('vendor/bin/hw/android.hardware.biometrics.fingerprint@2.1-goodixservice',
        'vendor/bin/hw/android.hardware.biometrics.fingerprint-service-rbs', 'vendor/lib64/libgf_hal.so'): blob_fixup()
        .replace_needed('android.hardware.biometrics.common-V3-ndk.so', 'android.hardware.biometrics.common-V4-ndk.so')
        .replace_needed('android.hardware.biometrics.fingerprint-V3-ndk.so', 'android.hardware.biometrics.fingerprint-V4-ndk.so')
        .binary_regex_replace(b'(?<=\x00)/default\x00', b'/wrapper\x00'),
    'vendor/etc/vintf/manifest/manifest_IMoto_AIDL_Fingerprint.xml': blob_fixup()
        .regex_replace('IFingerprint/default', 'IFingerprint/wrapper')
        .regex_replace('<instance>default</instance>', '<instance>wrapper</instance>'),
    ('vendor/bin/hw/motorola.hardware.sensorext-service',
        'vendor/bin/hw/vendor.qti.camera.provider-service_64', 'vendor/lib64/camx.provider-impl.so'): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    'vendor/bin/hw/motorola.hardware.sensorext-service': blob_fixup()
        .replace_needed('vendor.qti.hardware.display.config-V7-ndk.so', 'vendor.qti.hardware.display.config-V12-ndk.so'),
    ('vendor/lib64/camera/components/com.qti.node.dewarp.so', 'vendor/lib64/libcamximageformatutils.so',
        'vendor/lib64/vendor.qti.hardware.camera.postproc@1.0-service-impl.so'): blob_fixup()
        .remove_needed('android.hardware.graphics.allocator-V1-ndk.so'),
    'vendor/lib64/hw/com.qti.chi.override.so': blob_fixup()
        .replace_needed('android.hardware.graphics.allocator-V1-ndk.so', 'android.hardware.graphics.allocator-V2-ndk.so'),
    'vendor/lib64/libBSTSWAD.so': blob_fixup()
        .clear_symbol_version('AHardwareBuffer_allocate')
        .clear_symbol_version('AHardwareBuffer_describe')
        .clear_symbol_version('AHardwareBuffer_lock')
        .clear_symbol_version('AHardwareBuffer_lockPlanes')
        .clear_symbol_version('AHardwareBuffer_release')
        .clear_symbol_version('AHardwareBuffer_unlock'),
}

extract_fns: extract_fns_user_type = {
    star_firmware_regex: extract_star_firmware,
}

module = ExtractUtilsModule(
    'mona',
    'motorola',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_generated_carriersettings=True,
    add_firmware_proprietary_file=True,
    extract_fns=extract_fns,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(module, 'sm6475-common', module.vendor)
    utils.run()
