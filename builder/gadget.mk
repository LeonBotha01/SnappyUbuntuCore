include common.mk

OEM_UBOOT_BIN := gadget/boot-assets/u-boot.bin
OEM_SNAP := $(OUTPUT_DIR)/*.snap

# for preloader packaging
ifneq "$(findstring ARM, $(shell grep -m 1 'model name.*: ARM' /proc/cpuinfo))" ""
BOOTLOADER_PACK=bootloader_pack.arm
else
BOOTLOADER_PACK=bootloader_pack
endif

all: build

clean:
	rm -f $(OEM_UBOOT_BIN)
	rm -f $(OEM_BOOT_DIR)/bootloader.bin
	rm -f $(OEM_BOOT_DIR)/uboot.env
	rm -f $(OEM_SNAP)
distclean: clean

u-boot:
	@if [ ! -f $(UBOOT_BIN) ] ; then echo "Build u-boot first."; exit 1; fi
		cp -f $(UBOOT_BIN) $(OEM_UBOOT_BIN)

preload:
	cd $(TOOLS_DIR)/utils && ./$(BOOTLOADER_PACK) $(PRELOAD_DIR)/bootloader.bin $(PRELOAD_DIR)/bootloader.ini $(OEM_BOOT_DIR)/bootloader.bin
	mkenvimage -s 0x8000 -o $(OEM_BOOT_DIR)/uboot.env -r $(OEM_BOOT_DIR)/uEnv.txt

snappy:
	snapcraft snap gadget

gadget: preload u-boot snappy

build: gadget

.PHONY: u-boot snappy gadget build
