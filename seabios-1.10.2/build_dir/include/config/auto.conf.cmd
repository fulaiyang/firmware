deps_config := \
	vgasrc/Kconfig \
	/home/compile/rcos/rcos-qemu/seabios-1.10.2/src/Kconfig

include/config/auto.conf: \
	$(deps_config)


$(deps_config): ;
