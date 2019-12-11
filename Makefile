NAME := firmware
VERSION := 0.0.0
RELEASE := 000

FIRMWARE_ROOT = ${CURDIR}
BUILD_DIR = ${FIRMWARE_ROOT}/build_dir
ROOTFS = ${FIRMWARE_ROOT}/rootfs
EDK_DIR = ${FIRMWARE_ROOT}/edk2
SEABIOS_DIR = ${FIRMWARE_ROOT}/seabios-1.10.2

JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
ifeq ($(JOBS),)
JOBS := 1
endif

all: seabios ovmf
	@mkdir -p ${ROOTFS}/usr/share/qemu-kvm/
	cp ${BUILD_DIR}/bios.bin ${ROOTFS}/usr/share/qemu-kvm/seabios.bin
	cp ${EDK_DIR}/Build/*/*/FV/OVMF* ${ROOTFS}/usr/share/qemu-kvm/
seabios:
	@mkdir -p ${BUILD_DIR}
	$(MAKE) EXTRAVERSION="-${NAME}-${VERSION}-${RELEASE}" \
            OUT="${BUILD_DIR}/" -C $(SEABIOS_DIR)

ovmf:
	cd $(EDK_DIR) && make -j1

clean:
	@rm -rf ${BUILD_DIR} ${ROOTFS}
	@cd ${EDK_DIR} && $(MAKE) clean
    
.PHONY: all clean ovmf seabios
