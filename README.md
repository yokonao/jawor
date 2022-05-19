# jawor
DIY OS

## setup
1. installation
```sh
git clone https://github.com/yokonao/jawor.git --recursive
```

2. install XQuartz
```sh
brew install xquartz

# you should rerun the below command when XQuarts restarts
xhost + 127.0.0.1
```

You must check the box in security preference of XQuartz.

![XQuartz Configuration](./docs/images/XQuartz%20Configuration.png)

**NOTE:** After changing config, you should restart XQuartz.


3. launch the container for development

In vscode command palette, choose the below command.
`Remote-Containers: Open Folder in Container...`

Then, you may see the dialog for folder selection.
Please choose `jawor` directory.

4. setup in the container
In the shell of the development container, follow the below instructions.

```sh
cd ~/tools/edk2

ln -s /workspaces/jawor/JaworLoaderPkg .

source edksetup.sh
```

4. operation check
```sh
# In the container
cd ~/osbook/day01/bin
qemu-img create -f raw disk.img 200M
mkfs.fat -n 'MIKAN OS' -s 2 -f 2 -R 32 -F 32 disk.img

mkdir -p mnt
sudo mount -o loop disk.img mnt
sudo mkdir -p mnt/EFI/BOOT
sudo cp hello.efi mnt/EFI/BOOT/BOOTX64.EFI
sudo umount mnt

qemu-system-x86_64 -drive if=pflash,format=raw,file=$HOME/osbook/devenv/OVMF_CODE.fd -drive if=pflash,format=raw,file=$HOME/osbook/devenv/OVMF_VARS.fd -drive file=disk.img,format=raw,index=0,media=disk
```
If success, you see `Hello, World!` in the window of QEMU.
