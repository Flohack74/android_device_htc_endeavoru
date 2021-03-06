# Copyright 2010 The Android Open Source Project
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
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# inherit from tegra3-common
-include device/htc/tegra3-common/BoardConfigCommon.mk

# Boot/Recovery image settings
BOARD_KERNEL_CMDLINE := 
BOARD_KERNEL_PAGESIZE := 2048

TARGET_USERIMAGES_USE_EXT4 := true

# Skip droiddoc build to save build time
BOARD_SKIP_ANDROID_DOC_BUILD := true
DISABLE_DROIDDOC := true

#Stop some stupid logging
COMMON_GLOBAL_CFLAGS += -DSTOP_LOG_SPAM

# Partitions Info
#cat /proc/emmc
#dev:        size     erasesize name
#mmcblk0p5: 00800000 00001000 "recovery"
#mmcblk0p4: 00800000 00001000 "boot"
#mmcblk0p12: 50000000 00001000 "system"
#mmcblk0p13: 14000000 00001000 "cache"
#mmcblk0p17: 00200000 00001000 "misc"
#mmcblk0p1: 00600000 00001000 "wlan"
#mmcblk0p2: 00200000 00001000 "WDM"
#mmcblk0p20: 00200000 00001000 "pdata"
#mmcblk0p3: 00600000 00001000 "radiocab"
#mmcblk0p14: 650000000 00001000 "internalsd"
#mmcblk0p15: 89400000 00001000 "userdata"
#mmcblk0p19: 01600000 00001000 "devlog"
#mmcblk0p16: 00200000 00001000 "extra"

BOARD_BOOTIMAGE_PARTITION_SIZE := 8388608
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 8388608
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1342177280
BOARD_USERDATAIMAGE_PARTITION_SIZE := 27111981056
BOARD_FLASH_BLOCK_SIZE := 4096

# Wifi related defines
USES_TI_MAC80211                 := true
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
# Required for newer wpa_supplicant_8 versions to fix tethering
BOARD_WIFI_SKIP_CAPABILITIES     := true
WPA_SUPPLICANT_VERSION           := VER_0_8_X
# Private libs for the non-TI wpa_supplicant
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_wl12xx
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_wl12xx
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_WLAN_DEVICE                := wl12xx_mac80211
BOARD_SOFTAP_DEVICE              := wl12xx_mac80211
WIFI_DRIVER_MODULE_PATH          := "/system/lib/modules/wl12xx_sdio.ko"
WIFI_DRIVER_MODULE_NAME          := "wl12xx_sdio"
WIFI_FIRMWARE_LOADER             := ""
COMMON_GLOBAL_CFLAGS             += -DUSES_TI_MAC80211

# Kernel
TARGET_KERNEL_SOURCE := kernel/htc/endeavoru
TARGET_KERNEL_CONFIG := twrp_endeavoru_defconfig
#TARGET_PREBUILT_KERNEL := device/htc/endeavoru-kernel/zImage
# Art Tuning 
ART_BUILD_TARGET_DEBUG := false
ART_USE_OPTIMIZING_COMPILER := true

# Kitkat
BOARD_HAVE_PRE_KITKAT_AUDIO_BLOB := true
BOARD_HAVE_PRE_KITKAT_AUDIO_POLICY_BLOB := true
BOARD_EGL_WORKAROUND_BUG_10194508 := true
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true
BOARD_EGL_SKIP_FIRST_DEQUEUE := true
BOARD_EGL_NEEDS_FNW := true

# Lollipop
USE_LEGACY_AUDIO_POLICY := 1
BOARD_USES_LEGACY_MMAP := true
#libsymbols COMMON_GLOBAL_CFLAGS += -DADD_LEGACY_ACQUIRE_BUFFER_SYMBOL
TARGET_NEEDS_NON_PIE_SUPPORT := true
COMMON_GLOBAL_CFLAGS += -DTARGET_NEEDS_HWC_V0
COMMON_GLOBAL_CFLAGS += -DBOARD_CANT_REALLOCATE_OMX_BUFFERS

# Marshmallow
TARGET_NEEDS_TEXT_RELOCS_SUPPORT := true
COMMON_GLOBAL_CFLAGS += -DDISABLE_ASHMEM_TRACKING
TARGET_REQUIRES_SYNCHRONOUS_SETSURFACE := true

#Alfasamsung 
ifeq ($(TARGET_BUILD_VARIANT),user)
COMMON_GLOBAL_CFLAGS += -DALLOW_LOCAL_PROP_OVERRIDE=1 -DALLOW_DISABLE_SELINUX=1 -DALLOW_ADBD_ROOT=1
WITH_DEXPREOPT := true
DONT_DEXPREOPT_PREBUILTS := true
WITH_DEXPREOPT_COMP := true
endif

