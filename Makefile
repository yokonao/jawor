WORKDIR=$(CURDIR)
SOURCE_DIR=$(WORKDIR)/src
EDK2_DIR=$(WORKDIR)/tools/edk2

OVMF_BASE=$(EDK2_DIR)/Build/OvmfX64/DEBUG_CLANG38
OVMF_CODE=$(OVMF_BASE)/FV/OVMF_CODE.fd
OVMF_VARS=$(OVMF_BASE)/FV/OVMF_VARS.fd
OVMF_FILE=$(OVMF_BASE)/FV/OVMF.fd

.PHONY: edk2tool
edk2tool: $(EDK2_DIR)/BaseTools/Source/C/Makefile
	make -C $(EDK2_DIR)/BaseTools/Source/C

.PHONY: ovmf
ovmf: edk2tool $(EDK2_DIR)/edksetup.sh
	WORKSPACE=$(EDK2_DIR) source $(EDK2_DIR)/edksetup.sh --reconfig;\
		WORKSPACE=$(EDK2_DIR) build -p OvmfPkg/OvmfPkgX64.dsc -b DEBUG -a X64 -t CLANG38
.PHONY: install
install: Makefile
	git submodule foreach git submodule update -i