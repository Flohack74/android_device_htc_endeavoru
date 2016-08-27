LOCAL_PATH := $(call my-dir)

LZMA_RAMDISK_BOOT := $(PRODUCT_OUT)/ramdisk.lzma
LZMA_RAMDISK_RECOVERY := $(PRODUCT_OUT)/ramdisk-recovery.lzma

$(LZMA_RAMDISK_BOOT): $(INSTALLED_RAMDISK_TARGET)
	@echo -e ${CL_GRN}"----- Making LZMA boot ramdisk ------"${CL_RST}
	$(hide) gzip -d < $(INSTALLED_RAMDISK_TARGET) > $(PRODUCT_OUT)/ramdisk.cpio
	$(hide) xz --format=lzma --lzma1=dict=16MiB -9 < $(PRODUCT_OUT)/ramdisk.cpio > $@
	@echo -e ${CL_CYN}"Made LZMA boot ramdisk: $@"${CL_RST}

$(LZMA_RAMDISK_RECOVERY): $(recovery_uncompressed_ramdisk)
	@echo -e ${CL_GRN}"----- Making LZMA recovery ramdisk ------"${CL_RST}
	$(hide) xz --format=lzma --lzma1=dict=16MiB -9 < $(PRODUCT_OUT)/ramdisk-recovery.cpio > $@
	@echo -e ${CL_CYN}"Made LZMA recovery ramdisk: $@"${CL_RST}

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(LZMA_RAMDISK_BOOT)
	@echo -e ${CL_GRN}"----- Making boot image ------"${CL_RST}
        $(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@ --ramdisk $(LZMA_RAMDISK_BOOT)
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_DTIMAGE_TARGET) $(LZMA_RAMDISK_RECOVERY) $(recovery_kernel)
	@echo -e ${CL_GRN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@ --ramdisk $(LZMA_RAMDISK_RECOVERY)
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
