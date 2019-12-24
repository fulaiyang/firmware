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
SEABIOS_OUT_DIRS = src src/hw src/fw vgasrc
CSM_BIN = ${EDK_DIR}/OvmfPkg/Csm/Csm16/Csm16.bin

all: seabios ovmf
	@mkdir -p ${ROOTFS}/usr/share/qemu-kvm/
	cp ${BUILD_DIR}/bios.bin ${ROOTFS}/usr/share/qemu-kvm/seabios.bin
	cp ${EDK_DIR}/Build/*/$(BUILDTARGET)_*/FV/OVMF* ${ROOTFS}/usr/share/qemu-kvm/

seabios:
	@mkdir -p ${BUILD_DIR}
	@mkdir -p $(addprefix ${BUILD_DIR}/, ${SEABIOS_OUT_DIRS})
	$(MAKE) EXTRAVERSION="-${NAME}-${VERSION}-${RELEASE}" \
            OUT="${BUILD_DIR}/" -C $(SEABIOS_DIR)

ovmf:
	cd $(EDK_DIR) && make -j1 BUILDTARGET=$(BUILDTARGET) 
ifeq ($(BUILDTARGET),DEBUG)
	cp -rf ${EDK_DIR}/Build ${FIRMWARE_ROOT}/debug/
	rm -rf ${FIRMWARE_ROOT}/debug/Build/*/RELEASE_*
endif

seabios_csm:
ifneq ($(CSM_BIN),$(wildcard $(CSM_BIN)))
	@mkdir -p ${BUILD_DIR}
	@mkdir -p $(addprefix ${BUILD_DIR}/, ${SEABIOS_OUT_DIRS})
	mv ${SEABIOS_DIR}/.config ${SEABIOS_DIR}/.config.bak
	cp ${SEABIOS_DIR}/csm.config ${SEABIOS_DIR}/.config
	$(MAKE) EXTRAVERSION="-${NAME}-${VERSION}-${RELEASE}" \
            OUT="${BUILD_DIR}/" -C $(SEABIOS_DIR)
	mv ${SEABIOS_DIR}/.config.bak ${SEABIOS_DIR}/.config
	cp ${BUILD_DIR}/Csm16.bin ${EDK_DIR}/OvmfPkg/Csm/Csm16/
endif

ovmf_csm: seabios_csm
	cd $(EDK_DIR) && make -j1 BUILDTARGET=$(BUILDTARGET) CSM=ENABLE 
ifeq ($(BUILDTARGET),DEBUG)
	cp -rf ${EDK_DIR}/Build ${FIRMWARE_ROOT}/debug/
	rm -rf ${FIRMWARE_ROOT}/debug/Build/*/RELEASE_*
endif

install:
	mkdir -p ${DESTDIR}
	cp -rf ${ROOTFS}/* $(DESTDIR)

clean:
	@rm -rf ${BUILD_DIR} ${ROOTFS}
	@cd ${EDK_DIR} && $(MAKE) clean
	rm CSM_BIN
	-rm -rf ${FIRMWARE_ROOT}/debug/Build ${FIRMWARE_ROOT}/debug/*.log
    
.PHONY: all clean install ovmf seabios ovmf_csm
