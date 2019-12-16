#!/bin/bash
[ `pgrep -c qemu-system-x86` -gt 0 ] && echo "error: vm is running, kill qemu" && pkill qemu
echo "start qemu with ovmf"
./startvm.sh &
sleep 2
echo "start gdb with efi.py"
gdb -ex 'source efi.py' -ex 'efi -r -64'
