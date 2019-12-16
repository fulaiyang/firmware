BUILDTARGET = RELEASE
DESTDIR := ${CURDIR}
NAME := firmware
VERSION := 0.0.0
RELEASE := 000

FIRMWARE_ROOT = ${CURDIR}
BUILD_DIR = ${FIRMWARE_ROOT}/build_dir
ROOTFS = ${FIRMWARE_ROOT}/rootfs
EDK_DIR = ${FIRMWARE_ROOT}/edk2
SEABIOS_DIR = ${FIRMWARE_ROOT}/seabios-1.10.2

all: seabios ovmf
	@mkdir -p ${ROOTFS}/usr/share/qemu-kvm/
	cp ${BUILD_DIR}/bios.bin ${ROOTFS}/usr/share/qemu-kvm/seabios.bin
	cp ${EDK_DIR}/Build/*/$(BUILDTARGET)_*/FV/OVMF* ${ROOTFS}/usr/share/qemu-kvm/
ifeq ($(BUILDTARGET),DEBUG)
	cp -rf ${EDK_DIR}/Build ${FIRMWARE_ROOT}/debug/
	rm -rf ${FIRMWARE_ROOT}/debug/Build/*/RELEASE_*
endif

seabios:
	@mkdir -p ${BUILD_DIR}
	$(MAKE) EXTRAVERSION="-${NAME}-${VERSION}-${RELEASE}" \
            OUT="${BUILD_DIR}/" -C $(SEABIOS_DIR)

ovmf: 
	cd $(EDK_DIR) && make -j1 BUILDTARGET=$(BUILDTARGET)

install:
	mkdir -p ${DESTDIR}
	cp -rf ${ROOTFS}/* $(DESTDIR)

clean:
	@rm -rf ${BUILD_DIR} ${ROOTFS}
	@cd ${EDK_DIR} && $(MAKE) clean
	-rm -rf ${FIRMWARE_ROOT}/debug/Build ${FIRMWARE_ROOT}/debug/*.log
    
.PHONY: all clean install ovmf seabios
