#!/bin/sh -ex

if [ $# -lt 1 ]
then
    echo "Usage: $0 <.efi file> [another file]"
    exit 1
fi

DEVENV_DIR=$(dirname "$0")
EFI_FILE=$1
ANOTHER_FILE=$2
DISK_IMG=./disk.img
MOUNT_POINT=./mnt

rm -f $DISK_IMG
qemu-img create -f raw $DISK_IMG 200M
mkfs.fat -n 'MIKAN OS' -s 2 -f 2 -R 32 -F 32 $DISK_IMG

if [ `uname` = 'Darwin' ]; then
    hdiutil attach -mountpoint $MOUNT_POINT $DISK_IMG
    mkdir -p $MOUNT_POINT/EFI/BOOT
    cp $EFI_FILE $MOUNT_POINT/EFI/BOOT/BOOTX64.EFI
else
    mkdir -p $MOUNT_POINT
    sudo mount -o loop $DISK_IMG $MOUNT_POINT
    sudo mkdir -p $MOUNT_POINT/EFI/BOOT
    sudo cp $EFI_FILE $MOUNT_POINT/EFI/BOOT/BOOTX64.EFI
fi

if [ "$ANOTHER_FILE" != "" ]
then
    if [ `uname` = 'Darwin' ]; then
        cp $ANOTHER_FILE $MOUNT_POINT/
    else
        sudo cp $ANOTHER_FILE $MOUNT_POINT/
    fi
fi
sleep 0.5
if [ `uname` = 'Darwin' ]; then
    hdiutil detach $MOUNT_POINT
else
    sudo umount $MOUNT_POINT
fi

qemu-system-x86_64 \
    -m 1G \
    -drive if=pflash,format=raw,readonly,file=$DEVENV_DIR/OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=$DEVENV_DIR/OVMF_VARS.fd \
    -drive if=ide,index=0,media=disk,format=raw,file=$DISK_IMG \
    -device nec-usb-xhci,id=xhci \
    -device usb-mouse -device usb-kbd \
    -monitor stdio \
    $QEMU_OPTS
    