NAME := edk_ovmf
VERSION := 0.0.0
RELEASE := 000

EDK_DIR = ${CURDIR}

JOBS := $(shell grep -c ^processor /proc/cpuinfo 2>/dev/null)
ifeq ($(JOBS),)
JOBS := 1
endif

all: ovmf
edk_basetool:
	cd ${EDK_DIR} && \
        make -j$(JOBS) -C BaseTools -f GNUmakefile && \
        source ${EDK_DIR}/edksetup.sh

ovmf: edk_basetool
	${EDK_DIR}/OvmfPkg/build.sh \
       -a X64 \
       -D FD_SIZE_2MB \
       -D DEBUG_ON_SERIAL_PORT \
       -n $(JOBS) \
       -b RELEASE
clean:
	-cd ${EDK_DIR}/BaseTools && $(MAKE) clean -f GNUmakefile
	@rm -rf ${EDK_DIR}/Build
    
.PHONY: all clean ovmf edk_basetool
