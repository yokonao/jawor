TARGET = kernel.elf

WORKDIR=../..
LIBC_DIR=$(WORKDIR)/tools/x86_64-elf
EDK2_DIR=$(WORKDIR)/tools/edk2
MKFONT_CMD=$(WORKDIR)/tools/mkfont/makefont.py
SOURCE_DIR=${WORKDIR}/src

CPPFLAGS += -I$(LIBC_DIR)/include/c++/v1 -I$(LIBC_DIR)/include -I$(LIBC_DIR)/include/freetype2 \
            -I$(EDK2_DIR)/MdePkg/Include -I$(EDK2_DIR)/MdePkg/Include/X64 \
			-I$(SOURCE_DIR)/bootloader/Include \
			-I$(SOURCE_DIR)/kernel/include \
			-nostdlibinc  -D__ELF__ -D_LDBL_EQ_DBL -D_GNU_SOURCE -D_POSIX_TIMERS\
			 -DEFIAPI='__attribute__((ms_abi))'
LIBC_DIR=$(WORKDIR)/tools/x86_64-elf
CFLAGS   += -O2 -Wall -g --target=x86_64-elf -ffreestanding -mno-red-zone
CXXFLAGS += -O2 -Wall -g --target=x86_64-elf -ffreestanding -mno-red-zone \
	        -fno-exceptions -fno-rtti -std=c++17
LDFLAGS += -L${LIBC_DIR}/lib --entry KernelMain -z norelro -z separate-code --image-base 0x100000  --static

.PHONY: all
all: $(TARGET)

kernel.elf:  Makefile main.o
	ld.lld $(LDFLAGS)  -o kernel.elf main.o -lc -lc++

%.o: %.cpp Makefile
	clang++ $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@