# Flags
COMMON_GLOBAL_CFLAGS += -DMR0_AUDIO_BLOB -DMR0_CAMERA_BLOB -DNEEDS_VECTORIMPL_SYMBOLS



# Enable Minikin text layout engine (will be the default soon)
USE_MINIKIN := true

# Building wifi modules
TARGET_MODULES_SOURCE := "kernel/htc/endeavoru/drivers/net/wireless/compat-wireless_R5.SP2.03"
TARGET_MODULES_SOURCE_DIR := "compat-wireless_R5.SP2.03"

WIFI_MODULES:
	rm -rf $(KERNEL_OUT)/COMPAT
	mkdir $(KERNEL_OUT)/COMPAT
	cp -rf $(TARGET_MODULES_SOURCE) $(KERNEL_OUT)/COMPAT
	$(MAKE) -C $(KERNEL_OUT)/COMPAT/$(TARGET_MODULES_SOURCE_DIR) O=$(KERNEL_OUT)/COMPAT KERNEL_DIR=$(KERNEL_OUT) KLIB=$(KERNEL_OUT) KLIB_BUILD=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(KERNEL_CROSS_COMPILE)

	mv $(KERNEL_OUT)/COMPAT/$(TARGET_MODULES_SOURCE_DIR)/compat/compat.ko $(KERNEL_MODULES_OUT)
	mv $(KERNEL_OUT)/COMPAT/$(TARGET_MODULES_SOURCE_DIR)/net/mac80211/mac80211.ko $(KERNEL_MODULES_OUT)
	mv $(KERNEL_OUT)/COMPAT/$(TARGET_MODULES_SOURCE_DIR)/net/wireless/cfg80211.ko $(KERNEL_MODULES_OUT)
	mv $(KERNEL_OUT)/COMPAT/$(TARGET_MODULES_SOURCE_DIR)/drivers/net/wireless/wl12xx/wl12xx.ko $(KERNEL_MODULES_OUT)
	mv $(KERNEL_OUT)/COMPAT/$(TARGET_MODULES_SOURCE_DIR)/drivers/net/wireless/wl12xx/wl12xx_sdio.ko $(KERNEL_MODULES_OUT)

	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/compat.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/mac80211.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/cfg80211.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/wl12xx.ko
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/wl12xx_sdio.ko

TARGET_KERNEL_MODULES := WIFI_MODULES

# Avoid the generation of ldrcc instructions
NEED_WORKAROUND_CORTEX_A9_745320 := true

# Sensors invensense
BOARD_USES_GENERIC_INVENSENSE := false

# Bluetooth
BOARD_HAVE_BLUETOOTH_TI := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/htc/endeavoru/bluetooth

# Charge mode
BOARD_CHARGING_MODE_BOOTING_LPM := /sys/htc_lpm/lpm_mode

# Recovery
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_RECOVERY_SWIPE := true
#TARGET_RECOVERY_FSTAB := device/htc/endeavoru/ramdisk/fstab.unknown
#RECOVERY_FSTAB_VERSION := 2
BOARD_HAS_LARGE_FILESYSTEM := true
TARGET_RECOVERY_FSTAB := device/htc/endeavoru/recovery/root/fstab.unknown
TARGET_RECOVERY_DEVICE_MODULES += chargeled
BOARD_CUSTOM_BOOTIMG_MK := device/htc/endeavoru/recovery/recovery.mk 

#TWRP CONFIG:
#DEVICE_RESOLUTION to be eliminated: https://github.com/TeamWin/Team-Win-Recovery-Project/commit/591b920
DEVICE_RESOLUTION := 720x1280
# new handling of resolution
TW_THEME := portrait_hdpi
# this enables proper handling of /data/media on devices that have this folder for storage
RECOVERY_SDCARD_ON_DATA := true
# disables things like sdcard partitioning
BOARD_HAS_NO_REAL_SDCARD := true
# removes the USB storage button on devices that don't support USB storage
TW_NO_USB_STORAGE := true
TW_BRIGHTNESS_PATH := /sys/devices/platform/tegra-pwm-bl/backlight/tegra-pwm-bl/brightness
TW_MAX_BRIGHTNESS := 255
TW_NO_SCREEN_BLANK := true
# fixes slanty looking graphics on some devices
RECOVERY_GRAPHICS_USE_LINELENGTH := true
TWHAVE_SELINUX := true
HAVE_SELINUX := true

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := device/htc/endeavoru
 BOARD_SEPOLICY_DIRS += device/htc/endeavoru/sepolicy

