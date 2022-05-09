WORKDIR=$(CURDIR)
SOURCE_DIR=$(WORKDIR)/src
EDK2_DIR=$(WORKDIR)/tools/edk2

OVMF_BASE=$(EDK2_DIR)/Build/OvmfX64/DEBUG_CLANG38
OVMF_CODE=$(OVMF_BASE)/FV/OVMF_CODE.fd
OVMF_VARS=$(OVMF_BASE)/FV/OVMF_VARS.fd
OVMF_FILE=$(OVMF_BASE)/FV/OVMF.fd


.PHONY: install
install: Makefile
	git submodule foreach git submodule update -i