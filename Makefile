WORKDIR=$(CURDIR)
SOURCE_DIR=$(WORKDIR)/src
EDK2_DIR=$(WORKDIR)/tools/edk2
LOADER_EFI=$(EDK2_DIR)/Build/JaworLoaderX64/DEBUG_CLANGPDB/X64/Loader.efi

.PHONY: all
all: loader kernel.elf

.PHONY: edk2tool
edk2tool: $(EDK2_DIR)/BaseTools/Source/C/Makefile
	make -C $(EDK2_DIR)/BaseTools/Source/C

.PHONY: loader
loader: edk2tool $(EDK2_DIR)/edksetup.sh
	ln -s $(SOURCE_DIR)/JaworLoaderPkg $(EDK2_DIR)
	WORKSPACE=$(EDK2_DIR) source $(EDK2_DIR)/edksetup.sh;\
	WORKSPACE=$(EDK2_DIR) build -p JaworLoaderPkg/JaworLoader.dsc -b DEBUG -a X64 -t CLANGPDB

KERN_MAKEDIR=$(SOURCE_DIR)/kernel
KERN_MAKEFILE=$(KERN_MAKEDIR)/Makefile 
.PHONY: kernel
kernel:kernel.elf
kernel.elf: $(KERN_MAKEFILE)
	make -C $(KERN_MAKEDIR) all WORKDIR=${WORKDIR}

MOUNT_POINT=$(WORKDIR)/mnt
disk.img: loader kernel.elf
	rm -rf $@
	qemu-img create -f raw $@ 200M
	mkfs.fat -n 'JaworOS' -s 2 -f 2 -R 32 -F 32 $@
	mkdir -p ${MOUNT_POINT} 
	hdiutil attach -mountpoint ${MOUNT_POINT} $@
	sleep 0.5
	mkdir -p ${MOUNT_POINT}/EFI/BOOT
	cp $(LOADER_EFI) ${MOUNT_POINT}/EFI/BOOT/BOOTX64.EFI
	cp $(SOURCE_DIR)/kernel/kernel.elf ${MOUNT_POINT}/
	sleep 0.5
	hdiutil detach ${MOUNT_POINT}
	sleep 0.5
	rm -rf ${MOUNT_POINT}

run: disk.img
	qemu-system-x86_64 \
		-m 1G \
		-drive if=pflash,format=raw,readonly,file=$(WORKDIR)/tools/OVMF_CODE.fd \
		-drive if=pflash,format=raw,file=$(WORKDIR)/tools/OVMF_VARS.fd \
		-drive if=ide,index=0,media=disk,format=raw,file=$< \
		-device nec-usb-xhci,id=xhci \
		-device usb-mouse -device usb-kbd \
		-monitor stdio \
		-s

.PHONY: clean
clean:
	rm -rf $(EDK2_DIR)/LoaderPkg
	rm -rf $(EDK2_DIR)/Build/LoaderX64
