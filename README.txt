usage:
    1、make -j4:build seabios and ovmf,ovmf buildtarget is release
    2、make -j4 BUILDTARGET=DEBUG:ovmf buildtarget is debug
    3、make seabios/ovmf:only build seabios or ovmf
