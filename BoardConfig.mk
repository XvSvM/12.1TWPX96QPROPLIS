#
# X96Q Pro+ - Allwinner H728
# Board: H728A527-PRO2-AXP717C
# TWRP 12.1 (Vendor Boot)
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/x96/x96qproplus

ALLOW_MISSING_DEPENDENCIES := true

# A/B & Vendor Boot Recovery
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    vendor \
    system \
    system_dlkm \
    vendor_dlkm \
    product

BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true
BOARD_BUILD_VENDOR_RAMDISK_IMAGE := true
TARGET_NO_RECOVERY := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a55
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := generic

# Kernel (vendor_boot)
BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_KERNEL_SOURCE :=

# Device / Platform
TARGET_BOOTLOADER_BOARD_NAME := H728A527-PRO2-AXP717C
TARGET_BOARD_PLATFORM := sun55iw3p1
TARGET_NO_BOOTLOADER := true

# Display & Graphics
TARGET_SCREEN_DENSITY := 240
TARGET_RECOVERY_PIXEL_FORMAT := ARGB_8888
RECOVERY_GRAPHICS_FORCE_USE_LINELENGTH := true
TW_TARGET_USES_MALI := true

# Boot image header v4 & Offsets
BOARD_BOOT_HEADER_VERSION := 4
BOARD_HEADER_SIZE := 2128
BOARD_KERNEL_PAGESIZE := 2048
BOARD_PAGE_SIZE := 2048

BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x03388000
BOARD_TAGS_OFFSET := 0xfff88100
BOARD_DTB_OFFSET := 0x03288000
BOARD_DTB_SIZE := 176575

# DTB
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_SEPARATED_DTBO := true
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img

# Vendor boot & mkbootimg args
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_RAMDISK_USE_LZ4 := true
BOARD_VENDOR_CMDLINE := loop.max_part=4 mmcblk.perdev_minors=16 firmware_class.path=/vendor/etc/firmware bootconfig

BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_PAGE_SIZE)
BOARD_MKBOOTIMG_ARGS += --board "arm64"
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)

# Recovery fstab
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# Dynamic partitions (Super)
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SUPER_PARTITION_SIZE := 3758096384
BOARD_SUPER_PARTITION_GROUPS := sunxi_dynamic_partitions
BOARD_SUNXI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_dlkm vendor vendor_dlkm product
BOARD_SUNXI_DYNAMIC_PARTITIONS_SIZE := 3753902080

# Filesystems
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_COPY_OUT_VENDOR := vendor

# Platform / Security
OVERRIDE_TARGET_FLATTEN_APEX := true
DEXPREOPT_GENERATE_APEX_IMAGE := true
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
PLATFORM_VERSION := 16.1.0
# Must match the ROM exactly. The ROM's keys are wrapped by the software keymaster 3
# (PureSoftKeymasterContext), which stamps each key with:
#   OS version     ro.build.version.release         16  (set via the release config in build-twrp.sh)
#   OS patch       ro.build.version.security_patch  2026-09-01
#   vendor patch   ro.vendor.build.security_patch   EMPTY on the ROM, so do not set VENDOR_SECURITY_PATCH
#   boot patch     derived from the OS patch
# A lower value makes the key unusable; a higher one makes vold upgrade and rewrite the
# key blob, which the ROM then rejects.
# Tested 2026-10-14: TWRP at 2026-09-01 still decrypts after the ROM moved to 2026-10-01 (the
# software keymaster accepts keys from a newer OS patch). So keep this value AT OR BELOW the
# oldest ROM build users may run; never raise it past a ROM that is still in use, or TWRP could
# rewrite that ROM's key blobs and the ROM would lose access to /data.
PLATFORM_SECURITY_PATCH := 2026-09-01

# Decryption: file-based encryption v2, no metadata encryption.
# Same stack as the ROM (checked on the device 2026-10-03): keymaster@3.0-service finds no
# keystore.<ro.hardware|ro.product.board|ro.board.platform> module (the Samsung library is
# named keystore.exynos7580), so it runs its built-in software keymaster; gatekeeper is the
# software service. Samsung's TEE (MobiCore) is not involved, so it is left out.
TW_INCLUDE_CRYPTO := true
TW_USE_FSCRYPT_POLICY := 2
TARGET_RECOVERY_DEVICE_MODULES += \
    hwservicemanager \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \
    android.hardware.gatekeeper@1.0-service.software
# hwservicemanager is a system_ext module; listing it here also makes the build install it
TW_RECOVERY_ADDITIONAL_RELINK_BINARY_FILES += \
    $(TARGET_OUT_SYSTEM_EXT_EXECUTABLES)/hwservicemanager \
    $(TARGET_OUT_VENDOR_EXECUTABLES)/hw/android.hardware.keymaster@3.0-service \
    $(TARGET_OUT_VENDOR_EXECUTABLES)/hw/android.hardware.gatekeeper@1.0-service.software
TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/hw/android.hardware.keymaster@3.0-impl.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libkeymaster3device.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@3.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.gatekeeper@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libboot_control_client.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libresetprop.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.boot-V1-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.confirmationui-V1-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.keymint-V3-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.security.rkp-V3-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.security.aaid_aidl-cpp.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.system.keystore2-V4-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.system.suspend-V1-ndk.so
# TWRP's own relink list (bootable/recovery/prebuilt/Android.mk) misses the recovery
# binary's libboot_control_client/libresetprop and names the V1 keystore2/keymint AIDL
# libraries, while this tree builds the versions above. build-twrp.sh checks the result.

# TWRP UI
# Version shows as 3.7.1_14-A16: TWRP 3.7.1 from the twrp-14.1 (Android 14) branch, built
# for the LineageOS 23.2 / Android 16 ROM.
TW_DEVICE_VERSION := A16
TW_THEME := landscape_hdpi
# The panel is mounted upside down (the ROM rotates 180 too). TW_ROTATION only rotates the
# drawing; touch already reports upright coordinates, so no touch flip is needed.
TW_ROTATION := 180
# MTP: kernel configfs f_mtp (mtp.gs0 -> /dev/mtp_usb), set up in
# init.recovery.samsungexynos7580.rc. It was off until 2026-10-19 because USB died on the
# first function switch; kernel 0011 (reconnect after rebind) and 0013 (FunctionFS reset) fixed that.
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel/brightness"
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 160
RECOVERY_SDCARD_ON_DATA := true
TW_HAS_DOWNLOAD_MODE := true
TW_NO_REBOOT_BOOTLOADER := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_USE_TOOLBOX := true
TW_INCLUDE_NTFS_3G := false

# Keep the ramdisk small (about 20 MB is left next to the 19 MB kernel)
TW_EXTRA_LANGUAGES := false
TW_EXCLUDE_TWRPAPP := true
TW_EXCLUDE_APEX := true
TW_EXCLUDE_PYTHON := true
TW_EXCLUDE_NANO := true
TW_EXCLUDE_BASH := true
TW_EXCLUDE_LPDUMP := true
TW_EXCLUDE_LPTOOLS := true
TW_NO_HAPTICS := true

# Logging (useful while bringing up decryption)
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TW_CRYPTO_SYSTEM_VOLD_DEBUG := true
# Crypto / Encryption
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_METADATA_PARTITION := true
TW_USE_FSCRYPT_POLICY := 1
TW_CRYPTO_USE_SYSTEM_VOLD := true

# Debug
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true

# Гарантированное создание папки vendor_ramdisk до упаковки
$(shell mkdir -p $(PRODUCT_OUT)/vendor_ramdisk)
