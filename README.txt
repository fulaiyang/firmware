DIR:
    seabios:
        seabios project
    edk2:
        edk2 project, include OVMF and its Makefile
    debug:
        auto debug tool for ovmf debug. usage details see README in debug dir
usage:
    DEBUG:
        make BUILDTARGET=DEBUG
        results see debug dir
    RELEASE:
        make
        results see rootfs by make
        make seabios/ovmf:only build seabios or ovmf
