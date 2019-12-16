#!/bin/bash
current_path="$PWD"
firmware_path=$(dirname "$PWD")
edk_path=$firmware_path/edk2
buildFV_path=$current_path/Build/OvmfX64/DEBUG_*/FV

/usr/bin/qemu-system-x86_64 \
-s \
-bios $buildFV_path/OVMF.fd \
-net none \
-monitor telnet:0.0.0.0:44444,server,nowait \
-vnc 0.0.0.0:0 \
-debugcon file:$current_path/seabios.log \
-global isa-debugcon.iobase=0x402 \
-serial file:$current_path/debug.log \
#-fw_cfg name=opt/ovmf/csm,string=0 \
#-drive file=/opt/lessons/data.teacher.disk,format=raw,if=none,id=drive-virtio-disk1,cache=writeback \
#-device ide-cd,bus=ide.1,unit=1,drive=drive-virtio-disk1,id=virtio-disk1,bootindex=1 \
#-drive file=/opt/lessons/data.teacher.disk2,format=raw,if=none,id=drive-virtio-disk0,cache=writeback \
#-device virtio-blk-pci,bus=pci.0,addr=0x8,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=2 \
