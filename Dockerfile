# Trying Arch Linux to reduce image size
# This Dockerfile's development was funded by the Tendermint Hardware project.
# We're building Arch linux Dockerfiles for RISC-V Cores for Open CPU core development because they allow for faster, easier builds, making open semiconductor development available to a wider audience.


FROM archlinux:latest

MAINTAINER jacobgadikian@gmail.com

# Every risc-v package in community
# we could reduce this later, but seems fitting for where we are at currently.
RUN pacman -Syyu --noconfirm python-pythondata-cpu-vexriscv riscv32-elf-binutils riscv32-elf-gdb riscv32-elf-newlib riscv64-elf-binutils riscv64-elf-gcc riscv64-elf-gdb riscv64-elf-newlib riscv64-linux-gnu-binutils riscv64-linux-gnu-gcc riscv64-linux-gnu-gdb riscv64-linux-gnu-glibc riscv64-linux-gnu-linux-api-headers python

# Nice to have
RUN pacman -S --noconfirm base-devel git

# Key RISC-V stuff
RUN pacman -S --noconfirm verilator spike dtc openocd

# Bluespec Runtime Dependencies
RUN pacman -S --noconfirm gperf tcl flex bison iverilog autoconf ghc verilator

# Bluespec Build Dependencies
RUN pacman -S --noconfirm haskell-old-time haskell-regex-compat haskell-split haskell-syb

# Declare location of RISC-V tools
ENV RISCV=/usr/bin

# install vivado dependencies (this is to ease the setup of Chromite M, though users will have to manually install vivado as described below)
# RUN pacman -S --noconfirm  ncurses5-compat-libs libpng12 lib32-libpng12 gtk2

# build and install xillinx vivado
# vivado is behind a login-wall and super-proprietary
# RUN sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/vivado.git && cd vivado && makepkg -si --noconfirm && cd .. && rm -rf bluespec-git'

# Create builduser
RUN pacman -S --needed --noconfirm sudo && \
        useradd builduser -m && passwd -d builduser && \
         printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers

# Build and install bluespec
RUN sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/bluespec-git.git && cd bluespec-git && makepkg -si --noconfirm && cd .. && rm -rf bluespec-git'
