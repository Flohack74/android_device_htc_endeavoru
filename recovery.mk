LOCAL_PATH := $(call my-dir)

LZMA_RAMDISK_RECOVERY := $(PRODUCT_OUT)/ramdisk-recovery.lzma

$(LZMA_RAMDISK_RECOVERY): $(recovery_ramdisk)
	$(hide) xz --format=lzma --lzma1=dict=16MiB -9 < $(PRODUCT_OUT)/ramdisk-recovery.cpio > $@
	@echo -e ${CL_CYN}"Made LZMA recovery ramdisk: $@"${CL_RST}

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_DTIMAGE_TARGET) $(LZMA_RAMDISK_RECOVERY) $(recovery_kernel)
	@echo -e ${CL_GRN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@ --ramdisk $(LZMA_RAMDISK_RECOVERY)
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
