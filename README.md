# jawor
DIY OS
## Dependencies
```sh
brew install llvm

# llvmがインストールされたPATHを調べる
ls -l /usr/local/opt | grep llvm

# /path/to/llvm/binをPATHに追加
echo 'export PATH="$PATH:/usr/local/opt/llvm/bin"' >> ~/.zshrc

brew install qemu

brew install nasm dosfstools binutils
```
